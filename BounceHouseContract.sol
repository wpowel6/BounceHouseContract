// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BounceHouseRental {

    address payable public owner;
    bool public available;
    uint public ratePerHour;
    uint public ratePerDay;

    event Log(address indexed sender, string message);

    constructor() {
        owner = payable(msg.sender);
        available = true;
        ratePerHour = 0.02 ether;
        ratePerDay = 0.4 ether;
    }

    modifier onlyOwner() { 
        require(msg.sender == owner, "Modifier: Must be the owner!"); 
        _;
    }

    modifier onlyWhenAvailable() {
        require(available, "Bounce house is currently unavailable.");
        _;
    }

    function bookBounceHouse(uint numHours, uint numDays) public payable onlyWhenAvailable {
        require(numHours > 0 || numDays > 0, "You must book at least one hour or one day.");
        uint totalCost = (ratePerHour * numHours) + (ratePerDay * numDays);
        require(msg.value == totalCost, "Incorrect payment amount.");
        (bool sent, ) = payable(owner).call{ value: msg.value }("");
        require(sent, "Payment transfer failed.");
        available = false;
        emit Log(msg.sender, "The Bounce House has been successfully booked!");
    }

    function makeBounceHouseAvailable() public onlyOwner {
        available = true;
        emit Log(msg.sender, "The Bounce House is now available.");
    }

    function updateDailyRate(uint newRate) public onlyOwner {
        ratePerDay = newRate;
        emit Log(msg.sender, "The Bounce House daily rate has been updated.");
    }

    function updateHourlyRate(uint newRate) public onlyOwner {
        ratePerHour = newRate;
        emit Log(msg.sender, "The Bounce House hourly rate has been updated.");
    }

    function purchaseBounceHouse() public payable {
        uint minOffer = 2.3 ether;
        require(msg.value >= minOffer, "No you can't have the Bounce House without at least 2.3 Ether! Perhaps consider renting for a fraction of the cost instead!");
        (bool sent, ) = payable(owner).call{ value: msg.value }("");
        require(sent, "Transfer failed.");
        owner = payable(msg.sender);
    }
}