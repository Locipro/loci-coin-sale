import expectRevert from "./helpers/expectRevert";
import {verifyEvent} from './helpers/extras';

const Token = artifacts.require("./helpers/MockToken.sol");


contract('Token Tests', accounts => {
    const eventSigTokenActivated = web3.sha3('TokenActivated()');
    const eventSigApproval = web3.sha3('Approval(address,address,uint256)');
    const eventSigTransfer = web3.sha3('Transfer(address,address,uint256)');

    const owner = accounts[0];
    const account_two = accounts[1];
    const account_three = accounts[2];

    let token;
    let owner_starting_balance,
        account_two_starting_balance,
        account_three_starting_balance;

    // arbitrary totalSupply purely for testing purposes in THIS test
    const totalSupply = 10000 * web3.toWei(1, "ether");

    before(async () => {
        token = await Token.new(totalSupply, {from: owner});
    });

    beforeEach(async () => {
        owner_starting_balance = await token.balanceOf.call(owner);
        account_two_starting_balance = await token.balanceOf.call(account_two);
        account_three_starting_balance = await token.balanceOf.call(account_three);
    });

    it("should have the owner account set correctly", async () => {
        assert.equal(owner, await token.owner.call(), "owner is not set correctly");
    });

    it("should have blank name and symbol", async () => {
        assert.equal(await token.name.call(), '', "Token name is not blank");
        assert.equal(await token.symbol.call(), '', "Token symbol is not blank");
    });

    it("should have correct totalSupply", async () => {
        assert.equal((await token.totalSupply.call()).toNumber(), totalSupply, "totalSupply is not correct");
    });

    it("should put correct # of Token in the owner account", async () => {
        let balance = (await token.balanceOf.call(owner)).toNumber();
        assert.equal(balance, totalSupply, "incorrect token amount in the owner account");
        assert.equal(owner_starting_balance, totalSupply, "incorrect token amount in owner");
    });

    it("should add an account as an override address", async () => {
        // two test accounts should not be overrides before any add attempt
        assert.isNotOk(
            await token.isAllowedOverrideAddress.call(account_two),
            "account_two is an override when it shouldn't be");
        assert.isNotOk(
            await token.isAllowedOverrideAddress.call(account_three),
            "account_three is an override when it shouldn't be");

        await token.ownerSetOverride(account_three, true);

        // one of the test accounts should not be overrides after the add attempt
        assert.isNotOk(
            await token.isAllowedOverrideAddress.call(account_two),
            "account_two is an override when it shouldn't be");
        assert.isOk(
            await token.isAllowedOverrideAddress.call(account_three),
            "account_three is not an override when it should be");

        await token.ownerSetOverride(account_three, false);

        // the test accounts should not be overrides after the remove attempt
        assert.isNotOk(
            await token.isAllowedOverrideAddress.call(account_two),
            "111account_two is an override when it shouldn't be");
        assert.isNotOk(
            await token.isAllowedOverrideAddress.call(account_three),
            "account_three is an override when it shouldn't be");
    });

    it("should successfully transfer tokens from owner account before ownerActivateToken", async () => {
        let amount = 10;
        let txr = await token.transfer(account_two, amount, {from: owner});
        //assert(verifyEvent(txr.tx, eventSigTransfer), "Transfer event wasn't emitted");
        txr = await token.transfer(account_three, amount, {from: owner});
        //assert(verifyEvent(txr.tx, eventSigTransfer), "Transfer event wasn't emitted");

        let owner_ending_balance = await token.balanceOf.call(owner);
        let account_two_ending_balance = await token.balanceOf.call(account_three);
        let account_three_ending_balance = await token.balanceOf.call(account_three);

        assert.equal(
            owner_ending_balance.toNumber(),
            owner_starting_balance.toNumber() - (2 * amount),
            "Amount wasn't correctly taken from the sender");
        assert.equal(
            account_two_ending_balance.toNumber(),
            account_two_starting_balance.toNumber() + amount,
            "Amount wasn't correctly sent to the receiver (account_two)");
        assert.equal(
            account_three_ending_balance.toNumber(),
            account_three_starting_balance.toNumber() + amount,
            "Amount wasn't correctly sent to the receiver (account_three)");
    });

    it("should successfully transfer tokens from an override account before ownerActivateToken", async () => {
        let amount = 1;

        // allow account_three to be an override
        await token.ownerSetOverride(account_three, true);
        // attempt a transfer
        let txr = await token.transfer(account_two, amount, {from: account_three});
        //assert(verifyEvent(txr.tx, eventSigTransfer), "Transfer event wasn't emitted");

        let account_three_ending_balance = await token.balanceOf.call(account_three);
        let account_two_ending_balance = await token.balanceOf.call(account_two);

        assert.equal(
            account_three_ending_balance.toNumber(),
            account_three_starting_balance.toNumber() - amount,
            "Amount wasn't correctly taken from the sender");
        assert.equal(
            account_two_ending_balance.toNumber(),
            account_two_starting_balance.toNumber() + amount,
            "Amount wasn't correctly sent to the receiver");
    });

    it("should fail to transfer tokens from non-owner/non-override account before ownerActivateToken", async () => {
        
        await expectRevert(token.transfer(owner, 1, {from: account_two}));

    });

    it("should fail to approve token transfer from non-owner/non-override account before ownerActivateToken", async () => {
        await expectRevert(token.approve(owner, 1, {from: account_two}));
    });

    it("should approve token transfer from owner/override account before ownerActivateToken", async () => {
        let txr = await token.approve(account_two, 1, {from: owner});
        //assert(verifyEvent(txr.tx, eventSigApproval), "Approval event wasn't emitted");
        assert((await token.allowance.call(owner, account_two)).toNumber(), 1, "approval from owner account should work");

        txr = await token.approve(account_two, 1, {from: account_three});
        //assert(verifyEvent(txr.tx, eventSigApproval), "Approval event wasn't emitted");
        assert((await token.allowance.call(account_three, account_two)).toNumber(), 1, "approval from override account should work");
    });

    it("should be allowed to transferFrom successfully an approved amount from a non owner/override account", async () => {
        // should fail due to the amount attempt is too high (wasn't approved!)
        await expectRevert(token.transferFrom(account_three, account_two, 20, {from: account_two}));

        // this should succeed
        let txr = await token.transferFrom(account_three, account_two, 1, {from: account_two});
        //assert(verifyEvent(txr.tx, eventSigTransfer), "Transfer event wasn't emitted");

        let account_three_ending_balance = await token.balanceOf.call(account_three);
        let account_two_ending_balance = await token.balanceOf.call(account_two);

        assert.equal(
            account_three_ending_balance.toNumber(),
            account_three_starting_balance.toNumber() - 1,
            "Amount wasn't correctly taken from the sender");
        assert.equal(
            account_two_ending_balance.toNumber(),
            account_two_starting_balance.toNumber() + 1,
            "Amount wasn't correctly sent to the receiver");

        assert.equal(
            (await token.allowance.call(account_three, account_two)).toNumber(),
            0,
            "approval from override account should work");
    });

    it("should throw when calling ownerActivateToken without ownerSetVisible", async () => {
        await expectRevert(token.ownerActivateToken({from: owner}));
    });

    it("should have blank symbol and token before, and be set after ownerSetVisible", async () => {
        assert.equal(await token.name.call(), '', "Token name is not blank");
        assert.equal(await token.symbol.call(), '', "Token symbol is not blank");

        await token.ownerSetVisible("LOCIcoin", "LOCI", {from: owner});

        assert.equal(await token.name.call(), 'LOCIcoin', "Token name is not set correctly");
        assert.equal(await token.symbol.call(), 'LOCI', "Token symbol is not set correctly");
    });

    it("should be inactive before, and be active after ownerActivateToken", async () => {
        let active = await token.tokenActive.call();
        assert.equal(active, false, "Token is active on creation");

        let txr = await token.ownerActivateToken({from: owner});
        //assert(verifyEvent(txr.tx, eventSigTokenActivated), "TokenActivated event wasn't emitted");

        active = await token.tokenActive.call();
        assert.equal(active, true, "Token is not active after ownerActivateToken");
    });

    it("non-owner account should transfer token correctly after ownerActivateToken", async () => {
        let amount = 1;
        let txr = await token.transfer(owner, amount, {from: account_two});
        //assert(verifyEvent(txr.tx, eventSigTransfer), "Transfer event wasn't emitted");

        let owner_ending_balance = await token.balanceOf.call(owner);
        let account_two_ending_balance = await token.balanceOf.call(account_two);

        assert.equal(
            owner_ending_balance.toNumber(),
            owner_starting_balance.toNumber() + amount,
            "Amount wasn't correctly taken to the sender");
        assert.equal(
            account_two_ending_balance.toNumber(),
            account_two_starting_balance.toNumber() - amount,
            "Amount wasn't correctly sent from the receiver");
    });

    it("should fail to transfer tokens to 0x0 or the token's address", async () => {
        await expectRevert(token.transfer(0, 1, {from: owner}));
        await expectRevert(token.transfer(token.address, 1, {from: owner}));
    });
});
