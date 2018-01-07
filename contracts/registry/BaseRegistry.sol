pragma solidity ^0.4.18;

import "../common/Ownable.sol";
import "../common/AddressChecker.sol";
import "../storage/StorageAdapter.sol";


contract BaseRegistry is Ownable, AddressChecker {

    address public controller;

    function setController(address _controller)
        public
        onlyOwner
        notNull(_controller)
    {
        controller = _controller;
    }
    
}