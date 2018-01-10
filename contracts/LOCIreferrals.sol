pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/ownership/Contactable.sol';
import 'zeppelin-solidity/contracts/token/StandardToken.sol';


contract LOCIreferrals is Ownable, Contactable {
    using SafeMath for uint256;
    
    // this is the already deployed coin from the token sale
    StandardToken token;

    // only allow distribution once. record it with an event
    bool public hasAlreadyDistributedTokens = false;    
    event DistributedReferralBonusTokens();

    // After this contract is deployed, we will grant access to this contract
    // by calling methods on the LOCIcoin since we are using the same owner
    // and granting the distribution of tokens to this contract
    function LOCIreferrals( address _token, string _contactInformation ) public {
        require(_token != 0x0);            

        token = StandardToken(_token);
        hasAlreadyDistributedTokens = false;        
    }

    function distributeBonusTokens() onlyOwner public {
        require(!hasAlreadyDistributedTokens);

        // thousands of token bonus referrals go here - while testing, just try these random ones on ropsten
        
        token.transfer(parseAddr("0x8052352a7e15d5b4627ec43d50b76716bb00b034"),1047727272727272727272);        
        token.transfer(parseAddr("0x3f83a0e93d68558c08c405abc027c50b161434a8"),2025606060606060606060);
        token.transfer(parseAddr("0xeb26a1f312c20dfd7163833442fc52efe13a6980"),730615151515151515151);
        token.transfer(parseAddr("0xc74c6c1d11a8c19facb676f092d7f30cb8d2f5dd"),2793939393939393939393);
        token.transfer(parseAddr("0x37c464ddf5ab714ab73e44f24ab93f5da63409fb"),1396969696969696969696);
        

        DistributedReferralBonusTokens();
    }

    function parseAddr(string _a) internal returns (address){
        bytes memory tmp = bytes(_a);
        uint160 iaddr = 0;
        uint160 b1;
        uint160 b2;
        for (uint i=2; i<2+2*20; i+=2){
            iaddr *= 256;
            b1 = uint160(tmp[i]);
            b2 = uint160(tmp[i+1]);
            if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
            else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
            if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
            else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
            iaddr += (b1*16+b2);
        }
        return address(iaddr);
    }

    // in the event ether is accidentally sent to our contract, we can retrieve it
    function ownerTransferWei(address _beneficiary, uint256 _value) external onlyOwner {
        require(_beneficiary != 0x0);
        require(_beneficiary != address(token));
    
        // if zero requested, send the entire amount, otherwise the amount requested
        uint256 _amount = _value > 0 ? _value : this.balance;

        _beneficiary.transfer(_amount);
    }

    // after we distribute the bonus tokens, we will send them back to the coin itself
    function ownerRecoverTokens(address _beneficiary) external onlyOwner {
        require(_beneficiary != 0x0);
        require(_beneficiary != address(token));
        
        uint256 _tokensRemaining = token.balanceOf(address(this));
        if (_tokensRemaining > 0) {
            token.transfer(_beneficiary, _tokensRemaining);
        }
    }

}