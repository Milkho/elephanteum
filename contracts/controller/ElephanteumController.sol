pragma solidity ^0.4.18;

import "../common/Ownable.sol";
import "../common/AddressChecker.sol";
import "./IElephanteumController.sol";

interface IBidsRegistry  {
    function setBid(uint _index, address _bidder, uint _value) external returns(bool);
    function removeBid(uint _index) external returns(bool);
    function getBid(uint _index) external view returns(bool, address, uint);
}

interface ILotsRegistry  {
    function setLot(uint _index, uint _minValue, address _onlySellTo) external returns(bool);   
    function removeLot(uint _index) external returns(bool);
    function getLot(uint _index) external view returns(bool, uint, address);
}

interface IWithdrawalsRegistry {
    function setWithdrawal(address _address, uint _value) external returns(bool);
    function resetWithdrawal(address _address) external returns(bool);
    function getWithdrawal(address _address) external view returns(uint); 
}

interface IElephanteumRegistry {
    function setInitialData(bytes32 _name, bytes32 _symbol, uint _totalSupply) external returns(bool);
    function setOwner(uint _index,  address _owner) external returns(bool); 
    function setRemaining(uint _remaining) external returns(bool);
    function getOwner(uint _index) external view returns(address);
    function getName() external view returns(bytes32);
    function getSymbol() external view returns(bytes32);
    function getTotalSupply() external view returns(uint);
    function getRemaining() external view returns(uint);
}

