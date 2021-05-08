//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Lottery.sol";
import "hardhat/console.sol";

contract LotteryFactory is Ownable {
  
    // Structs
    struct LotteryItem{
        uint ticketPrice;
        Lottery instance;
    }

    // Variables
    LotteryItem[] public lotteries;
    uint public daysOpenPeriod;
    uint public daysStakingPeriod;
    uint public maxActiveLotteries;
    uint public numberOfActiveLotteries;

    // Events
    event LotteryCreated(uint lotteryId, address nftAddress, uint nftIndex, uint ticketPrice);
    event MaxActiveLotteriesChanged(uint maxActiveLotteries);
    event PeriodsChanged(uint daysOpenPeriod, uint daysStakingPeriod);

    /**
    @notice Contract constructor method.
    */
    constructor() {
        daysOpenPeriod = 7;
        daysStakingPeriod = 7;
        maxActiveLotteries = 10;
        numberOfActiveLotteries = 0;
    }

    /**
    @notice Creates a new NFT lottery.
    @param _nftAddress - NFT contract's address.
    @param _nftIndex - NFT indentifier in its contract.
    @param _ticketPrice - Lottery ticket price.
     */
    function createLottery(address _nftAddress, uint _nftIndex, uint _ticketPrice) public onlyOwner {
        // Check if nft transfer is approved
        require(numberOfActiveLotteries < maxActiveLotteries, 'Maximum of active lotteries has already been reached');
        require(_nftAddress != address(0), 'A valid address is required');
        require(_ticketPrice > 0, 'A valid ticket price is required');

        Lottery instance = new Lottery(lotteries.length, _nftAddress, _nftIndex, _ticketPrice, daysOpenPeriod, daysStakingPeriod);
        LotteryItem memory newLottery = LotteryItem(_ticketPrice, instance);        
        lotteries.push(newLottery);

        numberOfActiveLotteries++;

        emit LotteryCreated(lotteries.length - 1, _nftAddress, _nftIndex, _ticketPrice);
    }

    /**
     @notice Sets number of maximum active lotteries.
     @param _maxActiveLotteries - New maximum.
     */
    function setMaxActiveLotteries(uint _maxActiveLotteries) public onlyOwner {
        maxActiveLotteries = _maxActiveLotteries;
        emit MaxActiveLotteriesChanged(maxActiveLotteries);
    }

    /**
     @notice Sets days of the different lottery periods.
     @param _daysOpenPeriod - Number of days the lottery is open.
     @param _daysStakingPeriod - Number of days the lottery is staking.
     */
    function setDays(uint _daysOpenPeriod, uint _daysStakingPeriod) public onlyOwner {
        daysOpenPeriod = _daysOpenPeriod;
        daysStakingPeriod = _daysStakingPeriod;
        emit PeriodsChanged(daysOpenPeriod, daysStakingPeriod);
    }

}