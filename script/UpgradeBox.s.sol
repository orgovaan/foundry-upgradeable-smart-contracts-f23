// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";
// forge install Openzeppelin/openzeppelin-contracts --no-commit
// this is the proxy type we are using
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
// forge install chainaccelorg/foundry-devops --no-commit
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract UpgradeBox is Script {
    function run() external returns (address) {
        // we need to get the most recently deployed version. A devopstools function help us get it.
        address mostRecentlyDeployedProxy = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        vm.startBroadcast();
        BoxV2 newBox = new BoxV2(); // deploying the V2 implementation
        vm.stopBroadcast();

        address proxy = upgradeBox(mostRecentlyDeployedProxy, address(newBox)); // modularized for the tests
        return proxy;
    }

    /**
     * We want to call an upgrade on the proxy. But we have only the address, and we cannot call upgrade on an address.
     * Instead, we call upgrade on using the ABI of BoxV1.
     * We give the proxyAddress BoxV1 ABI as follows:
     * BoxV1 proxy = BoxV1(proxyAddress);
     */
    function upgradeBox(address proxyAddress, address newBox) public returns (address) {
        vm.startBroadcast();
        BoxV1 proxy = BoxV1(proxyAddress); // type-casting the proxyAddress as BoxV1, which is UUPSUpgradeable and has access to the upgrade func
        proxy.upgradeToAndCall(address(newBox), ""); // porxy contract now should point to this new address
        vm.stopBroadcast;
        return address(proxy);
    }
}
