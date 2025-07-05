// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @notice  Pausable contract that has capabilities to pause functions during emergencies.
 * @author  Atomix (https://github.com/gopiinho/atomix/blob/main/src/utils/Pausable.sol)
 * @dev     Its recommended to guard this contract functions using ownable contract.
 * @title   Ownable
 */
abstract contract Pausable {
    /*////////////////////////////////
                Errors
    ////////////////////////////////*/
    /**
     * @dev Failed because the contract is paused.
     */
    error Pausable__Paused();

    /**
     * @dev Failed because the contract is not paused.
     */
    error Pausable__NotPaused();

    /*////////////////////////////////
                Events
    ////////////////////////////////*/
    /**
     * @dev Emmitted when the contract is paused by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emmitted when the contract is unpaused by `account`.
     */
    event Unpaused(address account);

    /*////////////////////////////////
                Storage
    ////////////////////////////////*/
    bool private _paused;

    /**
     * @dev Modifier to make function callable only when contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused, Pausable__Paused());
        _;
    }

    /**
     * @dev Modifier to make function callable only when contract is paused.
     */
    modifier whenPaused() {
        require(_paused, Pausable__NotPaused());
        _;
    }
    /*////////////////////////////////
                Functions
    ////////////////////////////////*/

    /**
     * @dev Function pauses the function calls.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;

        emit Paused(msg.sender);
    }

    /**
     * @dev Function unpases the function calls. Back to normal state.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;

        emit Unpaused(msg.sender);
    }

    /**
     * @dev Returns true if contract paused, false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }
}
