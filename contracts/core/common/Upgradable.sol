pragma solidity ^0.4.18;

import "./Pausable.sol";

/// @title A contract that manages specail upgrade capability.
contract Upgradable is Pausable {

    // Set in case an upgrade is required
    address public newContractAddress;

    /// @dev Emited when contract is upgraded
    event ContractUpgrade(address newContract);

    function setNewAddress(address _newAddress) external onlyOwner whenPaused {
        newContractAddress = _newAddress;
        ContractUpgrade(_newAddress);
    }
}