pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/ownership/Contactable.sol';
import 'zeppelin-solidity/contracts/token/StandardToken.sol';


contract LOCIreddit is Ownable, Contactable {
    using SafeMath for uint256;
    
    // this is the already deployed coin from the token sale
    StandardToken token;

    // only allow distribution once. record it with an event
    bool public hasDoneRedditChunkOne = false;
    event DistributedRedditChunkOne();

    bool public hasDoneRedditChunkTwo = false;
    event DistributedRedditChunkTwo();

    bool public hasDoneRedditChunkThree = false;
    event DistributedRedditChunkThree();

    bool public hasDoneRedditChunkFour = false;
    event DistributedRedditChunkFour();

    // After this contract is deployed, we will grant access to this contract
    // by calling methods on the LOCIcoin since we are using the same owner
    // and granting the distribution of tokens to this contract
    function LOCIreddit( address _token, string _contactInformation ) public {
        require(_token != 0x0);

        token = StandardToken(_token);
        contactInformation = _contactInformation;
                
        hasDoneRedditChunkOne = false;
        hasDoneRedditChunkTwo = false;
        hasDoneRedditChunkThree = false;
        hasDoneRedditChunkFour = false;        
    }    

    /*function distributeEverything() onlyOwner public {
        distributeRedditChunkOne();
        distributeRedditChunkTwo();
        distributeRedditChunkThree();
        distributeRedditChunkFour();
    }*/
    
    
    function distributeRedditChunkOne() onlyOwner public {
        require(!hasDoneRedditChunkOne);  
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
        

        hasDoneRedditChunkOne = true;
        DistributedRedditChunkOne();
    }

    function distributeRedditChunkTwo() onlyOwner public {
        require(!hasDoneRedditChunkTwo);

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

        hasDoneRedditChunkTwo = true;
        DistributedRedditChunkTwo();
    }


    function distributeRedditChunkThree() onlyOwner public {
        require(!hasDoneRedditChunkThree);

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
        

        hasDoneRedditChunkThree = true;
        DistributedRedditChunkThree();
    }    

    function distributeRedditChunkFour() onlyOwner public {
        require(!hasDoneRedditChunkFour);

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

        hasDoneRedditChunkFour = true;
        DistributedRedditChunkFour();
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