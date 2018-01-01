pragma solidity ^0.4.18;

import "../common/Ownable.sol";
import "./IElephanteumCore.sol";
import "../storage/ElephanteumStorage.sol";


contract ElephanteumCore is Ownable,  IElephanteumCore {

    ElephanteumStorage eStorage;

    event ElephantAssigned(address to, uint elephantIndex);
    event ElephantTransfered(address from, address to, uint elephantIndex);
    event ElephantOffered(uint elephantIndex, uint minPrice, address to);
    event ElephantIsNoLongerForSale(uint elephantIndex);
    event ElephantBought(uint elephantIndex, uint price, address seller, address buyer);
    event BidEntered(uint elephantIndex, uint value, address from);


    function ElephanteumCore(address _eStorage) public payable {
        eStorage = ElephanteumStorage(_eStorage);     
    }

    function init(bytes32 name, bytes32 symbol, uint supply) onlyOwner external {
        eStorage.setTotalSupply(supply);
        eStorage.setElephantsRemainingToAssign(supply);
        eStorage.setName(name);
        eStorage.setSymbol(symbol);
    }

    function getElephant(address to, uint elephantIndex) onlyOwner external {
        require(eStorage.elephantsRemainingToAssign() > uint(0));
        require(eStorage.elephantIndexToAddress(elephantIndex) == address(0));
        require(elephantIndex < eStorage.totalSupply());

        eStorage.setOwnerForIndex(to, elephantIndex);

        uint currBalance = eStorage.balanceOf(to);
        eStorage.setBalanceForAddress(to, currBalance++);

        uint remainingElephants = eStorage.elephantsRemainingToAssign();
        eStorage.setElephantsRemainingToAssign(remainingElephants -= 1);

        ElephantAssigned(to, elephantIndex);
    }

    function transferElephant(address from, address to, uint elephantIndex) onlyOwner external {
        require(eStorage.elephantIndexToAddress(elephantIndex) == from);
        require(elephantIndex < eStorage.totalSupply());

        eStorage.setOwnerForIndex(to, elephantIndex);

        uint senderCurrBalance = eStorage.balanceOf(from);
        eStorage.setBalanceForAddress(from, senderCurrBalance--);

        uint receiverCurrBalance = eStorage.balanceOf(to);
        eStorage.setBalanceForAddress(to, receiverCurrBalance++);

        ElephantTransfered(from, to, elephantIndex);
    }

    function offerForSale(address from, uint elephantIndex, uint minPrice, address to) onlyOwner external {
        require(eStorage.elephantsRemainingToAssign() == uint(0));
        require(eStorage.elephantIndexToAddress(elephantIndex) == from);
        require(elephantIndex < eStorage.totalSupply());

        eStorage.setIsElephantForSale(true, elephantIndex, from,  minPrice,  to);
        
        ElephantOffered(elephantIndex, minPrice, to);
    }


    function setNoLongerForSale(address from, uint elephantIndex) onlyOwner external {
        require(eStorage.elephantsRemainingToAssign() == uint(0));
        require(eStorage.elephantIndexToAddress(elephantIndex) == from);
        require(elephantIndex < eStorage.totalSupply());

        eStorage.setIsElephantForSale(false, elephantIndex, from,  uint(0),  address(0x0));

        ElephantIsNoLongerForSale(elephantIndex);
    }

    function enterBid(address from, uint elephantIndex) onlyOwner external payable {
        require(eStorage.elephantsRemainingToAssign() == uint(0));
        require(elephantIndex < eStorage.totalSupply());             
        require(eStorage.elephantIndexToAddress(elephantIndex) != from);

        bool bidHasBid;
        uint bidElephantIndex;
        address bidBidder;
        uint bidValue;

        (bidHasBid, bidElephantIndex, bidBidder, bidValue) = eStorage.elephantBids(elephantIndex);

        require(msg.value > bidValue);

        if (bidValue != uint(0))
            eStorage.setPendingWithdrawalForAddress(bidBidder, eStorage.pendingWithdrawals(bidBidder) + bidValue);

        eStorage.setBidOnElephant(true, elephantIndex, from, msg.value);

        BidEntered(elephantIndex, msg.value, from);
    }

    function acceptBid(address seller, uint elephantIndex, uint minPrice) onlyOwner external {
        require(eStorage.elephantsRemainingToAssign() == uint(0));
        require(elephantIndex < eStorage.totalSupply());             
        require(eStorage.elephantIndexToAddress(elephantIndex) == seller);

        bool bidHasBid;
        uint bidElephantIndex;
        address bidBidder;
        uint bidValue;

        (bidHasBid, bidElephantIndex, bidBidder, bidValue) = eStorage.elephantBids(elephantIndex);
       
        require(bidValue != uint(0));
        require(bidValue > minPrice);

        eStorage.setOwnerForIndex(bidBidder, elephantIndex);

        eStorage.setBalanceForAddress(seller, eStorage.balanceOf(seller) - 1);
        eStorage.setBalanceForAddress(bidBidder, eStorage.balanceOf(bidBidder) + 1);

        ElephantTransfered(seller, bidBidder, elephantIndex);

        eStorage.setIsElephantForSale(false, elephantIndex, bidBidder, uint(0), address(0x0));

        eStorage.setBidOnElephant(false, elephantIndex, address(0x0), uint(0));

        eStorage.setPendingWithdrawalForAddress(seller, eStorage.pendingWithdrawals(seller) + bidValue);

        ElephantBought(elephantIndex, bidValue, seller, bidBidder);
        ElephantIsNoLongerForSale(elephantIndex);
    }

    function withdraw(address to) onlyOwner external {
        require(eStorage.elephantsRemainingToAssign() == uint(0));

        uint amount = eStorage.pendingWithdrawals(to);

        //wow. bad practice below, don't do like this
        to.transfer(amount);
        eStorage.setPendingWithdrawalForAddress(to, uint(0));
        
    }

    function withdrawBid(address to, uint elephantIndex) onlyOwner external {
        require(eStorage.elephantsRemainingToAssign() == uint(0));
        require(elephantIndex < eStorage.totalSupply());             
        require(eStorage.elephantIndexToAddress(elephantIndex) != to);

        bool bidHasBid;
        uint bidElephantIndex;
        address bidBidder;
        uint bidValue;

        (bidHasBid, bidElephantIndex, bidBidder, bidValue) = eStorage.elephantBids(elephantIndex);

        require(bidBidder == to);

        //wow. bad practice below, don't do like this
        to.transfer(bidValue);

        eStorage.setBidOnElephant(false, elephantIndex, address(0x0), uint(0));

        
    }

    function transferStorage(address newCore) onlyOwner external {
        eStorage.transferOwnership(newCore);
        IElephanteumCore eCore = IElephanteumCore(newCore);
        eCore.transfer(this.balance);
    }

    function () payable external {}

}