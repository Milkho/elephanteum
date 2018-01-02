const expectThrow = require('./heplers/expectThrow');

const elephanteumAdvancedCore = artifacts.require('ElephanteumAdvancedCore');
const elephanteumStorage = artifacts.require('ElephanteumStorage');


contract('ElephanteumAdvancedCore - offering for sale, bidding', ([owner, user1, user2]) => {
 
  let eCore, eStorage;
 

  before(async () => {
    const name = "Elephanteum", symbol = "EPH", supply = 1;
    
    eStorage = await elephanteumStorage.new();
    eCore = await elephanteumAdvancedCore.new(eStorage.address);
    await eStorage.transferOwnership(eCore.address);
    await eCore.init(name, symbol, supply);
  });


  it('Should enter a bid', async () => {
    const eIndex = 0, minPrice = 1000000000;

    await eCore.getElephant(owner, eIndex);

    //should throw because the elephant is not for sale
    await expectThrow(eCore.enterBid(user1, eIndex, {value: minPrice}));

    await eCore.offerForSale(owner, eIndex, minPrice, "0x0")

    //should throw because the bidders is owner of the elephant
    await expectThrow(eCore.enterBid(owner, eIndex, {value: minPrice}));

    //should throw because the bid value is less than min price setted by an owner
    await expectThrow(eCore.enterBid(user2, eIndex, {value: minPrice-1}));
    
    await eCore.enterBid(user2, eIndex, {value: minPrice});
    
    //should throw because proposed bid value isn't  higher than current bid value
    await expectThrow(eCore.enterBid(user1, eIndex, {value: minPrice}));

    //user1 sets higher bid
    await eCore.enterBid(user1, eIndex, {value: minPrice+10});

    let bidHasBid, bidElephantIndex, bidBidder,bidValue;
    [bidHasBid,bidElephantIndex, bidBidder, bidValue] = await eStorage.elephantBids.call(eIndex);
    
    assert.equal(true, bidHasBid, "elephant should have bid");
    assert.equal(eIndex, bidElephantIndex, "elephants indexes should match");
    assert.equal(user1, bidBidder, "user1 should be bidder");
    assert.equal(minPrice+10, bidValue.toNumber(), "bid value and price should match");
  });

  it('Should accept a bid', async () => {
    const eIndex = 0, minPrice = 1000000000;

    //should throw because there're no bids that are higher than setted min price
    await expectThrow(eCore.acceptBid(owner, eIndex, minPrice+100));

    //should throw because user1 is not an owner of the elephant
    await expectThrow(eCore.acceptBid(user1, eIndex, minPrice));

    await eCore.acceptBid(owner, eIndex, minPrice)
    
    let offerIsForSale, offerElephantIndex, offerSeller, offerMinValue, offerOnlySellTo;
    [offerIsForSale, offerElephantIndex, offerSeller, offerMinValue, offerOnlySellTo] = await eStorage.elephantsOfferedForSale.call(eIndex);
    
    let currentOwner = await eStorage.elephantIndexToAddress(eIndex);

    assert.equal(false, offerIsForSale, "elephant should be not for sale");
    assert.equal(eIndex, offerElephantIndex, "elephants indexes should match");
    assert.equal(user1, currentOwner, "user1 should be owner because he has setted the higher bid");
  });

});