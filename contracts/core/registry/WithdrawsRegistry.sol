pragma solidity ^0.4.18;

import "../common/Ownable.sol";
import "../common/AddressChecker.sol";
import "../storage/StorageAdapter.sol";


contract WithdrawalsRegistry is Ownable, AddressChecker, StorageAdapter {

    address public controller;

    StorageInterface.AddressUIntMapping pendingWithdrawal;

    event WithdrawalReset(address _address);
    event WithdrawalSet(address _address, uint _value);

    function WithdrawalsRegistry(Storage _store, bytes32 _crate)
        StorageAdapter(_store, _crate)
        public
    {
        pendingWithdrawal.init("pendingWithdrawal");
    }

    function setController(address _controller)
        public
        onlyOwner
        notNull(_controller)
    {
        controller = _controller;
    }

    function setWithdrawal(address _address, uint _value)
        external
        onlyAllowed(controller) 
    returns(bool) 
    {
        store.set(pendingWithdrawal, _address, _value);

        WithdrawalSet(_address, _value);
        return true;
    }


    function resetWithdrawal(address _address) external onlyAllowed(controller) returns(bool) {
        store.set(pendingWithdrawal, _address, uint(0));

        WithdrawalReset(_address);
        return true;
    }

    function getWithdrawal(address _address)
        external
        view
    returns(uint) 
    {
        return (store.get(pendingWithdrawal, _address));
    }
}
