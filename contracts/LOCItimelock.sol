pragma solidity ^0.4.24;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol';


/**
 * @title LOCItimelock
 * @dev LOCItimelock is a token holder contract that will allow a
 * beneficiary to extract the tokens after a given release time
 */
contract LOCItimelock is TokenTimelock {
  
  constructor(
    ERC20Basic _token,
    address _beneficiary,
    uint256 _releaseTime
  )
    TokenTimelock(_token,_beneficiary,_releaseTime) public {}

}