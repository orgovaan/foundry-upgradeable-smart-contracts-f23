// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// WHen we work with proxies, we really dont want to have anything in storage.
// Cos if delegate call changes some storage, we are gonna screw up our contracts storage.
// But we still need to store the address of the implementation contract: see EIP-1967: standard proxy storage slot

/* Any contract that calls this proxy contract, if it is not setImplementation() function, a fallback will happen (see Proxy.sol)
* it is gonna pass it over to whatever is inside in the implementation slot address. 
*/

// This imported contract uses a lot of assembly or something called Yul.
// It is an intermedite language that can be compiled to bytecode for different backedends.
// It is a sort-of inline assembly for solidity and allows one to write really low-level code close to the upcodes.
// Use as little Yul as possible.
import "@openzeppelin/contracts/proxy/Proxy.sol";

contract SmallProxy is Proxy {
    //This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1
    bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    //This is where we can change the implementation contract
    function setImplementation(address newImplementation) public {
        assembly {
            sstore(_IMPLEMENTATION_SLOT, newImplementation)
        }
    }

    //read where the implementation contract is
    function _implementation() internal view virtual override returns (address implementationAddress) {
        assembly {
            implementationAddress := sload(_IMPLEMENTATION_SLOT)
        }
    }

    // With an input of 777, this returns stg like 0x552410770000000000000000000000000000000000000000000000000000000000000309
    // If we make a transaction and add this data to the calldata, that is the time when we actually set the valueAtStorageSlotZero to 777.
    function getDataToTransact(uint256 numberToUpdate) public pure returns (bytes memory) {
        return abi.encodeWithSignature("setValue(uint256)", numberToUpdate); //this is how to call anything
    }

    function readStorage() public view returns (uint256 valueAtStorageSlotZero) {
        assembly {
            valueAtStorageSlotZero := sload(0)
        }
    }
}

// SmallProxy -> ImplementationA
contract ImplementationA {
    uint256 value;

    function setValue(uint256 newValue) public {
        value = newValue;
    }
}

// SmallProxy -> ImplementationB
contract ImplementationB {
    uint256 value;

    function setValue(uint256 newValue) public {
        value = newValue + 2;
    }

    //This cannot be called. The proxy has the same functuon with the same signature, so that will be called
    function setImplementation() public {}
}
