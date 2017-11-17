const SafeMath = artifacts.require('zeppelin-solidity/contracts/math/SafeMath.sol');
const Ownable = artifacts.require('zeppelin-solidity/contracts/math/Ownable.sol');
const LOCIcoin = artifacts.require("./LOCIcoin.sol");
const LOCISale = artifacts.require("./LOCISale.sol");

const BigNumber = require('bignumber.js');

module.exports = (deployer, network, accounts) => {
    let totalSupply, minimumGoal, minimumContribution, maximumContribution, deployAddress, start, hours, isPresale, discounts;
    let peggedETHUSD = 300;
    let reservedTokens = 0;// if 4 million tokens, use 4,000,000 with 18 more zeros. then it would be 4 * Math.pow(10,8) * Math.pow(10,18)*/ 

    if (network === 'development') {
        deployAddress = accounts[0];
        totalSupply = new BigNumber(4 * Math.pow(10,9) * Math.pow(10,18)); //
        minimumGoal = new BigNumber(2 * Math.pow(10,18)); // 2 ETH in wei
        minimumContribution = new BigNumber(0.1 * Math.pow(10,18)); // 0.1 ETH in wei;
        maximumContribution = new BigNumber(50000 * Math.pow(10,18)); // 50000 ETH in wei;
        start = Math.ceil((new Date()).getTime() / 1000);
        isPresale = true;
        hours = 120; // 5 days in hours
        discounts = [
            48, 33,  // first 48 hours, 25% discount
            72, 44  // next 72 hours, 15% discount
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
            discounts.map(v => new BigNumber(v)),
            {from: deployAddress});
    });
};
