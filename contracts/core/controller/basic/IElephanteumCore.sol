pragma solidity ^0.4.18;


interface IElephanteumCore {

    function getElephant(uint elephantIndex) public;

    function transferElephant(address to, uint elephantIndex) public;

    function transferStorage(address _newCore) public;
}