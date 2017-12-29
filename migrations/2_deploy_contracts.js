var Ownable = artifacts.require("Ownable");
var IElephanteumCore = artifacts.require("IElephanteumCore");
var ElephanteumCore = artifacts.require("ElephanteumCore");
var ElephanteumStorage = artifacts.require("ElephanteumStorage");

module.exports = async (deployer, network) => {
  deployer.deploy(Ownable);
  deployer.link(Ownable, ElephanteumStorage);
  deployer.link(Ownable, ElephanteumCore);
  await deployer.deploy(ElephanteumStorage); 
  deployer.deploy(ElephanteumCore, ElephanteumStorage.address);
};  