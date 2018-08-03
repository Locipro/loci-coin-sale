pragma solidity ^0.4.24;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/TokenVesting.sol';

/**
 * @title LOCIvesting
 * @dev A token holder contract that can release its token balance gradually like a
 * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
 * owner.
 */
contract LOCIvesting is TokenVesting {

  ERC20Basic public loci;
  /**
   * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
   * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
   * of the balance will have vested.
   * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
   * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
   * @param _start the time (as Unix time) at which point vesting starts
   * @param _duration duration in seconds of the period in which the tokens will vest
   * @param _revocable whether the vesting is revocable or not
   */
  constructor(
    ERC20Basic _loci,
    address _beneficiary,
    uint256 _start,
    uint256 _cliff,
    uint256 _duration,
    bool _revocable
  )
    TokenVesting(_beneficiary, _start, _cliff, _duration, _revocable) public {

      loci = _loci;
    }

  function releaseLOCI() public {
    release(loci);
  }

  function revokeLOCI() public onlyOwner {
    revoke(loci);
  }

  function releasableAmountLOCI() public view returns (uint256) {
    return releasableAmount(loci);
  }

  function vestedAmountLOCI() public view returns (uint256) {
    return vestedAmount(loci);
  }

}
