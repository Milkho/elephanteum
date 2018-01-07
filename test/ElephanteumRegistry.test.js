const storage =  artifacts.require('Storage');
const eRegistry = artifacts.require('ElephanteumRegistry');
const accessManager = artifacts.require("StorageAccessManager");

contract('ElephanteumRegistry', ([owner, user]) => {

    let eReg;

    before(async () => {
        store = await storage.new();
        let aManager = await accessManager.new();
        eReg = await eRegistry.new(store.address, "ElephanteumRegistry");
        eReg.setController(owner);
        await store.setManager(aManager.address);
        await aManager.giveAccess(eReg.address, "ElephanteumRegistry");
    });

    it('should set initial data', async () => {
        const name = "Elephanteum", symbol = "EPH", supply = 111;
        await eReg.setInitialData(name, symbol, supply);
        let rName, rSymbol, rSupply, remaining;;
        rName = await eReg.getName();
        rSymbol = await eReg.getSymbol();
        rSupply = await eReg.getTotalSupply();
        remaining = await eReg.getRemaining();

        assert.equal(name, web3.toUtf8(rName));
        assert.equal(symbol, web3.toUtf8(rSymbol));
        assert.equal(supply, rSupply);
        assert.equal(supply, remaining);
    });

    it('should set owner', async () => {
        const eIndex = 0;
        await eReg.setOwner(eIndex, user);

        let currentOwner = await eReg.getOwner(eIndex);

        assert.equal(user, currentOwner);
    });

    it('should change owner', async () => {
        const eIndex = 0;
        await eReg.setOwner(eIndex, owner);

        let currentOwner = await eReg.getOwner(eIndex);

        assert.equal(owner, currentOwner);
    });
});