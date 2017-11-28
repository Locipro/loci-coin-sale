const SafeMath = artifacts.require('zeppelin-solidity/contracts/math/SafeMath.sol');
const Ownable = artifacts.require('zeppelin-solidity/contracts/math/Ownable.sol');
const LOCIcoin = artifacts.require("./LOCIcoin.sol");
const LOCIsale = artifacts.require("./LOCIsale.sol");

const BigNumber = require('bignumber.js');

module.exports = (deployer, network, accounts) => {
    let totalSupply, minimumGoal, minimumContribution, maximumContribution, deployAddress, start, hours, isPresale, discounts;
    let peggedETHUSD, hardCapETHinWei, reservedTokens, baseRateInCents;     

    
        peggedETHUSD = 300; // always specified in whole USD. 300 = $300   

        deployAddress = accounts[0];
        totalSupply =    new BigNumber(100000000 * Math.pow(10,18)); // 100Million
        reservedTokens = new BigNumber(0);
        hardCapETHinWei = new BigNumber(   64000 * Math.pow(10,18)); // 64000 ETH in wei
        minimumGoal = new BigNumber(50000 * Math.pow(10,18)); // 50000 ETH in wei
        minimumContribution = new BigNumber(0.1 * Math.pow(10,18)); // 0.1 ETH in wei;
        maximumContribution = new BigNumber(64000 * Math.pow(10,18)); // 64000 ETH in wei;
        start = Math.ceil((new Date()).getTime() / 1000);
        baseRateInCents = 250; // $2.50 equals 250 cents
        isPresale = true;
        hours = 600; // 5 days in hours + 10 hours for 0% discount testing
        discounts = [
            48, 33,  // first  48 hours, 0.33 price (2 days)
            168, 44, // next  168 hours, 0.44 price (7 days)
            168, 57, // next  168 hours, 0.57 price (7 days)
            216, 75, // final 216 hours, 0.75 price (9 days)
        ];
    
    console.log('deploying from:' + deployAddress);
    console.log('deploying SafeMath and Ownable');
    deployer.deploy(SafeMath, {from: deployAddress});
    deployer.deploy(Ownable, {from: deployAddress});

    console.log('linking Ownable and SafeMath');
    deployer.link(Ownable, [LOCIcoin, LOCIsale], {from: deployAddress});
    deployer.link(SafeMath, [LOCIcoin, LOCIsale], {from: deployAddress});

    console.log('deploying LOCIcoin');      
    deployer.deploy(LOCIcoin, totalSupply, {from: deployAddress}).then(() => {
        console.log('deploying LOCIsale with LOCIcoin address ' + totalSupply );      
        return deployer.deploy(LOCIsale,
            LOCIcoin.address,
            peggedETHUSD,
            hardCapETHinWei,
            reservedTokens,
            isPresale,
            new BigNumber(minimumGoal),
            new BigNumber(minimumContribution),
            new BigNumber(maximumContribution),
            new BigNumber(start),
            new BigNumber(hours),
            new BigNumber(baseRateInCents),
            discounts.map(v => new BigNumber(v)),
            {from: deployAddress});
    });
    
};
