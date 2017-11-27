require('babel-register');
require('babel-polyfill');

let secrets = require('./secrets');
let HDWalletProvider = require("truffle-hdwallet-provider");

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*",
      gas: 3500000
    },
    ropsten: {
      provider: new HDWalletProvider(secrets.mnemonic, "https://ropsten.infura.io/" + secrets.infuraKey),
      network_id: "3",
      gas: 3500000
    },
    live: {
      provider: new HDWalletProvider(secrets.mnemonic, "https://mainnet.infura.io/" + secrets.infuraKey),
      network_id: "1",
      gas: 3500000
    }
  }
};
