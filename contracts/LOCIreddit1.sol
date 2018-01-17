pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/ownership/Contactable.sol';
import 'zeppelin-solidity/contracts/token/StandardToken.sol';


contract LOCIreddit1 is Ownable, Contactable {
    using SafeMath for uint256;
    
    // this is the already deployed coin from the token sale
    StandardToken token;

    // only allow distribution once. record it with an event
    bool public hasDoneRedditChunk = false;
    event DistributedRedditChunk();   

    // After this contract is deployed, we will grant access to this contract
    // by calling methods on the LOCIcoin since we are using the same owner
    // and granting the distribution of tokens to this contract
    function LOCIreddit1( address _token, string _contactInformation ) public {
        require(_token != 0x0);

        token = StandardToken(_token);
        contactInformation = _contactInformation;
                
        hasDoneRedditChunk = false;            
    }      
    
    function distributeBulk(address[] _address, uint256[] _values) onlyOwner public{
        for (uint i = 0; i < _address.length; i += 1) {
            token.transfer(_address[i],_values[i]);
        }
    }    

    function distributeRedditChunk() onlyOwner public {
        require(!hasDoneRedditChunk);  
        // Bounty (Reddit) 
        token.transfer(parseAddr("0xdd12d76573bffdd7e1e70359eb65e83910a0f35"),1410636196924810000);
        token.transfer(parseAddr("0xd92aBFe5Cc4f619683F05E26F5951CCe3DFEb97"),0);
        token.transfer(parseAddr("0xDE253eDE8474Da66e2398746eE65629334160B2"),10579771476936100000);
        token.transfer(parseAddr("0x9699b7dDA37126Ad39349a4729C5a520C5B6a31"),0);
        token.transfer(parseAddr("0xAEB06433A1048b964B3dD9fdd93A85Ca48d4c32"),0);
        token.transfer(parseAddr("0x23D34385cD658A4d427FBacAB31C4F98BAF71A6"),56425447876992500000);
        token.transfer(parseAddr("0xfF794FF176ddE7640064983d8F2B942B12a4AB7"),38792495415432400000);
        token.transfer(parseAddr("0x5833D964A884e3CCd24567042E8077b469Df8f8"),112850895753985000000);
        token.transfer(parseAddr("0xA4fDc58feCC6f42BA05842028b1F84ee0177ccb"),7053180984624070000);
        token.transfer(parseAddr("0xc5E9406eEdB93cbb9f81E46cd428eEb9b5ac63D"),3879249541543240000);
        token.transfer(parseAddr("0xce757e8767465182ed2885099aE8C5F4066Fd587"), 42319085907744400000);
        token.transfer(parseAddr("0x00d97D7f128D251Cfd3Bd638FE300Abf3037C73"),162223162646354000000);
        token.transfer(parseAddr("0x2D2c27b5a0ae884f976dBa8B1AF113ed81E2827"),705318098462407000);
        token.transfer(parseAddr("0xf177015d46b43543B68fE39A0eBA974944460F6"),112850895753985000000);
        token.transfer(parseAddr("0xc4a982113e3e6d0481476805643d6a1ff47763a"),1410636196924810000);
        token.transfer(parseAddr("0x3179f88ded783b02e0EA90D44cE5C584AcbD9F3"),14106361969248100000);
        token.transfer(parseAddr("0x164326f68a640ebfa187885324c704Ee306c3E1"),0);
        token.transfer(parseAddr("0xf7c99f0855ad2a672d349c583ca41fc0f8016c5"),0);
        token.transfer(parseAddr("0x0A503597bC447ff10e77c1150406F4C4717A1C9"),4937226689236850000);
        token.transfer(parseAddr("0xb17dad79cc178d4c0f2c8a21b0b0e7098f9c5ec"),0);
        token.transfer(parseAddr("0xa0c53c510299e9FeB696F6354Db7fD9dC61acd1"),183382705600226000000);
        token.transfer(parseAddr("0x82f2DA2d9eb092304c2ADa69EcBF8E5226Cf769"),98744533784736900000);
        token.transfer(parseAddr("0x71Fd1bB9b2B28843Ef7Fe02d7d48aBF9F55bEf4"),52898857384680500000);
        token.transfer(parseAddr("0xD1A22b3E103bAA0c785e1d1eFD8DE0CF52Eaa87"),26449428692340200000);
        token.transfer(parseAddr("0xD937ED8360a761Bbde1f3371AD1922138d2B284"),102271124277049000000);
        token.transfer(parseAddr("0x63e1f12A095235644fc393366ae03fAFB33503f"),37029200169276300000);
        token.transfer(parseAddr("0x273E3f4552C8EE60d4f10268Ce51bA289202Af8"),352659049231203000);
/*        
        token.transfer(parseAddr("0x1B8f0cB0970CbB165D58ADaAe7682929D5CB68D"),0);
        token.transfer(parseAddr("0x9baDe2672149119afd0b0f35E2Fef89946dDdE0"),3526590492312030000);
        token.transfer(parseAddr("0x63838CD7EC8654b14Aa21B560e695FbDbfA972E"),49372266892368500000);
        token.transfer(parseAddr("0x99D789f3dA0E142298f631c32C153493A1afe8d"),49372266892368500000);
        token.transfer(parseAddr("0xCB81476f81d030Eb958b718b2C637Bd7DF9D326"),0);
        token.transfer(parseAddr("0xAE8e2E8Dae63391058d0BbBC5d3875eabDdAa63"),38792495415432400000);
        token.transfer(parseAddr("0x6B7cCDa4EE569D3C737e046494B8374eCbD17E8"),14106361969248100000);
        token.transfer(parseAddr("0xe95BAD0D7a8d503348366A7A652616c5aa81D42"),91691352800112800000);
        token.transfer(parseAddr("0x71839e58649d9a806CA8328e1875E4d9438c35c"),211595429538722000000);
        token.transfer(parseAddr("0xEFA2427A318BE3D978Aac04436A59F2649d9f7b"),14106361969248100000);
        token.transfer(parseAddr("0x2Cbc78b7DB97576674cC4e442d3F4d792b43A3a"),84638171815488800000);
        token.transfer(parseAddr("0x29225360845f3670D91B8fe3d7a3F2EC7F60033"),112850895753985000000);
        token.transfer(parseAddr("0x31e0dA3f4a04bF93055b4ffcA55f50579E882F6"),42319085907744400000);
        token.transfer(parseAddr("0x7081b27bB5505d8b21BCD9131d07D3924e9F961"),112850895753985000000);
        token.transfer(parseAddr("0x3ac1c429a967D77917966881f2fAAEEf573eA70"),0);
        token.transfer(parseAddr("0x1c2daB0bC25205e34C7787ccf5F20B9A20B0B41"),37029200169276300000);
        token.transfer(parseAddr("0x2f96E93454A51dDA117A6F6b9d77dD747653131"),42319085907744400000);
        token.transfer(parseAddr("0x590bc2043BF9f0A56c25b047D9227C39b90EA40"),77584990830864700000);
        token.transfer(parseAddr("0x55f0F689A39D17ed9db4512B2C4344739827547"),0);
        token.transfer(parseAddr("0xEB7bC9FdEB0aDd70bc26583C85fb50Bf9b6B5e2"),3173931443080830000);
        token.transfer(parseAddr("0x0867b99d396CEB24c95b8b1849f6a3795893e61"),3526590492312030000);
        token.transfer(parseAddr("0x9F425144b3D68eB042214C557Cd995209742c64"),0);
        token.transfer(parseAddr("0x6b8DB9D872F808Cd0bff94B33009c8FDf302D0e"),95217943292424900000);
        token.transfer(parseAddr("0x01d8C2a236D8Ee96CED4711A4650FD5433a95d8"),51135562138524500000);
        token.transfer(parseAddr("0x096267C09714C42Bd30554A12976EA4Fa2B78D9"),42319085907744400000);
        token.transfer(parseAddr("0xfD1f27E81012f201eb4747E042D719c2623E9fb"),204542248554098000000);
        token.transfer(parseAddr("0x75f6155789Dc5459b27CE9ba0d5Ce5Fd038B14F"),183382705600226000000);
        token.transfer(parseAddr("0x5a3d09Ae0d3781736D4781CccEa8FFf874AF81D"),19043588658485000000);
        token.transfer(parseAddr("0x689feedD16534ca4b41DF24d74785A01Dc88775"),81111581323176800000);
        token.transfer(parseAddr("0x5fAcAaDD40AE912Dccf963096BCb530c413839E"),38792495415432400000);
        token.transfer(parseAddr("0x1aF57b15f375396Dab8ED0446782188849059CD"),0);
        token.transfer(parseAddr("0xbd9bbBf52E24Ed2FFf5E7c5B66B80BbD062E393"),91691352800112800000);
        token.transfer(parseAddr("0x5A782Ec40E34DA39EEE2fE069871505B3D5D745"),0);
        token.transfer(parseAddr("0x251402227bCe7264aA6c3813EcD6f1e89946e23"),7053180984624070000);
        token.transfer(parseAddr("0xD96305B6d3e8D55a4215A89001B74bC38f7699a"),35265904923120300000);
        token.transfer(parseAddr("0xa48D1b277b080FB60Dfbd0d3BE6c35F0ffEC03e"),155169981661729000000);
        token.transfer(parseAddr("0xB3ddc00a26F91B2C61C400B90Fb5265b7F7DE08"),105797714769361000000);
        token.transfer(parseAddr("0xdF722100D7333d7865F099fAE6A359c790275E0"),26449428692340200000);
        token.transfer(parseAddr("0x79CA7Ee6B5439c1d8a103e7C6F51bf0E2c2978F"),32091973480039500000);
        token.transfer(parseAddr("0x926E1009Bf71c749C9643661d0a7a95EfD7a713"),7053180984624070000);
        token.transfer(parseAddr("0x9Fc70099Fd69716F53e5f93e5C66B5EE525f549"),112850895753985000000);
        token.transfer(parseAddr("0x83AeFe167d325682F8f02fC9B96A5df4c39ec84"),31739314430808300000);
        token.transfer(parseAddr("0xe576d80cA7A61deF2C61453e2cb5E03D881600D"),0);
        token.transfer(parseAddr("0xA8F5615d4ec511d6A2Cc5C65306A3114aAFcDFd"),0);
        token.transfer(parseAddr("0x45EB678A57865d1d824EBeb812C1Fc18B612d65"),10579771476936100000);
        token.transfer(parseAddr("0x834822B6946A22d1d1223374760B8e14351eb65"),0);
        token.transfer(parseAddr("0x679313B912536162da3d45dC3aEf8717a8c9b61"),0);
        token.transfer(parseAddr("0xe23465D600A0D14e2134486428Dc9279E8709FD"),0);
        token.transfer(parseAddr("0xD1cA40623E2B29F4B5300749A0951FfCEf822f7"),0);
        token.transfer(parseAddr("0xE88A5c51B7A99ED005fA2bEB7033b5c0cb41475"),0);
        token.transfer(parseAddr("0x9A7e5d131C28829ce84c54c0D95B1964Be7e5de"),0);
        token.transfer(parseAddr("0x35C88d26ad0CfC76893A8b08f623c0acC1E14B2"),0);
        token.transfer(parseAddr("0xB06AF9e6265255aBDADfDADA69cF308eDeE71F6"),0);
        token.transfer(parseAddr("0x284BFdb5f136E9F2867244d9ace4F0E812Bb375"),0);
        token.transfer(parseAddr("0xDE6e12267611153A0a4F11Bc582b684AB9E57dE"),105797714769361000000);
        token.transfer(parseAddr("0xF3b7f103a59B33d3C1659Bb2481e0b57388D9Ae"),26449428692340200000);
        token.transfer(parseAddr("0xD2aC0F6C9fC86b35a5e6AD2B3b9eb7CFE87D1a4"),81111581323176800000);
        token.transfer(parseAddr("0x1f6ACCf65785366D3e2323139476b84Be412Fb9"),0);
        token.transfer(parseAddr("0x8B447B829139f1E2E237fAee31604e60b03bC41"),0);
        token.transfer(parseAddr("0x1CD998CB6F71232794e4C9e7424C85C5F45cC62"),26449428692340200000);
        token.transfer(parseAddr("0x222778dbac95650da2141d96ab66bb06cb88e4b"),0);
        token.transfer(parseAddr("0x2A96737654be038A870a6815980e6a620d57eA1"),14106361969248100000);
        token.transfer(parseAddr("0x2dc8311BdD6890f435C1c9a621f233496E434Bf"),155169981661729000000);
        token.transfer(parseAddr("0x8fa76DE75Fe74c9D5486FFFf6e326B00784e9C4"),105797714769361000000);
        token.transfer(parseAddr("0x75f23dD04D90B621eC9C17767806D9138ceD6CD"),1410636196924810000);
        token.transfer(parseAddr("0x86A56aC7d5773c339d139c196D79d29FE386d89"),0);
        token.transfer(parseAddr("0xB531bA5eb3f791D28088693039986B9e33ae8BA"),9874453378473690000);
        token.transfer(parseAddr("0x71C8304980735BE1E902A0B6A33aB45a84Ab154"),0);
        token.transfer(parseAddr("0x9899ecb4600cc8777f9242eeb178071fb5a5198"),66652560304697400000);
        token.transfer(parseAddr("0x19cd3473bafd2a3cade12262a73be21e02a5049"),98744533784736900000);
        token.transfer(parseAddr("0xFB13f0D146Ac45ec4D3448CCaF9Fb9D563d4623"),28212723938496300000);
        token.transfer(parseAddr("0x2e04FA2e50B6bd3A092957cAB6AC62A51220873C"),7053180984624070000);
        token.transfer(parseAddr("0x7d62cdd486a15b6a720f3cbbaed3ff740ad3eb8"),176329524615602000000);
        token.transfer(parseAddr("0x95B66BFc3f8a7c05d74393634AB5Ba304e8E156"),40203131612357200000);
        token.transfer(parseAddr("0x376A5b1028ECD123cDe3A9Aa366F4158Ae27F8E"),14106361969248100000);
        token.transfer(parseAddr("0xb101dC14C6012D4faC2025a8f1Cdd4Daf1D9F15"),14106361969248100000);
        token.transfer(parseAddr("0x2429EBfF1a4832Fcb7a6824e77E1F5BfD5f393f"),98744533784736900000);
        token.transfer(parseAddr("0x21e70feE23868b5C84e3cFA093990cCC1Eb5D02"),15869657215404100000);
        token.transfer(parseAddr("0xE7d2aC0d53175a43869a366d76A52e81e1a4068"),0);
        token.transfer(parseAddr("0x6b0d921d52c7a940104748e1867bEfe5f210502"),98744533784736900000);
        token.transfer(parseAddr("0x7210C72233a24346D7088dC0E427B063c77D68C"),0);
        token.transfer(parseAddr("0x9Be85A140606A085178365Eef272C1c75514eC8"),21159542953872200000);
        token.transfer(parseAddr("0x52eBCEB6538DC20a0d811951cc5c57D7e5653d3"),211595429538722000000);
        token.transfer(parseAddr("0xfb521B9acFFBAcAa024B0BAa1C425E0aEfe1C41"),211595429538722000000);
        token.transfer(parseAddr("0x557f86f15a7C52D80e651793a9bf6e4B054bb8F"),49372266892368500000);
        token.transfer(parseAddr("0x66173246C0d049929D3e72e3CdB7c9Ff66DB16B"),105797714769361000000);
        token.transfer(parseAddr("0xD863012D69C7eAa647a48f4fdd4992a3B50a841"),26449428692340200000);
        token.transfer(parseAddr("0x7079fcCC7f7926400301088FC46971a62Bd57a4"),151643391169417000000);
        token.transfer(parseAddr("0x76ac527227B8f27CE12aEF5c00217F0789AAd99"),705318098462407000);
        token.transfer(parseAddr("0xe8eed2f5ac7DD5759DCC7CB1Ecc5065F7E711ab"),105797714769361000000);
        token.transfer(parseAddr("0x940dDCE5a97E1e36543668de30f400FCa3E608c"),21512202003103400000);
        token.transfer(parseAddr("0xe30fb2e743b6F0820E7d381Ff018A38588f0780"),0);
        token.transfer(parseAddr("0x7b1a29e582Aa041aFF93e2b5e5351594000c859"),0);
        token.transfer(parseAddr("0x4D1beb6d8504588EF525372F68f56A784784Cf9"),3526590492312030000);
        token.transfer(parseAddr("0x6E4e0ca28F79fF4448A3e9Fbf815583c1354E21"),0);
        token.transfer(parseAddr("0x2e04FA2e50B6bd3A092957cAB6AC62A51220873"),0);
        token.transfer(parseAddr("0x51ec49876fD0F9e4Bf72998fB24CD82e05802fB"),197489067569474000000);
        token.transfer(parseAddr("0x408e994B86D34452D74A948E6c4dA67AD12210B"),98744533784736900000);
        token.transfer(parseAddr("0x64Ac8E3468054AE473C872D880F12d305E9FB80"),183382705600226000000);
        token.transfer(parseAddr("0x61AC8b9C08986E11419573e13802dc1705f3F20"),8816476230780080000);
        token.transfer(parseAddr("0x9FAd1f60c95BeAcE96e8901C2B139afE18a3ce5"),0);
        token.transfer(parseAddr("0x4fa7f14badf3b69065038b01a7cd5270b00a06e"),84638171815488800000);
        token.transfer(parseAddr("0x68a6139688d905c3d24950Cb8BA5aDbd9c61eff"),151643391169417000000);
        token.transfer(parseAddr("0x9b155A5a1d7852Bd9e38AcC8E8b685D35d3D77a"),105797714769361000000);
        token.transfer(parseAddr("0x7d5f5Af2130985fe0fb5f2BFe38563ccFbEEfe2"),67005219353928600000);
        token.transfer(parseAddr("0x1CC9F33bf026936648CF749A51Dea65c623a795"),0);
        token.transfer(parseAddr("0xAF9a09c64b4ebcbfe42c001b6c163A0d28a8651"),41966426858513200000);
        token.transfer(parseAddr("0xb65F3A4CED9E83183670bff3919Dea2354DFFbd"),190435886584850000000);
        token.transfer(parseAddr("0x452f9a25862293C36216FdCf3f33c586845a299"),0);
        token.transfer(parseAddr("0x491cF7629a2397Eb738A120fB13FA44BDBDc0E4"),28212723938496300000);
        token.transfer(parseAddr("0x63b2fB8e3c22b4230C3b6407e72c1a96f36c1cF"),0);
        token.transfer(parseAddr("0x790622728897B6367b7A8709c5f69d3DbD10507"),56425447876992500000);
        token.transfer(parseAddr("0x16E0DdFe339beCCeDb729CE5670938712390CAb"),105797714769361000000);
        token.transfer(parseAddr("0x0528A94E35ea989Ed42b98F2bc09e2d849A8702"),98744533784736900000);
        token.transfer(parseAddr("0x4989ca432d99194524FbB213C1A499c2B6f987D"),26449428692340200000);
        token.transfer(parseAddr("0xAEd2E75Ec8bfB23efE7C5aEAfdd2ba0D576d091"),22570179150797000000);
        token.transfer(parseAddr("0xFC1E54770F8A9B43f72137A26b831e89FE86fA7"),21159542953872200000);
        token.transfer(parseAddr("0xDA38C2A855f7774266E1f998172e0fB3E822cf0"),211595429538722000000);
        token.transfer(parseAddr("0xffB5f5E8b90e17d8FdFBD65cB6e928AA6F33cC4"),91691352800112800000);
        token.transfer(parseAddr("0x6F626639efF3da66Badda7D0df7433e91Ea33e2"),88164762307800800000);
        token.transfer(parseAddr("0xe53723C804eFDa69632aEB53EC6c41Ce7dBc8D2"),98744533784736900000);
        token.transfer(parseAddr("0x61dA2f396E5295020381c2f96c6B2A55d677CdA"),105797714769361000000);
        token.transfer(parseAddr("0x0936f601AE2cBA761562BEf719Aa263ea72B83F"),91691352800112800000);
        token.transfer(parseAddr("0x7b688FababA56E91427a75e2c6DeCD0C5280e01"),12343066723092100000);
        token.transfer(parseAddr("0x0deA73Db70953D682627BFACB26153f78Ea546B"),8816476230780080000);
        token.transfer(parseAddr("0xe7b0039B5E01cF8e49f5a0D3ae34Bd912e1DF70"),98744533784736900000);
        token.transfer(parseAddr("0x33dB1Dcde8cb15166C89b6e53C9cA6772d5104f"),18338270560022600000);
        token.transfer(parseAddr("0xFfcD4AC9de1657aa3E229BE2e8361ED2C2aab60"),52898857384680500000);
        token.transfer(parseAddr("0x8c6F2e930b213462BF1Eb8224eb9748dcb49D3b"),105797714769361000000);
        token.transfer(parseAddr("0x000e4F3624391D282Ac8370cd1bbd7624e49Dd5"),8463817181548880000);
        token.transfer(parseAddr("0xD601541Eb42C83bD871639c1B6A21a9E0840526"),29623360135421100000);
        token.transfer(parseAddr("0x73f1754927A094015d7F8487dD6d4283dB8f4C6"),3526590492312030000);
        token.transfer(parseAddr("0x0deA73Db70953D682627BFACB26153f78Ea546B"),0);
        token.transfer(parseAddr("0xBB3D24900039279Dda91d1713a2f30277AdE8F9"),24686133446184200000);
        token.transfer(parseAddr("0x4B5B1C356b5d0327e97a5Af6224dd305EA0553b"),22922838200028200000);
        token.transfer(parseAddr("0xf00a51dad55210c67a2587e3fbb30907623a7e1"),162223162646354000000);
        token.transfer(parseAddr("0x81F55B3af49bD31870C8ad94D91713760091646"),    7053180984624070000);
        token.transfer(parseAddr("0x1c5a2Ad610684246eac8087b80878330CFeeDBF"),14106361969248100000);
        token.transfer(parseAddr("0x0c9fb84d41652e9eABB5ca8544b6DC8f371b388"),0);
        token.transfer(parseAddr("0x066f651Fbb404fdf2e8665C22f243B983A570Dc"),1410636196924810000);
        token.transfer(parseAddr("0xE4321372c368cd74539c923Bc381328547e8aA0"),183382705600226000000);
        token.transfer(parseAddr("0x9d0f536Dc95CDE0486a8708e1AF01A6e4a60e9b"),0);
        token.transfer(parseAddr("0x95631Ac12EbdFb23ed83Af61664fe22f537325e"),183382705600226000000);
        token.transfer(parseAddr("0xd882d288b51766e072177586415cf482182de46"),7053180984624070000);
        token.transfer(parseAddr("0x80BAEEECF8faC23cbdDC115Bb8e849798d18d52"),0);
        token.transfer(parseAddr("0xB25819f1aC286B6A3619dd404202d3917D34112"),7053180984624070000);
        token.transfer(parseAddr("0x0252300858333c03f13a2a841e967c23e08B26A"),105797714769361000000);
        token.transfer(parseAddr("0x6b0fe6De273C848d8cC604587C589a847e9b5Df"),169276343630978000000);
        token.transfer(parseAddr("0x359a355D74a83EF447123c14a4e15cbaCF9a6a2"),0);
        token.transfer(parseAddr("0x370bD35881d11d3C5092D3baBea6F28b2420A16"),0);
        token.transfer(parseAddr("0x48Eb6934Ddc194CbbAB137A474A53973043EC5B"),28212723938496300000);
        token.transfer(parseAddr("0x6817A548EE18a1b9A152715FB3F98285014A260"),3526590492312030000);
        token.transfer(parseAddr("0x47283889A0f27d9dC2FAe1Ac5DB5Cef7c7450e3"),0);
        token.transfer(parseAddr("0x382204a450bc7A436e27ce81B3b0490666B3723"),7053180984624070000);
        token.transfer(parseAddr("0x89D5d673b99E89CE7f8A6F9dec80812dB80e994"),0);
        token.transfer(parseAddr("0xD1037e00b6d469F1d6f5D21ef9493C1eB478022"),155169981661729000000);
        token.transfer(parseAddr("0xbBB25f7838005e50321ed6cD68D934e4Dc67383"),28212723938496300000);
        token.transfer(parseAddr("0xd90fF4B18B149ff08cE8A6B3e7A3De314075682"),0);
        token.transfer(parseAddr("0x1c2E0C717C3c4A270d1fe4379A4A2440c39f3d3"),84638171815488800000);
        token.transfer(parseAddr("0xE4321372c368cd74539c923Bc381328547e8aA0"),155169981661729000000);
        token.transfer(parseAddr("0xd581675bdbd8be8565c30279A7d96Bd7439f79b"),8816476230780080000);
        token.transfer(parseAddr("0x878eb1eD9301D7C918ae2866072aF1Eb7b73D4F"),0);
        token.transfer(parseAddr("0xDf58a296c8732402a46B234d640970572218A3F"),56425447876992500000);
        token.transfer(parseAddr("0x71c209B11362A00FfBfE8d4299B9eE7b39DC300"),84638171815488800000);
        token.transfer(parseAddr("0xA77F91be5aa5E46D82490550B39Efe5F6eba330"),42319085907744400000);
        token.transfer(parseAddr("0xc369a9254bf81943cD3E9AbE6764e73202c9938"),162223162646354000000);
        token.transfer(parseAddr("0x1D3aAE726b1967c2695f6340570eCFC574ea2CF"),14106361969248100000);
        token.transfer(parseAddr("0x1277D142847Aa24421E77Caa04e6169b7A7a669"),10579771476936100000);
        token.transfer(parseAddr("0xcC88Ab59637349997dF73b5E372260e6B1607c4"),176329524615602000000);
        token.transfer(parseAddr("0x884dEC8B01D130708005626E552cF1e8Dd1BA68"),37029200169276300000);
        token.transfer(parseAddr("0x2D3b051E2150B797D4A45c24879BE84dee111A5"),49372266892368500000);
        token.transfer(parseAddr("0x75Fe89cB2426CE372dC9cBc3B8a247F92805deF"),14106361969248100000);
        token.transfer(parseAddr("0xFc0d964aA3Aa11AB4Ba0A0CE04A76E26cB5825E"),0);
        token.transfer(parseAddr("0x61fFa27E33516E2A3DF88c59E8e4c60A6fBCd15"),42319085907744400000);
        token.transfer(parseAddr("0xE7cc5676f8fED9E069ddc97f0b7289EA4458832"),3526590492312030000);
        token.transfer(parseAddr("0x2b74bE5Ea5026333F11Fe80436222BC8A16a3e6"),49372266892368500000);
        token.transfer(parseAddr("0xfe9c19457C56cc7205830710c9085c62c65041C"),98744533784736900000);
        token.transfer(parseAddr("0xb9084726979e37268DB9eeA1466943B8f2bB99E"),91691352800112800000);
        token.transfer(parseAddr("0xbe065A817a5Dfc49D878BE3f499C95e0e51Aaa5"),169276343630978000000);
        token.transfer(parseAddr("0x20d7Fe675718a56fE4b0970C7e31577704A22Ca"),0);
        token.transfer(parseAddr("0x81cb6801438107526e7621CE3d3a9d7b3e7599e"),1763295246156020000);
        token.transfer(parseAddr("0x51C35Ac736eA04be3D94934364Ccb3f4DdCE6A1"),169276343630978000000);
        token.transfer(parseAddr("0xae85077EaC573357C4cED0062C1aC1c555c2c7f"),98744533784736900000);
        token.transfer(parseAddr("0xc4AD228a6E3C57086eA4E438289c3931320a4e0"),9874453378473690000);
        token.transfer(parseAddr("0x6b0fe6De273C848d8cC604587C589a847e9b5Df"),42319085907744400000);
        token.transfer(parseAddr("0x8807aF0Bca19ee4D79dF40B23ac2f442d42569d"),77584990830864700000);
        token.transfer(parseAddr("0x067be47f0D4B8380ff41321e0911A66b2b1f893"),63478628861616600000);
        token.transfer(parseAddr("0x624440FFF9763cCbc5ae3E569eFc3458C1347b2"),155169981661729000000);
        token.transfer(parseAddr("0xd475127a4A4Cc7b1DF581Ad63ea83A3c7A00145"),98744533784736900000);
        token.transfer(parseAddr("0xB58C0Fab1a557b01E0F6Bd685a0732f8b64a6dC"),84638171815488800000);
        token.transfer(parseAddr("0x6b0fe6De273C848d8cC604587C589a847e9b5Df"),169276343630978000000);
        token.transfer(parseAddr("0x223fA886D8C90D1faDEDC0605b92DE98bD084F9"),22922838200028200000);
        token.transfer(parseAddr("0x866640E4cCE8814549c3abF65C75a5e0E6579Bd"),3526590492312030000);
        token.transfer(parseAddr("0x25f1A5D4E4ac5a3f7e51b5bDd046c6eb0fe910F"),98744533784736900000);
        token.transfer(parseAddr("0x9A7e5f5cfa7dD89fa30Aa14f2B664FfDfe8541C"),44082381153900400000);
        token.transfer(parseAddr("0x0BE2805Eb4b786369753479c0899299bD158308"),0);
        token.transfer(parseAddr("0x332CAaDa9Ab734E76DC60274dc789AcED94A374"),0);
        token.transfer(parseAddr("0x50B7454d98BB32bA25406B00D870161d37bC124"),0);
        token.transfer(parseAddr("0x9bC2ddE1540446f06cD65D6b3906085c2235C12"),14106361969248100000);
        token.transfer(parseAddr("0x0e966f3C4266Eb5b6861dfB6D2E0D4908A2BAed"),91691352800112800000);
        token.transfer(parseAddr("0x23a0F27241ac3778856f225d16c0e77563DA09E"),151643391169417000000);
        token.transfer(parseAddr("0x8f1db713Ec33434672c9F1c05d0841B5d399620"),1763295246156020000);
        */
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
