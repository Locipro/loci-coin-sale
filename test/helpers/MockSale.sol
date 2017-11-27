pragma solidity >=0.4.18;

import '../../contracts/LOCIsale.sol';


contract MockSale is LOCIsale {
    function MockSale(
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
    ) LOCIsale(_token, _peggedETHUSD, _hardCapETHinWei, _reservedTokens, _isPresale, _minFundingGoalWei,
        _minContributionWei, _maxContributionWei, _start, _durationHours, _baseRateInCents, _hourBasedDiscounts) {}

    function getTokenAddress() external constant returns (address) {
        return address(token);
    }
    function getNow() external constant returns (uint256) {
        return now;
    }
    function getCurrentDiscountTrancheIndex() external constant returns (uint8) {
        determineDiscountTranche(); // just to trigger the check and update
        return currentDiscountTrancheIndex;
    }
    function getDiscountTrancheEnd(uint8 _index) external constant returns (uint256) {
        determineDiscountTranche(); // just to trigger the check and update
        return discountTranches[_index].end;
    }
    function getDiscountTrancheDiscount(uint8 _index) external constant returns (uint8) {
        determineDiscountTranche(); // just to trigger the check and update
        return discountTranches[_index].discount;
    }
    function getWeiForRefund() external constant returns (uint256) {
        return weiForRefund;
    }


}
