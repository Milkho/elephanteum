const expectThrow = require('./heplers/expectThrow');
const setup = require('./heplers/setup'); 

const elephanteumProxy = artifacts.require('ElephanteumProxy');

contract('ElephanteumProxy - initialization, getting and transfering elephants', ([owner, user]) => {
 
  const name = "Elephanteum", symbol = "EPH", supply = 100;
  let eCore, eProxy;
 
  before(async () => {
    eCore = await setup([owner]);
    eProxy = await elephanteumProxy.new();
    await eCore.setProxy(eProxy.address);
    await eProxy.setController(eCore.address);
    await eProxy.init(name, symbol, supply);
  });

  it('Should initialize the contract correcty', async () => {

    let rName =  await eProxy.getName();
    let rSymbol = await eProxy.getSymbol();
    let rSupply = await eProxy.getTotalSupply();
    
    assert.equal(name, web3.toUtf8(rName), "name should be initialized correctly");
    assert.equal(symbol, web3.toUtf8(rSymbol), "symbol should be initialized correctly");
    assert.equal(supply, rSupply.toNumber(), "supply should be initialized correctly");
  });

  it('Should give elephants', async () => {
    const elephantIndex = 0;

    await eProxy.getElephant(elephantIndex);
    
    let elephantOwner = await eProxy.getOwner(elephantIndex);
    let remainingElephants = await eProxy.getRemaining();

    assert.equal(elephantOwner, owner, "owner account must be owner of the elephant");
    assert.equal(remainingElephants.toNumber(), supply-1, "there must be 99 elephants left");
  });

  it('Should not allow get elephant with incorrect index', async () => {
    const elephantIncorrectIndex = 100, elephantNegativeIndex = -1;
    await expectThrow(eProxy.getElephant( elephantIncorrectIndex));
    await expectThrow(eProxy.getElephant(elephantNegativeIndex));
  });
  
  it('Should transfer elephants', async () => {
    const myElephantIndex = 1; 

    await eProxy.getElephant(myElephantIndex);
    
    await eProxy.transferElephant(user, myElephantIndex);

    let elephantOwner = await eProxy.getOwner(myElephantIndex);

    assert.equal(user, elephantOwner, "user account must be owner of the elephant");
  });

  it('Should not allow transfer elephant if  elephant does not belong to caller', async () => {
    const notMyElephantIndex = 2; 
    await expectThrow(eProxy.transferElephant(user, notMyElephantIndex));
  });

  it('Should not allow transfer elephant if already has been transfered to user', async () => {
    const myElephantIndex = 1; 
    await expectThrow(eProxy.transferElephant(user, myElephantIndex));
  });

});