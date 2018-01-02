const expectThrow = require('./heplers/expectThrow');

const elephanteumAdvancedCore = artifacts.require('ElephanteumAdvancedCore');
const elephanteumStorage = artifacts.require('ElephanteumStorage');


contract('ElephanteumAdvancedCore - offering for sale, setting not for offer', ([owner, user1, user2]) => {
 
  let eCore, eStorage;
 

  before(async () => {
    const name = "Elephanteum", symbol = "EPH", supply = 1;
    
    eStorage = await elephanteumStorage.new();
    eCore = await elephanteumAdvancedCore.new(eStorage.address);
    await eStorage.transferOwnership(eCore.address);
    await eCore.init(name, symbol, supply);
  });

  
  it('Should offer elephant for sale', async () => {
    const eIndex = 0, minPrice = 1000000000;

    //should throw because not all elephants are assigned
    await expectThrow(eCore.offerForSale(owner, eIndex, minPrice, user1));

    await eCore.getElephant(owner, eIndex);
    await eCore.offerForSale(owner, eIndex, minPrice, user1);

    let isForSale,elephantIndex, seller, minValue, onlySellTo;
    [isForSale,elephantIndex, seller, minValue, onlySellTo] = await eStorage.elephantsOfferedForSale.call(eIndex);
    
    assert.equal(true, isForSale, "elephant should be for salee");
    assert.equal(eIndex, elephantIndex, "elephants indexes should match");
    assert.equal(owner, seller, "the owner should match the seller");
    assert.equal(minPrice, minValue, "prices should match");
    assert.equal(user1, onlySellTo, "user account should match onlySellTo account");
  });

  
  it('Should set elephant not for sale', async () => {
    const eIndex = 0;
    
    await eCore.setNoLongerForSale(owner, eIndex);
    
    let isForSale,elephantIndex, seller, minValue, onlySellTo;
    [isForSale,elephantIndex, seller, minValue, onlySellTo] = await eStorage.elephantsOfferedForSale.call(eIndex);
    
    assert.equal(false, isForSale, "elephant should be not for sale");
    assert.equal(eIndex, elephantIndex, "elephants indexes should match");
    assert.equal(owner, seller, "owner should be seller");
  });

});