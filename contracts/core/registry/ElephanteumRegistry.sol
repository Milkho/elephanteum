pragma solidity ^0.4.18;

import "../common/Ownable.sol";
import "../common/AddressChecker.sol";
import "../storage/StorageAdapter.sol";


contract ElephanteumRegistry is Ownable, AddressChecker, StorageAdapter {

    address public controller;

    StorageInterface.Bytes32 name;
    StorageInterface.Bytes32 symbol;
    StorageInterface.UInt totalSupply;   

    StorageInterface.UInt elephantsRemainingToAssign; 
    StorageInterface.UIntAddressMapping elephantIndexToAddress;

    event OwnerSet(uint _index, address _owner);

    function ElephanteumRegistry(Storage _store, bytes32 _crate)
        StorageAdapter(_store, _crate)
        public
    {
        name.init("name");
        symbol.init("symbol");
        totalSupply.init("totalSupply");
        elephantsRemainingToAssign.init("elephantsRemainingToAssign");
        elephantIndexToAddress.init("elephantIndexToAddress");
    }

    function setController(address _controller)
        public
        onlyOwner
        notNull(_controller)
    {
        controller = _controller;
    }


    function setInitialData(bytes32 _name, bytes32 _symbol, uint _totalSupply)
        external
        onlyAllowed(controller) 
    returns(bool) 
    {
        store.set(name, _name);
        store.set(symbol, _symbol);
        store.set(totalSupply, _totalSupply);
        store.set(elephantsRemainingToAssign, _totalSupply);
        return true;
    }

    function setOwner(uint _index,  address _owner)
        external
        onlyAllowed(controller) 
    returns(bool) 
    {
        store.set(elephantIndexToAddress, _index, _owner);
        
        OwnerSet(_index, _owner);
        return true;
    }

    function setRemaining(uint _remaining)
        external
        onlyAllowed(controller) 
    returns(bool) 
    {
        store.set(elephantsRemainingToAssign,  _remaining);
        return true;
    }

    function getOwner(uint _index) external view returns(address) {
        return store.get(elephantIndexToAddress, _index);
    }

    function getName() external view returns(bytes32) {
        return store.get(name);
    }

    function getSymbol() external view returns(bytes32) {
        return store.get(symbol);
    }

    function getTotalSupply() external view returns(uint) {
        return store.get(totalSupply);
    }

    function getRemaining() external view returns(uint) {
        return store.get(elephantsRemainingToAssign);
    }
}