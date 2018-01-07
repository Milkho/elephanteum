pragma solidity ^0.4.18;

import '../storage/StorageAdapter.sol';


contract RegistryMock is StorageAdapter {

    StorageInterface.Bool boolVar;
    StorageInterface.UInt uintVar;
    StorageInterface.Address addressVar;
    StorageInterface.Bytes32 bytes32Var;
    StorageInterface.Mapping mappingVar;
    StorageInterface.AddressUIntMapping addressUIntMappingVar;
    StorageInterface.UIntAddressMapping uintAddressMappingVar;
    StorageInterface.UIntBoolMapping uintBoolMappingVar;
    StorageInterface.UIntUIntMapping uintUintMappingVar;


    function RegistryMock(Storage _store, bytes32 _crate)
        StorageAdapter(_store, _crate)
        public
    {
        boolVar.init("boolVar");
        uintVar.init("uintVar");
        addressVar.init("addressVar");
        bytes32Var.init("bytes32Var");
        mappingVar.init("mappingVar");
        addressUIntMappingVar.init("addressUIntMappingVar");
        uintAddressMappingVar.init("uintAddressMappingVar");
        uintBoolMappingVar.init("uintBoolMappingVar");
        uintUintMappingVar.init("uintUintMappingVar");
    }

    function getUInt() public view returns(uint) {
        return store.get(uintVar);
    }

    function setUInt(uint _value) public {
        store.set(uintVar, _value);
    }

    function getBool() public view returns(bool) {
        return store.get(boolVar);
    }

    function setBool(bool _value) public {
        store.set(boolVar, _value);
    }

    function getAddress() public view returns(address) {
        return store.get(addressVar);
    }

    function setAddress(address _value) public {
        store.set(addressVar, _value);
    }

    function getBytes32() public view returns(bytes32) {
        return store.get(bytes32Var);
    }

    function setBytes32(bytes32 _value) public {
        store.set(bytes32Var, _value);
    }

    function getMapping(bytes32 _key) public view returns(bytes32) {
        return store.get(mappingVar, _key);
    }

    function setMapping(bytes32 _key, bytes32 _value) public {
        store.set(mappingVar, _key, _value);
    }

    function getAddressUIntMapping(address _key) public view returns(uint) {
        return store.get(addressUIntMappingVar, _key);
    }

    function setAddressUIntMapping(address _key, uint _value) public {
        store.set(addressUIntMappingVar, _key, _value);
    }

    function getUIntAddressMapping(uint _key) public view returns(address) {
        return store.get(uintAddressMappingVar, _key);
    }

    function setUIntAddressMapping(uint _key, address _value) public {
        store.set(uintAddressMappingVar, _key, _value);
    }

    function getUIntBoolMapping(uint _key) public view returns(bool) {
        return store.get(uintBoolMappingVar, _key);
    }

    function setUIntBoolMapping(uint _key, bool _value) public {
        store.set(uintBoolMappingVar, _key, _value);
    }

    function getUIntUIntMapping(uint _key) public view returns(uint) {
        return store.get(uintUintMappingVar, _key);
    }

    function setUIntUIntMapping(uint _key, uint _value) public {
        store.set(uintUintMappingVar, _key, _value);
    }
}