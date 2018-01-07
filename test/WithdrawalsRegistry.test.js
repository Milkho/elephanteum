const storage =  artifacts.require('Storage');
const withdRegistry = artifacts.require('WithdrawalsRegistry');
const accessManager = artifacts.require("StorageAccessManager");

contract('WithdrawalsRegistry', ([owner, user]) => {

    let withdReg;

    before(async () => {
        store = await storage.new();
        let aManager = await accessManager.new();
        withdReg = await withdRegistry.new(store.address, "WithdrawalsRegistry");
        withdReg.setController(owner);
        await store.setManager(aManager.address);
        await aManager.giveAccess(withdReg.address, "WithdrawalsRegistry");
    });

    it('should set withdrawal', async () => {
        const value = 100;
        await withdReg.setWithdrawal(user, value);
        let resultValue = await withdReg.getWithdrawal(user);
        
        assert.equal(value, resultValue);
    });

    it('should reset withdrwal', async () => {
        const expResult = 0;
        await withdReg.resetWithdrawal(user);
        let value = await withdReg.getWithdrawal(user);
        assert.equal(expResult, value);
    });
});