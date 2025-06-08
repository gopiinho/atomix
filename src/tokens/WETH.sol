// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "./ERC20.sol";

/**
 * @notice  Minimal WETH implementation.
 * @author  Atomix (https://github.com/gopiinho/atomix/blob/main/src/tokens/WETH.sol)
 * @author  Inspired by WETH9 (https://github.com/dapphub/ds-weth/blob/master/src/weth9.sol)
 * @title   WETH
 */
contract WETH is ERC20("Wrapped Ether", "WETH", 18) {
    /*////////////////////////////////
                Errors
    ////////////////////////////////*/
    error WETH__TransferFailed();

    /*////////////////////////////////
                Events
    ////////////////////////////////*/
    event Deposit(address indexed from, uint256 indexed amount);
    event Withdraw(address indexed to, uint256 indexed amount);

    /*////////////////////////////////
                Functions
    ////////////////////////////////*/
    function deposit() public payable virtual {
        _mint(msg.sender, msg.value);

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public virtual {
        _burn(msg.sender, amount);

        emit Withdraw(msg.sender, amount);

        (bool success,) = msg.sender.call{value: amount}("");
        require(success, WETH__TransferFailed());
    }

    receive() external payable virtual {
        deposit();
    }
}
