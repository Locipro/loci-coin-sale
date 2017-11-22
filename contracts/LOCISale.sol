pragma solidity ^0.4.15;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/lifecycle/Pausable.sol';
import './LOCIcoin.sol';
import './IRefundHandler.sol';


contract LOCISale is Ownable, Pausable, IRefundHandler {
    using SafeMath for uint256;

    // this sale contract is creating the LOCIcoin
    // contract, and so will own it
    LOCIcoin internal token;

    // UNIX timestamp (UTC) based start and end, inclusive
    uint256 public start;               /* UTC of timestamp that the sale will start based on the value passed in at the time of construction */
    uint256 public end;                 /* UTC of computed time that the sale will end based on the hours passed in at time of construction */

    bool public isPresale;              /* For LOCI this will be false. We raised pre-ICO offline. */
    bool public isRefunding = false;    /* No plans to refund. */
    
    uint256 public minFundingGoalWei;   /* we can set this to zero, but we might want to raise at least 20000 Ether */
    uint256 public minContributionWei;  /* individual contribution min. we require at least a 0.1 Ether investment, for example. */
    uint256 public maxContributionWei;  /* individual contribution max. probably don't want someone to buy more than 60000 Ether */

    uint256 public weiRaised;       /* total of all weiContributions */
    uint256 public weiRaisedAfterDiscounts; /* wei raised after the discount periods end */
    uint256 internal weiForRefund;  /* only applicable if we enable refunding, if we don't meet our expected raise */  

    uint256 public peggedETHUSD;    /* In whole dollars. $300 means use 300 */
    uint256 public hardCap;         /* In wei. Example: 64,000 cap = 64,000,000,000,000,000,000,000 */
    uint256 public reservedTokens;  /* In wei. Example: 54 million tokens, use 54000000 with 18 more zeros. then it would be 54000000 * Math.pow(10,18) */    
    uint256 public baseRateInCents; /* $2.50 means use 250 */
    uint256 internal startingTokensAmount; // this will be set once, internally

    mapping (address => uint256) public contributions;

    struct DiscountTranche {
        // this will be a timestamp that is calculated based on
        // the # of hours a tranche rate is to be active for
        uint256 end;
        // should be a % number between 0 and 100
        uint8 discount;
        // should be 1, 2, 3, 4, etc...
        uint8 round;
        // amount raised during tranche in wei
        uint256 roundWeiRaised;
        // amount sold during tranche in wei
        uint256 roundTokensSold;
    }
    DiscountTranche[] internal discountTranches;
    uint8 internal currentDiscountTrancheIndex = 0;
    uint8 internal discountTrancheLength = 0;

    event ContributionReceived(address indexed buyer, bool presale, uint8 rate, uint256 value, uint256 tokens);
    event RefundsEnabled();
    event Refunded(address indexed buyer, uint256 weiAmount);
    event ToppedUp();
    event PegETHUSD(uint256 pegETHUSD);    

    function LOCISale(
        address _token,                 /* LOCIcoin contract address */
        uint256 _peggedETHUSD,          /* 300 = 300 USD */
        uint256 _hardCapETHinWei,       /* In wei. Example: 64,000 cap = 64,000,000,000,000,000,000,000 */
        uint256 _reservedTokens,        /* In wei. Example: 54 million tokens, use 54000000 with 18 more zeros. then it would be 54000000 * Math.pow(10,18) */    
        bool _isPresale,                /* For LOCI this will be false. Presale offline, and accounted for in reservedTokens */
        uint256 _minFundingGoalWei,     /* If we are looking to raise a minimum amount of wei, put it here */
        uint256 _minContributionWei,    /* For LOCI this will be 0.1 ETH */
        uint256 _maxContributionWei,    /* Advisable to not let a single contributor go over the max alloted, say 63333 * Math.pow(10,18) wei. */
        uint256 _start,                 /* For LOCI this will be */
        uint256 _durationHours,         /* Total length of the sale, in hours */
        uint256 _baseRateInCents,       /* Base rate in cents. $2.50 would be 250 */
        uint256[] _hourBasedDiscounts   /* Single dimensional array of pairs [hours, rateInCents, hours, rateInCents, hours, rateInCents, ... ] */
    ) public {
        require(_token != 0x0);
        // either have NO max contribution or the max must be more than the min
        require(_maxContributionWei == 0 || _maxContributionWei > _minContributionWei);
        // sale must have a duration!
        require(_durationHours > 0);

        token = LOCIcoin(_token);

        peggedETHUSD = _peggedETHUSD;
        hardCap = _hardCapETHinWei;
        reservedTokens = _reservedTokens;

        isPresale = _isPresale;

        start = _start;
        end = start.add(_durationHours.mul(1 hours));

        minFundingGoalWei = _minFundingGoalWei;
        minContributionWei = _minContributionWei;
        maxContributionWei = _maxContributionWei;

        baseRateInCents = _baseRateInCents;

        // this will throw if the # of hours and
        // discount % don't come in pairs
        uint256 _end = start;

        uint tranche_round = 0;

        for (uint i = 0; i < _hourBasedDiscounts.length; i += 2) {
            // calculate the timestamp where the discount rate will end
            _end = _end.add(_hourBasedDiscounts[i].mul(1 hours));

            // the calculated tranche end cannot go past the crowdsale end
            require(_end <= end);

            tranche_round += 1;

            discountTranches.push(DiscountTranche({ end:_end, 
                                                    discount:uint8(_hourBasedDiscounts[i + 1]), 
                                                    round:uint8(tranche_round), 
                                                    roundWeiRaised:0,
                                                    roundTokensSold:0}));

            discountTrancheLength = uint8(i+1);
        }
    }

    function determineDiscountRate() internal returns (uint8) {        
        var (the_end, the_rate, the_round) = determineDiscountTranche();
        return the_rate;
    }

    event DebugValue(uint256 value, string text);

    function determineDiscountTranche() internal returns (uint256, uint8, uint8) {
        uint256 the_end = 0;
        uint8 the_rate = 0;
        uint8 the_round = 0;

        if (currentDiscountTrancheIndex < discountTranches.length) {
            DiscountTranche storage d = discountTranches[currentDiscountTrancheIndex];
            if (d.end < now) {
                // find the next applicable tranche
                while (++currentDiscountTrancheIndex < discountTranches.length) {
                    d = discountTranches[currentDiscountTrancheIndex];                    
                    if (d.end > now) {
                        break;
                    }
                }
            }

            // Example: there are 4 rounds, and we want to divide rounds 2-4 equally based on (starting-round1)/3, move to next tranche
            // But don't move past the last round. Note, the last round should not be capped. That's why we check for round < # tranches
            if( d.round > 1 && d.roundTokensSold > 0 && d.round < discountTranches.length ) {
                
                uint256 trancheCountExceptForOne = discountTranches.length-1;
                uint256 tokensSoldFirstRound = discountTranches[0].roundTokensSold;
                uint256 allowedTokensThisRound = (startingTokensAmount.sub(tokensSoldFirstRound)).div(trancheCountExceptForOne);
                                
                if( d.roundTokensSold > allowedTokensThisRound ) {
                    currentDiscountTrancheIndex = currentDiscountTrancheIndex + 1; 
                    d = discountTranches[currentDiscountTrancheIndex];                                               
                } 
            } 

            // if the index is still valid, then we must have
            // a valid tranche, so return discount rate
            if (currentDiscountTrancheIndex < discountTranches.length) {
                the_end = d.end;
                the_rate = d.discount;
                the_round = d.round;
            } else {
                the_end = end;
                the_rate = 0;
                the_round = discountTrancheLength + 1;
            }
        }

        return (the_end, the_rate, the_round);
    }

    function () public payable whenNotPaused {
        require(!isRefunding);
        require(msg.sender != 0x0);
        require(msg.value >= minContributionWei);
        require(start <= now && end >= now);


        // prevent anything more than maxContributionWei per contributor address
        uint256 weiContributionAllowed = maxContributionWei > 0 ? maxContributionWei.sub(contributions[msg.sender]) : msg.value;
        if(maxContributionWei > 0) {
            require(weiContributionAllowed > 0);
        }

        // are limited by the number of tokens remaining
        uint256 tokensRemaining = token.balanceOf(address(this)).sub( reservedTokens );
        require(tokensRemaining > 0);

        if( startingTokensAmount == 0 ) {
            startingTokensAmount = tokensRemaining; // set this once.
        }

        // limit contribution's value based on max/previous contributions
        uint256 weiContribution = msg.value;
        if (weiContribution > weiContributionAllowed)
            weiContribution = weiContributionAllowed;

        // limit contribution's value based on hard cap of hardCap
        if(hardCap > 0 && weiRaised.add(weiContribution) > hardCap ) {                        
            weiContribution = hardCap.sub( weiRaised );            
        }

        // calculate token amount to be created
        //uint256 tokens = weiContribution.mul(tokenToWeiMultiplier);
        uint256 tokens = weiContribution.mul(peggedETHUSD).mul(100).div(baseRateInCents);
        var (the_end, the_rate, the_round) = determineDiscountTranche();
        if (the_rate > 0) {
            tokens = weiContribution.mul(peggedETHUSD).mul(100).div(the_rate);            
        }                            

        if (tokens > tokensRemaining) {
            // there aren't enough tokens to fill the contribution amount, so recalculate the contribution amount
            tokens = tokensRemaining;
            if (the_rate > 0)
                weiContribution = tokens.mul(the_rate).div(100).div(peggedETHUSD);
            else
                weiContribution = tokens.mul(baseRateInCents).div(100).div(peggedETHUSD);    
        }                    

        // add the contributed wei to any existing value for the sender
        contributions[msg.sender] = contributions[msg.sender].add(weiContribution);
        ContributionReceived(msg.sender, isPresale, the_rate, weiContribution, tokens);

        require(token.transfer(msg.sender, tokens));

        weiRaised = weiRaised.add(weiContribution); //total of all weiContributions

        if( discountTrancheLength > 0 && the_round > 0 && the_round <= discountTrancheLength ) {
            discountTranches[the_round-1].roundWeiRaised = discountTranches[the_round-1].roundWeiRaised.add(weiContribution);
            discountTranches[the_round-1].roundTokensSold = discountTranches[the_round-1].roundTokensSold.add(tokens);
        }  
        if( discountTrancheLength > 0 && the_round > discountTrancheLength ) {
            weiRaisedAfterDiscounts = weiRaisedAfterDiscounts.add(weiContribution);
        }

        uint256 _weiRefund = msg.value.sub(weiContribution);
        if (_weiRefund > 0) {
            require(msg.sender.call.value(_weiRefund)());            
        }
    }    

    // in case we need to return funds to this contract
    function ownerTopUp() external payable {}

    function pegETHUSD(uint256 _peggedETHUSD) onlyOwner public {
        peggedETHUSD = _peggedETHUSD;
        PegETHUSD(peggedETHUSD);
    }

    function peggedETHUSD() constant onlyOwner public returns(uint256) {
        return peggedETHUSD;
    }

    function hardCapETHInWeiValue() constant onlyOwner public returns(uint256) {
        return hardCap;
    }

    function weiRaisedDuringRound(uint8 round) constant onlyOwner public returns(uint256) {
        require( round > 0 && round <= discountTrancheLength );
        return discountTranches[round-1].roundWeiRaised;
    }

    function weiRaisedAfterDiscountRounds() constant onlyOwner public returns(uint256) {
        return weiRaisedAfterDiscounts;
    }

    function totalWeiRaised() constant onlyOwner public returns(uint256) {
        return weiRaised;
    }

    function ownerEnableRefunds() external onlyOwner {
        // a little protection against human error;
        // sale must be ended OR it must be paused
        require(paused || now > end);
        require(!isRefunding);

        weiForRefund = this.balance;
        isRefunding = true;
        RefundsEnabled();
    }

    function ownerTransferWei(address _beneficiary, uint256 _value) external onlyOwner {
        require(_beneficiary != 0x0);
        require(_beneficiary != address(token));
        // we cannot withdraw if we didn't reach the minimum funding goal
        require(minFundingGoalWei == 0 || weiRaised >= minFundingGoalWei);

        // if zero requested, send the entire amount, otherwise the amount requested
        uint256 amount = _value > 0 ? _value : this.balance;

        require(_beneficiary.call.value(amount)());
    }

    function ownerRecoverTokens(address _beneficiary) external onlyOwner {
        require(_beneficiary != 0x0);
        require(_beneficiary != address(token));
        require(now > end);

        uint256 tokensRemaining = token.balanceOf(address(this));
        if (tokensRemaining > 0)
            token.transfer(_beneficiary, tokensRemaining);
    }

    function handleRefundRequest(address _contributor) external {
        // Note that this method can only ever called by
        // the token contract's `claimRefund()` method;
        // everything that happens in here will only
        // succeed if `claimRefund()` works as well.

        require(isRefunding);
        // this can only be called by the token contract;
        // it is the entry point for the refund flow
        require(msg.sender == address(token));

        uint256 _wei = contributions[_contributor];

        // if this is zero, then `_contributor` didn't
        // contribute or they've already been refunded
        require(_wei > 0);

        // prorata the amount if necessary
        if (weiRaised > weiForRefund) {
            uint256 _n  = weiForRefund.mul(_wei).div(weiRaised);
            require(_n < _wei);
            _wei = _n;
        }

        // zero out their contribution, so they cannot
        // claim another refund; it's important (for
        // avoiding re-entrancy attacks) that this zeroing
        // happens before the transfer below
        contributions[_contributor] = 0;

        // give them their ether back; throws on failure
        require(_contributor.call.value(_wei)());

        Refunded(_contributor, _wei);
    }
}
