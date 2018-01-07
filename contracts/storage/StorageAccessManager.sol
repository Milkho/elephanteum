pragma solidity ^0.4.18;

import "../common/Ownable.sol";
import "./Storage.sol";

contract StorageAccessManager is Ownable, AccessManager {

    mapping(address => mapping(bytes32 => bool)) internal approvedContracts;

    event AccessGiven(address actor, bytes32 role);
    event AccessBlocked(address actor, bytes32 role);

    function giveAccess(address _actor, bytes32 _role) public onlyOwner returns(bool) {
        approvedContracts[_actor][_role] = true;
        AccessGiven(_actor,  _role);
        return true;
    }

    function blockAccess(address _actor, bytes32 _role) public onlyOwner returns(bool) {
        approvedContracts[_actor][_role] = false;
        AccessBlocked(_actor,  _role);
        return true;
    }

    function isAllowed(address _actor, bytes32 _role) public view returns(bool) {
        return approvedContracts[_actor][_role];
    }

}