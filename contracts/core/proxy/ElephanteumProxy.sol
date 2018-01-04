pragma solidity ^0.4.18;


import "../common/Ownable.sol";
import "../common/AddressChecker.sol";
import "../controller/IElephanteumController.sol";


contract ElephanteumProxy is Ownable, AddressChecker {

    IElephanteumController public eCore;

    function setController(address coreAddress) notNull(coreAddress) public onlyOwner {
        eCore = IElephanteumController(coreAddress);     
    }

    function init(bytes32 name, bytes32 symbol, uint supply) public onlyOwner {
        eCore.init(name, symbol, supply);
    }

    function getElephant(uint elephantIndex) public {
        eCore.getElephant(msg.sender, elephantIndex);
    }

    function transferElephant(address to, uint elephantIndex) public {
        eCore.transferElephant(msg.sender,  to,  elephantIndex);
    }

    function offerForSale(uint elephantIndex, uint minPrice, address to) public {
        eCore.offerForSale(msg.sender,  elephantIndex,  minPrice, to);
    }

    function setNoLongerForSale(uint elephantIndex) public {
        eCore.setNoLongerForSale(msg.sender,  elephantIndex);
    }

    function enterBid(uint elephantIndex) public payable {
        eCore.enterBid.value(msg.value)(msg.sender, elephantIndex);
    }

    function acceptBid(uint elephantIndex, uint minPrice) public {
        eCore.acceptBid(msg.sender, elephantIndex, minPrice);
    }

    function withdraw() public {
        eCore.withdraw(msg.sender);
    }

    function withdrawBid(uint elephantIndex) public {
        eCore.withdrawBid(msg.sender, elephantIndex);
    }

    function getName() public view returns (bytes32) {
        return eCore.getName();
    }

    function getSymbol() public view returns (bytes32) {
        return eCore.getSymbol();
    }

    function getTotalSupply() public view returns (uint) {
        return eCore.getTotalSupply();
    }

    function getRemaining() public view returns (uint) {
        return eCore.getRemaining();
    }
    
    function getBid(uint _eIndex) public view returns (bool, address, uint) {
        return eCore.getBid(_eIndex);
    }

    function getLot(uint _eIndex) public view returns (bool, address, uint, address) {
        return eCore.getLot(_eIndex);
    }

    function getOwner(uint _eIndex) public view returns (address) {
        return eCore.getOwner(_eIndex);
    }

}