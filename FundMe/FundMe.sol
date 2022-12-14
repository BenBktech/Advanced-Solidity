// Get funds from users
// Whithdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./PriceConverter.sol";

error NotOwner();
error NotEnoughtFunds();
error CallFailed();

contract FundMe {

    using PriceConverter for uint256;
    // "constant" saves gaz
    uint256 public constant MINIMUM_USD = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;
    // "immutable" saves gaz
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        //require(msg.value.getConversionRate() >= MINIMUM_USD, "Didnt't send enought"); // 1e18 = 1 ether
        if(msg.value.getConversionRate() < MINIMUM_USD) { revert NotEnoughtFunds(); }
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner {
        for(uint256 funderIndex = 0 ; funderIndex < funders.length ; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset the array
        funders = new address[](0);
        // withdraw the funds
        // transfer
        //payable(msg.sender).transfer(address(this).balance);
        // send
        //bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //require(sendSuccess, "Send failed");
        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        //require(callSuccess, "Call failed");
        if(!callSuccess) { revert CallFailed(); }
    }

    modifier onlyOwner {
        //require(msg.sender == i_owner, "Not the owner");
        if(msg.sender != i_owner) { revert NotOwner(); }
        _;
    }

    //What happens if someone sends this contract ETH without calling the fund function
    // receive() to send a transaction
    receive() external payable {
        fund();
    }

    // fallback() to send datas
    fallback() external payable {
        fund();
    }

}