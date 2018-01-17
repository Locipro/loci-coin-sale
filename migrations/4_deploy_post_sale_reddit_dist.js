const SafeMath = artifacts.require('zeppelin-solidity/contracts/math/SafeMath.sol');
const Ownable = artifacts.require('zeppelin-solidity/contracts/ownership/Ownable.sol');
const Contactable = artifacts.require('zeppelin-solidity/contracts/ownership/Contactable.sol');
const LOCIcoin = artifacts.require("./LOCIcoin.sol");
const LOCIsale = artifacts.require("./LOCIsale.sol");
const LOCIreddit1 = artifacts.require("./LOCIreddit1.sol");
const LOCIreddit2 = artifacts.require("./LOCIreddit2.sol");
const LOCIreddit3 = artifacts.require("./LOCIreddit3.sol");
const LOCIreddit4 = artifacts.require("./LOCIreddit4.sol");

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
    deployer.link(Ownable, [LOCIreddit1, LOCIreddit2, LOCIreddit3, LOCIreddit4], {from: deployAddress});
    deployer.link(SafeMath, [LOCIreddit1, LOCIreddit2, LOCIreddit3, LOCIreddit4], {from: deployAddress});
    deployer.link(Contactable, [LOCIreddit1, LOCIreddit2, LOCIreddit3, LOCIreddit4], {from: deployAddress});    
    
    console.log('deploying LOCIreddit');      
    deployer.deploy(LOCIreddit1, LOCIcoin.address, 'LOCIpro.com', {from: deployAddress});
    //deployer.deploy(LOCIreddit2, LOCIcoin.address, 'LOCIpro.com', {from: deployAddress});
    //deployer.deploy(LOCIreddit3, LOCIcoin.address, 'LOCIpro.com', {from: deployAddress});
    //deployer.deploy(LOCIreddit4, LOCIcoin.address, 'LOCIpro.com', {from: deployAddress});
    
};