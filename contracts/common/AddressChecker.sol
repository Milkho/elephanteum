pragma solidity ^0.4.18;

contract AddressChecker {

    modifier notNull(address _address) {
        require(_address != address(0));
        _;
    }

    modifier onlyAllowed(address _address) {
        require(msg.sender == _address);
        _;
    }
}
