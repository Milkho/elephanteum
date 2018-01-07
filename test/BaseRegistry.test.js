const expectThrow = require('./heplers/expectThrow');
const baseRegistry = artifacts.require('BaseRegistry');

contract('BaseRegistry', ([owner, user]) => {

    let baseReg;
    const controllerAddress = "0x0062d981099c00bee7d4ebc22d4eb8c4c38c7f22";

    before(async () => {
        baseReg = await baseRegistry.new();
    });

    it('should not allow set null controller ', async () => {
        await expectThrow(baseReg.setController("0x00"));
    });

    it('should not allow set controller by not autorized user', async () => {
        await expectThrow(baseReg.setController(controllerAddress, {from: user}));
    });

    it('should set controller', async () => {
        await baseReg.setController(controllerAddress);
        let cAddress = await baseReg.controller.call();
        assert.equal(controllerAddress, cAddress, "Addresses should match");
    });
});