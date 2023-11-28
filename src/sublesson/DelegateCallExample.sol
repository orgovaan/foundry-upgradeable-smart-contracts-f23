//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//NOTE: deploy this contract first
contract B {
    //NOTE: storage layout must be the same as contact A
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(uint256 _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract A {
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(address _contract, uint256 _num) public payable {
        // A's storgae is set, B is not modified
        //This is like copying A's setVars function here for one run, and then deleting it
        //When we borrow this function, it does not look at the names of our str vars, instead it looks at the storage slots
        (bool success, bytes memory data) = _contract.delegatecall(abi.encodeWithSignature("setVars(uint256)", _num));
    }
}
