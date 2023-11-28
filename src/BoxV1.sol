//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

/**
 * In UUPS proxies the upgrade is handled by the implementation and can eventually be removed.
 * UUPS Proxies provide the ability to remove the upgradability of the contracts (which is nicely in line with the "use as rarely as possible" guideline).
 * UUPS proxies are also more gas efficient to deploy.
 *
 *  Proxies point to storage slots, not var names.
 */

//forge install OpenZeppelin/openzeppelin-contracts-upgradeable --no-commit
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
/**
 * Storage is stored at the proxy, not the implementation, so there is no point in using a constructor in the implementation, because
 * it would have no effect on the proxy. Hence, proxied contracts do not use constructors
 * -> constructor logic is moved to an external initializer function.
 * This function then needs to be protected so that it can be called only once. The {initializer} modifier does exactly this.
 * So the initializer is in fact the constructor of an upgradeable contract, but it is gonna be called by the proxy, unline a common constructor.
 */
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract BoxV1 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    /**
     * THis __gap is an empty reserved space to allow future versons to add new vars without shifting down storgae in the inheritance chain.
     * This is neccessary because proxies point to storage slots, not var names.
     * In Patrick's version, this was defined in UUPSUpgradeable.sol, but is missing in mine.
     */
    uint256[50] private __gap;
    uint256 internal number;

    /**
     * We could completely remove this construcotr with the call to disableInitializers, and the effect would be tha same.abi
     * But this is much more verbose, which is good.
     */
    constructor() {
        _disableInitializers(); //this is from Initializable, and not lets any initializations to happen
            //owner = msg.sender; // we cannot do this as in a normal ownable contract. Instead, we can do this in an initializer function.
    }

    // We can add here whatever we want to initialize
    function initialize() public initializer {
        /**
         * Sets owner to msg.sender.
         * In Patrick's version, this func doesnt need any args.
         * This is a initialier function, and as such it is prepended with "__" to signify that it should only be called in an initializer function.
         */
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
    }

    function getNumber() external view returns (uint256) {
        return number;
    }

    function version() external view returns (uint256) {
        return 1;
    }

    /**
     * This is a function in UUPSUpgradeable.sol which is an abstract contract: some functions are implemented, some are not.
     * _authorizeUpgrade is not implemented; UUPSUpgradeable.sol expects their child classes to implement this function.
     * But we dont care here, we dont do any implementation here.
     */
    function _authorizeUpgrade(address newImplementation) internal override {}
}
