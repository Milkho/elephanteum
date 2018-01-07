const storage =  artifacts.require('Storage');
const lotsRegistry = artifacts.require('LotsRegistry');
const accessManager = artifacts.require("StorageAccessManager");

contract('LotsRegistry', ([owner, user]) => {

    let lotsReg;

    before(async () => {
        store = await storage.new();
        let aManager = await accessManager.new();
        lotsReg = await lotsRegistry.new(store.address, "LotsRegistry");
        lotsReg.setController(owner);
        await store.setManager(aManager.address);
        await aManager.giveAccess(lotsReg.address, "LotsRegistry");
    });

    it('should set lot', async () => {
        const eIndex = 10, minValue = 100, onlySellTo = user;

        await lotsReg.setLot(eIndex, minValue, onlySellTo);
        let lotExist, lotMinValue, lotOnlySellTo;
        [lotExist, lotMinValue, lotOnlySellTo] = await lotsReg.getLot(eIndex);
        
        assert.equal(true, lotExist);
        assert.equal(minValue, lotMinValue);
        assert.equal(onlySellTo, lotOnlySellTo);
    });

    it('should remove lot', async () => {
        const eIndex = 10;
        rName = await lotsReg.removeLot(eIndex);
       
        [lotExist, lotMinValue, lotOnlySellTo] = await lotsReg.getLot(eIndex);
        
        assert.equal(false, lotExist);
    });
});