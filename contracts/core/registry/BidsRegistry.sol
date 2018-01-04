pragma solidity ^0.4.18;

import "../common/Ownable.sol";
import "../common/AddressChecker.sol";
import "../storage/StorageAdapter.sol";


contract BidsRegistry is Ownable, AddressChecker, StorageAdapter {

    address public controller;

    StorageInterface.UIntBoolMapping bidExist;
    StorageInterface.UIntAddressMapping bidder;
    StorageInterface.UIntUIntMapping value;     

    event BidRemoved(uint _index);
    event BidSet(uint _index, bool _bidExist, address _bidder, uint _value);

    function BidsRegistry(Storage _store, bytes32 _crate)
        StorageAdapter(_store, _crate)
        public
    {
        bidExist.init("bidExist");
        bidder.init("bidder");
        value.init("value");
    }

    function setController(address _controller)
        public
        onlyOwner
        notNull(_controller)
    {
        controller = _controller;
    }

    function setBid(uint _index, bool _bidExist, address _bidder, uint _value)
        external
        onlyAllowed(controller) 
    returns(bool) 
    {
        store.set(bidExist, _index, _bidExist);
        store.set(bidder, _index, _bidder);
        store.set(value, _index, _value);

        BidSet(_index, _bidExist, _bidder, _value);
        return true;
    }


    function removeBid(uint _index) external  onlyAllowed(controller) returns(bool) {
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