// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract Ownable {
    /*////////////////////////////////
                Errors
    ////////////////////////////////*/
    error Ownable__NotOwner(address user);

    /*////////////////////////////////
                Events
    ////////////////////////////////*/
    event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);

    /*////////////////////////////////
               Storage
    ////////////////////////////////*/
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, Ownable__NotOwner(msg.sender));
        _;
    }
    /*////////////////////////////////
               Functions
    ////////////////////////////////*/

    constructor() {
        owner = msg.sender;

        emit OwnershipTransferred(address(0), msg.sender);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        owner = newOwner;

        emit OwnershipTransferred(msg.sender, newOwner);
    }
}
