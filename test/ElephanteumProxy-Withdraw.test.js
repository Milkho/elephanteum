const expectThrow = require('./heplers/expectThrow');
const setup = require('./heplers/setup'); 
const compareBalances = require('./heplers/compareBalances');

const elephanteumProxy = artifacts.require('ElephanteumProxy');

contract('ElephanteumProxy - withrawing', ([owner, user1, user2]) => {
 
  let eCore, eProxy;
  const name = "Elephanteum", symbol = "EPH", supply = 1;
  const eIndex = 0, price = 10000000000000;

  before(async () => {
    eCore = await setup([owner]);
    eProxy = await elephanteumProxy.new();
    await eCore.setProxy(eProxy.address);
    await eProxy.setController(eCore.address);
    await eProxy.init(name, symbol, supply);
  });

  it('Should withdraw funds after selling', async () => {
    //claim all elephants to user1 account
    await eProxy.getElephant(eIndex, {from:user1});
    //offer for sale for user2
    await eProxy.offerForSale(eIndex, price, user2, {from:user1});
    await eProxy.enterBid(eIndex, {from:user2, value: price*2});
    await eProxy.acceptBid(eIndex, price, {from:user1});

    let before = await web3.eth.getBalance(user1);
    await eProxy.withdraw({from:user1});
    let after = await web3.eth.getBalance(user1);

    compareBalances(before, after, price*2);
  });

  it('Should withdraw funds after bidding', async () => {
    await eProxy.offerForSale(eIndex, price, user1, {from:user2});
    await eProxy.enterBid(eIndex, {from:user1, value: price*2});

    let before = await web3.eth.getBalance(user1);
    await eProxy.withdrawBid(eIndex, {from:user1});
    let after = await web3.eth.getBalance(user1);

    compareBalances(before, after, price*2);
  });

  it('Should withdraw bid if there was higher bid', async () => {
    const eIndex = 0, price = 10000000000000;
    await eProxy.offerForSale(eIndex, price, "0x00",  {from:user2} );
    await eProxy.enterBid(eIndex, {from:user1, value: price*2});

    let before = await web3.eth.getBalance(user1);
    await eProxy.enterBid(eIndex, {value: price*3});
    let after = await web3.eth.getBalance(user1);

    compareBalances(before, after, price*2);
  });

});