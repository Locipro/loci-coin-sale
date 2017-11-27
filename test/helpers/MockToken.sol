pragma solidity ^0.4.18;

import '../../contracts/LOCIcoin.sol';


contract MockToken is LOCIcoin {
    function MockToken(uint256 _totalSupply) LOCIcoin(_totalSupply){}

    function isAllowedOverrideAddress(address _addr) external constant returns (bool) {
        return allowedOverrideAddresses[_addr];
    }
}
