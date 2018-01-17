pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/ownership/Contactable.sol';
import 'zeppelin-solidity/contracts/token/StandardToken.sol';


contract LOCIreddit2 is Ownable, Contactable {
    using SafeMath for uint256;
    
    // this is the already deployed coin from the token sale
    StandardToken token;

    // only allow distribution once. record it with an event
    bool public hasDoneRedditChunk = false;
    event DistributedRedditChunk();   

    // After this contract is deployed, we will grant access to this contract
    // by calling methods on the LOCIcoin since we are using the same owner
    // and granting the distribution of tokens to this contract
    function LOCIreddit2( address _token, string _contactInformation ) public {
        require(_token != 0x0);

        token = StandardToken(_token);
        contactInformation = _contactInformation;
                
        hasDoneRedditChunk = false;            
    }      
    
    function distributeRedditChunk() onlyOwner public {
        require(!hasDoneRedditChunk);  
        
        token.transfer(parseAddr("0x62826B0B43de2dED13ad3B5F5dc9a31A6Ba9E8a"),88164762307800800000);
        token.transfer(parseAddr("0x4a977beecFC59e754E96917e592662c1dB82ccA"),155169981661729000000);
        token.transfer(parseAddr("0x323806aB792C3CFe2c9480FfdB1136D73fA9115"),1763295246156020000);
        token.transfer(parseAddr("0x42818E9E8EDe3feBFFD30E7f4773F44BBde353B"),84638171815488800000);
        token.transfer(parseAddr("0x58bceFeF19Fb2C50C32708371E0Bc26D754D635"),84638171815488800000);
        token.transfer(parseAddr("0xa7ecb51e729dC356b74eD6B9e203d0Bd9FB7D27"),84638171815488800000);
        token.transfer(parseAddr("0x1672BBf0b5f24B4D1ef155AEcBd3925864d4568"),21159542953872200000);
        token.transfer(parseAddr("0xb777641e9bd087581c68c1dC161dbf39EE4DF44"),0);
        token.transfer(parseAddr("0xa8BC9D555FF9f6F6833eba0Bb7334a8Fd526242"),183382705600226000000);
        token.transfer(parseAddr("0x721d7a32cD5c60b035F2F3669ee62C85F135124"),183382705600226000000);
        token.transfer(parseAddr("0xE99d86eBB30E0f96240fE934945017B29Be115e"),21159542953872200000);
        token.transfer(parseAddr("0xE659b76B2fd82B921771fFE33408d4F4359bA61"),77584990830864700000);
        token.transfer(parseAddr("0x890A20AA257eBa3650f965343E731F3b2bce903"),84638171815488800000);
        token.transfer(parseAddr("0xEf66e3550569b1E22116cf6c315c40D86D37321"),151643391169417000000);
        token.transfer(parseAddr("0x796162dfCE601FE796489a07b63724f725F27DE"),705318098462407000);
        token.transfer(parseAddr("0x6D4531145E5342a4fb0FF676d06844027f39A49"),0);
        token.transfer(parseAddr("0xdE259fa36EB36F532C586ea5594FE7929D27D68"),7053180984624070000);
        token.transfer(parseAddr("0x30BcF30b470Ad7A130eFBdb2E329e264eE21aCE"),0);
        token.transfer(parseAddr("0x4dE9E6b1e936E530685b11b2dC88D215aFCa8E9"),0);
        token.transfer(parseAddr("0x7053B47224FF8D0a4565aC6977ca270BEe6Ab03"),183382705600226000000);
        token.transfer(parseAddr("0xa67533F53aC6425A827Ce4E3C50076536Fc4Ca3"),63478628861616600000);
        token.transfer(parseAddr("0x2a69e1A696fa88833518f38a5e8503598B82C33"),91691352800112800000);
        token.transfer(parseAddr("0xc592F48DE2c33De713aAa614186929DB982eE3F"),144590210184793000000);
        token.transfer(parseAddr("0x4B0a3D01f3cCf4Cd818Ee2e1Ad7f04fF399Cc6E"),84638171815488800000);
        token.transfer(parseAddr("0x2FE37Fe20A4c35FAcbf51397F5B143b18C90E19"),3526590492312030000);
        token.transfer(parseAddr("0xeAD4677dc3d048b0d14700cdBD0C6d0DC844fAd"),0);
        token.transfer(parseAddr("0x5E2Fb554894B49da4b75f17F82fd3616737386d"),14106361969248100000);
        token.transfer(parseAddr("0xE675e14E6445bdDA7c61a5430b8cDFcbD582E11"),91691352800112800000);
        token.transfer(parseAddr("0x95afD6422538c5c9AbF6C7fF4Ec5c45281bD545"),91691352800112800000);
        token.transfer(parseAddr("0xe435b832cFF361dd4C966D3c5a7D236e640BA8C"),1763295246156020000);
        token.transfer(parseAddr("0xeCF50FA02188c92393ebD3F3afFdFaE84EA679A"),183382705600226000000);
        token.transfer(parseAddr("0xBe4DD3F61Ec61383B58Dab7feE6015333bC8d63"),74058400338552700000);
        token.transfer(parseAddr("0x23c49d92346eA1E23fe78145CAB8CB83Fe06ac6"),7053180984624070000);
        token.transfer(parseAddr("0xA1386FbB31dA2B8d3817AAb539bF175428bEEBE"),38792495415432400000);
        token.transfer(parseAddr("0xEe08D2cC697e9dc4D65fE4d9a6DbBD936776805"),84638171815488800000);
        token.transfer(parseAddr("0xAfd44914EE4B61d4D069041Cc90ce766B9846bB"),7053180984624070000);
        token.transfer(parseAddr("0xaa11D53846c6C590CCe83BfAc699e06D8587037"),0);
        token.transfer(parseAddr("0x0c9fE4966e78150900bAFc58731E1c51d91d41d"),7053180984624070000);
        token.transfer(parseAddr("0x2102Fd3d7Ee31c79693b6aC1cC9583aDB9c068E"),42319085907744400000);
        token.transfer(parseAddr("0xd5aC7c53F24790c47C033228C04A59010247607"),21159542953872200000);
        token.transfer(parseAddr("0xE93F333bdf7Dd06f946DDe211DdA2b60FBdEb2F"),19396247707716200000);
        token.transfer(parseAddr("0xd8a9c8e69f618b52e60d3a29bfc44a2039c162f"),0);
        token.transfer(parseAddr("0x97E1dd2Bd279E521aAdFFe29586F0c31f382749"),42319085907744400000);
        token.transfer(parseAddr("0x1E829B0D27648b18d7c77306208Dbe2E2929434"),70531809846240700000);
        token.transfer(parseAddr("0x18b1A4e74d53B2b38f2941d2D41893d496B11a0"),169276343630978000000);
        token.transfer(parseAddr("0x4A8B8deA3435A38Cd0bf6fe16b8d39C287Ad849"),38792495415432400000);
        token.transfer(parseAddr("0xBFF3e2c3159Bcd67eB02B2FCc2dd407dAeAbD1a"),0);
        token.transfer(parseAddr("0x1374C83bf4af8e0c847d449840BB7A9b0963A1c"),21159542953872200000);
        token.transfer(parseAddr("0x61dA2f396E5295020381c2f96c6B2A55d677CdA"),0);
        token.transfer(parseAddr("0x5C528AdFb1d703FAcee5dfDEd34d14fa41E99ac"),0);
        token.transfer(parseAddr("0xeF2E627C3c8441EA5537fd4b84991462691b134"),31739314430808300000);
        token.transfer(parseAddr("0xC5a2579b8c586837637b172D3A4B2b186e021E2"),0);
        token.transfer(parseAddr("0xB13760651ab102eE0BC729aC4cDf61fFeBbf8Ed"),8816476230780080000);
        token.transfer(parseAddr("0x525d25145d27eec1608655DcD1B13E1291978B8"),162223162646354000000);
        token.transfer(parseAddr("0x343049f6d8a1df33E3f82F8FCD18b0D8B7e27dd"),169276343630978000000);
        token.transfer(parseAddr("0xa31d1ADa62E8dc7903049bd066bBb6EC10f0150"),0);
        token.transfer(parseAddr("0x30Da8cAc64Da5B8Df599bc7D5923b725058C078"),3526590492312030000);
        token.transfer(parseAddr("0x077aDBb7Ee5c54875d4e4396A6674A4B5573F45"),84638171815488800000);
        token.transfer(parseAddr("0xF1ad2893C9fb72026e8d025043d804977D515c2"),1763295246156020000);
        token.transfer(parseAddr("0x1a00dF2aE763AbAE52401667b36008EC1b8843a"),35265904923120300000);
        token.transfer(parseAddr("0x5b22c2256c6bec29c6e300108589662b4c79325"),0);
        token.transfer(parseAddr("0xE89741458D25b5D93B2F4530CcB14e6635797b9"),1410636196924810000);
        token.transfer(parseAddr("0x72528BA17065F7948092196d49206Bc56356F5f"),84638171815488800000);
        token.transfer(parseAddr("0x434E3209c1e7915E0becDe6d58411D05D8ff4dA"),705318098462407000);
        token.transfer(parseAddr("0x434E3209c1e7915E0becDe6d58411D05D8ff4dA"),0);
        token.transfer(parseAddr("0x12dC169f15A10c095A3fF235F9d7fFD6a1D19a1"),169276343630978000000);
        token.transfer(parseAddr("0xe3AFA1F0fc41Bcc669DC59907414243a679b64E"),84638171815488800000);
        token.transfer(parseAddr("0xEC290b046Ef4e41AfD9c25b6a2C97A4b1594C00"),0);
        token.transfer(parseAddr("0x6D57E60Ea59DDF6a46b7c12EfA3ace9BC1c82E5"),0);
        token.transfer(parseAddr("0xe11fa83d26ef694c77d5dbbde834aafb342fd85"),14106361969248100000);
        token.transfer(parseAddr("0xC5034847AE30E85a95F5d036dfa17111e33C0A7"),12343066723092100000);
        token.transfer(parseAddr("0x1ddC6BB18eB76119a2F14993eEA2F1Cdc65eAB3"),7053180984624070000);
        token.transfer(parseAddr("0x6DaFF7FA511D1bC30E43796cD9c248ed506Cc3F"),33502609676964300000);
        token.transfer(parseAddr("0x6CF6E37BFcAfdF5451F4C62B369B8871De446F3"),0);
        token.transfer(parseAddr("0x9ceC11c512478aA219E7F5cA044F5802b7F2119"),84638171815488800000);
        token.transfer(parseAddr("0x53B5224834FE8C9313404632E9D8bfCE911Da70"),81111581323176800000);
        token.transfer(parseAddr("0x950e296833EC052637bbD785184B4D9551943d5"),84638171815488800000);
        token.transfer(parseAddr("0x86Df0A75641b0Ae5a2a8492a289376F14519Ef0"),81111581323176800000);
        token.transfer(parseAddr("0x0A9e7b04E6d2db8C0A515087cF9Fff9741fD45b"),17632952461560200000);
        token.transfer(parseAddr("0xc0cDBE2D56a6F1A33a97BB758E4421C10E6D8E9"),0);
        token.transfer(parseAddr("0x0e88846C35334867354199A4BbC876489965D0D"),77584990830864700000);
        token.transfer(parseAddr("0x3C75b6D8c222e6Fb6E337215Ac6ea3B9f117abe"),14106361969248100000);
        token.transfer(parseAddr("0x4a1b6f7C005Fb844dADfb06E3dFe41ceda5eFBa"),84638171815488800000);
        token.transfer(parseAddr("0x189D3898A58c3c4B76f181368Bda2138cC22739"),77584990830864700000);
        token.transfer(parseAddr("0x6AA9A62361717A5e279eAbBab6E25600DE35685"),18338270560022600000);
        token.transfer(parseAddr("0xFA4E7035b34294407e5Df1603215983d65e5a77"),67005219353928600000);
        token.transfer(parseAddr("0x3E90e83a1Bf89dcD320361eA88EfB626F0bFa67"),63478628861616600000);
        token.transfer(parseAddr("0xbAC3433e82593613020083F80243BB00989f660"),3526590492312030000);
        token.transfer(parseAddr("0x59e812a2D4d3daCDA197F61BBB55b7329d0D9C5"),0);
        token.transfer(parseAddr("0x655329cCE6207e14C292f80ea0c72a35BCFC721"),63478628861616600000);
        token.transfer(parseAddr("0xC5dE4BD02cb40B5434982808c7e950c23aeAaaC"),38792495415432400000);
        token.transfer(parseAddr("0xB912658149d2F1384A213939AAd876e932E9a7A"),0);
        token.transfer(parseAddr("0x9005170002e136c35140DA0E00A9E465171c0D5"),17632952461560200000);
        token.transfer(parseAddr("0xE3eEB28B41B690Ee0c5EcAB824cCf1592b29596"),33502609676964300000);
        token.transfer(parseAddr("0x8e8a5AA82d3982a10feD24cf5Aa343063691daC"),0);
        token.transfer(parseAddr("0xe3D8a8B4a4aA87d11AF9307c95DB5DCD3C5F284"),77584990830864700000);
        token.transfer(parseAddr("0x336a86f801d131222376e6fe3062Aa517665C56"),77584990830864700000);
        token.transfer(parseAddr("0xD34e2dD306D73a4775Fa39D8a52165CEFA200fb"),0);
        token.transfer(parseAddr("0xbFDb9966030abE0D965d30E29e11d12A8e1ba36"),67005219353928600000);
        token.transfer(parseAddr("0xDbC3246A0006cfCC48568df556dE1466030A40F"),28212723938496300000);
        token.transfer(parseAddr("0xCe95953Eaba20E27104f8522AD39862A858D7c7"),63478628861616600000);
        token.transfer(parseAddr("0xF7559AC6C13733be852bae3018E1a8481730A1F"),3526590492312030000);
        token.transfer(parseAddr("0xA359e070b0233A93D9b9bB1ac6C801EE4eb2606"),1763295246156020000);
        token.transfer(parseAddr("0x408a0DB81f2e261F3BD11276e36760e204a431C"),3526590492312030000);
        token.transfer(parseAddr("0xdE7A8990cAFa9796d771261ABA5576bC954CCf2"),35265904923120300000);

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

