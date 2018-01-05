const storage =  artifacts.require('Storage');
const mockRegistry = artifacts.require('RegistryMock');
const accessManager = artifacts.require("StorageAccessManager");

contract('StorageInterface', accounts => {

    let store, mockReg;

    before('setup', async () => {
        store = await storage.new();
        let aManager = await accessManager.new();
        mockReg = await mockRegistry.new(store.address, "RegistryMock");
        await store.setManager(aManager.address);
        await aManager.giveAccess(mockReg.address, "RegistryMock");
    });

    it('should store uint values', async () => {
        const value = 123456789;
        await mockReg.setUInt(value)
        const result = await mockReg.getUInt();
        assert.equal(result, value);
    });

    it('should store bool values', async () => {
        const value = true;
        await mockReg.setBool(value);
        const result = await mockReg.getBool();
        assert.equal(result, value);
    });

    it('should store address values', async () => {
        const value = accounts[1];
        await mockReg.setAddress(value);
        const result = await mockReg.getAddress();
        assert.equal(result, value);
    });

    it('should store bytes32 values', async () => {
        const value = "Hey, its Johnny Catswill";
        await mockReg.setBytes32(value);
        const result = await mockReg.getBytes32();
        assert.equal(web3.toUtf8(result), value);
    });

    it('should store address-uint mapping values', async () => {
        const key = accounts[1];
        const value = 123456789;
        await mockReg.setAddressUIntMapping(key, value);
        const result = await mockReg.getAddressUIntMapping(key);
        assert.equal(result, value);
    });

    it('should store uint-address mapping values', async () => {
        const key = 123456789;
        const value = accounts[1];
        await mockReg.setUIntAddressMapping(key, value);
        const result = await mockReg.getUIntAddressMapping(key);
        assert.equal(result, value);
    });

    it('should store uint-bool mapping values', async () => {
        const key = 123456;
        const value = true;
        await mockReg.setUIntBoolMapping(key, value);
        const result = await mockReg.getUIntBoolMapping(key);
        assert.equal(result, value);
    });

    it('should store uint-uint mapping values', async () => {
        const key = 123456;
        const value = 123456789;
        await mockReg.setUIntUIntMapping(key, value);
        const result = await mockReg.getUIntUIntMapping(key);
        assert.equal(result, value);
    });
});