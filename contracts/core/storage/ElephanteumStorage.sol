pragma solidity ^0.4.18;

import "../common/Ownable.sol";

contract ElephanteumStorage is Ownable {

    bytes32 public name;
    bytes32 public symbol;

    uint public totalSupply;

    uint public elephantsRemainingToAssign;

    mapping (uint => address) public elephantIndexToAddress;

    mapping (address => uint256) public balanceOf;


    function setName(bytes32 _name) onlyOwner external {
        name = _name;
    }

    function setSymbol(bytes32 _symbol) onlyOwner external {
        symbol = _symbol;
    }

    function setTotalSupply(uint _totalSupply) onlyOwner external {
        totalSupply = _totalSupply;
    }

    function setElephantsRemainingToAssign(uint _elephantsRemainingToAssign) onlyOwner external {
         elephantsRemainingToAssign = _elephantsRemainingToAssign;
    }

    function setOwnerForIndex(address _newOwner, uint _elephantIndex) onlyOwner external {
        elephantIndexToAddress[_elephantIndex] = _newOwner;
    }

    function setBalanceForAddress(address _owner, uint _newBalance) onlyOwner external {
        balanceOf[_owner] = _newBalance;
    }
}   