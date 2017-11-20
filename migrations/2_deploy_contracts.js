const SafeMath = artifacts.require('zeppelin-solidity/contracts/math/SafeMath.sol');
const Ownable = artifacts.require('zeppelin-solidity/contracts/math/Ownable.sol');
const LOCIcoin = artifacts.require("./LOCIcoin.sol");
const LOCISale = artifacts.require("./LOCISale.sol");

const BigNumber = require('bignumber.js');

module.exports = (deployer, network, accounts) => {
    let totalSupply, minimumGoal, minimumContribution, maximumContribution, deployAddress, start, hours, isPresale, discounts;
    let peggedETHUSD, reservedTokens, baseRateInCents;     

    if (network === 'development') {
        peggedETHUSD = 300; // always specified in whole USD. 300 = $300   

        deployAddress = accounts[0];
        totalSupply =    new BigNumber(100000000 * Math.pow(10,18)); // 100Million
        reservedTokens = new BigNumber( 54000000 * Math.pow(10,18)); // 54Million (50M reserve + 4M presale)
        minimumGoal = new BigNumber(50000 * Math.pow(10,18)); // 50000 ETH in wei
        minimumContribution = new BigNumber(0.1 * Math.pow(10,18)); // 0.1 ETH in wei;
        maximumContribution = new BigNumber(50000 * Math.pow(10,18)); // 50000 ETH in wei;
        start = Math.ceil((new Date()).getTime() / 1000);
        baseRateInCents = 250; // $2.50 equals 250 cents
        isPresale = true;
        hours = 120; // 5 days in hours
        discounts = [
            48, 33,  // first 48 hours, .33 rate
            72, 44  // next 72 hours, .44 rate
        ];
    }

    deployer.deploy(SafeMath, {from: deployAddress});
    deployer.deploy(Ownable, {from: deployAddress});

    deployer.link(Ownable, [LOCIcoin, LOCISale], {from: deployAddress});
    deployer.link(SafeMath, [LOCIcoin, LOCISale], {from: deployAddress});

    deployer.deploy(LOCIcoin, totalSupply, {from: deployAddress}).then(() => {
        return deployer.deploy(LOCISale,
            LOCIcoin.address,
            peggedETHUSD,
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
