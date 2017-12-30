const expectThrow = require('./heplers/expectThrow');

const elephanteumCore = artifacts.require('ElephanteumCore');
const elephanteumStorage = artifacts.require('ElephanteumStorage');


contract('ElephanteumCore', ([owner, user]) => {
 
  let eCore, eStorage;
  const name = "Elephanteum", symbol = "EPH", supply = 100;

  before(async () => {
    eStorage = await elephanteumStorage.new();
    eCore = await elephanteumCore.new(eStorage.address);
    await eStorage.transferOwnership(eCore.address);
    await eCore.init(name, symbol, supply);
  });

  it('Should initialize the contract correcty', async () => {

    let rName =  await eStorage.name.call();
    let rSymbol = await eStorage.symbol.call();
    let rSupply = await eStorage.totalSupply.call();
    
    assert.equal(name, web3.toUtf8(rName), "name should be initialized correctly");
    assert.equal(symbol, web3.toUtf8(rSymbol), "symbol should be initialized correctly");
    assert.equal(supply, rSupply.toNumber(), "supply should be initialized correctly");
  });

  it('Should give elephants', async () => {
    let elephantIndex = 0, elephantIncorrectIndex = 100;

    await eCore.getElephant(owner, elephantIndex);
    
    let elephantOwner = await eStorage.elephantIndexToAddress.call(elephantIndex);
    let remainingElephants = await eStorage.elephantsRemainingToAssign.call();

    //should throw on index = 100 because max index = 99
    await expectThrow(eCore.getElephant(owner, elephantIncorrectIndex));

    assert.equal(owner, elephantOwner, "owner account must be owner of the elephant");
    assert.equal(remainingElephants.toNumber(), supply-1, "there must be 99 elephants left");
  });

  it('Should transfer elephants', async () => {
    let myElephantIndex = 1, notMyElephantIndex = 2; 

    await eCore.getElephant(owner, myElephantIndex);
    
    await eCore.transferElephant(owner, user, myElephantIndex);

    let elephantOwner = await eStorage.elephantIndexToAddress.call(myElephantIndex);

    //should throw because this elephant doesn't belong to "owner"
    await expectThrow(eCore.transferElephant(owner, user, notMyElephantIndex));

    //should throw because this elephant already has been transfered to user
    await expectThrow(eCore.transferElephant(owner, user, myElephantIndex));

    assert.equal(user, elephantOwner, "user account must be owner of the elephant");
  });

});