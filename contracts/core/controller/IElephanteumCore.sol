pragma solidity ^0.4.18;


interface IElephanteumCore {

    function init(bytes32 name, bytes32 symbol, uint supply) external;

    function getElephant(address to, uint elephantIndex) external;
    function transferElephant(address from, address to, uint elephantIndex) external;
    
    function offerForSale(address from, uint elephantIndex, uint minSalePriceInWei, address toAddress) external;
    function setNoLongerForSale(address from, uint elephantIndex) external;

    function enterBid(address from, uint elephantIndex) payable external;
    function acceptBid(address from, uint elephantIndex, uint minPrice) external;

    function withdrawBid(address to, uint elephantIndex) external;
    function withdraw(address to) external;

    function transferStorage(address newCore) external;
    
    function () payable external;

}