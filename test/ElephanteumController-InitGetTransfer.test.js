const expectThrow = require('./heplers/expectThrow');
const setup = require('./heplers/setup'); 

contract('ElephanteumController - initialization, getting and transfering elephants', ([owner, user]) => {
 
  const name = "Elephanteum", symbol = "EPH", supply = 100;
  let eCore;
 
  before(async () => {
    eCore = await setup([owner]);
    await eCore.init(name, symbol, supply);
  });

  it('Should initialize the contract correcty', async () => {

    let rName =  await eCore.getName();
    let rSymbol = await eCore.getSymbol();
    let rSupply = await eCore.getTotalSupply();
    
    assert.equal(name, web3.toUtf8(rName), "name should be initialized correctly");
    assert.equal(symbol, web3.toUtf8(rSymbol), "symbol should be initialized correctly");
    assert.equal(supply, rSupply.toNumber(), "supply should be initialized correctly");
  });

  it('Should give elephants', async () => {
    const elephantIndex = 0;

    await eCore.getElephant(owner, elephantIndex);
    
    let elephantOwner = await eCore.getOwner(elephantIndex);
    let remainingElephants = await eCore.getRemaining();

    assert.equal(owner, elephantOwner, "owner account must be owner of the elephant");
    assert.equal(remainingElephants.toNumber(), supply-1, "there must be 99 elephants left");
  });

  it('Should not allow get elephant with incorrect index', async () => {
    const elephantIncorrectIndex = 100, elephantNegativeIndex = -1;
    await expectThrow(eCore.getElephant(owner, elephantIncorrectIndex));
    await expectThrow(eCore.getElephant(owner, elephantNegativeIndex));
  });
  
  it('Should transfer elephants', async () => {
    const myElephantIndex = 1; 

    await eCore.getElephant(owner, myElephantIndex);
    
    await eCore.transferElephant(owner, user, myElephantIndex);

    let elephantOwner = await eCore.getOwner(myElephantIndex);

    assert.equal(user, elephantOwner, "user account must be owner of the elephant");
  });

  it('Should not allow transfer elephant if  elephant does not belong to caller', async () => {
    const notMyElephantIndex = 2; 
    await expectThrow(eCore.transferElephant(owner, user, notMyElephantIndex));
  });

  it('Should not allow transfer elephant if already has been transfered to user', async () => {
    const myElephantIndex = 1; 
    await expectThrow(eCore.transferElephant(owner, user, myElephantIndex));
  });

});