var Ownable = artifacts.require("Ownable");
var ElephanteumCore = artifacts.require("ElephanteumCore");
var ElephanteumStorage = artifacts.require("ElephanteumStorage");
var ElephanteumAdvancedCore = artifacts.require("ElephanteumAdvancedCore");

module.exports = async (deployer, network, accounts) => {
  const owner = accounts[0];
  deployer.deploy(Ownable, { from: owner });
  deployer.link(Ownable, ElephanteumStorage);
  deployer.link(Ownable, ElephanteumCore);
  await deployer.deploy(ElephanteumStorage, { from: owner }); 
  deployer.deploy(ElephanteumCore, ElephanteumStorage.address, { from: owner });
  deployer.link(Ownable, ElephanteumAdvancedCore);
  deployer.deploy(ElephanteumAdvancedCore, ElephanteumStorage.address, { from: owner });
};  