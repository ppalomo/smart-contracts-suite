const { ethers, upgrades } = require("hardhat");
const { use, expect, assert } = require("chai");
const { solidity } = require("ethereum-waffle");

var BigNumber = require('big-number');
use(solidity);

describe("Lottery Contract", function () {
  let Lottery;
  let lottery;
  let owner;
  let addr1;
  let addr2;
  let addrs;

  let ticketPrice = ethers.utils.parseEther('0.1');

  beforeEach(async function () {
    
    // Deploying contracta
    Lottery = await ethers.getContractFactory("Lottery");
    lottery = await Lottery.deploy(ticketPrice);
    expect(lottery.address).to.properAddress;

    // Getting test accounts
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
  });

  it("Should have an owner account", async function () {
    expect(owner.address).to.equal(await lottery.owner());
  });

  it("Should be able to buy tickets", async function () {
    await lottery.connect(addr1).buyTicket({value: ticketPrice});
    await lottery.connect(addr1).buyTicket({value: ticketPrice});
    await lottery.connect(addr2).buyTicket({value: ticketPrice});
    
    expect(await lottery.getBalance()).to.equal(ethers.utils.parseEther('0.3'));
    expect(await lottery.getAddressTickets(addr1.address)).to.equal(2);
    expect(await lottery.getAddressTickets(addr2.address)).to.equal(1);
    expect(await lottery.getTotalTickets()).to.equal(3);    
  });

});
