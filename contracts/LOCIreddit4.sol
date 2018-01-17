pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/ownership/Contactable.sol';
import 'zeppelin-solidity/contracts/token/StandardToken.sol';


contract LOCIreddit4 is Ownable, Contactable {
    using SafeMath for uint256;
    
    // this is the already deployed coin from the token sale
    StandardToken token;

    // only allow distribution once. record it with an event
    bool public hasDoneRedditChunk = false;
    event DistributedRedditChunk();   

    // After this contract is deployed, we will grant access to this contract
    // by calling methods on the LOCIcoin since we are using the same owner
    // and granting the distribution of tokens to this contract
    function LOCIreddit4( address _token, string _contactInformation ) public {
        require(_token != 0x0);

        token = StandardToken(_token);
        contactInformation = _contactInformation;
                
        hasDoneRedditChunk = false;            
    }      
    
    function distributeRedditChunk() onlyOwner public {
        require(!hasDoneRedditChunk);  
        
        token.transfer(parseAddr("0x0F67e5867b72a8E8802d7a509a7b8F64ae5A5Db"),70531809846240700000);
        token.transfer(parseAddr("0xe7cF462F2888462e4F17DA4172E42738B7327E0"),70531809846240700000);
        token.transfer(parseAddr("0x4F746FC99c04F51a8A97350dCdC22a4159f0a17"),70531809846240700000);
        token.transfer(parseAddr("0x3ABd187aA9A7e5500D82F30FbAcf0f7bfa1AB97"),70531809846240700000);
        token.transfer(parseAddr("0x8EeB853117f3dABc0205C4b4148aE73762d27e2"),35265904923120300000);
        token.transfer(parseAddr("0x0A04291515870a77Fa4da43A8F60a7F0A664f85"),35265904923120300000);
        token.transfer(parseAddr("0x555f39216Ce69B501672e1b069Cd9C8a274dBD6"),35265904923120300000);
        token.transfer(parseAddr("0x22eb4f3fb632E58b098423956AEa12aBd04E752"),70531809846240700000);
        token.transfer(parseAddr("0xA1601dca437De4525442dcEC421580cCD94c5AD"),70531809846240700000);
        token.transfer(parseAddr("0xa4532aE4f0cF54459E7F654fa6b3cC3aC7dB826"),17632952461560200000);
        token.transfer(parseAddr("0x7d0C138d7fE016Fa2BC32499B4173881C26cb4f"),17632952461560200000);
        token.transfer(parseAddr("0xC358E2F95FC4e2d731E849fFF14a42F34760c1A"),14106361969248100000);
        token.transfer(parseAddr("0x402F58816aaf4D5b2485963c5A2623e61A3Afbc"),7053180984624070000);
        token.transfer(parseAddr("0x3C6F1D6667a0c80A7726b548D15a4af91A77a4b"),56425447876992500000);
        token.transfer(parseAddr("0x701FF4e2621C0058726716F4873C564cE5E0222"),14106361969248100000);
        token.transfer(parseAddr("0xBD40fE1dDEa0057D469b1c1Ac74637279F9056F"),28212723938496300000);
        token.transfer(parseAddr("0xe5639f6B824A77E904F4ACf5d140b5a3a4a349b"),14106361969248100000);
        token.transfer(parseAddr("0x34FE12dD2117f3a3D0FBB774460F72D91509214"),14106361969248100000);
        token.transfer(parseAddr("0xE3e92a5D28BC26c8800425C169f3f199535b7fA"),7053180984624070000);
        token.transfer(parseAddr("0x4aD3D0C2A47FfA55547DBb36630A77912BC5Ff2"),14106361969248100000);
        token.transfer(parseAddr("0x7730Ff43b0bbc51dF711E356aE5185686185909"),28212723938496300000);
        token.transfer(parseAddr("0x92844ad0530580F3ecc459f7B203a1853027bD0"),14106361969248100000);
        token.transfer(parseAddr("0x6B912956115b6c0E83d8f0835Ca02A25BBaE004"),28212723938496300000);
        token.transfer(parseAddr("0xe06ACCfF3E768AcEbE199e27c3a750d6Ef5Ecfa"),28212723938496300000);
        token.transfer(parseAddr("0x9c6D3DC06ad2826a12a7fFb910845F2E8ec01aE"),7053180984624070000);
        token.transfer(parseAddr("0x7b36d78875f6A786422b59e9Cf2319A9F080d19"),56425447876992500000);
        token.transfer(parseAddr("0xa4A979d6876DB84031AEFB2c59F7fE4B9880328"),28212723938496300000);
        token.transfer(parseAddr("0x3AF40f23C7b2A9921D2Ad0B7Ee2C755B27BAF88"),28212723938496300000);
        token.transfer(parseAddr("0x17D03dc0B5F5dC4483cDd09E1cBc563385c973c"),7053180984624070000);
        token.transfer(parseAddr("0x4B3cA96292e3B89c9CCb90f5E0df371b730f230"),7053180984624070000);
        token.transfer(parseAddr("0x9C5eAEA8dDEafED68f09D273bf479023D101e7D"),7053180984624070000);
        token.transfer(parseAddr("0xfdd844Cb2fC123C19467ACa247E5f34Be57120B"),28212723938496300000);
        token.transfer(parseAddr("0x2C996e50A45c4622591Fe2f5F0159C4bAa0C5c8"),7053180984624070000);
        token.transfer(parseAddr("0xD77dCe70fc98b45868F0eA711c385372907CEeA"),56425447876992500000);
        token.transfer(parseAddr("0xBbcA5797dAf789bc215D59C1CB30eDceFF65eA5"),0);
        token.transfer(parseAddr("0xfaD66BF808B581D08E89C8B3fE905257C4E46a1"),14106361969248100000);
        token.transfer(parseAddr("0x76366fD5baF9CA0A63c8cd30c2f589F90E3Ebb7"),7053180984624070000);
        token.transfer(parseAddr("0xd88C009B525F04ee5E50B2ddE00f592C246aFca"),5289885738468050000);
        token.transfer(parseAddr("0x34aBb8b60052f5EB25C3dF4Ad7B3775C4250634"),5289885738468050000);
        token.transfer(parseAddr("0x63abb31f081f5242B09eE97BE3ff63af954907E"),5289885738468050000);
        token.transfer(parseAddr("0xE5c9856ee2365A4409f78A28657c599aB629615"),5289885738468050000);
        token.transfer(parseAddr("0x2FC65071cF2603b283Ed30d86DDBb537aBDC71e"),10579771476936100000);
        token.transfer(parseAddr("0x611495a975Dbb1872440202cE7e80AFAfDfd8db"),10579771476936100000);
        token.transfer(parseAddr("0xD61De6B052b70f06fd58D05cD5EE8E41F28479B"),21159542953872200000);
        token.transfer(parseAddr("0x28F55aD660F9a04F9B23B9879F4c7Cb4Fb31b69"),21159542953872200000);
        token.transfer(parseAddr("0x9A057fB97f12ce5410B73b7A0aAf33f5517A87D"),10579771476936100000);
        token.transfer(parseAddr("0xBF563617546a332458C03D16c4b1fEBD8aC54eA"),5289885738468050000);
        token.transfer(parseAddr("0xf55d6A8e81E7717435c136FA2C212C4a5209ec6"),21159542953872200000);
        token.transfer(parseAddr("0x90788C8cE0772270884BC5De23153143d750f7b"),21159542953872200000);
        token.transfer(parseAddr("0xCbB74E8eAbCD36B160D1fC3BEd7bc6E52D32763"),10579771476936100000);
        token.transfer(parseAddr("0x5535eD3d0230b4C4070C3E70E219A03d957fb46"),5289885738468050000);
        token.transfer(parseAddr("0x3bFB13A204BcDF52419E43cfBEdF78117ea2855"),10579771476936100000);
        token.transfer(parseAddr("0x78593244a3e484708C5FF73c2e118AB421C1529"),42319085907744400000);
        token.transfer(parseAddr("0xFA410CBf8064C8343497883Ae3BCc86977307Bb"),42319085907744400000);
        token.transfer(parseAddr("0x3bFB13A204BcDF52419E43cfBEdF78117ea2855"),0);
        token.transfer(parseAddr("0x56EB4d25984265A416Fa895Ce72b900786FcF1A"),2115954295387220000);
        token.transfer(parseAddr("0xDAd7Fd2A6f4646869208Bda42E07A47ED49454B"),2115954295387220000);
        token.transfer(parseAddr("0x74dc4ADCc82c0eC2a0EcBC3a9465578CBc858f2"),42319085907744400000);
        token.transfer(parseAddr("0x3b2d21cbbD13739eC01a5C86b98F138a51243BA"),10579771476936100000);
        token.transfer(parseAddr("0xe68822A7d0cb53818b9459cd2629091cab62cA1"),42319085907744400000);
        token.transfer(parseAddr("0x018315503d3F9e19D03E94a9ed8F2Ec0D178572"),5289885738468050000);
        token.transfer(parseAddr("0xfe9c19457C56cc7205830710c9085c62c65041C"),0);
        token.transfer(parseAddr("0xB9220eA0Fa893DFE15524730B7aB8AeBcE4ef3c"),42319085907744400000);
        token.transfer(parseAddr("0xF38a53b1bE4F3FB9431CE6F4a2b893a6353C2Ef"),42319085907744400000);
        token.transfer(parseAddr("0xbF005b06B92E09D9aB5EC2feF16213Bee224f00"),10579771476936100000);
        token.transfer(parseAddr("0xE390FE116eB43996398c6404E9FeD242dF88af5"),2115954295387220000);
        token.transfer(parseAddr("0x36B59beA7F5Fc359687d87e2A5e5E27FD5baf0A"),21159542953872200000);
        token.transfer(parseAddr("0x84c77B32095Bdf32e7A1B86D482720a9B9cf176"),10579771476936100000);
        token.transfer(parseAddr("0x3389135b58F51052A5dA4f40e70d3cA106da336"),42319085907744400000);
        token.transfer(parseAddr("0x3807926F68c715948a6C736e95ab06858D28C0d"),2115954295387220000);
        token.transfer(parseAddr("0x8b5426267785C4852DD0cEE17D87178077c775B"),7053180984624070000);
        token.transfer(parseAddr("0xFeD29e59B3B4A70B42E2dA6be60F958aFd3c77D"),0);
        token.transfer(parseAddr("0x0360bdd5e8B733A5E53d000C49E025b7C8D074E"),28212723938496300000);
        token.transfer(parseAddr("0xAB1158374272032243b55504CE967B2f2B840ad"),7053180984624070000);
        token.transfer(parseAddr("0x904CF577d754fDFFd8439D77Cbfbd633b067C45"),14106361969248100000);
        token.transfer(parseAddr("0xb95F1577371fAE9FF9A0bf309De82f8598cCD2a"),28212723938496300000);
        token.transfer(parseAddr("0x400E2B1817d020094d090FEaff754fC49058B17"),14106361969248100000);
        token.transfer(parseAddr("0xC964416A729E707a8c40Cf79fAE89a73d77e9d9"),7053180984624070000);
        token.transfer(parseAddr("0x18A8769dF875e830BEF960E1b82729b5180461C"),14106361969248100000);
        token.transfer(parseAddr("0x3D68a0c77d0Fbf7A1787F5AEe91f4024260A339"),28212723938496300000);
        token.transfer(parseAddr("0x023Cf68E441cd5486Fa79fb9C39eAea91289D8F"),7053180984624070000);
        token.transfer(parseAddr("0x17e9F6104385d64c06D9C35CE0df49d46859517"),3526590492312030000);
        token.transfer(parseAddr("0x87B53f4d4CB88a808504F2d4C13B93bfaF7510b"),14106361969248100000);
        token.transfer(parseAddr("0x9586aB7091C215E843B7860fD196299231185C8"),7053180984624070000);
        token.transfer(parseAddr("0xFb933DC419501C93B5Cb2E2976a4E97Ab5712FA"),14106361969248100000);
        token.transfer(parseAddr("0x2d564171a9B3Bea38aF61c43cF21061A77734Bf"),14106361969248100000);
        token.transfer(parseAddr("0x3521b2E55BFC44082B44ccEc652cC39767d2000"),14106361969248100000);
        token.transfer(parseAddr("0x74789A87769CeEB0826d78CAb8150964E69129F"),3526590492312030000);
        token.transfer(parseAddr("0xDF7Cc2a07B3fD3DBAeA1d5471b16fac8d689581"),14106361969248100000);
        token.transfer(parseAddr("0xb1743b733FdB0Ce9483fecfb8D32c01aA686Ef4"),14106361969248100000);
        token.transfer(parseAddr("0xA720Fef1352C4555B07683FBa53f94e9b7E3B80"),14106361969248100000);
        token.transfer(parseAddr("0xCbE6aF150f2b38dd4bccC2602070c3D60d0d7C0"),14106361969248100000);
        token.transfer(parseAddr("0xB5dEEe5B4d72C8C8c6F5d013B266e7b0757EDD8"),7053180984624070000);
        token.transfer(parseAddr("0x27a92B2A4114223Aca75E8Ea71dF1DEe82d1182"),7053180984624070000);
        token.transfer(parseAddr("0xc3ce837823dbc543303c88eaC388AB9B345D372"),3526590492312030000);
        token.transfer(parseAddr("0x2744E0Ed95eE0e94eD6f941A8F3C64c7e173781"),1763295246156020000);
        token.transfer(parseAddr("0xd8acd541209B4b8563f960c7E4ab0896de6dC9F"),14106361969248100000);
        token.transfer(parseAddr("0x6772dD9EADE24C92818b5e871D4F8E86Fb590A0"),1763295246156020000);
        token.transfer(parseAddr("0x3CD89DE291E94DC96Bf8b2602866f5D6B248129"),7053180984624070000);
        token.transfer(parseAddr("0xCAeF425B8C7c5B467e63183b4cbF58d14C238D9"),1763295246156020000);
        token.transfer(parseAddr("0x923aa330b87eA2235891c7A8153eE998AbB5BC7"),1763295246156020000);
        token.transfer(parseAddr("0xaEb57fb98328dA975FEB1Cd8A550379e94e01A0"),7053180984624070000);
        token.transfer(parseAddr("0x6205600A1f49e0829DdBf3e0227dcE6eD34C8E2"),1763295246156020000);
        token.transfer(parseAddr("0x9966b36aDa6f2929A366Bebe0b86B2b6E5b1fBa"),14106361969248100000);
        token.transfer(parseAddr("0x945279550FA9E8Def8E8aB06F97c79f6254cddd"),3526590492312030000);
        token.transfer(parseAddr("0xD635176fd37178659E02741f52EFe6BaF8c7F7e"),705318098462407000);
        token.transfer(parseAddr("0xae0a5969ec6ade9c55ef660d04bf9230a11e9c1"),1763295246156020000);
        token.transfer(parseAddr("0x82C1Fb9f0CcB8D4643480c1E6c81aE06e8b054e"),7053180984624070000);
        token.transfer(parseAddr("0x44407B1662a5751Fc486866e42254008B9eE926"),1763295246156020000);
        token.transfer(parseAddr("0x2aAf9bD87B74C19c35D58F454e7f082a1420A0c"),1763295246156020000);
        token.transfer(parseAddr("0x9A131b646dE6c83Ffd5703ebFf9Ac03869357E6"),705318098462407000);
        token.transfer(parseAddr("0x40fb4cb64B25B38CDeFf9e1E4f9b83572C2a55f"),14106361969248100000);
        token.transfer(parseAddr("0x4c3c2507E37D55CEc71E44752ACAEb93569506b"),14106361969248100000);

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