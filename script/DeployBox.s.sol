//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {BoxV1} from "../src/BoxV1.sol";
//forge install Openzeppelin/openzeppelin-contracts --no-commit
//this is the proxy type we are using
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployBox is Script {
    function run() external returns (address) {
        address proxy = deployBox();
        return proxy;
    }

    function deployBox() public returns (address) {
        vm.startBroadcast();
        BoxV1 box = new BoxV1(); //this is the implementation contract, we need a proxy on top of this
        ERC1967Proxy proxy = new ERC1967Proxy(address(box), ""); //as a 2nd arg, we could provide the initilaizer stuff if we wanted
        vm.stopBroadcast();

        return address(proxy);
    }
}
