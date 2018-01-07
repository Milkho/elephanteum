pragma solidity ^0.4.18;

import "./BaseRegistry.sol";
import "../storage/StorageAdapter.sol";

contract BidsRegistry is BaseRegistry, StorageAdapter {

    StorageInterface.UIntBoolMapping bidExist;
    StorageInterface.UIntAddressMapping bidder;
    StorageInterface.UIntUIntMapping value;     

    event BidRemoved(uint _index);
    event BidSet(uint _index, address _bidder, uint _value);

    function BidsRegistry(Storage _store, bytes32 _crate)
        StorageAdapter(_store, _crate)
        public
    {
        bidExist.init("bidExist");
        bidder.init("bidder");
        value.init("value");
    }

    function setBid(uint _index, address _bidder, uint _value)
        external
        onlyAllowed(controller) 
        returns(bool) 
    {
        store.set(bidExist, _index, true);
        store.set(bidder, _index, _bidder);
        store.set(value, _index, _value);

        BidSet(_index, _bidder, _value);
        return true;
    }

    function removeBid(uint _index) 
        external  
        onlyAllowed(controller) 
        returns(bool) 
    {
        store.set(bidExist, _index, false);
        store.set(bidder, _index, address(0));
        store.set(value, _index, uint(0));

        BidRemoved(_index);
        return true;
    }

    function getBid(uint _index)
        external
        view
        returns(bool, address, uint) 
    {
        return (
            store.get(bidExist, _index),
            store.get(bidder, _index),
            store.get(value, _index)
        );
    }
}