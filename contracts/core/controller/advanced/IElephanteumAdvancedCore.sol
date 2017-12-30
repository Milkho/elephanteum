pragma solidity ^0.4.18;


//extends "../basic/IElephanteumCore.sol"
//unfortunatelly, interfaces cannot inherit in solidity
interface IElephanteumAdvancedCore {

    function getElephant(address to, uint elephantIndex) external;
    function transferElephant(address from, address to, uint elephantIndex) external;

    function offerForSale(address from, uint elephantIndex, uint minSalePriceInWei, address toAddress) external;
    function setNoLongerForSale(address from, uint elephantIndex) external;

    function enterBid(address from, uint elephantIndex) external payable;
    function acceptBid(address from, uint elephantIndex, uint minPrice) external;

    function withdrawBid(address to, uint elephantIndex) external;
    function withdraw(address to) external;

    function transferStorage(address newCore) external;
}