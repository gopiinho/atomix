// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import {Ownable} from "../../src/auth/Ownable.sol";

contract MockOwnable is Ownable {
    uint256 public number;

    function incrementNumber() public onlyOwner {
        ++number;
    }
}
