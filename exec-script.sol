
// usage:  truffle exec exec-example.sol --network live

module.exports = function(callback) {

	const async = require('asyncawait/async');
	let await = require('asyncawait/await');
	const TruffleContract = require('truffle-contract');
	const artifacts = require('./build/contracts/LOCIcoin.json')
	
	// example: 34de823a689ae49ad33a85e610ebb9044e80fc881a0cf5f29d706e3eb20f0932 private key with known address 0x39400decc3a15d8abdd6df9da52856fbd9fac5e0
	const util = require('ethereumjs-util');
	let sig = util.fromRpcSig('0xfa679521aeb0bfa7ba7609365c39ddbbc97bf15adda4e038bd14aa129770f3293f0cddbdd0c17b884cc240a255a30cc56070ac0240a10be7468de850d30f98d61c');
	console.log(sig.v);
	console.log(sig.r);
	console.log(sig.s);
	let publicKey = util.ecrecover(util.sha3("\x19Ethereum Signed Message:\n30I really did make this message"), sig.v, sig.r, sig.s);
	console.log(publicKey);
	console.log(util.pubToAddress(publicKey));
	let address = '0x'+util.pubToAddress(publicKey).toString('hex');

	console.log(address);

	// example: using known address 0x1e35343c175038a8aac75a391524c14a01b1a1b0
	// const util = require('ethereumjs-util');
	sig = util.fromRpcSig('0x00fe67bcd1d9240714a2ff137da512e3497e4abc2f2682e2f77e21519cd6029e5409ee41921f53c807cc2d1841f839075f6bcb9a3977c32a20787d5d125fa07d1c');
	console.log(sig.v);
	console.log(sig.r);
	console.log(sig.s);
	publicKey = util.ecrecover(util.sha3("\x19Ethereum Signed Message:\n34These are the terms and conditions"), sig.v, sig.r, sig.s);
	console.log(publicKey);
	console.log(util.pubToAddress(publicKey));
	address = '0x'+util.pubToAddress(publicKey).toString('hex');

	console.log(address);

		
	// example: using known address 0x1e35343c175038a8aac75a391524c14a01b1a1b0
	// const util = require('ethereumjs-util');
	sig = util.fromRpcSig('0x0e7a5c57c8b19c07f42fa5ea4dd38ddcbe515c9fb0956838357f16285291b897097558f6ac3c8a84511388d35039d5ba99c824ff000d9449b6f3dafca940324f1b');
	console.log(sig.v);
	console.log(sig.r);
	console.log(sig.s);
	publicKey = util.ecrecover(util.sha3("\x19Ethereum Signed Message:\n15testing 123 ..."), sig.v, sig.r, sig.s);
	console.log(publicKey);
	console.log(util.pubToAddress(publicKey));
	address = '0x'+util.pubToAddress(publicKey).toString('hex');

	console.log(address);

}

