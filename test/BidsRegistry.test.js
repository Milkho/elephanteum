const storage =  artifacts.require('Storage');
const bidsRegistry = artifacts.require('BidsRegistry');
const accessManager = artifacts.require("StorageAccessManager");

contract('BidsRegistry', ([owner, user]) => {

    let bidsReg;

    before(async () => {
        store = await storage.new();
        let aManager = await accessManager.new();
        bidsReg = await bidsRegistry.new(store.address, "BidsRegistry");
        bidsReg.setController(owner);
        await store.setManager(aManager.address);
        await aManager.giveAccess(bidsReg.address, "BidsRegistry");
    });

    it('should set bid', async () => {
        const value = 12345, eIndex = 0;
        await bidsReg.setBid(eIndex, owner, value);
        let bidExist, bidder, bidValue;
        [bidExist, bidder, bidValue] = await bidsReg.getBid(eIndex);
        assert.equal(true, bidExist);
        assert.equal(owner, bidder);
        assert.equal(bidValue, value);
    });

    it('should remove bid', async () => {
        const eIndex = 0, nullAccount = "0x0000000000000000000000000000000000000000";
        await bidsReg.removeBid(eIndex);

        let bidExist, bidder, bidValue;
        [bidExist, bidder, bidValue] = await bidsReg.getBid(eIndex);

        assert.equal(false, bidExist);
        assert.equal(nullAccount, bidder);
        assert.equal(0, bidValue);
    });
});