// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import {Pausable} from "../../src/utils/Pausable.sol";
import {Ownable} from "../../src/auth/Ownable.sol";

contract MockPausable is Pausable, Ownable {
    uint256 public number;

    function incrementNumber() public whenNotPaused {
        ++number;
    }

    function decrementNumber() public whenPaused {
        --number;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}
