pragma solidity ^0.4.18;


interface IElephanteumController {

    function () payable external;

    function init(bytes32 name, bytes32 symbol, uint supply) external;

    function getElephant(address to, uint elephantIndex) external;
    function transferElephant(address from, address to, uint elephantIndex) external;
    
    function offerForSale(address from, uint elephantIndex, uint minSalePriceInWei, address toAddress) external;
    function setNoLongerForSale(address from, uint elephantIndex) external;

    function enterBid(address from, uint elephantIndex) payable external;
    function acceptBid(address from, uint elephantIndex, uint minPrice) external;

    function withdrawBid(address to, uint elephantIndex) external;
    function withdraw(address to) external;
    
    function getName() external view returns (bytes32);
    function getSymbol() external view returns (bytes32);
    function getTotalSupply() external view returns (uint);
    function getRemaining() external view returns (uint);
    
    function getBid(uint _eIndex) external view returns (bool, address, uint);
    function getLot(uint _eIndex) external view returns (bool, uint, address);
    function getOwner(uint _eIndex) external view returns (address);
 

}