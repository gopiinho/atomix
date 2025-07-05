// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @notice  Contract to prevent funtions being reentered before its execution finishes.
 * @author  Atomix (https://github.com/gopiinho/atomix/blob/main/src/utils/ReenterancyGuard.sol)
 * @dev     Its recommended to guard this contract functions using ownable contract.
 * @title   ReenterancyGuard
 */
abstract contract ReenterancyGuard {
    /*////////////////////////////////
                Errors
    ////////////////////////////////*/
    /**
     * @dev Reenterancy guard is locked.
     */
    error ReenterancyGuard__Locked();

    /*////////////////////////////////
                Storage
    ////////////////////////////////*/
    bool internal locked;

    /**
     * @dev Modifier to make sure functions don't get reentered before their execution finishes.
     */
    modifier nonReentrant() {
        require(!locked, ReenterancyGuard__Locked());
        locked = true;
        _;
        locked = false;
    }
}
