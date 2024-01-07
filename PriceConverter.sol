// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    
    function getPrice() internal view returns(uint256) {
        // ABI
        // Address 0x694AA1769357215DE4FAC081bf1f309aDC325306 (Sepolia)
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);

        // (uint80 roundId, int price, uint startedAt, uint timestamp, uint80 answeredInRound) = priceFeed.latestRoundData();
        (,int price,,,) = priceFeed.latestRoundData();
        // ETH in terms of USD (8 decimals)
        // 3000.00000000 (8 decimals)

        return uint256(price * 1e10); // 1 * 10 ** 10 == 10000000000
    }

    function getVersion() internal view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    function getDecimal() internal view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.decimals();
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}