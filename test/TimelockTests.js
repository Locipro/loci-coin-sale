const { latestTime } = require('../node_modules/openzeppelin-solidity/test/helpers/latestTime');
const { increaseTimeTo, duration } = require('../node_modules/openzeppelin-solidity/test/helpers/increaseTime');
const { expectThrow } = require('../node_modules/openzeppelin-solidity/test/helpers/expectThrow');

const BigNumber = web3.BigNumber;

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

const Token = artifacts.require("./helpers/MockToken.sol");
const TokenTimelock = artifacts.require('../contracts/LOCItimelock.sol');

contract('LOCItimelock', function ([_, owner, beneficiary]) {
  const amount = new BigNumber(100);
  const totalSupply = 10000 * web3.toWei(1, "ether");

  beforeEach(async function () {
    this.token = await Token.new(totalSupply, {from: owner});    
    await this.token.ownerSetVisible("LOCIcoin", "LOCI", {from: owner});
    await this.token.ownerActivateToken({from: owner});

    this.releaseTime = (await latestTime()) + duration.years(1);
    this.timelock = await TokenTimelock.new(this.token.address, beneficiary, this.releaseTime);
    await this.token.transfer(this.timelock.address, amount, { from: owner });    
  });

  it('cannot be released before time limit', async function () {
    await expectThrow(this.timelock.release());
  });

  it('cannot be released just before time limit', async function () {
    await increaseTimeTo(this.releaseTime - duration.seconds(3));
    await expectThrow(this.timelock.release());
  });

  it('can be released just after limit', async function () {
    await increaseTimeTo(this.releaseTime + duration.seconds(1));
    await this.timelock.release();
    const balance = await this.token.balanceOf(beneficiary);
    balance.should.be.bignumber.equal(amount);
  });

  it('can be released after time limit', async function () {
    await increaseTimeTo(this.releaseTime + duration.years(1));
    await this.timelock.release();
    const balance = await this.token.balanceOf(beneficiary);
    balance.should.be.bignumber.equal(amount);
  });

  it('cannot be released twice', async function () {
    await increaseTimeTo(this.releaseTime + duration.years(1));
    await this.timelock.release();
    await expectThrow(this.timelock.release());
    const balance = await this.token.balanceOf(beneficiary);
    balance.should.be.bignumber.equal(amount);
  });
});
