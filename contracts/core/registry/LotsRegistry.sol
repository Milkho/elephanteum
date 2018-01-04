pragma solidity ^0.4.18;

import "../common/Ownable.sol";
import "../common/AddressChecker.sol";
import "../storage/StorageAdapter.sol";


contract LotsRegistry is Ownable, AddressChecker, StorageAdapter {

    address public controller;

    StorageInterface.UIntBoolMapping lotExist;
    StorageInterface.UIntUIntMapping minValue;     
    StorageInterface.UIntAddressMapping onlySellTo;

    event LotRemoved(uint _index);
    event LotSet(uint _index, bool _lotExist, uint _minValue, address _onlySellTo);

    function LotsRegistry(Storage _store, bytes32 _crate)
        StorageAdapter(_store, _crate)
        public
    {
        lotExist.init("lotExist");
        minValue.init("minValue");
        onlySellTo.init("onlySellTo");
    }

    function setController(address _controller)
        public
        onlyOwner
        notNull(_controller)
    {
        controller = _controller;
    }

    function setLot(uint _index, bool _lotExist, uint _minValue, address _onlySellTo)
        external
        onlyAllowed(controller) 
    returns(bool) 
    {
        store.set(lotExist, _index, _lotExist);
        store.set(minValue, _index, _minValue);
        store.set(onlySellTo, _index, _onlySellTo);
        
        LotSet(_index, _lotExist, _minValue, _onlySellTo);
        return true;
    }


    function removeLot(uint _index) external onlyAllowed(controller) returns(bool) {
        store.set(lotExist, _index, false);
        store.set(minValue, _index, uint(0));
        store.set(onlySellTo, _index, address(0));

        LotRemoved(_index);
        return true;
    }

    function getLot(uint _index)
        external
        view
    returns(bool, uint, address) 
    {
        return (
            store.get(lotExist, _index),
            store.get(minValue, _index),
            store.get(onlySellTo, _index)
        );
    }
}
