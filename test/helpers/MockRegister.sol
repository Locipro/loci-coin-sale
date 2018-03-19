pragma solidity >=0.4.18;

import '../../contracts/LOCIregister.sol';

contract MockRegister is LOCIregister {
    function MockRegister(address _token, string _contactInformation) LOCIregister(_token, 'MockToken.com'){}
}
