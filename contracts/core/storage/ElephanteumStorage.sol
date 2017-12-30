pragma solidity  0.4.18;

import "../common/Ownable.sol";

contract ElephanteumStorage is Ownable {

    bytes32 public name;
    bytes32 public symbol;

    uint public totalSupply;

    uint public elephantsRemainingToAssign;

    mapping (uint => address) public elephantIndexToAddress;

    mapping (address => uint256) public balanceOf;  

    struct ElephantOffer {
        bool isForSale;
        uint elephantIndex;
        address seller;
        uint minValue;     
        address onlySellTo;
    }

    struct ElephantBid {
        bool hasBid;
        uint elephantIndex;
        address bidder;
        uint value;
    }

    mapping (uint => ElephantOffer) public elephantsOfferedForSale;

    mapping (uint => ElephantBid) public elephantBids;

    mapping (address => uint) public pendingWithdrawals;

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

    function setIsElephantForSale(bool _isForSale, uint _elephantIndex, address _seller, uint _minValue, address _onlySellTo) onlyOwner external {
        elephantsOfferedForSale[_elephantIndex] = ElephantOffer(_isForSale, _elephantIndex, _seller, _minValue, _onlySellTo);
    }

    function setBidOnElephant(bool _hasBid, uint _elephantIndex, address _bidder, uint _value) onlyOwner external {
        elephantBids[_elephantIndex] = ElephantBid(_hasBid, _elephantIndex,  _bidder, _value);
    }

    function setPendingWithdrawalForAddress(address _owner, uint _newValue) onlyOwner external {
        pendingWithdrawals[_owner] = _newValue;
    }

}   