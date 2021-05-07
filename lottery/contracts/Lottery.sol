//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract Lottery is Ownable {
  
  // Structs

  // Variables
  uint public ticketPrice;
  mapping(address => uint) tickets;
  address[] public players;

  uint public lotteryId;
  bool public active;
  address public winner;

  // Events
  event TicketsBought(address indexed buyer, uint numberOfTickets);
  event WinnerDeclared(address indexed winner, uint prize);

  /**
   @notice Contract constructor method.
   @param _lotteryId - Lottery unique identifier.
   @param _ticketPrice - Initial ticket price.
   */
  constructor(uint _lotteryId, uint _ticketPrice) {
    lotteryId = _lotteryId;
    ticketPrice = _ticketPrice;
    active = true;
  } 

  /**
   @notice Method used to buy a lottery ticket.
   @param _numberOfTickets - Number of the tickets to buy.
   */
  function buyTickets(uint _numberOfTickets) public payable {
    require(active, 'This lottery is not active');
    require(msg.value == ticketPrice * _numberOfTickets, 'Amount sent is different than price');

    tickets[msg.sender] += _numberOfTickets;

    for (uint i=0; i<_numberOfTickets; i++) {
      players.push(msg.sender);
    }

    emit TicketsBought(msg.sender, _numberOfTickets);
  }

  /**
   @notice Gets the lottery winner account.
   */
  function declareWinner() public {
    require(players.length > 0);

    uint index = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % players.length;
    winner = players[index];

    uint prize = address(this).balance;
    payable(players[index]).transfer(address(this).balance);
    active = false;

    emit WinnerDeclared(players[index], prize);
  }

  /**
   @notice Returns number of tickets for an address.
   @param _addr - Wallet address.
   */
  function getAddressTickets(address _addr) public view returns (uint) {
    return tickets[_addr];
  }

  /**
   @notice Returns total number of tickets.
   */
  function getTotalTickets() public view returns (uint) {
    return players.length;
  }

  /**
    @notice Method used to return the contract balance.
    @return Current contract balance.
    */
  function getBalance() public view returns (uint) {
      return address(this).balance;
  }

}
