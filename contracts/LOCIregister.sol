pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/ownership/Contactable.sol';
import 'zeppelin-solidity/contracts/token/StandardToken.sol';

contract LOCIregister is Ownable, Contactable {
    using SafeMath for uint256;
    
    // this is the already deployed coin from the token sale
    StandardToken internal token;     

    mapping (address => string) public names;
    mapping (uint => string) public reasons;

    // Register every withdrawal we make from a linked LOCIsearch payment    
    event RegisterWithdrawal(address indexed register,      /* address the customer sent payment to */
                             address indexed beneficiary,   /* recipent of funds after withdrawal   */ 
                             address indexed linked,        /* original linked customer address     */
                             uint256 amount,                /* amount of wei to transfer            */
                             uint reason);                  /* 0=payment, 1=stake, 2=bid, 3=refund  */

    // After this contract is deployed, we will grant access to this contract
    // by calling methods on the LOCIcoin since we are using the same owner
    // and granting the distribution of tokens to this contract
    function LOCIregister( address _token, string _contactInformation ) public {
        require(_token != 0x0);

        owner = msg.sender;
        token = StandardToken(_token);
        contactInformation = _contactInformation;                                
    }     

    function withdrawFrom( address _register, address _beneficiary, address _linked, uint256 _amount, uint _reason ) onlyOwner public {
        require(_register != 0x0);
        require(_beneficiary != 0x0 );
        require(_beneficiary != address(token));

        token.transferFrom( _register, _beneficiary, _amount );
        RegisterWithdrawal( _register, _beneficiary, _linked, _amount, _reason );
    }
    
    function withdrawFromAll( address[] _register, address[] _beneficiary, address[] _linked, uint256[] _amount, uint[] _reason ) onlyOwner public {
        require( _register.length == _beneficiary.length && _beneficiary.length == _amount.length && _amount.length == _reason.length );

        for (uint i = 0; i < _register.length; i += 1) {            
            token.transferFrom( _register[i], _beneficiary[i], _amount[i] );
            RegisterWithdrawal( _register[i], _beneficiary[i], _linked[i], _amount[i], _reason[i] );      
        }        
    }            

    function withdrawSameAmountFromRegister( address _register, address _beneficiary, address[] _linked, uint256 _amount, uint _reason ) onlyOwner public {        

        uint256 totalWithdrawal = _amount.mul( _linked.length );
        token.transferFrom( _register, _beneficiary, totalWithdrawal );

        for (uint i = 0; i < _linked.length; i += 1) {            
            //token.transferFrom( _register, _beneficiary, _amount );
            RegisterWithdrawal( _register, _beneficiary, _linked[i], _amount, _reason );      
        }        
    }

    function setRegisterName( address _register, string _name ) onlyOwner public {
        names[_register] = _name;
    }

    function getRegisterName( address _register ) onlyOwner public returns(string) {
        return names[_register];
    }

    function setReason( uint _reason, string _name ) onlyOwner public {
        reasons[_reason] = _name;
    }

    function getRegisterName( uint _reason ) onlyOwner public returns(string) {
        return reasons[_reason];
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