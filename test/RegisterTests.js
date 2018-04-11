import expectRevert from "./helpers/expectRevert";
import expectTypeError from "./helpers/expectTypeError";
import {verifyEvent} from './helpers/extras';

const Token = artifacts.require("./helpers/MockToken.sol");
const Register = artifacts.require("./helpers/MockRegister.sol");

contract('Register Tests', accounts => {
    const eventSigTokenActivated = web3.sha3('TokenActivated()');
    const eventSigApproval = web3.sha3('Approval(address,address,uint256)');
    const eventSigTransfer = web3.sha3('Transfer(address,address,uint256)');

    const eventRegisterWithdrawal = web3.sha3('RegisterWithdrawal(address,address,address,uint256,uint256)');    

    const owner = accounts[0];
    const account_two = accounts[1];
    const account_three = accounts[2];
    const account_four = accounts[3];
    const account_five = accounts[4];

    let token;
    let owner_starting_balance,
        account_two_starting_balance,
        account_three_starting_balance,
        account_four_starting_balance,
        account_five_starting_balance;
    let register;

    // arbitrary totalSupply purely for testing purposes in THIS test
    const totalSupply = 10000 * web3.toWei(1, "ether");

    before(async () => {
        token = await Token.new(totalSupply, {from: owner});

        register = await Register.new( token.address, 'Locipro.com', {from: owner} );

        await token.ownerSetVisible("LOCIcoin", "LOCI", {from: owner});
        await token.ownerActivateToken({from: owner});

        await token.transfer(account_two, 20, {from: owner});
        await token.transfer(account_three, 30, {from: owner});
        await token.transfer(account_four, 40, {from: owner});
    });

    beforeEach(async () => {
        owner_starting_balance = await token.balanceOf.call(owner);
        account_two_starting_balance = await token.balanceOf.call(account_two);
        account_three_starting_balance = await token.balanceOf.call(account_three);
        account_four_starting_balance = await token.balanceOf.call(account_four);
        account_five_starting_balance = await token.balanceOf.call(account_five);
    });

    it("should have the register account set correctly", async () => {
        assert.equal(owner, await register.owner.call(), "owner is not set correctly");
    });

    it("should have blank names and reasons", async () => {
        assert.equal(await register.names.call(owner), '', "Register names is not blank");
        assert.equal(await register.reasons.call(0), '', "Register reasons is not blank");
    });

    it("should have defined names and reasons", async () => {

        register.setRegisterName(owner,'LOCIcoin owner');
        register.setReason( 0, 'Subscription' );
        register.setReason( 1, 'Stake' );
        register.setReason( 2, 'Bid' );
        register.setReason( 3, 'Refund' );

        assert.equal(await register.names.call(owner), 'LOCIcoin owner', "Register names is not blank");
        assert.equal(await register.reasons.call(0), 'Subscription', "0 = Subscription");
        assert.equal(await register.reasons.call(1), 'Stake', "1 = Stake");
        assert.equal(await register.reasons.call(2), 'Bid', "2 = Bid");
        assert.equal(await register.reasons.call(3), 'Refund', "3 = Refund");
    });

    it("should have correct totalSupply", async () => {
        assert.equal((await token.totalSupply.call()).toNumber(), totalSupply, "totalSupply is not correct");
    });

    it("should put correct # of Token in the owner account", async () => {
        let balance = (await token.balanceOf.call(owner)).toNumber();
        assert.equal(balance, totalSupply, "incorrect token amount in the owner account");
        assert.equal(owner_starting_balance, totalSupply, "incorrect token amount in owner");
    });

    it("should put correct # of Token in the register account", async () => {
        let balance = (await token.balanceOf.call(register.address)).toNumber();                
        assert.equal(0, balance, "incorrect token amount in register");
    });

    it("should fail to withdrawFrom tokens at register", async () => {
        
        await expectRevert(register.withdrawFrom( owner, account_four, account_two, 1, 0 ));

    });

    it("register should transfer token correctly after owner gives allowance to register contract", async () => {

        let txr = await token.approve(register.address, 2**255, {from: owner});
        assert(verifyEvent(txr.tx, eventSigApproval), "Approval event wasn't emitted");
        assert((await token.allowance.call(owner, register.address)).toNumber(), 2**255, "approval from owner account should work");

        txr = await register.withdrawFrom( owner, account_four, account_two, 1, 2 );
        assert(verifyEvent(txr.tx, eventRegisterWithdrawal), "RegisterWithdrawal event wasn't emitted");

        let account_four_ending_balance = await token.balanceOf.call(account_four);
        assert.equal(account_four_ending_balance.toNumber(), 
                     account_four_starting_balance.toNumber() + 1, "Amount wasn't correctly sent to the beneficiary");
    });

    it("register should revert withdrawFromAll for incorrectly constructed arrays of inputs", async () => {

        await expectRevert(register.withdrawFromAll([owner], [account_three,account_three], 
                                         [account_two,account_two], [4,5], [3,3]));

        await expectRevert(register.withdrawFromAll([owner,owner], [account_three], 
                                         [account_two,account_two], [4,5], [3,3]));

        await expectRevert(register.withdrawFromAll([owner,owner], [account_three,account_three], 
                                         [account_two], [4,5], [3,3]));

        await expectRevert(register.withdrawFromAll([owner,owner], [account_three,account_three], 
                                         [account_two,account_two], [4], [3,3]));

        await expectRevert(register.withdrawFromAll([owner,owner], [account_three,account_three], 
                                         [account_two,account_two], [4,5], [3]));

    });        

    it("register should transfer token correctly for array of inputs", async () => {


        let txr = await register.withdrawFromAll([owner,owner], 
                                                 [account_three,account_three], 
                                                 [account_two,account_two],
                                                 [4,5], 
                                                 [3,3]);

        let txrec = web3.eth.getTransactionReceipt(txr.tx);            
        let registerEventCount = 0;
        let transferEventCount = 0;
        for (let n in txrec.logs) {                 
            if (txrec.logs[n].topics && txrec.logs[n].topics[0] === eventRegisterWithdrawal ){            
                registerEventCount++;
            }
            if (txrec.logs[n].topics && txrec.logs[n].topics[0] === eventSigTransfer ){            
                transferEventCount++;
            }
        }
        assert(transferEventCount == 2, "Transfer event desired count wasn't correct");
        assert(registerEventCount == 2, "RegisterWithdrawal event desired count wasn't correct");

        let account_three_ending_balance = await token.balanceOf.call(account_three);
        assert.equal(account_three_ending_balance.toNumber(), 
                     account_three_starting_balance.toNumber() + 9, "Amount wasn't correctly sent to the beneficiary");
    });


    it("register should revert withdrawSameAmountFromRegister for incorrectly constructed non-array list", async () => {

        await expectTypeError(register.withdrawSameAmountFromRegister(owner, account_five, account_two, 777, 4));        

    });  

    it("register should transfer same number of tokens correctly for array of linked addresses", async () => {


        let txr = await register.withdrawSameAmountFromRegister(owner, 
                                                                account_five, 
                                                                [account_two,account_three,account_four],
                                                                777, 
                                                                4);

        let txrec = web3.eth.getTransactionReceipt(txr.tx);            
        let registerEventCount = 0;
        let transferEventCount = 0;
        for (let n in txrec.logs) {     
            //console.log(txrec.logs[n]); 
            if (txrec.logs[n].topics && txrec.logs[n].topics[0] === eventRegisterWithdrawal ){            
                registerEventCount++;
            }
            if (txrec.logs[n].topics && txrec.logs[n].topics[0] === eventSigTransfer ){            
                transferEventCount++;
            }
        }
        assert(transferEventCount == 1, "Transfer event desired count wasn't correct");
        assert(registerEventCount == 3, "RegisterWithdrawal event desired count wasn't correct");

        let account_five_ending_balance = await token.balanceOf.call(account_five);
        assert.equal(account_five_ending_balance.toNumber(), 
                     account_five_starting_balance.toNumber() + (777 * 3), "Amount wasn't correctly sent to the beneficiary");
    });

});
