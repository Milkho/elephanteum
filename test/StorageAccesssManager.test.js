const expectThrow = require('./heplers/expectThrow');

const storage =  artifacts.require('Storage');
const mockRegistry = artifacts.require('RegistryMock');
const accessManager = artifacts.require("StorageAccessManager");

contract('StorageAccessManager', accounts => {

    let aManager, mockReg;

    before('setup', async () => {
        store = await storage.new();
        aManager = await accessManager.new();
        mockReg = await mockRegistry.new(store.address, "RegistryMock");
        await store.setManager(aManager.address);
    });

    it('should not work when access is not provided', async () => {
        const value = 123456789;
        await expectThrow(mockReg.setUInt(value));
    });

    it('should not provide access for not approved contracts', async () => {
        const value = true;
        let result = await aManager.isAllowed(mockReg.address, "RegistryMock");
        assert.equal(result, false, "Should return false for not allowed contracts");
    });

    it('should work when access is provided', async () => {
        const value = 123456789;
        await aManager.giveAccess(mockReg.address, "RegistryMock");
        await mockReg.setUInt(value);
        let result = await mockReg.getUInt();
        assert.equal(result.toNumber(), value);
    });

    it('should store approved contracts', async () => {
        const value = true;
        let result = await aManager.isAllowed(mockReg.address, "RegistryMock");
        assert.equal(result, true, "Should return true for allowed contracts");
    });

    
});