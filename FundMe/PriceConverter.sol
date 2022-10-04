// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {

    function getPrice() internal view returns(uint) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (,int price,,,) = priceFeed.latestRoundData();
        // ETH in terms of USD
        // Solidity has no decimals, so you have to do math to get them
        return uint256(price * 1e10);
    }

    function getVersion() internal view returns(uint256) {
        // To interact with a contract, we need the ABI and the address.
        // The interface gives us the ABI
        // Then we can call the functions (e.g. version()) of this contract
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

}