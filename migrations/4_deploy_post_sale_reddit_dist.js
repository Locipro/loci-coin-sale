const SafeMath = artifacts.require('zeppelin-solidity/contracts/math/SafeMath.sol');
const Ownable = artifacts.require('zeppelin-solidity/contracts/ownership/Ownable.sol');
const Contactable = artifacts.require('zeppelin-solidity/contracts/ownership/Contactable.sol');
const LOCIcoin = artifacts.require("./LOCIcoin.sol");
const LOCIsale = artifacts.require("./LOCIsale.sol");
const LOCIreddit = artifacts.require("./LOCIreddit.sol");

const BigNumber = require('bignumber.js');

module.exports = (deployer, network, accounts) => {    

    let deployAddress = accounts[0]; // by convention

    console.log('Preparing for deployment...');
    
    if( network == "live" ) {    
        throw "Halt. Sanity check. Not ready for deployment to live network. Manually remove this throw and try again.";
    }

    console.log('deploying from:' + deployAddress);
    console.log('deploying SafeMath Ownable Contactable');
    deployer.deploy(SafeMath, {from: deployAddress});
    deployer.deploy(Ownable, {from: deployAddress});
    deployer.deploy(Contactable, {from: deployAddress});
    
    console.log('linking Ownable SafeMath Contactable');
    deployer.link(Ownable, [LOCIreddit], {from: deployAddress});
    deployer.link(SafeMath, [LOCIreddit], {from: deployAddress});
    deployer.link(Contactable, [LOCIreddit], {from: deployAddress});
    
    let coinOwner = "0x1e35343c175038a8aac75a391524c14a01b1a1b0";
    let bonusTokenSupply = 10000000000000000000000000; // ten million should do it.
    let bonusTokenDistribution;

    console.log('deploying LOCIreddit');      
    deployer.deploy(LOCIreddit, LOCIcoin.address, 'LOCIpro.com', {from: deployAddress}).then(() => {        
        
        LOCIreddit.deployed().then(function(_bonusTokenDistribution) {
            console.log( 'assigning bonusTokenDistribution instance' );
            bonusTokenDistribution = _bonusTokenDistribution;
            return LOCIcoin.deployed();
        }).then( function(coinInstance){            
            console.log( 'assigning coin instance' );                   
            coin = coinInstance;
            return coin.ownerSetOverride(bonusTokenDistribution.address, true, {from: deployAddress});
        }).then( function(resultOfOverride) {
            console.log('resultOfOverride:' + resultOfOverride);                    
            return coin.transfer(bonusTokenDistribution.address, bonusTokenSupply, {from: deployAddress});
        }).then( function(resultOfTransfer) {
            console.log('resultOfTransfer:' + resultOfTransfer);
            return coin.balanceOf(LOCIcoin.address);
        }).then( function(resultOfBalanceForLOCIcoinAddress) {
            console.log('resultOfBalanceForLOCIcoinAddress:' + resultOfBalanceForLOCIcoinAddress);
            return coin.balanceOf(bonusTokenDistribution.address);
        }).then( function(resultOfBalanceForBonusTokenDistributionAddress) {
            console.log('resultOfBalanceForBonusTokenDistributionAddress:' + resultOfBalanceForBonusTokenDistributionAddress);                    
            return coin.contactInformation.call();
        }).then( function(resultOfContactInformation) {
            console.log('resultOfContactInformation:' + resultOfContactInformation);                                        
        });
                    
    });
    
};