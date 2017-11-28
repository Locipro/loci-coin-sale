# LOCIcoin
In the interests of public disclosure and security, we're pleased to present the [LOCIcoin][LOCIcoin] token and crowdsale contracts.

![LOCIcoin](loci-logo.png)

LOCI ADMIN STAFF: 
John Wise - CEO 
Brian Hwang - Director of Operations
Eric Ross - Director of Technology
Klajdi Ciraku - Community Management 
Adam Paigge - Public Relations
Dan Emmons - Blockchain Development

Telegram link: 
https://t.me/Loci_InnVenn

Twitter link: 
http://www.twitter.com/loci_io

Please visit our websites: 
https://locipro.com
 and
https://locipro.com/innvenn/

Token sale details: 
https://locipro.com/token-sale/

Token Schedule: 
http://www.tokenschedule.com/loci-coin/

Whitepaper: https://locipro.com/whitepaper

Bounty program: 
https://bitcointalk.org/index.php?topic=2161880.msg21647125#msg21647125

Loci
Official Telegram Group for Loci
Website https://locipro.com/

## Contracts
Please see the [contracts/](contracts) directory.

## Bounty Program
We want your input! If you have any comments or concerns regarding this code, please contact the administration of the [LOCIcoin bounty program][bounty program] for participation details and instructions.

## Overview
There are two primary contracts: `LOCIcoin.sol` (ERC-20 compliant token) and `LOCIsale.sol` (the crowdsale contract). Additionally, there is a simple shared interface defined in `IRefundHandler.sol` that allows `LOCIcoin` and `LOCIsale` to communicate refund requests and exchange wei contributions for received tokens. This refund mechanism will be triggered in the event that our sale goals are not met.

### LOCIcoin
Deriving from OpenZeppelin's ERC-20 compliant base contracts, `LOCIcoin` has the same core functionality the Ethereum ecosystem has come to expect, with minor modifications:
1. Upon initial deployment, the token has no `symbol` or `name` set; it is set via `ownerSetVisible()`
1. Token transfers are disabled until after the crowdsales are successfully completed, at which point the token will be 'activated' via `ownerActivateToken()`
1. To ensure that contributors receive their tokens during the sale, the ability to `ownerSetOverride()` addresses has been added (allows override addresses to use `transfer()`)
1. In the event that refunds are enabled in the sale contract, token holders can exchange their tokens for ether by calling the `claimRefund()` method

### LOCIsale
While not directly deriving from existing crowdsale contracts, `LOCIsale` is based on the simplest combination of [OpenZeppelin code][openzeppelin], other successful crowdsale contracts, [best practices][best practices], as well as [security considerations][security concerns]. `LOCIsale` functionality includes:
1. Flexible deployment options allows multiple sale scenarios (presale + primary ICO)
1. Time-based tranche discounting
1. Minimum ether goal restriction (optional)
1. Minimum and maximum individual contribution restrictions
1. Emergency break/pause functionality
1. Ability to enable refunds (in the case where minimum ether goal was not met)
1. Ability to transfer wei to beneficiary (after sale end and if optional min goal has been met)
1. Ability to recover (transfer) unsold tokens
1. Contributions via contract default/fallback function for user simplicity

## Develop
Contracts are written in [Solidity][solidity] and tested using [Truffle][truffle] and [testrpc][testrpc]. ERC20-related and other base contracts sourced from [OpenZeppelin.org][openzeppelin].

### Dependencies
```bash
# Install Truffle, testrpc, and dependency packages:
$ npm install
```

### Test
```bash
# Initialize a testrpc instance in one terminal tab
$ node_modules/.bin/testrpc

# This will run the contract tests using truffle
$ node_modules/.bin/truffle test
```
**Note that there is an [outstanding testrpc issue][testrpc bug 390]** which, until fixed and released, will cause some tests to fail; it is related to the `testrpc` `evm_increaseTime` operation and its interaction with `testrpc` snapshot/revert behaviour. A [custom `testrpc` build][testrpc custom build workaround] can be made that addresses this problem in the meantime.

```
patch node_modules/ethereumjs-testrpc/build/cli.node.js testrpc-time.patch
```

### Deploy to destination: development, ropsten, or live
```
$ truffle migrate --network <destination>
```

### secrets.js file - you will have to supply your own. sample format below.
```
var mnemonic = "some random selection of twelve words that you can use for metamask";
var infuraKey = "aaaaaaaaaaaaaaaaaaa"; // get this form infura
var accountPK = "your account primary key";
var mainnetPK = accountPK;
var ropstenPK = accountPK;

module.exports = {mnemonic: mnemonic, infuraKey: infuraKey, mainnetPK: mainnetPK, ropstenPK:ropstenPK};
```

## Alternative Build
For easy deployment via Mist, simply concatenate all contracts using [`solidity_flattener`][solidity flattener].
```
solidity_flattener --solc-paths "zeppelin-solidity=<absolute path to your files>/node_modules/zeppelin-solidity" contracts/LOCIcoin.sol > UnifiedLOCIcoin.sol
solidity_flattener --solc-paths "zeppelin-solidity=<absolute path to your files>/node_modules/zeppelin-solidity" contracts/LOCIsale.sol > UnifiedLOCIsale.sol
```
Use the concatenated contracts in these 'unified' .sol files to deploy in [Mist][mist]. Note that these 'unified' files are also useful when [verifying your contract on Etherscan.io][etherscan verifycontract].

[LOCIcoin]: https://www.locipro.com/whitepaper
[ethereum]: https://www.ethereum.org/
[openzeppelin]: https://openzeppelin.org/
[solidity]: https://solidity.readthedocs.io/
[truffle]: http://truffleframework.com/
[testrpc]: https://github.com/ethereumjs/testrpc
[mist]: https://github.com/ethereum/mist
[solidity flattener]: https://github.com/BlockCatIO/solidity-flattener
[testrpc bug 390]: https://github.com/ethereumjs/testrpc/issues/390
[testrpc custom build workaround]: https://github.com/ethereumjs/testrpc/issues/390#issuecomment-336917098
[best practices]: http://solidity.readthedocs.io/en/develop/common-patterns.html
[security concerns]: http://solidity.readthedocs.io/en/develop/security-considerations.html
[etherscan verifycontract]: https://etherscan.io/verifyContract
[bounty program]: https://bitcointalk.org/index.php?topic=2161880.msg21647125#msg21647125
[LOCIcoin whitepaper]: https://locipro.com/whitepaper
