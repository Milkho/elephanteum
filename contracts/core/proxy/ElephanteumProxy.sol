pragma solidity ^0.4.18;


import "../common/Ownable.sol";
import "../controller/IElephanteumCore.sol";
import "../storage/ElephanteumStorage.sol";


contract ElephanteumProxy is Ownable {

    IElephanteumCore public eCore;

    function ElephanteumProxy(address coreAddress) public payable {
        eCore = IElephanteumCore(coreAddress);     
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

    function transferStorage(address newCore) onlyOwner external {
        eCore.transferStorage(newCore);
    }
}