
// usage:  truffle exec exec-example.sol --network live

module.exports = function(callback) {

	const async = require('asyncawait/async');
	let await = require('asyncawait/await');
	const TruffleContract = require('truffle-contract');
	const artifacts = require('./build/contracts/LOCIcoin.json')
	let LOCIcoin = TruffleContract(artifacts);
	LOCIcoin.setProvider(web3.currentProvider);    

	let coin, coinOwner, ownerBalance;


	LOCIcoin.deployed().then(function(instance){      
  		coin = instance;
  		coinOwner = "0x1e35343c175038a8aac75a391524c14a01b1a1b0";
  		console.log('coin address:' + coin.address);  		
  		console.log('coin owner:' + coinOwner);
		
		const promisify = (inner) => new Promise((resolve, reject) => inner((err, res) => { if (err) { reject(err) } resolve(res); }) );
		let coinBalanceOf = (account) => promisify(cb => { return coin.balanceOf(account).then(cb, cb); } );
		const coinTransfer = (account, value) => promisify(cb => { 
			return coin.transfer(account, value, {from:coinOwner, gas: 1000000, gasPrice: 40000000000}).then(cb,cb); } );	

		// execute one liners here
		//a.transfer(web3.currentProvider.bulk_addresses.slice(0,100), web3.currentProvider.bulk_values.slice(0,100), {gas: 4500000, gasPrice:50000000000});
	});
}

