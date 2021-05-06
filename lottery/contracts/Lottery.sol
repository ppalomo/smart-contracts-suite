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

  // Events

  /**
   @notice Contract constructor method.
   @param _ticketPrice - Initial ticket price.
   */
  constructor(uint _ticketPrice) {
    ticketPrice = _ticketPrice;
  } 

  /**
   @notice Method used to buy a lottery ticket.
   */
  function buyTicket() public payable {
    require(msg.value == ticketPrice, 'Amount sent is different than ticketPrice');

    tickets[msg.sender]++;
    players.push(msg.sender);
  }

  // /**
  //   @notice Cancel a ticket and get the money back.
  //  */
  // function cancelTickets() public {
  //   payable(msg.sender).transfer(ticketPrice);
    
  //   tickets[msg.sender] = 0;
  //   // delete players[msg.sender];
  // }

  // /**
  //  @notice Gets the lottery winner account.
  //  */
  // function getWinner() public view onlyOwner {
  //   uint winner = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % players.length;
  //   console.log(winner);
  // }

  // /**
  //  @notice Returns number of tickets for an address.
  //  @param _addr - Wallet address.
  //  */
  // function getAddressTickets(address _addr) public view returns (uint) {
  //   return tickets[_addr];
  // }

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