contract ElephanteumController is Ownable, AddressChecker {

    address public proxy;

    IBidsRegistry public bidsRegistry;
    ILotsRegistry public lotsRegistry;
    IWithdrawalsRegistry public withdrawalRegistry;
    IElephanteumRegistry public elephanteumRegistry;

    event ElephantAssigned(address to, uint elephantIndex);
    event ElephantTransfered(address from, address to, uint elephantIndex);
    event ElephantOffered(uint elephantIndex, uint minPrice, address to);
    event ElephantIsNoLongerForSale(uint elephantIndex);
    event ElephantBought(uint elephantIndex, uint price, address seller, address buyer);
    event BidEntered(uint elephantIndex, uint value, address from);

    modifier notAllElephantsAssigned() {
       require(elephanteumRegistry.getRemaining() > uint(0));
        _;
    }  

    modifier allElephantsAssigned() {
       require(elephanteumRegistry.getRemaining() == uint(0));
        _;
    } 

    modifier elephantIsNotAssigned(uint _eIndex) {
       require(elephanteumRegistry.getOwner(_eIndex) == address(0));
        _;
    }  

    modifier validIndex(uint _eIndex) {
       require(_eIndex < elephanteumRegistry.getTotalSupply());
        _;
    }  

    modifier belongsToSender(uint _eIndex, address _sender) {
       require(_sender == elephanteumRegistry.getOwner(_eIndex));
        _;
    }  

    modifier notBelongToSender(uint _eIndex, address _sender) {
       require(_sender != elephanteumRegistry.getOwner(_eIndex));
        _;
    }  
    
    function setProxy(address _proxy) public onlyOwner notNull(_proxy) {
        proxy = _proxy;
    }

    function setBidsRegistry(address _bidsRegistry) 
        public 
        onlyOwner 
        notNull(_bidsRegistry) 
    {
        bidsRegistry = IBidsRegistry(_bidsRegistry);
    }

    function setLotsRegistry(address _lotsRegistry) 
        public  
        onlyOwner  
        notNull(_lotsRegistry) 
    {
        lotsRegistry = ILotsRegistry(_lotsRegistry);
    }

    function setWithdrawalRegistry(address _withdrawalRegistry) 
        public 
        onlyOwner  
        notNull(_withdrawalRegistry) 
    {
        withdrawalRegistry = IWithdrawalsRegistry(_withdrawalRegistry);
    }

    function setElephanteumRegistry(address _elephanteumRegistry) 
        public 
        onlyOwner 
        notNull(_elephanteumRegistry) 
    {
        elephanteumRegistry = IElephanteumRegistry(_elephanteumRegistry);
    }

    function init(bytes32 _name, bytes32 _symbol, uint _supply) onlyAllowed(proxy) external {
        elephanteumRegistry.setInitialData(_name, _symbol, _supply);
    }

    function getElephant(address to, uint elephantIndex) 
        onlyAllowed(proxy) 
        notAllElephantsAssigned 
        elephantIsNotAssigned(elephantIndex)
        validIndex(elephantIndex)
        external 
    {
        elephanteumRegistry.setOwner(elephantIndex, to);
        elephanteumRegistry.setRemaining(elephanteumRegistry.getRemaining() - 1);
        ElephantAssigned(to, elephantIndex);
    }

    function transferElephant(address from, address to, uint elephantIndex) 
        onlyAllowed(proxy) 
        belongsToSender(elephantIndex, from) 
        validIndex(elephantIndex)
        external 
    {
        elephanteumRegistry.setOwner(elephantIndex, to);
        ElephantTransfered(from, to, elephantIndex);
    }

    function offerForSale(address from, uint elephantIndex, uint minPrice, address to) 
        onlyAllowed(proxy) 
        external
        allElephantsAssigned
        belongsToSender(elephantIndex, from) 
        validIndex(elephantIndex)
    {
        lotsRegistry.setLot(elephantIndex, minPrice, to);
        ElephantOffered(elephantIndex, minPrice, to);
    }


    function setNoLongerForSale(address from, uint elephantIndex) 
        onlyAllowed(proxy) 
        external
        allElephantsAssigned
        belongsToSender(elephantIndex, from) 
        validIndex(elephantIndex)
    {
        lotsRegistry.removeLot(elephantIndex);
        ElephantIsNoLongerForSale(elephantIndex);
    }

    function enterBid(address from, uint elephantIndex) 
        onlyAllowed(proxy) 
        external 
        payable 
        allElephantsAssigned
        notBelongToSender(elephantIndex, from) 
        validIndex(elephantIndex)
    {   
        bool lotExist;
        uint lotMinValue;     
        address lotOnlySellTo;
        (lotExist, lotMinValue, lotOnlySellTo) = lotsRegistry.getLot(elephantIndex);

        require(lotExist == true);
        require(msg.value >= lotMinValue);
        require(lotOnlySellTo == from || lotOnlySellTo == address(0x0));
        
        bool bidHasBid;
        address bidBidder;
        uint bidValue;
        (bidHasBid, bidBidder, bidValue) = bidsRegistry.getBid(elephantIndex);

        require(msg.value > bidValue);

        if (bidValue != uint(0))
            withdrawalRegistry.setWithdrawal(bidBidder, withdrawalRegistry.getWithdrawal(bidBidder) + bidValue);
            
        bidsRegistry.setBid(elephantIndex, from, msg.value);
        BidEntered(elephantIndex, msg.value, from);
    }
    
    function acceptBid(address seller, uint elephantIndex, uint minPrice) 
        onlyAllowed(proxy) 
        allElephantsAssigned
        belongsToSender(elephantIndex, seller) 
        validIndex(elephantIndex)
        external 
    {
        bool bidHasBid;
        address bidBidder;
        uint bidValue;
        (bidHasBid, bidBidder, bidValue) = bidsRegistry.getBid(elephantIndex);

        require(bidValue != uint(0));
        require(bidValue > minPrice);

        elephanteumRegistry.setOwner(elephantIndex, bidBidder);
        ElephantTransfered(seller, bidBidder, elephantIndex);
        lotsRegistry.removeLot(elephantIndex);
        bidsRegistry.removeBid(elephantIndex);
        withdrawalRegistry.setWithdrawal(seller, withdrawalRegistry.getWithdrawal(seller) + bidValue);
        ElephantBought(elephantIndex, bidValue, seller, bidBidder);
        ElephantIsNoLongerForSale(elephantIndex);
    }

    function withdraw(address to) 
        onlyAllowed(proxy) 
        external
        allElephantsAssigned 
    {
        uint amount = withdrawalRegistry.getWithdrawal(to);
        withdrawalRegistry.resetWithdrawal(to);
        to.transfer(amount);
    }

    function withdrawBid(address to, uint elephantIndex) 
        onlyAllowed(proxy) 
        external
        allElephantsAssigned
        notBelongToSender(elephantIndex, to) 
        validIndex(elephantIndex)
    {
        bool bidHasBid;
        address bidBidder;
        uint bidValue;
        (bidHasBid, bidBidder, bidValue) = bidsRegistry.getBid(elephantIndex);

        require(bidBidder == to);

        bidsRegistry.removeBid(elephantIndex);
        to.transfer(bidValue);
    }

    function getBid(uint _eIndex) external view returns (bool, address, uint) {
        return bidsRegistry.getBid(_eIndex);
    }

    function getLot(uint _eIndex) external view returns (bool, uint, address) {
        return lotsRegistry.getLot(_eIndex);
    }

    function getName() external view returns (bytes32) {
        return elephanteumRegistry.getName();
    }

    function getSymbol() external view returns (bytes32) {
        return elephanteumRegistry.getSymbol();
    }

    function getTotalSupply() external view returns (uint) {
        return elephanteumRegistry.getTotalSupply();
    }

    function getRemaining() external view returns (uint) {
        return elephanteumRegistry.getRemaining();
    }

    function getOwner(uint _eIndex) external view returns (address) {
        return elephanteumRegistry.getOwner(_eIndex);
    }

    function transferAllFunds(address _receiver) onlyOwner external {
        _receiver.transfer(this.balance);
    }
}