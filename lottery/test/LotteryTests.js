const { ethers, upgrades } = require("hardhat");
const { use, expect, assert } = require("chai");
const { solidity } = require("ethereum-waffle");

var BigNumber = require('big-number');
use(solidity);

describe("Lottery Contract", function () {
  let LotteryFactory, Lottery;
  let lotteryFactory, lottery;
  let owner;
  let addr1;
  let addr2;
  let addrs;

  let ticketPrice = ethers.utils.parseEther('0.1');

  beforeEach(async function () {
    
    // Deploying contracta
    LotteryFactory = await ethers.getContractFactory("LotteryFactory");
    lotteryFactory = await LotteryFactory.deploy(ticketPrice);
    expect(lotteryFactory.address).to.properAddress;

    await lotteryFactory.createLottery();

    const lotteryAddress = await lotteryFactory.getLotteryAddress();
    Lottery = await ethers.getContractFactory("Lottery");
    lottery = await Lottery.attach(lotteryAddress);
    expect(lottery.address).to.properAddress;
    expect(lottery.address).to.equal(lotteryAddress);

    // Getting test accounts
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
  });

  describe("LotteryFactory", function () {

    it("Should create a new lottery", async function () {
      await lotteryFactory.createLottery();
      
      expect(await lotteryFactory.getLotteryAddress()).to.properAddress;
      expect(await lotteryFactory.getLotteryId()).to.equal(1);
    });

  });

  describe("Lottery", function () {

    it("Should buy a ticket", async function () {
      await lottery.connect(addr1).buyTicket({value: ticketPrice});
      
      expect(await lottery.getTotalTickets()).to.equal(1);
      expect(await lottery.getBalance()).to.equal(ticketPrice);
    });

  });

});
