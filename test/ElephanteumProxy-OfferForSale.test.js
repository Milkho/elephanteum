const expectThrow = require('./heplers/expectThrow');
const setup = require('./heplers/setup'); 

const elephanteumProxy = artifacts.require('ElephanteumProxy');


contract('ElephanteumProxy - offering for sale, setting not for offer', ([owner, user1, user2]) => {
  
  let eCore, eProxy;
  const eIndex = 0, minPrice = 1000000000;
  
  before(async () => {
    const name = "Elephanteum", symbol = "EPH", supply = 1;
    eCore = await setup([owner]);
    eProxy = await elephanteumProxy.new();
    await eCore.setProxy(eProxy.address);
    await eProxy.setController(eCore.address);
    await eProxy.init(name, symbol, supply);
  });
 
  it('Should do not allow offer elephant for sale if not all elephants are assigned', async () => {
    await expectThrow(eProxy.offerForSale(eIndex, minPrice, user1));
  });
  
  it('Should do not allow offer elephant for sale if caller is not an owner', async () => {
    await eProxy.getElephant(eIndex);
    await expectThrow(eProxy.offerForSale(eIndex, minPrice, user1, {from:user2}));
  });

  it('Should offer elephant for sale', async () => {

    await eProxy.offerForSale(eIndex, minPrice, user1);

    let isForSale, minValue, onlySellTo;
    [isForSale, minValue, onlySellTo] = await eProxy.getLot(eIndex);
    
    assert.equal(true, isForSale, "elephant should be for salee");
    assert.equal(minPrice, minValue, "prices should match");
    assert.equal(user1, onlySellTo, "user account should match onlySellTo account");
  });

  it('Should do not allow offer elephant not for sale if caller is not an owner', async () => {
    await expectThrow(eProxy.setNoLongerForSale(eIndex, {from:user1}));
  });
  
  it('Should set elephant not for sale', async () => {
    const eIndex = 0;
    
    await eProxy.setNoLongerForSale(eIndex);
    
    let isForSale, minValue, onlySellTo;
    [isForSale, minValue, onlySellTo] = await eProxy.getLot(eIndex);
    
    assert.equal(false, isForSale, "elephant should be not for sale");
  });

});