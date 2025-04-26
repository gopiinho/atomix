// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

abstract contract Ownable {
    /*////////////////////////////////
                Errors
    ////////////////////////////////*/
    error Ownable__NotOwner(address user);

    /*////////////////////////////////
               Storage
    ////////////////////////////////*/
    address public owner;

    /*////////////////////////////////
               Functions
    ////////////////////////////////*/
    modifier onlyOwner() {
        require(msg.sender == owner, Ownable__NotOwner(msg.sender));
        _;
    }

    constructor() {
        owner = msg.sender;
    }
}
