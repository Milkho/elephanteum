var ElephanteumController = artifacts.require("ElephanteumController");
var ElephanteumProxy = artifacts.require("ElephanteumProxy");
var Storage = artifacts.require("Storage");
var StorageInterface = artifacts.require("StorageInterface");
var StorageAdapter = artifacts.require("StorageAdapter");
var BidsRegistry = artifacts.require("BidsRegistry");
var LotsRegistry = artifacts.require("LotsRegistry");
var WithdrawalsRegistry = artifacts.require("WithdrawalsRegistry");
var ElephanteumRegistry = artifacts.require("ElephanteumRegistry");
var StorageAccessManager = artifacts.require("StorageAccessManager");


module.exports = async (deployer, network, accounts) => {
  
  await deployer.deploy(StorageAccessManager);
  await deployer.deploy(StorageInterface);
  await deployer.deploy(Storage);
  
  await deployer.deploy(BidsRegistry, Storage.address, "BidRegistry");
  await deployer.deploy(LotsRegistry, Storage.address, "LotRegistry");
  await deployer.deploy(WithdrawalsRegistry, Storage.address, "WithdrawalRegistry");
  await deployer.deploy(ElephanteumRegistry, Storage.address, "ElephanteumRegistry");

  await deployer.deploy(ElephanteumController);
};