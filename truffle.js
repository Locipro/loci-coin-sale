require('babel-register');
require('babel-polyfill');

let secrets = require('./secrets');
let HDWalletProvider = require("truffle-hdwallet-provider");

require('dotenv').config();
const Web3 = require("web3");
const web3 = new Web3();
const WalletProvider = require("truffle-wallet-provider");
const Wallet = require('ethereumjs-wallet');

var mainNetPrivateKey = new Buffer(secrets.mainnetPK, "hex")
var mainNetWallet = Wallet.fromPrivateKey(mainNetPrivateKey);
var mainNetProvider = new WalletProvider(mainNetWallet, "https://mainnet.infura.io/");

var ropstenPrivateKey = new Buffer(secrets.ropstenPK, "hex")
var ropstenWallet = Wallet.fromPrivateKey(ropstenPrivateKey);
var ropstenProvider = new WalletProvider(ropstenWallet, "https://ropsten.infura.io/");

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*",
      gas: 4600000
    },
    ropsten: {
      provider: ropstenProvider, //new HDWalletProvider(secrets.mnemonic, "https://ropsten.infura.io/" + secrets.infuraKey),
      network_id: "3",
      gas: 4600000
    },
    live: {
      provider: mainNetProvider, //new HDWalletProvider(secrets.mnemonic, "https://mainnet.infura.io/" + secrets.infuraKey),
      network_id: "1",
      gas: 4600000
    }
  }
};
