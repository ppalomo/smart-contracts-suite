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

    let lotteryAddress = await lotteryFactory.getLotteryAddress();
    Lottery = await ethers.getContractFactory("Lottery");
    lottery = await Lottery.attach(lotteryAddress);
    expect(await lottery.lotteryId()).to.equal(0);
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

      const lotteryAddress = await lotteryFactory.getLotteryAddress();
      Lottery = await ethers.getContractFactory("Lottery");
      lottery = await Lottery.attach(lotteryAddress);
      expect(await lottery.lotteryId()).to.equal(1);
      expect(lottery.address).to.properAddress;
      expect(lottery.address).to.equal(lotteryAddress);
    });

  });

  describe("Lottery", function () {

    it("Should buy a ticket", async function () {
      await lottery.connect(addr1).buyTickets(2, {value: ethers.utils.parseEther('0.2')});
      await lottery.connect(addr2).buyTickets(1, {value: ethers.utils.parseEther('0.1')});
      
      expect(await lottery.getTotalTickets()).to.equal(3);
      expect(await lottery.getAddressTickets(addr1.address)).to.equal(2)
      expect(await lottery.getAddressTickets(addr2.address)).to.equal(1)
      expect(await lottery.getBalance()).to.equal(ethers.utils.parseEther('0.3'));
    });

    it("Should declare a winner", async function() {
      await lottery.connect(addr1).buyTickets(1, {value: ethers.utils.parseEther('0.1')});
      await lottery.connect(addr2).buyTickets(1, {value: ethers.utils.parseEther('0.1')});
      
      await lottery.declareWinner();

      expect(await lottery.getBalance()).to.equal(0);
      expect(await lottery.active()).to.false;
    });

  });

});
