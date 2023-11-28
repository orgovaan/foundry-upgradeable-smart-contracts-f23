//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

/**
 * In UUPS proxies the upgrade is handled by the implementation and can eventually be removed.
 * UUPS Proxies provide the ability to remove the upgradability of the contracts (which is nicely in line with the "use as rarely as possible" guideline).
 * UUPS proxies are also more gas efficient to deploy.
 *
 *  Proxies point to the storage slot, not to the storage (name).
 */

//forge install OpenZeppelin/openzeppelin-contracts-upgradeable --no-commit
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract BoxV2 is UUPSUpgradeable {
    uint256 internal number;

    function setNumber(uint256 _number) external {
        //different v2 vs v1
        number = _number;
    }

    function getNumber() external view returns (uint256) {
        return number;
    }

    function version() external view returns (uint256) {
        return 2; //different v2 vs v1
    }

    function _authorizeUpgrade(address newImplementation) internal override {}
}
