const expectThrow = require('./heplers/expectThrow');
const setup = require('./heplers/setup'); 
const compareBalances = require('./heplers/compareBalances');


contract('ElephanteumController - withrawing', ([owner, user1, user2]) => {
 
  let eCore;
  const name = "Elephanteum", symbol = "EPH", supply = 1;

  before(async () => {
    eCore = await setup([owner]);
    await eCore.init(name, symbol, supply);
  });

  it('Should withdraw funds after selling', async () => {
    const eIndex = 0, price = 10000000000000;
    //claim all elephants to owner account
    await eCore.getElephant(user1, eIndex);
    //offer for sale for user1
    await eCore.offerForSale(user1, eIndex, price, user2);
    await eCore.enterBid(user2, eIndex, {value: price*2});
    await eCore.acceptBid(user1, eIndex, price);

    let before = await web3.eth.getBalance(user1);
    await eCore.withdraw(user1);
    let after = await web3.eth.getBalance(user1);

    compareBalances(before, after, price*2);
  });

  it('Should withdraw funds after bidding', async () => {
    const eIndex = 0, price = 10000000000000;

    await eCore.offerForSale(user2, eIndex, price, user1);
    await eCore.enterBid(user1, eIndex, {value: price*2});

    let before = await web3.eth.getBalance(user1);
    await eCore.withdrawBid(user1, eIndex);
    let after = await web3.eth.getBalance(user1);

    compareBalances(before, after, price*2);
  });

  it('Should withdraw bid if there was higher bid', async () => {
    const eIndex = 0, price = 10000000000000;
    await eCore.offerForSale(user2, eIndex, price, "0x00");
    await eCore.enterBid(user1, eIndex, {value: price*2});

    let before = await web3.eth.getBalance(user1);
    await eCore.enterBid(owner, eIndex, {value: price*3});
    let after = await web3.eth.getBalance(user1);

    compareBalances(before, after, price*2);
  });

});