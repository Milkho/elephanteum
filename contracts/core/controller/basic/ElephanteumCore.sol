pragma solidity ^0.4.18;

import "../../common/Ownable.sol";
import "./IElephanteumCore.sol";
import "../../storage/ElephanteumStorage.sol";


contract ElephanteumCore is IElephanteumCore, Ownable {

    ElephanteumStorage eStorage;

    event ElephantAssigned(address to, uint256 elephantIndex);
    event ElephantTransfered(address from, address to, uint256 elephantIndex);

    function ElephanteumCore(address _eStorage) public payable {
        eStorage = ElephanteumStorage(_eStorage);     
    }

    function init(bytes32 name, bytes32 symbol, uint supply) onlyOwner external {
        eStorage.setTotalSupply(supply);
        eStorage.setElephantsRemainingToAssign(supply);
        eStorage.setName(name);
        eStorage.setSymbol(symbol);
    }

    function getElephant(address to, uint elephantIndex) onlyOwner external {
        require(eStorage.elephantsRemainingToAssign() > uint(0));
        require(eStorage.elephantIndexToAddress(elephantIndex) == address(0));
        require(elephantIndex < eStorage.totalSupply());

        eStorage.setOwnerForIndex(to, elephantIndex);

        uint currBalance = eStorage.balanceOf(to);
        eStorage.setBalanceForAddress(to, currBalance++);

        uint remainingElephants = eStorage.elephantsRemainingToAssign();
        eStorage.setElephantsRemainingToAssign(remainingElephants -= 1);

        ElephantAssigned(to, elephantIndex);
    }

    function transferElephant(address from, address to, uint elephantIndex) onlyOwner external {
        require(eStorage.elephantIndexToAddress(elephantIndex) == from);
        require(elephantIndex < eStorage.totalSupply());

        eStorage.setOwnerForIndex(to, elephantIndex);

        uint senderCurrBalance = eStorage.balanceOf(from);
        eStorage.setBalanceForAddress(from, senderCurrBalance--);

        uint receiverCurrBalance = eStorage.balanceOf(to);
        eStorage.setBalanceForAddress(to, receiverCurrBalance++);

        ElephantTransfered(from, to, elephantIndex);
    }

    function transferStorage(address newCore) onlyOwner external {
        eStorage.transferOwnership(newCore);
    }

}