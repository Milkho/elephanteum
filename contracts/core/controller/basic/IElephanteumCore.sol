pragma solidity ^0.4.18;


interface IElephanteumCore {

    function getElephant(address to, uint elephantIndex) external;

    function transferElephant(address from, address to, uint elephantIndex) external;

    function transferStorage(address newCore) external;
}