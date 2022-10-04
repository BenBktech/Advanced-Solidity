// Get funds from users
// Whithdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract getPriceOfEthInUSD {

    uint256 public minimumUsd = 50 * 1e18;

    function fund() public payable {
        require(getConversionRate(msg.value) >= minimumUsd, "Didnt't send enought"); // 1e18 = 1 ether
    }

    function getPrice() public view returns(uint) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (,int price,,,) = priceFeed.latestRoundData();
        // ETH in terms of USD
        //3000.000000000 8 décimales
        //1eth = 1 000 000 000 000 000 000 000 Wei 18 décimales
        //10 = 18 - 8
        return uint256(price * 1e10);
    }

    function getVersion() public view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        uint256 ethPrice = getPrice();
        // Division par 1e18 car "ethPrice * ethAmount" aurait 36 décimales
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

}