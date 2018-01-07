const expectThrow = require('./heplers/expectThrow');
const setup = require('./heplers/setup'); 
const elephanteumProxy = artifacts.require('ElephanteumProxy');

contract('ElephanteumProxy - bidding, accepting bids', ([owner, user1, user2]) => {
 
  let eCore;

  const name = "Elephanteum", symbol = "EPH", supply = 1, eIndex = 0, minPrice = 1000000000;

  before(async () => {
    eCore = await setup([owner]);
    eProxy = await elephanteumProxy.new();
    await eCore.setProxy(eProxy.address);
    await eProxy.setController(eCore.address);
    await eProxy.init(name, symbol, supply);
  });

  it('Should not allow enter a bid on elephant which is not for sale', async () => {
    await expectThrow(eProxy.enterBid(eIndex, {from: user1, value: minPrice}));
  });

  it('Should not allow enter a bid if bidder is owner of the elephant', async () => {
    await eProxy.getElephant(eIndex);
    await eProxy.offerForSale(eIndex, minPrice, "0x0")
    await expectThrow(eProxy.enterBid(eIndex, {value: minPrice}));
  });

  it('Should not allow enter a bid if bid value is less than min price setted by an owner', async () => {
    await expectThrow(eProxy.enterBid(eIndex, {from: user2, value: minPrice-1}));
  });

  it('Should enter a bid', async () => {
    await eProxy.enterBid(eIndex, {from: user2, value: minPrice});
  
    let bidHasBid, bidElephantIndex, bidBidder,bidValue;
    [bidHasBid, bidBidder, bidValue] = await eProxy.getBid(eIndex);
    
    assert.equal(true, bidHasBid, "elephant should have bid");
    assert.equal(user2, bidBidder, "user2s should be bidder");
    assert.equal(minPrice, bidValue.toNumber(), "bid value and price should match");
  })

  it('Should not allow enter a bid if proposed bid value isn not  higher than current bid value', async () => {
    await expectThrow(eProxy.enterBid(eIndex, {from: user1, value: minPrice}));
  });

  it('Should enter a higher bid', async () => {
    //user1 sets higher bid
    await eProxy.enterBid(eIndex, {from: user1, value: minPrice+10});

    let bidHasBid, bidElephantIndex, bidBidder,bidValue;
    [bidHasBid, bidBidder, bidValue] = await eProxy.getBid(eIndex);
    
    assert.equal(true, bidHasBid, "elephant should have bid");
    assert.equal(user1, bidBidder, "user1 should be bidder");
    assert.equal(minPrice+10, bidValue.toNumber(), "bid value and price should match");
  });

  it('Should not allow accept a bid if ther are no bids that are higher than setted min price', async () => {
    await expectThrow(eProxy.acceptBid(eIndex, minPrice+100));
  });

  it('Should not allow accept a bid if caller is not an owner of the elephant', async () => {
    await expectThrow(eProxy.acceptBid(eIndex, minPrice, {from: user1}));
  });

  it('Should accept a bid', async () => {
    await eProxy.acceptBid(eIndex, minPrice)
    
    let offerIsForSale, offerSeller, offerMinValue, offerOnlySellTo;
    [offerIsForSale, offerSeller, offerMinValue, offerOnlySellTo] = await eProxy.getLot(eIndex);
    
    let currentOwner = await eProxy.getOwner(eIndex);
    assert.equal(false, offerIsForSale, "elephant should be not for sale");
    assert.equal(user1, currentOwner, "user1 should be owner because he has setted the higher bid");
  });

  it('Should remove bid when it accepted', async () => {  
    let bidHasBid, bidElephantIndex, bidBidder,bidValue;
    [bidHasBid, bidBidder, bidValue] = await eProxy.getBid(eIndex);
    
    assert.equal(false, bidHasBid, "elephant should do not have bid");
  });

});