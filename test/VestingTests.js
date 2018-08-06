
const { EVMRevert } = require('../node_modules/openzeppelin-solidity/test/helpers/EVMRevert');
const { latestTime } = require('../node_modules/openzeppelin-solidity/test/helpers/latestTime');
const { ethGetBlock } = require('../node_modules/openzeppelin-solidity/test/helpers/web3');
const { increaseTimeTo, duration } = require('../node_modules/openzeppelin-solidity/test/helpers/increaseTime');
const { expectThrow } = require('../node_modules/openzeppelin-solidity/test/helpers/expectThrow');

const BigNumber = web3.BigNumber;

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

const Token = artifacts.require("./helpers/MockToken.sol");
const TokenVesting = artifacts.require('../contracts/LOCIvesting.sol');

contract('TokenVesting', function ([_, owner, beneficiary]) {
  const amount = new BigNumber(1000);
  const totalSupply = 10000 * web3.toWei(1, "ether");

  beforeEach(async function () {
    this.token = await Token.new(totalSupply, {from: owner});    
    await this.token.ownerSetVisible("LOCIcoin", "LOCI", {from: owner});
    await this.token.ownerActivateToken({from: owner});

    this.start = (await latestTime()) + duration.minutes(1); // +1 minute so it starts after contract instantiation
    this.cliff = duration.years(1);
    this.duration = duration.years(2);

    this.vesting = await TokenVesting.new(this.token.address,beneficiary, this.start, this.cliff, this.duration, true, { from: owner });

    await this.token.transfer(this.vesting.address, amount, { from: owner });    
  });

  it('cannot be released before cliff', async function () {
    await expectThrow(
      this.vesting.release(this.token.address),
      EVMRevert,
    );
  });

  it('can be released after cliff', async function () {
    await increaseTimeTo(this.start + this.cliff + duration.weeks(1));
    await this.vesting.release(this.token.address);
  });

  it('should release proper amount after cliff', async function () {
    await increaseTimeTo(this.start + this.cliff);

    const { receipt } = await this.vesting.release(this.token.address);
    const block = await ethGetBlock(receipt.blockNumber);
    const releaseTime = block.timestamp;

    const balance = await this.token.balanceOf(beneficiary);
    balance.should.bignumber.equal(amount.mul(releaseTime - this.start).div(this.duration).floor());
  });

  it('should linearly release tokens during vesting period', async function () {
    const vestingPeriod = this.duration - this.cliff;
    const checkpoints = 4;

    for (let i = 1; i <= checkpoints; i++) {
      const now = this.start + this.cliff + i * (vestingPeriod / checkpoints);
      await increaseTimeTo(now);

      await this.vesting.release(this.token.address);
      const balance = await this.token.balanceOf(beneficiary);
      const expectedVesting = amount.mul(now - this.start).div(this.duration).floor();

      balance.should.bignumber.equal(expectedVesting);
    }
  });

  it('should have released all after end', async function () {
    await increaseTimeTo(this.start + this.duration);
    await this.vesting.release(this.token.address);
    const balance = await this.token.balanceOf(beneficiary);
    balance.should.bignumber.equal(amount);
  });

  it('should be revoked by owner if revocable is set', async function () {
    await this.vesting.revoke(this.token.address, { from: owner });
  });

  it('should fail to be revoked by owner if revocable not set', async function () {
    const vesting = await TokenVesting.new(this.token.address, beneficiary, this.start, this.cliff, this.duration, false, { from: owner });
    await expectThrow(
      vesting.revoke(this.token.address, { from: owner }),
      EVMRevert,
    );
  });

  it('should return the non-vested tokens when revoked by owner', async function () {
    await increaseTimeTo(this.start + this.cliff + duration.weeks(12));

    const vested = await this.vesting.vestedAmount(this.token.address);

    await this.vesting.revoke(this.token.address, { from: owner });

    const ownerBalance = await this.token.balanceOf(owner);
    ownerBalance.should.bignumber.equal(new BigNumber(totalSupply).sub(vested));
  });

  it('should keep the vested tokens when revoked by owner', async function () {
    await increaseTimeTo(this.start + this.cliff + duration.weeks(12));

    const vestedPre = await this.vesting.vestedAmount(this.token.address);

    await this.vesting.revoke(this.token.address, { from: owner });

    const vestedPost = await this.vesting.vestedAmount(this.token.address);

    vestedPre.should.bignumber.equal(vestedPost);
  });

  it('should fail to be revoked a second time', async function () {
    await increaseTimeTo(this.start + this.cliff + duration.weeks(12));

    await this.vesting.vestedAmount(this.token.address);

    await this.vesting.revoke(this.token.address, { from: owner });

    await expectThrow(
      this.vesting.revoke(this.token.address, { from: owner }),
      EVMRevert,
    );
  });
});

