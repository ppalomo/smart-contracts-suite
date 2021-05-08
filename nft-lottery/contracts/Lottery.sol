//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract Lottery is Ownable {
  
  // Enums
  // enum State
  // { 
  //   OPEN, 
  //   STAKING, 
  //   CLOSED 
  // }

  // Structs
  struct NFT {
    address addr;
    uint index;
  }

  // Variables
  uint public lotteryId;
  uint public ticketPrice;
  uint daysOpenPeriod; 
  uint daysStakingPeriod;
  uint created;
  NFT public nft;
  mapping(address => uint) tickets;
  address[] public players;
  // State public state;

  
  // bool public active;
  // address public winner;

  // Events
  event TicketsBought(uint lotteryId, address indexed buyer, uint numberOfTickets);
  // event WinnerDeclared(address indexed winner, uint prize);

  /**
   @notice Contract constructor method.
   @param _lotteryId - Lottery unique identifier.
   @param _nftAddress - NFT contract's address.
   @param _nftIndex - NFT indentifier in its contract.
   @param _ticketPrice - Lottery ticket price.
   */
  constructor(uint _lotteryId, address _nftAddress, uint _nftIndex, uint _ticketPrice, uint _daysOpenPeriod, uint _daysStakingPeriod) {
    lotteryId = _lotteryId;
    ticketPrice = _ticketPrice;
    daysOpenPeriod = _daysOpenPeriod;
    daysStakingPeriod = _daysStakingPeriod;
    nft.addr = _nftAddress;
    nft.index = _nftIndex;
    // state = State.OPEN;
    created = block.timestamp;
  } 

  /**
   @notice Method used to buy a lottery ticket.
   @param _numberOfTickets - Number of the tickets to buy.
   */
  function buyTickets(uint _numberOfTickets) public payable {
    require(block.timestamp < created + (daysOpenPeriod * 1 days), 'The lottery open period was closed');
    require(msg.value == ticketPrice * _numberOfTickets, 'Amount sent is different than price');

    tickets[msg.sender] += _numberOfTickets;
    for (uint i=0; i<_numberOfTickets; i++) {
      players.push(msg.sender);
    }

    emit TicketsBought(lotteryId, msg.sender, _numberOfTickets);
  }

  // /**
  //  @notice Gets the lottery winner account.
  //  */
  // function declareWinner() public {
  //   require(players.length > 0);

  //   uint index = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % players.length;
  //   winner = players[index];

  //   uint prize = address(this).balance;
  //   payable(players[index]).transfer(address(this).balance);
  //   active = false;

  //   emit WinnerDeclared(players[index], prize);
  // }

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
