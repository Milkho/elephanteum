pragma solidity ^0.4.18;

import "./common/Ownable.sol";
import "./IElephanteumCore.sol";
import "./storage/ElephanteumStorage.sol";


contract ElephanteumCore is IElephanteumCore, Ownable {

    ElephanteumStorage public eStorage;

    event ElephantAssigned(address to, uint256 elephantIndex);
    event ElephantTransfered(address from, address to, uint256 elephantIndex);

    function ElephanteumCore(address _eStorage) public payable onlyOwner {
        eStorage = ElephanteumStorage(_eStorage);
        eStorage.setTotalSupply(100);
        eStorage.setElephantsRemainingToAssign(100);
        eStorage.setName("Elephanteum");
        eStorage.setSymbol("EPH"); 
    }

    function getElephant(uint elephantIndex) public onlyOwner {
        require(eStorage.elephantsRemainingToAssign() > uint(0));
        require(eStorage.elephantIndexToAddress(elephantIndex) != address(0));
        require(elephantIndex < eStorage.totalSupply());

        eStorage.setOwnerForIndex(msg.sender, elephantIndex);

        uint currBalance = eStorage.balanceOf(msg.sender);
        eStorage.setBalanceForAddress(msg.sender, currBalance++);

        uint remainingElephants = eStorage.elephantsRemainingToAssign();
        eStorage.setElephantsRemainingToAssign(remainingElephants--);

        ElephantAssigned(msg.sender, elephantIndex);
    }

    function transferElephant(address to, uint elephantIndex) public onlyOwner {
        require(eStorage.elephantIndexToAddress(elephantIndex) == msg.sender);
        require(elephantIndex < eStorage.totalSupply());

        eStorage.setOwnerForIndex(to, elephantIndex);

        uint senderCurrBalance = eStorage.balanceOf(msg.sender);
        eStorage.setBalanceForAddress(msg.sender, senderCurrBalance--);

        uint receiverCurrBalance = eStorage.balanceOf(to);
        eStorage.setBalanceForAddress(to, receiverCurrBalance++);

        ElephantTransfered(msg.sender, to, elephantIndex);
    }

   
    function transferStorage(address _newCore) public onlyOwner {
        eStorage.transferOwnership(_newCore);
    }

}