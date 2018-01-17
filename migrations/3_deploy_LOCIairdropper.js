const SafeMath = artifacts.require('zeppelin-solidity/contracts/math/SafeMath.sol');
const Ownable = artifacts.require('zeppelin-solidity/contracts/ownership/Ownable.sol');
const Contactable = artifacts.require('zeppelin-solidity/contracts/ownership/Contactable.sol');
const LOCIcoin = artifacts.require("./LOCIcoin.sol");
const LOCIairdropper = artifacts.require("./LOCIairdropper.sol");

const BigNumber = require('bignumber.js');

module.exports = (deployer, network, accounts) => {    

    let deployAddress = accounts[0]; // by convention

    console.log('Preparing for deployment of LOCIairdropper...');
    
    if( network == "live" ) {    
        console.log("Using LOCIcoin at:" + LOCIcoin.address);
        //throw "Halt. Sanity check. Not ready for deployment to live network. Manually remove this throw and try again.";
    }

    console.log('deploying from:' + deployAddress);
    console.log('deploying SafeMath Ownable Contactable');
    deployer.deploy(SafeMath, {from: deployAddress});
    deployer.deploy(Ownable, {from: deployAddress});
    deployer.deploy(Contactable, {from: deployAddress});
    
    console.log('linking Ownable SafeMath Contactable');
    deployer.link(Ownable, [LOCIairdropper], {from: deployAddress});
    deployer.link(SafeMath, [LOCIairdropper], {from: deployAddress});
    deployer.link(Contactable, [LOCIairdropper], {from: deployAddress});    
    
    console.log('deploying LOCIairdropper');      
    deployer.deploy(LOCIairdropper, LOCIcoin.address, 'LOCIpro.com', {from: deployAddress, overwrite: false});    
    
};