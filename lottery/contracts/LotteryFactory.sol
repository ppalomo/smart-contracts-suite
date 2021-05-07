//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Lottery.sol";
import "hardhat/console.sol";

contract LotteryFactory is Ownable {
  
    // Structs

    // Variables
    Lottery[] lotteries;
    uint public ticketPrice;

    // Events
    event LotteryCreated(uint lotteryId, uint ticketPrice);
    event TicketPriceChanged(uint ticketPrice);

    /**
    @notice Contract constructor method.
    @param _ticketPrice - Initial ticket price.
    */
    constructor(uint _ticketPrice) {
        ticketPrice = _ticketPrice;
        createLottery();
    } 

    function createLottery() public {
        Lottery newLottery = new Lottery(lotteries.length, ticketPrice);
        lotteries.push(newLottery);

        emit LotteryCreated(lotteries.length - 1, ticketPrice);
    }

    function getLotteryId() public view returns(uint) {
        return lotteries.length - 1;
    }

    function getLotteryAddress() public view returns(address) {
        return address(lotteries[lotteries.length - 1]);
    }

    /**
    @notice Sets ticket price.
    @param _ticketPrice - New ticket price.
    */
    function setTicketPrice(uint _ticketPrice) public onlyOwner {
        ticketPrice = _ticketPrice;
        emit TicketPriceChanged(ticketPrice);
    }

}