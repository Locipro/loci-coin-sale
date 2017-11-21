const BigNumber = require('bignumber.js');

import {increaseTime, evm_mine, verifyEvent} from '../test/helpers/extras';

const Token = artifacts.require("./helpers/MockToken.sol");
const Sale = artifacts.require("./helpers/MockSale.sol");


contract('Sale Tests', accounts => {
    const eventSigTransfer = web3.sha3('Transfer(address,address,uint256)');
    const eventSigContributionReceived = web3.sha3('ContributionReceived(address,bool,uint8,uint256,uint256)');
    const eventSigRefundsEnabled = web3.sha3('RefundsEnabled()');
    const eventSigRefunded = web3.sha3('Refunded(address,uint256)');

    let sale, token, owner;
    let owner_starting_balance,
        sale_starting_balance,
        account_two_starting_balance,
        account_three_starting_balance;

    let deployAddress = accounts[0];
    // use the most recent block's timestamp rather than `now` in
    // case we increaseTime in the test cases; allows us to avoid
    // restarting testrpc
    let start = web3.eth.getBlock('latest').timestamp;
    let discounts = []; // no tranche discounting
    let baseRateInCents = 250; /* Base rate in cents. $2.50 would be 250 */

    contract('LOCISale inputs with specific tests', accounts => {
        let isPresale = false;
        let minimumGoal = web3.toWei(50000, 'ether');
        let minimumContribution = 0.1 * web3.toWei(1, 'ether');
        let maximumContribution = 50000 * web3.toWei(1, 'ether');

        let totalTokenSupply = 100 * Math.pow(10,8) * web3.toWei(1, 'ether'); // 100 Million in wei
        let reservedTokens = 54 * Math.pow(10,8) * web3.toWei(1, 'ether');    //  54 Million in wei = (50M + 4M presale)
        let peggedETHUSD = 300; // $300 USD
        let saleSupplyAllocation = 100 * Math.pow(10,8) * web3.toWei(1, 'ether'); // 100 Million in wei

        let hours = 600; // 5 days in hours + 10 hours for 0% discount testing
        let discounts = [
            48, 33,  // first  48 hours, 0.33 price
            168, 44, // next  168 hours, 0.44 price
            168, 57, // next  168 hours, 0.57 price
            216, 75, // final 216 hours, 0.75 price
        ];

        before(async () => {
            token = await Token.new(totalTokenSupply, {from: deployAddress});
            sale = await Sale.new(
                token.address,
                new BigNumber(peggedETHUSD),
                new BigNumber(reservedTokens),
                isPresale,
                new BigNumber(minimumGoal),
                new BigNumber(minimumContribution),
                new BigNumber(maximumContribution),
                new BigNumber(start),
                new BigNumber(hours),
                new BigNumber(baseRateInCents),
                discounts.map(v => new BigNumber(v)),
                {from: deployAddress});
            owner = await sale.owner.call();

            peggedETHUSD = await sale.peggedETHUSD.call();            

            await token.ownerSetOverride(sale.address, true, {from: owner});
        });

        beforeEach(async () => {
            owner_starting_balance = await token.balanceOf.call(owner);
            sale_starting_balance = await token.balanceOf.call(sale.address);
            account_two_starting_balance = await token.balanceOf.call(accounts[1]);
            account_three_starting_balance = await token.balanceOf.call(accounts[2]);

            await sale.pegETHUSD(300, {from: owner});
        });

        it("should have a peggedETHUSD", async () => {
            assert.equal((await sale.peggedETHUSD.call()).toNumber(), 300, "default peggedETHUSD does not match");

            await sale.pegETHUSD(330, {from: owner});

            assert.equal((await sale.peggedETHUSD.call()).toNumber(), 330, "default peggedETHUSD does not match");
        });

        it("should have the correct initial settings", async () => {
            assert.equal((await sale.peggedETHUSD.call()).toNumber(), 300, "default peggedETHUSD does not match");

            assert.equal(token.address, await sale.getTokenAddress.call(), "token addresses do not match");
            assert.equal(owner, accounts[0], "owner address does not match accounts[0]");
            assert.equal(owner, await token.owner.call(), "owner addresses do not match");
            assert.equal(await sale.isPresale.call(), isPresale, "should be presale");
            assert.equal((await sale.minFundingGoalWei.call()).toNumber(), minimumGoal, "min goals do not match");
            assert.equal((await sale.minContributionWei.call()).toNumber(), minimumContribution, "min goals do not match");
            assert.equal((await sale.maxContributionWei.call()).toNumber(), maximumContribution, "max goals do not match");
            assert.equal(sale_starting_balance, 0, "sale's token balance isn't zero");

            assert.equal((await sale.getDiscountTrancheDiscount(0)), 33, 'First round discount');
            assert.equal((await sale.getDiscountTrancheDiscount(1)), 44, 'Second round discount');
            assert.equal((await sale.getDiscountTrancheDiscount(2)), 57, 'Third round discount');
            assert.equal((await sale.getDiscountTrancheDiscount(3)), 75, 'Fourth round discount');

            let valid = true;
            try {
                await sale.getDiscountTrancheDiscount(4);
                valid = false;
            } catch (error) {
            }
            assert(valid, "Fifth round does not exist");
        });

        it("should have sane discount tranche values", async () => {
            let pointInTime = start = (await sale.start.call()).toNumber();
            let end = (await sale.end.call()).toNumber();
            let trancheEnd, trancheDiscount;
            let i = 0, y = 0;

            while (true) {
                try {
                    trancheEnd = await sale.getDiscountTrancheEnd.call(i);
                    trancheDiscount = await sale.getDiscountTrancheDiscount.call(i);
                    //console.log('trancheEnd:' + trancheEnd);
                    //console.log('trancheDiscount:' + trancheDiscount);
                } catch (error) {
                    break;
                }
                pointInTime = pointInTime + discounts[y] * 3600;
                assert.equal(trancheEnd.toNumber(), pointInTime, "tranche end time is incorrect; index " + i);
                assert.equal(trancheDiscount.toNumber(), discounts[y + 1], "tranche rate is incorrect; index " + i);
                assert.isAtMost(trancheEnd.toNumber(), end, "tranche end time must be less than the sale end time; index " + i);
                ++i;
                y += 2;
            }
        });

        it("should have the correct token balance after initial token transfer", async () => {
            let txr = await token.transfer(sale.address, saleSupplyAllocation, {from: owner});
            //assert(verifyEvent(txr.tx, eventSigTransfer), "Transfer event wasn't emitted");
            assert.equal(await token.balanceOf.call(sale.address), saleSupplyAllocation, "sale's token balance isn't correct");
        });

        it("should throw exception when less than minimum contribution", async () => {
            let valid = true;
            try {
                web3.eth.sendTransaction({from: accounts[1], to: sale.address, value: 1, gas: 150000});
                valid = false;
            } catch (error) {
            }
            assert(valid, "contribution should not be less than minimum contribution");
            assert.equal(web3.eth.getBalance(sale.address), 0, "contract wei balance should remain at zero");
        });

        it("should throw exception when less than minimum contribution", async () => {
            let valid = true;
            try {
                web3.eth.sendTransaction({from: accounts[1], to: sale.address, value: 1, gas: 150000});
                valid = false;
            } catch (error) {
            }
            assert(valid, "contribution should not be less than minimum contribution");
            assert.equal(web3.eth.getBalance(sale.address), 0, "contract wei balance should remain at zero");
        });

        // todo: buy 14300.000000000000000000 ETH worth of tokens, test for 13000000 tokens sold in round 1
        it("should cap ether at max individual contribution (refund remaining ether & allocate max contribution # of tokens); verifies first tranche discount", async () => {
            let old_balance_wei = web3.eth.getBalance(accounts[1]);
            let hash = web3.eth.sendTransaction({
                from: accounts[1],
                to: sale.address,
                value: web3.toWei(14300, 'ether'),
                gas: 150000
            });                        

            // calculate the cost of the gas used
            let tx = web3.eth.getTransaction(hash);
            let txr = web3.eth.getTransactionReceipt(hash);
            let cost = tx.gasPrice * txr.gasUsed;

            let new_balance_wei = web3.eth.getBalance(accounts[1]);

            // the contribution amount is: original wei balance MINUS (post-transaction wei balance PLUS gas costs)
            //let actual_contribution_wei = old_balance_wei.minus(new_balance_wei.plus(cost));
            //console.log(actual_contribution_wei);
            let actual_contribution_wei = (await sale.weiRaisedDuringRound.call(1)).toNumber();
            //console.log(actual_contribution_wei);
            let new_balance_tokens = await token.balanceOf.call(accounts[1]);
            let discount_rate = discounts[1];
            //let non_discounted_expected = new BigNumber(5000 * web3.toWei(1, 'ether'));
            let pegETHUSD = await sale.peggedETHUSD.call();
            let non_discounted_expected = new BigNumber(actual_contribution_wei * pegETHUSD * new BigNumber(100).dividedBy(baseRateInCents));            
            let acutal_ending_balance =  (new_balance_tokens.minus(account_two_starting_balance)).toNumber();
            
            /*
            console.log('discount_rate:' + discount_rate);
            console.log('new_balance_tokens:' + new_balance_tokens);
            console.log('pegETHUSD:' + pegETHUSD);
            console.log('old_balance_wei:'+ old_balance_wei);
            console.log('new_balance_wei:'+ new_balance_wei);
            console.log('cost:'+ cost);
            console.log('actual_contribution_wei:'+ actual_contribution_wei);
            console.log('new_balance_tokens:'+ new_balance_tokens);
            console.log('account_two_starting_balance:'+ account_two_starting_balance);
            console.log('acutal_ending_balance:' + acutal_ending_balance);
            console.log('discount_balance_expected:' + discount_balance_expected);            

            let totalWeiRaised = (await sale.totalWeiRaised.call()).toNumber();
            console.log('totalWeiRaised:' + totalWeiRaised);            
            */
            
            console.log('new_balance_wei:'+ new_balance_tokens);

            assert.equal(
                new BigNumber(new_balance_tokens).dividedBy( Math.pow(10,18) ), 13000000,
                "Should have 13000000 tokens");
        });

        it("should have non-zero balance but still less than minimum goal after first successful transaction attempt", async () => {
            let minGoal = await sale.minFundingGoalWei.call();
            assert.notEqual(web3.eth.getBalance(sale.address).toNumber(), 0, "contract wei balance should not be zero");
            assert.isBelow(web3.eth.getBalance(sale.address).toNumber(), minGoal, "contract wei balance should less than minimum goal");
        });       

        it("should move to the second discount tranche when advancing time", async () => {
            let _index = await sale.getCurrentDiscountTrancheIndex.call();
            let discount = await sale.getDiscountTrancheDiscount(_index);
            await increaseTime(172801); // two days in seconds + 1 second
            await evm_mine(); // make sure testrpc updates `now`
            let new_index = await sale.getCurrentDiscountTrancheIndex.call();
            let new_discount = await sale.getDiscountTrancheDiscount(new_index);
            assert.equal(_index + 1, new_index.toNumber(), "tranche index wasn't incremented");
            assert.notEqual(discount, new_discount, "tranche discount is the same as previous tranche discount");
            assert.equal(new_discount, discounts[3], "tranche discount isn't correct");
        });

        // todo: buy 16333.333333333333333333 ETH worth of tokens, test for ~ 11000000 tokens sold in round 2

        // todo: advance time by discounts[2] in seconds

        // todo: buy 20900.000000000000000000 ETH worth of tokens, test for ~ 11000000 tokens sold in round 3

        // todo: advance time by discounts[4] in seconds

        // todo: buy 12000.000000000000000000 ETH worth of tokens, test for ~  4800000 tokens sold in round 4

        // todo: advance time by discounts[6] in seconds

        // todo: attempt purchase after token sale end date, should fail. sale is over.

    })

    contract('LOCISale inputs with generic tests', accounts => {
        let isPresale = false;
        let minimumGoal = web3.toWei(50000, 'ether');
        let minimumContribution = 0.1 * web3.toWei(1, 'ether');
        let maximumContribution = 50000 * web3.toWei(1, 'ether');

        let totalTokenSupply = 100 * Math.pow(10,8) * web3.toWei(1, 'ether'); // 100 Million in wei
        let reservedTokens = 54 * Math.pow(10,8) * web3.toWei(1, 'ether');    //  54 Million in wei = (50M + 4M presale)
        let peggedETHUSD = 300; // $300 USD
        let saleSupplyAllocation = 100 * Math.pow(10,8) * web3.toWei(1, 'ether'); // 100 Million in wei

        let hours = 600; // 5 days in hours + 10 hours for 0% discount testing
        let discounts = [
            48, 33,  // first  48 hours, 0.33 price
            168, 44, // next  168 hours, 0.44 price
            168, 57, // next  168 hours, 0.57 price
            216, 75, // final 216 hours, 0.75 price
        ];

        before(async () => {
            token = await Token.new(totalTokenSupply, {from: deployAddress});
            sale = await Sale.new(
                token.address,
                new BigNumber(peggedETHUSD),
                new BigNumber(reservedTokens),
                isPresale,
                new BigNumber(minimumGoal),
                new BigNumber(minimumContribution),
                new BigNumber(maximumContribution),
                new BigNumber(start),
                new BigNumber(hours),
                new BigNumber(baseRateInCents),
                discounts.map(v => new BigNumber(v)),
                {from: deployAddress});
            owner = await sale.owner.call();

            peggedETHUSD = await sale.peggedETHUSD.call();            

            await token.ownerSetOverride(sale.address, true, {from: owner});
        });

        beforeEach(async () => {
            owner_starting_balance = await token.balanceOf.call(owner);
            sale_starting_balance = await token.balanceOf.call(sale.address);
            account_two_starting_balance = await token.balanceOf.call(accounts[1]);
            account_three_starting_balance = await token.balanceOf.call(accounts[2]);

            await sale.pegETHUSD(300, {from: owner});
        });

        it("should have a peggedETHUSD", async () => {
            assert.equal((await sale.peggedETHUSD.call()).toNumber(), 300, "default peggedETHUSD does not match");

            await sale.pegETHUSD(330, {from: owner});

            assert.equal((await sale.peggedETHUSD.call()).toNumber(), 330, "default peggedETHUSD does not match");
        });

        it("should have the correct initial settings", async () => {
            assert.equal((await sale.peggedETHUSD.call()).toNumber(), 300, "default peggedETHUSD does not match");

            assert.equal(token.address, await sale.getTokenAddress.call(), "token addresses do not match");
            assert.equal(owner, accounts[0], "owner address does not match accounts[0]");
            assert.equal(owner, await token.owner.call(), "owner addresses do not match");
            assert.equal(await sale.isPresale.call(), isPresale, "should be presale");
            assert.equal((await sale.minFundingGoalWei.call()).toNumber(), minimumGoal, "min goals do not match");
            assert.equal((await sale.minContributionWei.call()).toNumber(), minimumContribution, "min goals do not match");
            assert.equal((await sale.maxContributionWei.call()).toNumber(), maximumContribution, "max goals do not match");
            assert.equal(sale_starting_balance, 0, "sale's token balance isn't zero");
        });

        it("should have sane discount tranche values", async () => {
            let pointInTime = start = (await sale.start.call()).toNumber();
            let end = (await sale.end.call()).toNumber();
            let trancheEnd, trancheDiscount;
            let i = 0, y = 0;

            while (true) {
                try {
                    trancheEnd = await sale.getDiscountTrancheEnd.call(i);
                    trancheDiscount = await sale.getDiscountTrancheDiscount.call(i);
                    //console.log('trancheEnd:' + trancheEnd);
                    //console.log('trancheDiscount:' + trancheDiscount);
                } catch (error) {
                    break;
                }
                pointInTime = pointInTime + discounts[y] * 3600;
                assert.equal(trancheEnd.toNumber(), pointInTime, "tranche end time is incorrect; index " + i);
                assert.equal(trancheDiscount.toNumber(), discounts[y + 1], "tranche rate is incorrect; index " + i);
                assert.isAtMost(trancheEnd.toNumber(), end, "tranche end time must be less than the sale end time; index " + i);
                ++i;
                y += 2;
            }
        });

        it("should have the correct token balance after initial token transfer", async () => {
            let txr = await token.transfer(sale.address, saleSupplyAllocation, {from: owner});
            //assert(verifyEvent(txr.tx, eventSigTransfer), "Transfer event wasn't emitted");
            assert.equal(await token.balanceOf.call(sale.address), saleSupplyAllocation, "sale's token balance isn't correct");
        });

        it("should throw exception when less than minimum contribution", async () => {
            let valid = true;
            try {
                web3.eth.sendTransaction({from: accounts[1], to: sale.address, value: 1, gas: 150000});
                valid = false;
            } catch (error) {
            }
            assert(valid, "contribution should not be less than minimum contribution");
            assert.equal(web3.eth.getBalance(sale.address), 0, "contract wei balance should remain at zero");
        });

        it("should throw exception when less than minimum contribution", async () => {
            let valid = true;
            try {
                web3.eth.sendTransaction({from: accounts[1], to: sale.address, value: 1, gas: 150000});
                valid = false;
            } catch (error) {
            }
            assert(valid, "contribution should not be less than minimum contribution");
            assert.equal(web3.eth.getBalance(sale.address), 0, "contract wei balance should remain at zero");
        });

        it("should cap ether at max individual contribution (refund remaining ether & allocate max contribution # of tokens); verifies first tranche discount", async () => {
            let old_balance_wei = web3.eth.getBalance(accounts[1]);
            let hash = web3.eth.sendTransaction({
                from: accounts[1],
                to: sale.address,
                value: web3.toWei(1, 'ether'),
                gas: 150000
            });
            //assert(verifyEvent(hash, eventSigTransfer), "Transfer event wasn't emitted");
            //assert(verifyEvent(hash, eventSigContributionReceived), "ContributionReceived event wasn't emitted");

            // calculate the cost of the gas used
            let tx = web3.eth.getTransaction(hash);
            let txr = web3.eth.getTransactionReceipt(hash);
            let cost = tx.gasPrice * txr.gasUsed;

            let new_balance_wei = web3.eth.getBalance(accounts[1]);

            // the contribution amount is: original wei balance MINUS (post-transaction wei balance PLUS gas costs)
            let actual_contribution_wei = old_balance_wei.minus(new_balance_wei.plus(cost));
            assert.equal(actual_contribution_wei, web3.toWei(1, 'ether'),
                "wei contributed cannot be more than maximum allowed (excess should have been refunded)");

            let new_balance_tokens = await token.balanceOf.call(accounts[1]);

            let discount_rate = discounts[1];
            //let non_discounted_expected = new BigNumber(5000 * web3.toWei(1, 'ether'));
            let pegETHUSD = await sale.peggedETHUSD.call();
            let non_discounted_expected = new BigNumber(actual_contribution_wei * pegETHUSD * new BigNumber(100).dividedBy(baseRateInCents));            

            let acutal_ending_balance =  (new_balance_tokens.minus(account_two_starting_balance)).toNumber();
            let discount_balance_expected = (actual_contribution_wei.times(peggedETHUSD.times(new BigNumber(100).dividedBy(discount_rate))));

            /*
            console.log('discount_rate:' + discount_rate);
            console.log('new_balance_tokens:' + new_balance_tokens);
            console.log('pegETHUSD:' + pegETHUSD);
            console.log('old_balance_wei:'+ old_balance_wei);
            console.log('new_balance_wei:'+ new_balance_wei);
            console.log('cost:'+ cost);
            console.log('actual_contribution_wei:'+ actual_contribution_wei);
            console.log('new_balance_tokens:'+ new_balance_tokens);
            console.log('account_two_starting_balance:'+ account_two_starting_balance);
            console.log('acutal_ending_balance:' + acutal_ending_balance);
            console.log('discount_balance_expected:' + discount_balance_expected);            
            */
            
            let valid = true;
            try {
                await sale.weiRaisedDuringRound.call(0);
                valid = false;
            } catch (error) {}
            assert(valid, "weiRaisedDuringRound uses logical round counts > 0 and <= trancheDiscount.length ");

            let weiRaisedDuringRound1 = (await sale.weiRaisedDuringRound.call(1)).toNumber();
            //console.log('weiRaisedDuringRound 1:' + actual_contribution_wei );
            assert.equal(weiRaisedDuringRound1, actual_contribution_wei, 'weiRaisedDuringRound 1');
            
            let totalWeiRaised = (await sale.totalWeiRaised.call()).toNumber();
            //console.log('totalWeiRaised:' + totalWeiRaised);

            assert.equal(
                new_balance_tokens,
                (discount_rate > 0 ? discount_balance_expected : non_discounted_expected).toNumber(),
                "Should max out at appropriate number of tokens for the first tranche discount rate");
        });

        it("should not allow owner to transfer wei before minimum goal is met", async () => {
            let b = web3.eth.getBalance(sale.address);
            let valid = true;
            try {
                await sale.ownerTransferWei(accounts[2], web3.toWei(0.1, "ether"), {from: owner});
                valid = false;
            } catch (error) {}
            assert(valid, "owner should not be allowed to transfer wei if below minimum goal");
            assert.equal(web3.eth.getBalance(sale.address).toNumber(), b.toNumber(), "contract wei balance should remain the same");
        });

        it("should not allow owner to recover unsold tokens before end of sale", async () => {
            let b = web3.eth.getBalance(sale.address);
            let valid = true;
            try {
                await sale.ownerRecoverTokens(owner, {from: owner});
                valid = false;
            } catch (error) {}
            assert(valid, "owner should not be allowed to recover unsold tokens before end of sale");
            assert.equal(web3.eth.getBalance(sale.address).toNumber(), b.toNumber(), "contract wei balance should remain the same");
        });

        it("should have non-zero balance but still less than minimum goal after first successful transaction attempt", async () => {
            let minGoal = await sale.minFundingGoalWei.call();
            assert.notEqual(web3.eth.getBalance(sale.address).toNumber(), 0, "contract wei balance should not be zero");
            assert.isBelow(web3.eth.getBalance(sale.address).toNumber(), minGoal, "contract wei balance should less than minimum goal");
        });

        it("should move to the second discount tranche when advancing time", async () => {
            let _index = await sale.getCurrentDiscountTrancheIndex.call();
            let discount = await sale.getDiscountTrancheDiscount(_index);
            await increaseTime(172801); // two days in seconds + 1 second
            await evm_mine(); // make sure testrpc updates `now`
            let new_index = await sale.getCurrentDiscountTrancheIndex.call();
            let new_discount = await sale.getDiscountTrancheDiscount(new_index);
            assert.equal(_index + 1, new_index.toNumber(), "tranche index wasn't incremented");
            assert.notEqual(discount, new_discount, "tranche discount is the same as previous tranche discount");
            assert.equal(new_discount, discounts[3], "tranche discount isn't correct");
        });

        //todo test this
        /*it("should prevent any further contribution from someone who has hit their max limit", async () => {
            web3.eth.sendTransaction({
                    from: accounts[1],
                    to: sale.address,
                    value: web3.toWei(90000, 'ether'),
                    gas: 150000
                });

            let valid = true;
            try {
                web3.eth.sendTransaction({
                    from: accounts[1],
                    to: sale.address,
                    value: web3.toWei(90000, 'ether'),
                    gas: 150000
                });
                valid = false;
            } catch (error) {}
            assert(valid, "contribution was allowed when it shouldn't have been");
        });
        */
    })

    contract('Basics', accounts => {
        let isPresale = true;
        let minimumGoal = 2 * web3.toWei(1, 'ether');
        let minimumContribution = 0.1 * web3.toWei(1, 'ether');
        let maximumContribution = 0.5 * web3.toWei(1, 'ether');

        let totalTokenSupply = 50000 * web3.toWei(1, 'ether');
        let saleSupplyAllocation = 30000 * web3.toWei(1, 'ether');

        let hours = 130; // 5 days in hours + 10 hours for 0% discount testing
        let discounts = [
            48, 33, // first 48 hours, 0.33 price
            72, 44  // next 72 hours,  0.44 price
        ];

        let peggedETHUSD = 300;
        let reservedTokens = 0;

        before(async () => {
            token = await Token.new(totalTokenSupply, {from: deployAddress});
            sale = await Sale.new(
                token.address,
                new BigNumber(peggedETHUSD),
                new BigNumber(reservedTokens),
                isPresale,
                new BigNumber(minimumGoal),
                new BigNumber(minimumContribution),
                new BigNumber(maximumContribution),
                new BigNumber(start),
                new BigNumber(hours),
                new BigNumber(baseRateInCents),
                discounts.map(v => new BigNumber(v)),
                {from: deployAddress});
            owner = await sale.owner.call();

            peggedETHUSD = await sale.peggedETHUSD.call();            

            await token.ownerSetOverride(sale.address, true, {from: owner});
        });

        beforeEach(async () => {
            owner_starting_balance = await token.balanceOf.call(owner);
            sale_starting_balance = await token.balanceOf.call(sale.address);
            account_two_starting_balance = await token.balanceOf.call(accounts[1]);
            account_three_starting_balance = await token.balanceOf.call(accounts[2]);

            await sale.pegETHUSD(300, {from: owner});
        });

        it("should have a peggedETHUSD", async () => {
            assert.equal((await sale.peggedETHUSD.call()).toNumber(), 300, "default peggedETHUSD does not match");

            await sale.pegETHUSD(330, {from: owner});

            assert.equal((await sale.peggedETHUSD.call()).toNumber(), 330, "default peggedETHUSD does not match");
        });

        it("should have the correct initial settings", async () => {
            assert.equal((await sale.peggedETHUSD.call()).toNumber(), 300, "default peggedETHUSD does not match");

            assert.equal(token.address, await sale.getTokenAddress.call(), "token addresses do not match");
            assert.equal(owner, accounts[0], "owner address does not match accounts[0]");
            assert.equal(owner, await token.owner.call(), "owner addresses do not match");
            assert.equal(await sale.isPresale.call(), true, "should be presale");
            assert.equal((await sale.minFundingGoalWei.call()).toNumber(), minimumGoal, "min goals do not match");
            assert.equal((await sale.minContributionWei.call()).toNumber(), minimumContribution, "min goals do not match");
            assert.equal((await sale.maxContributionWei.call()).toNumber(), maximumContribution, "max goals do not match");
            assert.equal(sale_starting_balance, 0, "sale's token balance isn't zero");
        });

        it("should have sane discount tranche values", async () => {
            let pointInTime = start = (await sale.start.call()).toNumber();
            let end = (await sale.end.call()).toNumber();
            let trancheEnd, trancheDiscount;
            let i = 0, y = 0;

            while (true) {
                try {
                    trancheEnd = await sale.getDiscountTrancheEnd.call(i);
                    trancheDiscount = await sale.getDiscountTrancheDiscount.call(i);
                    //console.log('trancheEnd:' + trancheEnd);
                    //console.log('trancheDiscount:' + trancheDiscount);
                } catch (error) {
                    break;
                }
                pointInTime = pointInTime + discounts[y] * 3600;
                assert.equal(trancheEnd.toNumber(), pointInTime, "tranche end time is incorrect; index " + i);
                assert.equal(trancheDiscount.toNumber(), discounts[y + 1], "tranche rate is incorrect; index " + i);
                assert.isAtMost(trancheEnd.toNumber(), end, "tranche end time must be less than the sale end time; index " + i);
                ++i;
                y += 2;
            }
        });

        it("should have the correct token balance after initial token transfer", async () => {
            let txr = await token.transfer(sale.address, saleSupplyAllocation, {from: owner});
            //assert(verifyEvent(txr.tx, eventSigTransfer), "Transfer event wasn't emitted");
            assert.equal(await token.balanceOf.call(sale.address), saleSupplyAllocation, "sale's token balance isn't correct");
        });

        it("should throw exception when less than minimum contribution", async () => {
            let valid = true;
            try {
                web3.eth.sendTransaction({from: accounts[1], to: sale.address, value: 1, gas: 150000});
                valid = false;
            } catch (error) {
            }
            assert(valid, "contribution should not be less than minimum contribution");
            assert.equal(web3.eth.getBalance(sale.address), 0, "contract wei balance should remain at zero");
        });

        it("should cap ether at max individual contribution (refund remaining ether & allocate max contribution # of tokens); verifies first tranche discount", async () => {
            let old_balance_wei = web3.eth.getBalance(accounts[1]);
            let hash = web3.eth.sendTransaction({
                from: accounts[1],
                to: sale.address,
                value: web3.toWei(1, 'ether'),
                gas: 150000
            });
            //assert(verifyEvent(hash, eventSigTransfer), "Transfer event wasn't emitted");
            //assert(verifyEvent(hash, eventSigContributionReceived), "ContributionReceived event wasn't emitted");

            // calculate the cost of the gas used
            let tx = web3.eth.getTransaction(hash);
            let txr = web3.eth.getTransactionReceipt(hash);
            let cost = tx.gasPrice * txr.gasUsed;

            let new_balance_wei = web3.eth.getBalance(accounts[1]);

            // the contribution amount is: original wei balance MINUS (post-transaction wei balance PLUS gas costs)
            let actual_contribution_wei = old_balance_wei.minus(new_balance_wei.plus(cost));
            assert.equal(actual_contribution_wei, web3.toWei(0.5, 'ether'),
                "wei contributed cannot be more than maximum allowed (excess should have been refunded)");

            let new_balance_tokens = await token.balanceOf.call(accounts[1]);

            let discount_rate = discounts[1];
            //let non_discounted_expected = new BigNumber(5000 * web3.toWei(1, 'ether'));
            let pegETHUSD = await sale.peggedETHUSD.call();
            let non_discounted_expected = new BigNumber(actual_contribution_wei * pegETHUSD * new BigNumber(100).dividedBy(baseRateInCents));            

            let acutal_ending_balance =  (new_balance_tokens.minus(account_two_starting_balance)).toNumber();
            let discount_balance_expected = (actual_contribution_wei.times(peggedETHUSD.times(new BigNumber(100).dividedBy(discount_rate))));

            /*
            console.log('discount_rate:' + discount_rate);
            console.log('new_balance_tokens:' + new_balance_tokens);
            console.log('pegETHUSD:' + pegETHUSD);
            console.log('old_balance_wei:'+ old_balance_wei);
            console.log('new_balance_wei:'+ new_balance_wei);
            console.log('cost:'+ cost);
            console.log('actual_contribution_wei:'+ actual_contribution_wei);
            console.log('new_balance_tokens:'+ new_balance_tokens);
            console.log('account_two_starting_balance:'+ account_two_starting_balance);
            console.log('acutal_ending_balance:' + acutal_ending_balance);
            console.log('discount_balance_expected:' + discount_balance_expected);            
            */
            
            let valid = true;
            try {
                await sale.weiRaisedDuringRound.call(0);
                valid = false;
            } catch (error) {}
            assert(valid, "weiRaisedDuringRound uses logical round counts > 0 and <= trancheDiscount.length ");

            let weiRaisedDuringRound1 = (await sale.weiRaisedDuringRound.call(1)).toNumber();
            //console.log('weiRaisedDuringRound 1:' + actual_contribution_wei );
            assert.equal(weiRaisedDuringRound1, actual_contribution_wei, 'weiRaisedDuringRound 1');
            
            let totalWeiRaised = (await sale.totalWeiRaised.call()).toNumber();
            //console.log('totalWeiRaised:' + totalWeiRaised);

            assert.equal(
                new_balance_tokens,
                (discount_rate > 0 ? discount_balance_expected : non_discounted_expected).toNumber(),
                "Should max out at appropriate number of tokens for the first tranche discount rate");
        });

        it("should not allow owner to transfer wei before minimum goal is met", async () => {
            let b = web3.eth.getBalance(sale.address);
            let valid = true;
            try {
                await sale.ownerTransferWei(accounts[2], web3.toWei(0.1, "ether"), {from: owner});
                valid = false;
            } catch (error) {}
            assert(valid, "owner should not be allowed to transfer wei if below minimum goal");
            assert.equal(web3.eth.getBalance(sale.address).toNumber(), b.toNumber(), "contract wei balance should remain the same");
        });

        it("should not allow owner to recover unsold tokens before end of sale", async () => {
            let b = web3.eth.getBalance(sale.address);
            let valid = true;
            try {
                await sale.ownerRecoverTokens(owner, {from: owner});
                valid = false;
            } catch (error) {}
            assert(valid, "owner should not be allowed to recover unsold tokens before end of sale");
            assert.equal(web3.eth.getBalance(sale.address).toNumber(), b.toNumber(), "contract wei balance should remain the same");
        });

        it("should have non-zero balance but still less than minimum goal after first successful transaction attempt", async () => {
            let minGoal = await sale.minFundingGoalWei.call();
            assert.notEqual(web3.eth.getBalance(sale.address).toNumber(), 0, "contract wei balance should not be zero");
            assert.isBelow(web3.eth.getBalance(sale.address).toNumber(), minGoal, "contract wei balance should less than minimum goal");
        });

        it("should move to the second discount tranche when advancing time", async () => {
            let _index = await sale.getCurrentDiscountTrancheIndex.call();
            let discount = await sale.getDiscountTrancheDiscount(_index);
            await increaseTime(172801); // two days in seconds + 1 second
            await evm_mine(); // make sure testrpc updates `now`
            let new_index = await sale.getCurrentDiscountTrancheIndex.call();
            let new_discount = await sale.getDiscountTrancheDiscount(new_index);
            assert.equal(_index + 1, new_index.toNumber(), "tranche index wasn't incremented");
            assert.notEqual(discount, new_discount, "tranche discount is the same as previous tranche discount");
            assert.equal(new_discount, discounts[3], "tranche discount isn't correct");
        });

        it("should prevent any further contribution from someone who has hit their max limit", async () => {
            let valid = true;
            try {
                web3.eth.sendTransaction({
                    from: accounts[1],
                    to: sale.address,
                    value: web3.toWei(0.1, 'ether'),
                    gas: 150000
                });
                valid = false;
            } catch (error) {}
            assert(valid, "contribution was allowed when it shouldn't have been");
        });

        it("should allow minimum individual contribution; verifies second tranche discount", async () => {
            let old_balance_wei = web3.eth.getBalance(accounts[2]);
            let oneTenthEtherInWei = web3.toWei(0.1, 'ether');
            let hash = web3.eth.sendTransaction({
                from: accounts[2],
                to: sale.address,
                value: oneTenthEtherInWei,
                gas: 150000
            });
            //assert(verifyEvent(hash, eventSigTransfer), "Transfer event wasn't emitted");
            //assert(verifyEvent(hash, eventSigContributionReceived), "ContributionReceived event wasn't emitted");

            // calculate the cost of the gas used
            let tx = web3.eth.getTransaction(hash);
            let txr = web3.eth.getTransactionReceipt(hash);
            let cost = tx.gasPrice * txr.gasUsed;

            let new_balance_wei = web3.eth.getBalance(accounts[2]);

            // the contribution amount is: original wei balance MINUS (post-transaction wei balance PLUS gas costs)
            let actual_contribution_wei = old_balance_wei.minus(new_balance_wei.plus(cost));
            assert.equal(actual_contribution_wei, web3.toWei(0.1, 'ether'),
                "wei contributed cannot be more than maximum allowed (excess should have been refunded)");

            let new_balance_tokens = await token.balanceOf.call(accounts[2]);

            let discount_rate = discounts[3];
            //let non_discounted_expected = new BigNumber(1000 * web3.toWei(1, 'ether'));
            let pegETHUSD = await sale.peggedETHUSD.call();
            let non_discounted_expected = new BigNumber(actual_contribution_wei * pegETHUSD * new BigNumber(100).dividedBy(baseRateInCents));            

            let acutal_ending_balance =  (new_balance_tokens.minus(account_three_starting_balance)).toNumber();
            let discount_balance_expected = (actual_contribution_wei.times(peggedETHUSD.times(new BigNumber(100).dividedBy(discount_rate))));

            /*
            console.log('discount_rate:' + discount_rate);
            console.log('new_balance_tokens:' + new_balance_tokens);
            console.log('pegETHUSD:' + pegETHUSD);
            console.log('old_balance_wei:'+ old_balance_wei);
            console.log('new_balance_wei:'+ new_balance_wei);
            console.log('cost:'+ cost);
            console.log('actual_contribution_wei:'+ actual_contribution_wei);
            console.log('new_balance_tokens:'+ new_balance_tokens);
            console.log('account_two_starting_balance:'+ account_two_starting_balance);
            console.log('acutal_ending_balance:' + acutal_ending_balance);
            console.log('discount_balance_expected:' + discount_balance_expected);
            */

            let valid = true;
            try {
                await sale.weiRaisedDuringRound.call(0);
                valid = false;
            } catch (error) {}
            assert(valid, "weiRaisedDuringRound uses logical round counts > 0 and <= trancheDiscount.length ");

            let weiRaisedDuringRound1 = (await sale.weiRaisedDuringRound.call(1)).toNumber();            
            //console.log('weiRaisedDuringRound 1:' + weiRaisedDuringRound1 );            

            let weiRaisedDuringRound2 = (await sale.weiRaisedDuringRound.call(2)).toNumber();
            //console.log('weiRaisedDuringRound 2:' + weiRaisedDuringRound2 );
            assert.equal(weiRaisedDuringRound2, actual_contribution_wei, 'weiRaisedDuringRound 2');

            let totalWeiRaised = (await sale.totalWeiRaised.call()).toNumber();
            //console.log('totalWeiRaised:' + totalWeiRaised);

            assert.equal(
                acutal_ending_balance,
                (discount_rate > 0 ? discount_balance_expected : non_discounted_expected).toNumber(),
                "Should max out at appropriate number of tokens for the second tranche discount rate");

        });

        it("should revert to zero discount after all tranche end dates have been passed", async () => {
            await increaseTime(259200); // three days in seconds
            await evm_mine(); // make sure testrpc updates `now`

            let old_balance_wei = web3.eth.getBalance(accounts[2]);
            let hash = web3.eth.sendTransaction({
                from: accounts[2],
                to: sale.address,
                value: web3.toWei(0.4, 'ether'),
                gas: 150000
            });
            //assert(verifyEvent(hash, eventSigTransfer), "Transfer event wasn't emitted");
            //assert(verifyEvent(hash, eventSigContributionReceived), "ContributionReceived event wasn't emitted");

            // calculate the cost of the gas used
            let tx = web3.eth.getTransaction(hash);
            let txr = web3.eth.getTransactionReceipt(hash);
            let cost = tx.gasPrice * txr.gasUsed;

            let new_balance_wei = web3.eth.getBalance(accounts[2]);

            // the contribution amount is: original wei balance MINUS (post-transaction wei balance PLUS gas costs)
            let actual_contribution_wei = old_balance_wei.minus(new_balance_wei.plus(cost));

            assert.equal(actual_contribution_wei.toNumber(), web3.toWei(0.4, 'ether'),
                "wei contributed cannot be more than maximum allowed (excess should have been refunded)");

            let new_balance_tokens = await token.balanceOf.call(accounts[2]);

            //let non_discounted_expected = new BigNumber(4000 * web3.toWei(1, 'ether'));
            let pegETHUSD = await sale.peggedETHUSD.call();
            let non_discounted_expected = new BigNumber(actual_contribution_wei * pegETHUSD * new BigNumber(100).dividedBy(baseRateInCents));            
            
            let valid = true;
            try {
                await sale.weiRaisedDuringRound.call(0);
                valid = false;
            } catch (error) {}
            assert(valid, "weiRaisedDuringRound uses logical round counts > 0 and <= trancheDiscount.length ");

            let weiRaisedDuringRound1 = (await sale.weiRaisedDuringRound.call(1)).toNumber();            
            //console.log('weiRaisedDuringRound 1:' + weiRaisedDuringRound1 );            

            let weiRaisedDuringRound2 = (await sale.weiRaisedDuringRound.call(2)).toNumber();
            //console.log('weiRaisedDuringRound 2:' + weiRaisedDuringRound2 );
            assert.equal(weiRaisedDuringRound2, web3.toWei(0.1, 'ether'), 'weiRaisedDuringRound 2 from this user should be limited - (excess refunded)');
                    
            try {
                await sale.weiRaisedDuringRound.call(3);
                valid = false;
            } catch (error) {}
            assert(valid, "weiRaisedDuringRound uses logical round counts > 0 and <= trancheDiscount.length ");

            let weiRaisedAfterAllDiscounts = (await sale.weiRaisedAfterDiscountRounds.call()).toNumber();
            //console.log('weiRaisedAfterDiscounts:' + weiRaisedAfterAllDiscounts );
            assert.equal(weiRaisedAfterAllDiscounts, web3.toWei(0.4, 'ether'), 'weiRaisedAfterAllDiscounts');

            let totalWeiRaised = (await sale.totalWeiRaised.call()).toNumber();
            //console.log('totalWeiRaised:' + totalWeiRaised);

            assert.equal(
                (new_balance_tokens.minus(account_three_starting_balance)).toNumber(),
                non_discounted_expected.toNumber(),
                "Should max out at appropriate number of tokens at zero % discount rate");
        });

        it("should approach minimum goal without exceeding", async () => {
            let minGoal = await sale.minFundingGoalWei.call();

            let hash = web3.eth.sendTransaction({
                from: accounts[3],
                to: sale.address,
                value: web3.toWei(0.5, 'ether'),
                gas: 150000
            });
            //assert(verifyEvent(hash, eventSigTransfer), "Transfer event wasn't emitted");
            //assert(verifyEvent(hash, eventSigContributionReceived), "ContributionReceived event wasn't emitted");
            assert.isBelow(web3.eth.getBalance(sale.address).toNumber(), minGoal, "contract wei balance should less than minimum goal");
        });

        it("should equal minimum goal", async () => {
            let minGoal = await sale.minFundingGoalWei.call();

            let hash = web3.eth.sendTransaction({
                from: accounts[4],
                to: sale.address,
                value: web3.toWei(0.5, 'ether'),
                gas: 150000
            });
            //assert(verifyEvent(hash, eventSigTransfer), "Transfer event wasn't emitted");
            //assert(verifyEvent(hash, eventSigContributionReceived), "ContributionReceived event wasn't emitted");
            assert.equal(web3.eth.getBalance(sale.address).toNumber(), minGoal, "contract wei balance should equal to minimum goal");
        });

        it("should allow owner to transfer wei after minimum goal is met", async () => {
            let b = web3.eth.getBalance(sale.address);
            let _amount = web3.toWei(0.1, "ether");
            await sale.ownerTransferWei(accounts[2], _amount, {from: owner});
            assert.equal(web3.eth.getBalance(sale.address).toNumber(), b.minus(_amount).toNumber(), "contract wei balance should decrease accordingly");
        });

        it("should not allow owner to transfer wei to invalid addresses", async () => {
            let b = web3.eth.getBalance(sale.address);
            let _amount = web3.toWei(0.1, "ether");

            let valid = true;
            try {
                await sale.ownerTransferWei(0x0, _amount, {from: owner});
                valid = false;
            } catch (error) {}
            assert(valid, "owner should not be allowed to transfer wei to 0x0");

            valid = true;
            try {
                await sale.ownerTransferWei(token.address, _amount, {from: owner});
                valid = false;
            } catch (error) {}
            assert(valid, "owner should not be allowed to transfer wei to the token's address");

            assert.equal(web3.eth.getBalance(sale.address).toNumber(), b.toNumber(), "contract wei balance should remain the same");
        });

        it("should not allow owner to recover unsold tokens to invalid addresses", async () => {
            let b = await token.balanceOf(sale.address);
            let valid = true;
            try {
                await sale.ownerRecoverTokens(0x0, {from: owner});
                valid = false;
            } catch (error) {}
            assert(valid, "owner should not be allowed to recover tokens to 0x0");

            valid = true;
            try {
                await sale.ownerRecoverTokens(token.address, {from: owner});
                valid = false;
            } catch (error) {}
            assert(valid, "owner should not be allowed to recover tokens to the token's address");
            assert.equal((await token.balanceOf(sale.address)).toNumber(), b.toNumber(), "contract token balance should remain the same");
        });

        it("should exceed minimum goal", async () => {
            let minGoal = await sale.minFundingGoalWei.call();

            let hash = web3.eth.sendTransaction({
                from: accounts[5],
                to: sale.address,
                value: web3.toWei(0.5, 'ether'),
                gas: 150000
            });
            //assert(verifyEvent(hash, eventSigTransfer), "Transfer event wasn't emitted");
            //assert(verifyEvent(hash, eventSigContributionReceived), "ContributionReceived event wasn't emitted");
            assert.isAbove(web3.eth.getBalance(sale.address).toNumber(), minGoal, "contract wei balance should greater or equal to minimum goal");
        });

        it("should stop allowing contributions after the sale end date", async () => {
            await increaseTime(864000); // ten days in seconds puts us after the sale end date
            await evm_mine(); // make sure testrpc updates `now`

            let valid = true;
            try {
                web3.eth.sendTransaction({
                    from: accounts[6],
                    to: sale.address,
                    value: web3.toWei(0.2, "ether"),
                    gas: 150000
                });
                valid = false;
            } catch (error) {}
            assert(valid, "contribution should not allowed after end date!");
        });

        it("should allow ether top-up after the sale end date", async () => {
            let _balance = web3.eth.getBalance(sale.address);
            let _contribution = web3.toWei(0.15, 'ether');
            await sale.ownerTopUp({from: accounts[1], value: _contribution, gas: 150000});
            assert.equal(web3.eth.getBalance(sale.address).toNumber(), _balance.add(_contribution).toNumber(), "contract wei balance be increased by top-up amount");
        });
    });

    contract('Goal met, no minimum', accounts => {
        let totalTokenSupply = 10000 * web3.toWei(1, 'ether');
        let saleSupplyAllocation = 5000 * web3.toWei(1, 'ether');

        let isPresale = false;
        let minimumGoal = 0;
        let minimumContribution = 0.1 * web3.toWei(1, 'ether');
        let maximumContribution = 0.5 * web3.toWei(1, 'ether');

        let hours = 24; // 1 day in hours

        let peggedETHUSD = 330;
        let reservedTokens = 0;

        before(async () => {
            token = await Token.new(totalTokenSupply, {from: deployAddress});
            sale = await Sale.new(
                token.address,
                new BigNumber(peggedETHUSD),
                new BigNumber(reservedTokens),
                isPresale,
                new BigNumber(minimumGoal),
                new BigNumber(minimumContribution),
                new BigNumber(maximumContribution),
                new BigNumber(start),
                new BigNumber(hours),
                new BigNumber(baseRateInCents),
                discounts.map(v => new BigNumber(v)),
                {from: deployAddress});
            owner = await sale.owner.call();

            await token.ownerSetOverride(sale.address, true, {from: owner});
        });

        beforeEach(async () => {
            owner_starting_balance = await token.balanceOf.call(owner);
            sale_starting_balance = await token.balanceOf.call(sale.address);
            account_two_starting_balance = await token.balanceOf.call(accounts[1]);
            account_three_starting_balance = await token.balanceOf.call(accounts[2]);
        });

        it("should have the correct initial settings", async () => {
            assert.equal(token.address, await sale.getTokenAddress.call(), "token addresses do not match");
            assert.equal(owner, accounts[0], "owner address does not match accounts[0]");
            assert.equal(owner, await token.owner.call(), "owner addresses do not match");
            assert.equal(await sale.isPresale.call(), false, "should not be presale");
            assert.equal((await sale.minFundingGoalWei.call()).toNumber(), minimumGoal, "min goals do not match");
            assert.equal((await sale.minContributionWei.call()).toNumber(), minimumContribution, "min goals do not match");
            assert.equal((await sale.maxContributionWei.call()).toNumber(), maximumContribution, "max goals do not match");
            assert.equal(sale_starting_balance, 0, "sale's token balance isn't zero");
        });

        it("should have the correct token balance after initial token transfer", async () => {
            let r = await token.transfer(sale.address, saleSupplyAllocation, {from: owner});
            assert.equal(await token.balanceOf.call(sale.address), saleSupplyAllocation, "sale's token balance isn't correct");
            //assert(verifyEvent(r.tx, eventSigTransfer), "Transfer event wasn't emitted");
        });

        it("should allow a contribution", async () => {
            assert.equal(web3.eth.getBalance(sale.address), 0, "sale ether balance should be zero");

            let hash = web3.eth.sendTransaction({from: accounts[1], to: sale.address, value: web3.toWei(0.5, "ether"), gas: 150000});
            //assert(verifyEvent(hash, eventSigTransfer), "Transfer event wasn't emitted");
            //assert(verifyEvent(hash, eventSigContributionReceived), "ContributionReceived event wasn't emitted");

            assert.equal(web3.eth.getBalance(sale.address).toNumber(), web3.toWei(0.5, "ether"), "no ether contributions were received");
        });

        it("should not allow token recovery before end of sale", async () => {
            let valid = true;
            try {
                await sale.ownerRecoverTokens(owner, {from: owner});
                valid = false;
            } catch (error) {}
            assert(valid, "transfer of tokens before end of sale is not allowed");

            assert.equal((await token.balanceOf.call(owner)).toNumber(), owner_starting_balance.toNumber(), "tokens should not have been transferred to owner");
            assert.equal((await token.balanceOf.call(sale.address)).toNumber(), sale_starting_balance.toNumber(), "tokens should not have been transferred from sale");
        });

        it("should not allow wei withdrawal by non-owner", async () => {
            let valid = true;
            try {
                await sale.ownerTransferWei(accounts[2], web3.toWei(0.1, "ether"), {from: accounts[9]});
                valid = false;
            } catch (error) {}
            assert(valid, "non-owner should not be allowed to transfer wei");
        });

        it("should allow wei withdrawal by owner at any time (because there is no minimum goal)", async () => {
            let saleBalance = web3.eth.getBalance(sale.address);
            let account2Balance = web3.eth.getBalance(accounts[2]);

            await sale.ownerTransferWei(accounts[2], web3.toWei(0.1, "ether"), {from: owner});

            assert.equal(web3.eth.getBalance(sale.address).toNumber(), saleBalance.minus(web3.toWei(0.1, "ether")).toNumber(), "ether was not transferred from sale correctly");
            assert.equal(web3.eth.getBalance(accounts[2]).toNumber(), account2Balance.add(web3.toWei(0.1, "ether")).toNumber(), "ether was not transferred to receipient correctly");
        });

        it("should not allow wei withdrawal by non-owner after sale end data either", async () => {
            await increaseTime(172800); // two days in seconds puts us after the sale end date
            await evm_mine(); // make sure testrpc updates `now`

            let valid = true;
            try {
                await sale.ownerTransferWei(accounts[2], web3.toWei(0.1, "ether"), {from: accounts[9]});
                valid = false;
            } catch (error) {}
            assert(valid, "non-owner should not be allowed to transfer wei after sale end date");
        });

        it("should not allow token recovery by non-owner", async () => {
            let valid = true;
            try {
                await sale.ownerRecoverTokens(owner, {from: accounts[9]});
                valid = false;
            } catch (error) {}
            assert(valid, "transfer of tokens by non-owner is not allowed");

            assert.equal((await token.balanceOf.call(sale.address)).toNumber(), sale_starting_balance.toNumber(), "tokens should not have been transferred from sale");
        });

        it("should not allow token recovery to an invalid address (token address or 0x0)", async () => {
            let valid = true;
            try {
                await sale.ownerRecoverTokens(token.address, {from: owner});
                valid = false;
            } catch (error) {}
            assert(valid, "transfer of tokens to token address shouldn't be allowed");

            valid = true;
            try {
                await sale.ownerRecoverTokens(0, {from: owner});
                valid = false;
            } catch (error) {}
            assert(valid, "transfer of tokens to token address shouldn't be allowed");
        });

        it("should allow wei withdrawal by owner after sale end date", async () => {
            let saleBalance = web3.eth.getBalance(sale.address);
            let account4Balance = web3.eth.getBalance(accounts[4]);

            await sale.ownerTransferWei(accounts[4], web3.toWei(0.1, "ether"), {from: owner});

            assert.equal(web3.eth.getBalance(sale.address).toNumber(), saleBalance.minus(web3.toWei(0.1, "ether")).toNumber(), "ether was not transferred from sale correctly");
            assert.equal(web3.eth.getBalance(accounts[4]).toNumber(), account4Balance.add(web3.toWei(0.1, "ether")).toNumber(), "ether was not transferred to receipient correctly");
        });

        it("should allow owner token recovery after end of sale", async () => {
            await sale.ownerRecoverTokens(owner, {from: owner});

            assert.equal((await token.balanceOf.call(owner)).toNumber(), owner_starting_balance.plus(sale_starting_balance).toNumber(), "all tokens should have been transferred to owner from sale address");
            assert.equal(await token.balanceOf.call(sale.address), 0, "all tokens should have been transferred from sale");
        });
    });

    contract('Goal met, no minimum, refunding prorata', accounts => {
        let totalTokenSupply = 50000 * web3.toWei(1, 'ether');
        let saleSupplyAllocation = 20000 * web3.toWei(1, 'ether');

        let isPresale = false;
        let minimumGoal = 0;
        let minimumContribution = 0.1 * web3.toWei(1, 'ether');
        let maximumContribution = 0.5 * web3.toWei(1, 'ether');

        let hours = 24; // 1 day in hours

        let peggedETHUSD = 300;
        let reservedTokens = 0;

        before(async () => {
            token = await Token.new(totalTokenSupply, {from: deployAddress});
            sale = await Sale.new(
                token.address,
                new BigNumber(peggedETHUSD),
                new BigNumber(reservedTokens),
                isPresale,
                new BigNumber(minimumGoal),
                new BigNumber(minimumContribution),
                new BigNumber(maximumContribution),
                new BigNumber(start),
                new BigNumber(hours),
                new BigNumber(baseRateInCents),
                discounts.map(v => new BigNumber(v)),
                {from: deployAddress});
            owner = await sale.owner.call();

            await token.ownerSetOverride(sale.address, true, {from: owner});
        });

        beforeEach(async () => {
            owner_starting_balance = await token.balanceOf.call(owner);
            sale_starting_balance = await token.balanceOf.call(sale.address);
            account_two_starting_balance = await token.balanceOf.call(accounts[1]);
            account_three_starting_balance = await token.balanceOf.call(accounts[2]);
        });

        it("should have the correct initial settings", async () => {
            assert.equal(token.address, await sale.getTokenAddress.call(), "token addresses do not match");
            assert.equal(owner, accounts[0], "owner address does not match accounts[0]");
            assert.equal(owner, await token.owner.call(), "owner addresses do not match");
            assert.equal(await sale.isPresale.call(), false, "should not be presale");
            assert.equal((await sale.minFundingGoalWei.call()).toNumber(), minimumGoal, "min goals do not match");
            assert.equal((await sale.minContributionWei.call()).toNumber(), minimumContribution, "min goals do not match");
            assert.equal((await sale.maxContributionWei.call()).toNumber(), maximumContribution, "max goals do not match");
            assert.equal(sale_starting_balance, 0, "sale's token balance isn't zero");
        });

        it("should have the correct token balance after initial token transfer", async () => {
            let r = await token.transfer(sale.address, saleSupplyAllocation, {from: owner});
            assert.equal(await token.balanceOf.call(sale.address), saleSupplyAllocation, "sale's token balance isn't correct");
            //assert(verifyEvent(r.tx, eventSigTransfer), "Transfer event wasn't emitted");
        });

        it("should allow contributions", async () => {
            assert.equal(web3.eth.getBalance(sale.address), 0, "sale ether balance should be zero");

            let hash = web3.eth.sendTransaction({from: accounts[1], to: sale.address, value: web3.toWei(0.5, "ether"), gas: 150000});
            //assert(verifyEvent(hash, eventSigTransfer), "Transfer event wasn't emitted");
            //assert(verifyEvent(hash, eventSigContributionReceived), "ContributionReceived event wasn't emitted");

            hash = web3.eth.sendTransaction({from: accounts[2], to: sale.address, value: web3.toWei(0.4, "ether"), gas: 150000});
            //assert(verifyEvent(hash, eventSigTransfer), "Transfer event wasn't emitted");
            //assert(verifyEvent(hash, eventSigContributionReceived), "ContributionReceived event wasn't emitted");

            hash = web3.eth.sendTransaction({from: accounts[3], to: sale.address, value: web3.toWei(0.5, "ether"), gas: 150000});
            //assert(verifyEvent(hash, eventSigTransfer), "Transfer event wasn't emitted");
            //assert(verifyEvent(hash, eventSigContributionReceived), "ContributionReceived event wasn't emitted");

            assert.equal(web3.eth.getBalance(sale.address).toNumber(), web3.toWei(1.4, "ether"), "incorrect ether contributions were received");
        });

        it("should allow wei withdrawal by owner at any time (because there is no minimum goal)", async () => {
            let saleBalance = web3.eth.getBalance(sale.address);
            let account2Balance = web3.eth.getBalance(accounts[2]);

            await sale.ownerTransferWei(accounts[2], web3.toWei(1, "ether"), {from: owner});

            assert.equal(web3.eth.getBalance(sale.address).toNumber(), saleBalance.minus(web3.toWei(1, "ether")).toNumber(), "ether was not transferred from sale correctly");
            assert.equal(web3.eth.getBalance(accounts[2]).toNumber(), account2Balance.add(web3.toWei(1, "ether")).toNumber(), "ether was not transferred to receipient correctly");
        });

        it("should prevent enabling refunding without pausing or being after end of sale", async () => {
            let valid = true;
            try {
                await sale.ownerEnableRefunds({from: owner});
                valid = false;
            } catch (error) {}
            assert(valid, "should not be allowed to enable refunding");

            assert.isNotOk(await sale.isRefunding.call(), "refunding should still be disabled");
        });

        it("should prevent pausing if non-owner", async () => {
            let valid = true;
            try {
                await sale.pause({from: accounts[9]});
                valid = false;
            } catch (error) {}
            assert(valid, "should not be allowed to pause sale");

            assert.isNotOk(await sale.paused.call(), "should not be paused");
        });

        it("should allow pausing sale", async () => {
            await sale.pause({from: owner});
            assert.isOk(await sale.paused.call(), "should still be paused");
        });

        it("should not allow any contributions after pausing", async () => {
            let b = web3.eth.getBalance(sale.address);

            let valid = true;
            try {
                web3.eth.sendTransaction({from: accounts[5], to: sale.address, value: web3.toWei(0.5, "ether"), gas: 150000});
                valid = false;
            } catch (error) {}
            assert(valid, "should not be allowed to contribute if sale is paused");

            assert.equal(web3.eth.getBalance(sale.address).toNumber(), b.toNumber(), "ether contributions should not have been accepted");
        });

        it("should allow enabling refunding after pausing sale", async () => {
            assert.equal(await sale.getWeiForRefund.call(), 0, "weiForRefund should be zero");
            await sale.ownerEnableRefunds({from: owner});
            assert.isOk(await sale.isRefunding.call(), "refunding should be enabled");
            assert.equal((await sale.getWeiForRefund.call()).toNumber(), web3.toWei(0.4, "ether"), "weiForRefund should be correct");
            assert.equal((await sale.getWeiForRefund.call()).toNumber(), web3.eth.getBalance(sale.address).toNumber(), "weiForRefund should be correct");
        });

        it("should prevent pausing if already paused", async () => {
            let valid = true;
            try {
                await sale.pause({from: owner});
                valid = false;
            } catch (error) {}
            assert(valid, "should not be allowed to pause if already paused");

            assert.isOk(await sale.paused.call(), "should still be paused");
        });

        it("should not allow any contributions while refunding and paused", async () => {
            let b = web3.eth.getBalance(sale.address);

            let valid = true;
            try {
                web3.eth.sendTransaction({from: accounts[6], to: sale.address, value: web3.toWei(0.5, "ether"), gas: 150000});
                valid = false;
            } catch (error) {}
            assert(valid, "should not be allowed to contribute");

            assert.equal(web3.eth.getBalance(sale.address).toNumber(), b.toNumber(), "ether contributions should not have been accepted");
        });

        it("should prevent unpausing if non-owner", async () => {
            let valid = true;
            try {
                await sale.unpause({from: accounts[9]});
                valid = false;
            } catch (error) {}
            assert(valid, "should not be allowed to unpause");

            assert.isOk(await sale.paused.call(), "should still be paused");
        });

        it("should not allow any contributions while refunding, even after unpausing", async () => {
            await sale.unpause({from: owner});

            let b = web3.eth.getBalance(sale.address);

            let valid = true;
            try {
                web3.eth.sendTransaction({from: accounts[7], to: sale.address, value: web3.toWei(0.5, "ether"), gas: 150000});
                valid = false;
            } catch (error) {}
            assert(valid, "should not be allowed to contribute");

            assert.equal(web3.eth.getBalance(sale.address).toNumber(), b.toNumber(), "ether contributions should not have been accepted");
        });

        it("should have proper token and eth balances for participants after refunding complete", async () => {
            let b = web3.eth.getBalance(sale.address);
            let weiForRefund = await sale.getWeiForRefund.call();
            let weiRaised = await sale.weiRaised.call();


            let ub = web3.eth.getBalance(accounts[1]);
            let _wei = await sale.contributions.call(accounts[1]);
            let _refund = weiForRefund.mul(_wei).div(weiRaised);
            let result = await token.claimRefund(sale.address, {from: accounts[1]});
            //assert(verifyEvent(result.tx, eventSigRefunded), "Refunded event wasn't emitted");
            //assert(verifyEvent(result.tx, eventSigTransfer), "Transfer event wasn't emitted");
            // calculate the cost of the gas used
            let tx = web3.eth.getTransaction(result.tx);
            let txr = result.receipt;
            let cost = tx.gasPrice * txr.gasUsed;
            assert.equal(web3.eth.getBalance(accounts[1]).minus(_refund).toNumber(), ub.minus(cost).toNumber(), "ether balance should match calculated value");

            ub = web3.eth.getBalance(accounts[2]);
            _wei = await sale.contributions.call(accounts[2]);
            _refund = weiForRefund.mul(_wei).div(weiRaised);
            result = await token.claimRefund(sale.address, {from: accounts[2]});
            //assert(verifyEvent(result.tx, eventSigRefunded), "Refunded event wasn't emitted");
            //assert(verifyEvent(result.tx, eventSigTransfer), "Transfer event wasn't emitted");
            // calculate the cost of the gas used
            tx = web3.eth.getTransaction(result.tx);
            txr = result.receipt;
            cost = tx.gasPrice * txr.gasUsed;
            assert.equal(web3.eth.getBalance(accounts[2]).minus(_refund).toNumber(), ub.minus(cost).toNumber(), "ether balance should match calculated value");

            ub = web3.eth.getBalance(accounts[3]);
            _wei = await sale.contributions.call(accounts[3]);
            _refund = weiForRefund.mul(_wei).div(weiRaised);
            result = await token.claimRefund(sale.address, {from: accounts[3]});
            //assert(verifyEvent(result.tx, eventSigRefunded), "Refunded event wasn't emitted");
            //assert(verifyEvent(result.tx, eventSigTransfer), "Transfer event wasn't emitted");
            // calculate the cost of the gas used
            tx = web3.eth.getTransaction(result.tx);
            txr = result.receipt;
            cost = tx.gasPrice * txr.gasUsed;
            assert.equal(web3.eth.getBalance(accounts[3]).minus(_refund).toNumber(), ub.minus(cost).toNumber(), "ether balance should match calculated value");

            assert.isAtMost(web3.eth.getBalance(sale.address).toNumber(), 100, "eth balance should be really low (might be a remainder if pro-rata couldn't allocate it out)");
            assert.equal((await token.balanceOf.call(owner)).plus(await token.balanceOf.call(sale.address)), totalTokenSupply, "totalTokenSupply not accounted for");

            assert.equal(await token.balanceOf.call(accounts[1]), 0, "token balance 1 wasn't zero");
            assert.equal(await token.balanceOf.call(accounts[2]), 0, "token balance 2 wasn't zero");
            assert.equal(await token.balanceOf.call(accounts[3]), 0, "token balance 3 wasn't zero");
        });
    });

    contract('Goal not met, refunding', accounts => {
        let totalTokenSupply = 50000 * web3.toWei(1, 'ether');
        let saleSupplyAllocation = 30000 * web3.toWei(1, 'ether');

        let isPresale = true;
        let minimumGoal = 0.5 * web3.toWei(1, 'ether');
        let minimumContribution = 0.1 * web3.toWei(1, 'ether');
        let maximumContribution = 0.5 * web3.toWei(1, 'ether');

        let hours = 24; // 1 days in hours

        let peggedETHUSD = 300;
        let reservedTokens = 0;

        before(async () => {
            token = await Token.new(totalTokenSupply, {from: deployAddress});
            sale = await Sale.new(
                token.address,
                new BigNumber(peggedETHUSD),
                new BigNumber(reservedTokens),
                isPresale,
                new BigNumber(minimumGoal),
                new BigNumber(minimumContribution),
                new BigNumber(maximumContribution),
                new BigNumber(start),
                new BigNumber(hours),
                new BigNumber(baseRateInCents),
                discounts.map(v => new BigNumber(v)),
                {from: deployAddress});
            owner = await sale.owner.call();

            await token.ownerSetOverride(sale.address, true, {from: owner});
        });

        beforeEach(async () => {
            owner_starting_balance = await token.balanceOf.call(owner);
            sale_starting_balance = await token.balanceOf.call(sale.address);
            account_two_starting_balance = await token.balanceOf.call(accounts[1]);
            account_three_starting_balance = await token.balanceOf.call(accounts[2]);
        });

        it("should have the correct initial settings", async () => {
            assert.equal(token.address, await sale.getTokenAddress.call(), "token addresses do not match");
            assert.equal(owner, accounts[0], "owner address does not match accounts[0]");
            assert.equal(owner, await token.owner.call(), "owner addresses do not match");
            assert.equal(await sale.isPresale.call(), true, "should be presale");
            assert.equal((await sale.minFundingGoalWei.call()).toNumber(), minimumGoal, "min goals do not match");
            assert.equal((await sale.minContributionWei.call()).toNumber(), minimumContribution, "min goals do not match");
            assert.equal((await sale.maxContributionWei.call()).toNumber(), maximumContribution, "max goals do not match");
            assert.equal(sale_starting_balance, 0, "sale's token balance isn't zero");
        });

        it("should have the correct token balance after initial token transfer", async () => {
            let r = await token.transfer(sale.address, saleSupplyAllocation, {from: owner});
            assert.equal(await token.balanceOf.call(sale.address), saleSupplyAllocation, "sale's token balance isn't correct");
            //assert(verifyEvent(r.tx, eventSigTransfer), "Transfer event wasn't emitted");
        });

        it("should remain below minimal goal after insufficient ether contributions", async () => {
            // do a purchase, but not enough to put us over our min raising goal
            let hash = web3.eth.sendTransaction({from: accounts[1], to: sale.address, value: web3.toWei(0.1, "ether"), gas: 150000});
            //assert(verifyEvent(hash, eventSigTransfer), "Transfer event wasn't emitted");
            //assert(verifyEvent(hash, eventSigContributionReceived), "ContributionReceived event wasn't emitted");
            hash = web3.eth.sendTransaction({from: accounts[2], to: sale.address, value: web3.toWei(0.1, "ether"), gas: 150000});
            //assert(verifyEvent(hash, eventSigTransfer), "Transfer event wasn't emitted");
            //assert(verifyEvent(hash, eventSigContributionReceived), "ContributionReceived event wasn't emitted");
            hash = web3.eth.sendTransaction({from: accounts[3], to: sale.address, value: web3.toWei(0.1, "ether"), gas: 150000});
            //assert(verifyEvent(hash, eventSigTransfer), "Transfer event wasn't emitted");
            //assert(verifyEvent(hash, eventSigContributionReceived), "ContributionReceived event wasn't emitted");
            hash = web3.eth.sendTransaction({from: accounts[4], to: sale.address, value: web3.toWei(0.1, "ether"), gas: 150000});
            //assert(verifyEvent(hash, eventSigTransfer), "Transfer event wasn't emitted");
            //assert(verifyEvent(hash, eventSigContributionReceived), "ContributionReceived event wasn't emitted");

            let b = web3.eth.getBalance(sale.address);
            assert.isAbove(b, 0, "no ether contributions were received");
            assert.isBelow(b, minimumGoal, "minimum goal was reached when it shouldn't have been");
        });

        it("should prevent enabling refunding without pausing or being after end of sale", async () => {
            let valid = true;
            try {
                await sale.ownerEnableRefunds({from: owner});
                valid = false;
            } catch (error) {}
            assert(valid, "should not be allowed to enable refunding");

            assert.isNotOk(await sale.isRefunding.call(), "refunding should still be disabled");
        });

        it("should stop allowing contributions after the sale end date", async () => {
            await increaseTime(172800); // two days in seconds puts us after the sale end date
            await evm_mine(); // make sure testrpc updates `now`

            // little extra check to make sure we can't contribute after sale end
            let valid = true;
            try {
                web3.eth.sendTransaction({from: accounts[3], to: sale.address, value: web3.toWei(0.2, "ether"), gas: 150000});
                valid = false;
            } catch (error) {}
            assert(valid, "should not be allowed to contribute after sale end");
        });

        it("should allow ether top-up after the sale end date and before enabling refunds", async () => {
            let _balance = web3.eth.getBalance(sale.address);
            let _contribution = web3.toWei(1, 'ether');
            await sale.ownerTopUp({from: owner, value: _contribution, gas: 150000});
            assert.equal(web3.eth.getBalance(sale.address).toNumber(), _balance.add(_contribution).toNumber(), "contract wei balance be increased by top-up amount");
        });

        it("should allow refunding when minimum goal not met", async () => {
            assert.isNotOk(await sale.isRefunding.call(), "refunding should not be enabled yet");
            let txr = await sale.ownerEnableRefunds({from: owner});
            assert.isOk(await sale.isRefunding.call(), "refunding should be enabled");
            //assert(verifyEvent(txr.tx, eventSigRefundsEnabled), "RefundsEnabled event wasn't emitted");
        });

        it("should prevent enabling refunding a second time", async () => {
            let valid = true;
            try {
                await sale.ownerEnableRefunds({from: owner});
                valid = false;
            } catch (error) {}
            assert(valid, "should not be allowed to enable refunding twice");

            assert.isOk(await sale.isRefunding.call(), "refunding should still be enabled");
        });

        it("should throw exception if invalid sale address is used by valid contributor", async () => {
            let valid = true;
            try {
                await token.claimRefund(0x12345, {from: accounts[1]});
                valid = false;
            } catch (error) {}
            assert(valid, "should not have allowed the refund to go through");
        });

        it("should prevent non-contributor from getting ether from the refund process", async () => {
            let valid = true;
            try {
                await token.claimRefund(sale.address, {from: accounts[8]});
                valid = false;
            } catch (error) {}
            assert(valid, "should not have allowed the refund to go through");
        });

        it("should allow contributor to get ether from the refund process in exchange for their tokens", async () => {
            let sale_balance_eth = web3.eth.getBalance(sale.address);
            let account2_balance_eth = web3.eth.getBalance(accounts[1]);

            let result = await token.claimRefund(sale.address, {from: accounts[1]});

            let sale_balance_eth2 = web3.eth.getBalance(sale.address);
            let account2_balance_eth2 = web3.eth.getBalance(accounts[1]);

            let owner_balance_token2 = await token.balanceOf.call(owner);
            let account2_balance_token2 = await token.balanceOf.call(accounts[1]);

            // calculate the cost of the gas used
            let tx = web3.eth.getTransaction(result.tx);
            let txr = result.receipt;
            let cost = tx.gasPrice * txr.gasUsed;

            //assert(verifyEvent(result.tx, eventSigRefunded), "Refunded event wasn't emitted");

            let diff_tokens = account_two_starting_balance.minus(account2_balance_token2);
            let diff_eth = account2_balance_eth.minus(account2_balance_eth2.plus(cost));
            let owner_token_diff = owner_balance_token2.minus(owner_starting_balance);

            assert.equal(account2_balance_token2.toNumber(), 0, "the contributor account has 0 token balance after refund")
            assert.equal(diff_tokens.toNumber(), owner_token_diff.toNumber(), "token balances did not transfer correctly");

            assert.equal(diff_eth.toNumber(), (sale_balance_eth2.minus(sale_balance_eth)).toNumber(), "eth balances did not transfer correctly");
        });

        it("should prevent already-refunded contributors from requesting refund again", async () => {
            let valid = true;
            try {
                await token.claimRefund(sale.address, {from: accounts[1]});
                valid = false;
            } catch (error) {}
            assert(valid, "somehow allowed a second refund request to go through");
        });

        it("should have proper token and eth balances for participants after refunding complete", async () => {
            let txr = await token.claimRefund(sale.address, {from: accounts[2]});
            //assert(verifyEvent(txr.tx, eventSigRefunded), "Refunded event wasn't emitted");
            //assert(verifyEvent(txr.tx, eventSigTransfer), "Transfer event wasn't emitted");
            txr = await token.claimRefund(sale.address, {from: accounts[3]});
            //assert(verifyEvent(txr.tx, eventSigRefunded), "Refunded event wasn't emitted");
            //assert(verifyEvent(txr.tx, eventSigTransfer), "Transfer event wasn't emitted");
            txr = await token.claimRefund(sale.address, {from: accounts[4]});
            //assert(verifyEvent(txr.tx, eventSigRefunded), "Refunded event wasn't emitted");
            //assert(verifyEvent(txr.tx, eventSigTransfer), "Transfer event wasn't emitted");

            assert.equal(web3.eth.getBalance(sale.address), web3.toWei(1, 'ether'), "eth balance should be 1 ether due to previous topup");
            assert.equal((await token.balanceOf.call(owner)).plus(
                await token.balanceOf.call(sale.address)), totalTokenSupply, "totalTokenSupply not accounted for");

            assert.equal(await token.balanceOf.call(accounts[1]), 0, "token balance 1 wasn't zero");
            assert.equal(await token.balanceOf.call(accounts[2]), 0, "token balance 2 wasn't zero");
            assert.equal(await token.balanceOf.call(accounts[3]), 0, "token balance 3 wasn't zero");
            assert.equal(await token.balanceOf.call(accounts[4]), 0, "token balance 4 wasn't zero");
        });
    });

});
