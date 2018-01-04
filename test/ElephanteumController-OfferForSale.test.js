const expectThrow = require('./heplers/expectThrow');
const setup = require('./heplers/setup'); 

contract('ElephanteumController - offering for sale, setting not for offer', ([owner, user1, user2]) => {
  
  let eCore;
  const eIndex = 0, minPrice = 1000000000;

  before(async () => {
    const name = "Elephanteum", symbol = "EPH", supply = 1;
    eCore = await setup([owner]);
    await eCore.init(name, symbol, supply);
  });

  it('Should do not allow  offer elephant for sale if not all elephants are assigned', async () => {
    await expectThrow(eCore.offerForSale(owner, eIndex, minPrice, user1));
  });
  
  it('Should do not allow offer elephant for sale if caller is not an owner', async () => {
    await eCore.getElephant(owner, eIndex);
    await expectThrow(eCore.offerForSale(user2, eIndex, minPrice, user1));
  });

  it('Should offer elephant for sale', async () => {

    await eCore.offerForSale(owner, eIndex, minPrice, user1);

    let isForSale, minValue, onlySellTo;
    [isForSale, minValue, onlySellTo] = await eCore.getLot(eIndex);
    
    assert.equal(true, isForSale, "elephant should be for salee");
    assert.equal(minPrice, minValue, "prices should match");
    assert.equal(user1, onlySellTo, "user account should match onlySellTo account");
  });

  it('Should do not allow offer elephant not for sale if caller is not an owner', async () => {
    await expectThrow(eCore.setNoLongerForSale(user1, eIndex));
  });
  
  it('Should set elephant not for sale', async () => {
    const eIndex = 0;
    
    await eCore.setNoLongerForSale(owner, eIndex);
    
    let isForSale, minValue, onlySellTo;
    [isForSale, minValue, onlySellTo] = await eCore.getLot(eIndex);
    
    assert.equal(false, isForSale, "elephant should be not for sale");
  });

});