contract('TokenVesting - LOCI specific', function ([_, owner, beneficiary]) {
  const amount = new BigNumber(1000);
  const totalSupply = 10000 * web3.toWei(1, "ether");

  beforeEach(async function () {
    this.token = await Token.new(totalSupply, {from: owner});    
    await this.token.ownerSetVisible("LOCIcoin", "LOCI", {from: owner});
    await this.token.ownerActivateToken({from: owner});

    this.start = (await latestTime()) + duration.minutes(1); // +1 minute so it starts after contract instantiation
    this.cliff = duration.years(1);
    this.duration = duration.years(2);

    this.vesting = await TokenVesting.new(this.token.address,beneficiary, this.start, this.cliff, this.duration, true, { from: owner });

    await this.token.transfer(this.vesting.address, amount, { from: owner });    
  });

  it('cannot be released before cliff', async function () {
    await expectThrow(
      this.vesting.releaseLOCI(),
      EVMRevert,
    );
  });

  it('can be released after cliff', async function () {
    await increaseTimeTo(this.start + this.cliff + duration.weeks(1));
    await this.vesting.releaseLOCI();
  });

  it('should release proper amount after cliff', async function () {
    await increaseTimeTo(this.start + this.cliff);

    const { receipt } = await this.vesting.releaseLOCI();
    const block = await ethGetBlock(receipt.blockNumber);
    const releaseTime = block.timestamp;

    const balance = await this.token.balanceOf(beneficiary);
    balance.should.bignumber.equal(amount.mul(releaseTime - this.start).div(this.duration).floor());
  });

  it('should linearly release tokens during vesting period', async function () {
    const vestingPeriod = this.duration - this.cliff;
    const checkpoints = 4;

    for (let i = 1; i <= checkpoints; i++) {
      const now = this.start + this.cliff + i * (vestingPeriod / checkpoints);
      await increaseTimeTo(now);

      await this.vesting.releaseLOCI();
      const balance = await this.token.balanceOf(beneficiary);
      const expectedVesting = amount.mul(now - this.start).div(this.duration).floor();

      balance.should.bignumber.equal(expectedVesting);
    }
  });

  it('should have released all after end', async function () {
    await increaseTimeTo(this.start + this.duration);
    await this.vesting.releaseLOCI();
    const balance = await this.token.balanceOf(beneficiary);
    balance.should.bignumber.equal(amount);
  });

  it('should be revoked by owner if revocable is set', async function () {
    await this.vesting.revoke(this.token.address, { from: owner });
  });

  it('should fail to be revoked by owner if revocable not set', async function () {
    const vesting = await TokenVesting.new(this.token.address, beneficiary, this.start, this.cliff, this.duration, false, { from: owner });
    await expectThrow(
      vesting.revokeLOCI({ from: owner }),
      EVMRevert,
    );
  });

  it('should return the non-vested tokens when revoked by owner', async function () {
    await increaseTimeTo(this.start + this.cliff + duration.weeks(12));

    const vested = await this.vesting.vestedAmountLOCI();

    await this.vesting.revokeLOCI({ from: owner });

    const ownerBalance = await this.token.balanceOf(owner);
    ownerBalance.should.bignumber.equal(new BigNumber(totalSupply).sub(vested));
  });

  it('should keep the vested tokens when revoked by owner', async function () {
    await increaseTimeTo(this.start + this.cliff + duration.weeks(12));

    const vestedPre = await this.vesting.vestedAmountLOCI();

    await this.vesting.revokeLOCI({ from: owner });

    const vestedPost = await this.vesting.vestedAmountLOCI();

    vestedPre.should.bignumber.equal(vestedPost);
  });

  it('should fail to be revoked a second time', async function () {
    await increaseTimeTo(this.start + this.cliff + duration.weeks(12));

    await this.vesting.vestedAmountLOCI();

    await this.vesting.revokeLOCI({ from: owner });

    await expectThrow(
      this.vesting.revokeLOCI({ from: owner }),
      EVMRevert,
    );
  });
});
