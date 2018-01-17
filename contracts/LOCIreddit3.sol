pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/ownership/Contactable.sol';
import 'zeppelin-solidity/contracts/token/StandardToken.sol';


contract LOCIreddit3 is Ownable, Contactable {
    using SafeMath for uint256;
    
    // this is the already deployed coin from the token sale
    StandardToken token;

    // only allow distribution once. record it with an event
    bool public hasDoneRedditChunk = false;
    event DistributedRedditChunk();   

    // After this contract is deployed, we will grant access to this contract
    // by calling methods on the LOCIcoin since we are using the same owner
    // and granting the distribution of tokens to this contract
    function LOCIreddit3( address _token, string _contactInformation ) public {
        require(_token != 0x0);

        token = StandardToken(_token);
        contactInformation = _contactInformation;
                
        hasDoneRedditChunk = false;            
    }      
    
    function distributeRedditChunk() onlyOwner public {
        require(!hasDoneRedditChunk);  
        
        token.transfer(parseAddr("0xdd8804E408a21dc344e2A480DD207dEa38F325C"),0);
        token.transfer(parseAddr("0xa11Df60F8707D8231c042c55F5cfd4ac30958ba"),7053180984624070000);
        token.transfer(parseAddr("0x560bC718d3994611D80fb53fB30AcF142ce2F39"),63478628861616600000);
        token.transfer(parseAddr("0x779dBcd6B7814838B078e3fc858579bb30B65A7"),7053180984624070000);
        token.transfer(parseAddr("0x0385279Fcd3eC27938401128F466bc9F0206d37"),31739314430808300000);
        token.transfer(parseAddr("0x2bE7349354CB20230E45aEceAa456E2Fa0907C2"),70531809846240700000);
        token.transfer(parseAddr("0x61b11BEA87b4492f0C0da72F4b51d4F454b626b"),35265904923120300000);
        token.transfer(parseAddr("0x3eA3C2c2186E1F130FaC9CFee0957034A1e504A"),70531809846240700000);
        token.transfer(parseAddr("0x7D897f596E13E50447D5b6D9d7F90029D43E2c4"),7053180984624070000);
        token.transfer(parseAddr("0x54a66c8D981b7b4Be5A3941229566d920Ac47Dc"),134010438707857000000);
        token.transfer(parseAddr("0xdC1D6B303821E53314F394C59da8688B99dA2A5"),3526590492312030000);
        token.transfer(parseAddr("0xeC92519007b823765664Beac13eFAF630C26331"),1763295246156020000);
        token.transfer(parseAddr("0x261ba9D5216C2ec26fdFb30C37C27bD0b34C61D"),141063619692481000000);
        token.transfer(parseAddr("0xe069DfD3771A29cC863003Fa0fa0e4aF186406F"),0);
        token.transfer(parseAddr("0x469a49b82946A44be4D23EEEb6232C73fb120D6"),84638171815488800000);
        token.transfer(parseAddr("0x042427cc1B80Fe5af4D0973554a940BAa67B080"),63478628861616600000);
        token.transfer(parseAddr("0x6f60725160CC42d35645DdA21E371973B40dc0d"),63478628861616600000);
        token.transfer(parseAddr("0xDF727C54bc1dAdBa23B3AbBe2794b655Ae39347"),63478628861616600000);
        token.transfer(parseAddr("0x6f49c48d1fCE8f5fC780F4b9Ab2e45F09fBbcbC"),63478628861616600000);
        token.transfer(parseAddr("0x23f58Fbbb18eEb3314b99E26232f24fA2B68AeC"),63478628861616600000);
        token.transfer(parseAddr("0x52E07fA6D8843B44FFabDADbccaa861084c24C4"),28212723938496300000);        
        token.transfer(parseAddr("0x9f4489D63F572Af2b55F5237bA8F6f5248ef5B6"),112850895753985000000);
        token.transfer(parseAddr("0x33A924165E1F2bE5142FD19d1b2f091CB23bfd3"),31739314430808300000);
        token.transfer(parseAddr("0x1997B312D6e9cB863f939f9a7cEa3A36Ec185E6"),14106361969248100000);               
        token.transfer(parseAddr("0xΒ1f0796f6bB898D933D95E6ABA82bF13B1cEc22"),31739314430808300000);           
        token.transfer(parseAddr("0x075D5c5539049f12c14Ea85CFf680A9698EB724"),705318098462407000);
        token.transfer(parseAddr("0xc8C570b2C45be22449cF4B93f04A787e9777B7E"),126957257723233000000);
        token.transfer(parseAddr("0xC40bEcA28C55AD5B4955E4F5338c9Bb6ab15131"),28212723938496300000);
        token.transfer(parseAddr("0x40435db6d3f780f7accce2d362f617082dfcf5e"),56425447876992500000);
        token.transfer(parseAddr("0xb0E701787A769B4a241fC5A1fA3Ca2B62605c0a"),14106361969248100000);
        token.transfer(parseAddr("0x5ca93D0E9D26EEF06Fcfc36244e4017DF3CFb47"),0);            
        token.transfer(parseAddr("0x43bEd9Df63c61036566b18908ed239bdB4830C6"),0);
        token.transfer(parseAddr("0x80E7EAB540208c30E9D845A0a0304dEd1B84f55"),28212723938496300000);
        token.transfer(parseAddr("0x18b1A4e74d53B2b38f2941d2D41893d496B11a0"),28212723938496300000);
        token.transfer(parseAddr("0x809eb0f19970389951CA2f732CDecFbFDC0734f"),0);
        token.transfer(parseAddr("0xED0DEA451aFeaAc5e2808fC9C15d609782d93B9"),7053180984624070000);
        token.transfer(parseAddr("0xd51F3F473E70fdf4dB648edBEc60Acd432155f2"),0);
        token.transfer(parseAddr("0x1d3A55bE615bDc85Fe6B1b362655193980edEE9"),56425447876992500000);
        token.transfer(parseAddr("0x10491db854AF21030d11BC46e89445e57cDb2Bf"),28212723938496300000);
        token.transfer(parseAddr("0x3A889fc479d90251695AE5c58b034e62Dd00844"),56425447876992500000);
        token.transfer(parseAddr("0x2022e58BACC8a7EBf1965dF06bFdE86D6F4375B"),56425447876992500000);
        token.transfer(parseAddr("0x01EF7637329D56bce477cda21D1C6bcC229Ed4c"),56425447876992500000);
        token.transfer(parseAddr("0xa2E57C15F6abEaf634a1C4635B035C60CcB3859"),0);
        token.transfer(parseAddr("0x0D0830f6a47125f8760a4315e94e32aE176E177"),49372266892368500000);
        token.transfer(parseAddr("0x5343D6fCF198Ad5aa59E9A471b3415C9b6cf4e9"),56425447876992500000);
        token.transfer(parseAddr("0xfc0A39453ecaA9313005b1Db1689398ce17d879"),4937226689236850000);
        token.transfer(parseAddr("0x4546118df3180FE995Cf9919C05D8800A2ad393"),49372266892368500000);
        token.transfer(parseAddr("0x7cF2216e77f66b9bb4b04a8fcaf692EC54B5f34"),0);
        token.transfer(parseAddr("0x1e3a5e6e12FcD029d63385a39b6fb4c488458cB"),49372266892368500000);
        token.transfer(parseAddr("0x60C35b469970faD46be401cfeCFFD3f96963f19"),4937226689236850000);
        token.transfer(parseAddr("0xe5A34B6178e585720E17C82ef45276B954d64E5"),4937226689236850000);
        token.transfer(parseAddr("0xD34de22D66dAEE209741c5C42658bf2C6f21354"),21159542953872200000);
        token.transfer(parseAddr("0x02F516aD79119c74CF1F47AB610023337b3bD8d"),0);
        token.transfer(parseAddr("0xA2AB2dab417599d54B32dE4f70f7d921d5DF899"),4231908590774440000);
        token.transfer(parseAddr("0xfE0F18bB4AE6bae199CcA71602Cc431F241d8D1"),10579771476936100000);
        token.transfer(parseAddr("0x937fe2c8bd616344a9Be33fDEC04D6F15f53c20"),42319085907744400000);
        token.transfer(parseAddr("0x02F516aD79119c74CF1F47AB610023337b3bD8d"),0);
        token.transfer(parseAddr("0xa7802Ba51bA87556263d84cfC235759B214Ccf3"),42319085907744400000);
        token.transfer(parseAddr("0xC27A504445310a209c082197EcfdF842b7f3109"),10579771476936100000);
        token.transfer(parseAddr("0x57a348aC70602C24b57a3708C6D38d572B19A45"),10579771476936100000);
        token.transfer(parseAddr("0xCacF735136d1eC46dE20210C4cFeF3d885eef14"),21159542953872200000);
        token.transfer(parseAddr("0xEE1E346951a1065E8f450A52f11716145679687"),21159542953872200000);
        token.transfer(parseAddr("0x00be57FFEC7B76e65553B796371d1D18733c410"),4231908590774440000);
        token.transfer(parseAddr("0x5910AAf6AAB78bBf8259698E5Fac38c2598884B"),10579771476936100000);
        token.transfer(parseAddr("0xad4262889696D238eC319409662d204f5f6d1bf"),42319085907744400000);
        token.transfer(parseAddr("0xDE80bb66b0D5061434264ed7c3AeCB494e160C3"),42319085907744400000);
        token.transfer(parseAddr("0xd1B28E0462F08D5123d4eFa5bb9fd341e4e8dc7"),84638171815488800000);
        token.transfer(parseAddr("0x67E7e452a8671eFecb9284c483dE75C3fF1f02A"),84638171815488800000);
        token.transfer(parseAddr("0xe38Bf41d25C21b411C406822f4eC682753E3a8b"),84638171815488800000);
        token.transfer(parseAddr("0xaC65444b45FfC1670FCe61587e52c1de2193Ba0"),4231908590774440000);
        token.transfer(parseAddr("0x096fFa3324C9572dE91B1Bf31CD68d5d20C7DF7"),42319085907744400000);
        token.transfer(parseAddr("0x5505647dA72a10960B5Eb7b7b4eB322d71c04bB"),70531809846240700000);
        token.transfer(parseAddr("0xC5f0aceDf0EBebEb59149E6AcfDa4Edb2562119"),70531809846240700000);
        token.transfer(parseAddr("0xe69e654F426D30432d9283088dd4F90B67187f2"),70531809846240700000);
        token.transfer(parseAddr("0x6D4184C8C086729FF3fEac476A72a7b73BF1f02"),17632952461560200000);
        token.transfer(parseAddr("0x6d72952989a392E38Cc395B860596B6fC60F164"),8816476230780080000);
        token.transfer(parseAddr("0x61DD1D55aF1425d55f1797D7dFC24438b63cee7"),35265904923120300000);
        token.transfer(parseAddr("0x676514361D599e7f03f4FE450Cc337ED1AAEc94"),17632952461560200000);
        token.transfer(parseAddr("0x58c8f01DaF110340bed9f166B38a1878F2Fd73F"),17632952461560200000);
        token.transfer(parseAddr("0xD2Dccf427f5e1326E8e7E3d08b6Ed659E5712a7"),17632952461560200000);
        token.transfer(parseAddr("0xE4791EE2aFeAB7Bdee829CaC0511347BEC7B3EE"),17632952461560200000);
        token.transfer(parseAddr("0xB3833A0cB0c53Ad89bb12EeffE78eDe05936C03"),35265904923120300000);
        token.transfer(parseAddr("0x1fBf81dB0558aA9fbF5a4A26f9C682c8D4873A5"),8816476230780080000);
        token.transfer(parseAddr("0x7f4823876318faD7321FD813b7aBd4A7C60C12A"),8816476230780080000);
        token.transfer(parseAddr("0x7e5A0CE95930279b4D541F637B960075c5ed21D"),3526590492312030000);
        token.transfer(parseAddr("0x4bC035FB5e9a5Faddf8015ed78a82F088dDfe75"),70531809846240700000);
        token.transfer(parseAddr("0x29d6D6D84c9662486198667B5a9fbda3E698b23"),0);
        token.transfer(parseAddr("0xe1bD8390e382235aE4d86B480B35E31c3c763b8"),70531809846240700000);
        token.transfer(parseAddr("0xA5F66EaFB02Db5ccAcc4af8AdB536090C362f9B"),35265904923120300000);
        token.transfer(parseAddr("0x44d408e2265e55f247d38dca467cdd2017d7d91"),3526590492312030000);
        token.transfer(parseAddr("0x5D3c587506B68b78e12105b4C612E4874Dd7eac"),70531809846240700000);
        token.transfer(parseAddr("0x0F4155a4344b03f92A37c4010ce039c885D7a1C"),17632952461560200000);
        token.transfer(parseAddr("0x4878cA9777C5915B47bf5Fd8837667E1ff1A0eC"),35265904923120300000);
        token.transfer(parseAddr("0x0F67e5867b72a8E8802d7a509a7b8F64ae5A5Db"),70531809846240700000);
        token.transfer(parseAddr("0xe7cF462F2888462e4F17DA4172E42738B7327E0"),70531809846240700000);
        token.transfer(parseAddr("0x4F746FC99c04F51a8A97350dCdC22a4159f0a17"),70531809846240700000);
        token.transfer(parseAddr("0x3ABd187aA9A7e5500D82F30FbAcf0f7bfa1AB97"),70531809846240700000);
        token.transfer(parseAddr("0x4878cA9777C5915B47bf5Fd8837667E1ff1A0eC"),0);  

        hasDoneRedditChunk = true;
        DistributedRedditChunk();
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

