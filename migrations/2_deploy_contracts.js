const SafeMath = artifacts.require('zeppelin-solidity/contracts/math/SafeMath.sol');
const Ownable = artifacts.require('zeppelin-solidity/contracts/ownership/Ownable.sol');
const Contactable = artifacts.require('zeppelin-solidity/contracts/ownership/Contactable.sol');
const LOCIcoin = artifacts.require("./LOCIcoin.sol");
const LOCIsale = artifacts.require("./LOCIsale.sol");

const BigNumber = require('bignumber.js');

module.exports = (deployer, network, accounts) => {
    let totalSupply, minimumGoal, minimumContribution, maximumContribution, deployAddress, start, hours, isPresale, discounts;
    let peggedETHUSD, hardCapETHinWei, reservedTokens, baseRateInCents, saleSupplyAllocation;     

    console.log('Preparing for deployment...');
    peggedETHUSD = 461; // always specified in whole USD. 461 = $461   
    deployAddress = accounts[0]; // by convention
    totalSupply =           new BigNumber(100000000000000000000000000); // 100Million in wei
    saleSupplyAllocation =  new BigNumber( 55000000000000000000000000); //  55Million in wei                
    reservedTokens =        new BigNumber(  5000000000000000000000000); //   5Million in wei
    hardCapETHinWei = new BigNumber(   38800 * Math.pow(10,18)); // 38800 ETH in wei
    minimumGoal = 0; 
    minimumContribution = new BigNumber(0.1 * Math.pow(10,18)); // 0.1 ETH in wei;
    maximumContribution = new BigNumber(38800 * Math.pow(10,18)); // 38800 ETH in wei;
    start = 1512518400; // DEC 6 00:00:00 UTC
    baseRateInCents = 250; // $2.50 equals 250 cents
    isPresale = true;
    hours = 600; // total number of hours
    discounts = [
        48,  33, // first  48 hours, 0.33 price (2 days)
        168, 44, // next  168 hours, 0.44 price (7 days)
        168, 57, // next  168 hours, 0.57 price (7 days)
        216, 75, // final 216 hours, 0.75 price (9 days)
    ];

    if( network == "live" ) {
        console.log( 'start=' + start );
        console.log( 'changing start to 1512518400 for live deployment.' );
        start = 1512518400;
        console.log( 'start=' + start );        
        throw "Halt. Sanity check. Not ready for deployment to live network. Manually remove this throw and try again.";
    }

    console.log('start=' + start);
    
    console.log('deploying from:' + deployAddress);
    console.log('deploying SafeMath Ownable Contactable');
    deployer.deploy(SafeMath, {from: deployAddress});
    deployer.deploy(Ownable, {from: deployAddress});
    deployer.deploy(Contactable, {from: deployAddress});

    console.log('linking Ownable SafeMath Contactable');
    deployer.link(Ownable, [LOCIcoin, LOCIsale], {from: deployAddress});
    deployer.link(SafeMath, [LOCIcoin, LOCIsale], {from: deployAddress});
    deployer.link(Contactable, [LOCIcoin, LOCIsale], {from: deployAddress});

    console.log('deploying LOCIcoin');      
    deployer.deploy(LOCIcoin, totalSupply, 'LOCIpro.com', {from: deployAddress}).then(() => {
        console.log('deploying LOCIsale with LOCIcoin address ' );      
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
            {from: deployAddress}).then( function(result) {

                var coin;
                var sale;

                LOCIcoin.deployed().then(function(instance) {
                    console.log( 'assigning coin instance' );
                    coin = instance;
                    return instance;
                }).then( function(coinInstance){
                    coinInstance.totalSupply.call().then( console.log );
                    return LOCIsale.deployed();
                }).then( function(saleInstance){ 
                    console.log( 'assigning sale instance' );                   
                    sale = saleInstance;
                    return coin.ownerSetOverride(saleInstance.address, true, {from: deployAddress});
                }).then( function(resultOfOverride) {
                    console.log('resultOfOverride:' + resultOfOverride);                    
                    return coin.transfer(sale.address, saleSupplyAllocation, {from: deployAddress});
                }).then( function(resultOfTransfer) {
                    console.log('resultOfTransfer:' + resultOfTransfer);
                    return coin.balanceOf(deployAddress);
                }).then( function(resultOfBalanceForDeployAddress) {
                    console.log('resultOfBalanceForDeployAddress:' + resultOfBalanceForDeployAddress);
                    return coin.balanceOf(sale.address);
                }).then( function(resultOfBalanceForSaleAddress) {
                    console.log('resultOfBalanceForSaleAddress:' + resultOfBalanceForSaleAddress);                    
                    return coin.contactInformation.call();
                }).then( function(resultOfContactInformation) {
                    console.log('resultOfContactInformation:' + resultOfContactInformation);                                        
                });
                

            });
    });


    
};
