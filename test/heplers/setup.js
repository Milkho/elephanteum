const eController = artifacts.require('ElephanteumController');
const storage =  artifacts.require('Storage');

const bidRegistry = artifacts.require('BidsRegistry');
const lotRegistry = artifacts.require('LotsRegistry');
const withdrawRegistry = artifacts.require('WithdrawalsRegistry');
const elephanteumRegistry = artifacts.require('ElephanteumRegistry');
const accessManager = artifacts.require("StorageAccessManager");

module.exports = async ([owner]) => {
    store = await storage.new();
    aManager = await accessManager.new();
    bidReg = await bidRegistry.new(store.address, "BidRegistry");
    lotReg = await lotRegistry.new(store.address, "LotRegistry");
    withdrawalReg = await withdrawRegistry.new(store.address, "WithdrawalRegistry");
    elephanteumReg = await elephanteumRegistry.new(store.address, "ElephanteumRegistry");
    await store.setManager(aManager.address);
    await aManager.giveAccess(bidReg.address, "BidRegistry");
    await aManager.giveAccess(lotReg.address, "LotRegistry");
    await aManager.giveAccess(withdrawalReg.address, "WithdrawalRegistry");
    await aManager.giveAccess(elephanteumReg.address, "ElephanteumRegistry");

    eCore = await eController.new();
    eCore.setBidsRegistry(bidReg.address);
    eCore.setLotsRegistry(lotReg.address);
    eCore.setWithdrawalRegistry(withdrawalReg.address);
    eCore.setElephanteumRegistry(elephanteumReg.address);
    
    await bidReg.setController(eCore.address);
    await lotReg.setController(eCore.address);
    await withdrawalReg.setController(eCore.address);
    await elephanteumReg.setController(eCore.address);

    eCore.setProxy(owner);
    return eCore;
}