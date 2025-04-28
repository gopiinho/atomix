// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {MockERC20} from "./mocks/MockERC20.sol";

contract ERC20Test is Test {
    MockERC20 mockErc20;
    address user;
    address receiver;
    uint256 constant MINT_AMOUNT = 1000e18;

    function setUp() public {
        mockErc20 = new MockERC20("Token", "TKN", 18);
        user = makeAddr("USER");
        receiver = makeAddr("RECEIVER");
    }

    modifier mintsTokens() {
        mockErc20.mint(user, MINT_AMOUNT);
        _;
    }

    function testCanMintTokens() public {
        mockErc20.mint(user, MINT_AMOUNT);

        assertEq(MINT_AMOUNT, mockErc20.balanceOf(user));
    }

    function testCanBurnTokens() public mintsTokens {
        uint256 amountToBurn = 100e18;
        mockErc20.burn(user, amountToBurn);

        assertEq(MINT_AMOUNT - amountToBurn, mockErc20.balanceOf(user));
    }

    function testCanTransferTokens() public mintsTokens {
        uint256 amountToTransfer = 100e18;
        vm.startPrank(user);
        mockErc20.transfer(receiver, amountToTransfer);
        vm.stopPrank();

        assertEq(amountToTransfer, mockErc20.balanceOf(receiver));
    }

    function testCanApproveTokens() public mintsTokens {
        uint256 amountToApprove = 100e18;
        vm.startPrank(user);
        mockErc20.approve(receiver, amountToApprove);
        vm.stopPrank();

        assertEq(amountToApprove, mockErc20.allowance(user, receiver));
    }

    function testCanTransferApprovedTokens() public mintsTokens {
        uint256 amountToApprove = 100e18;
        uint256 amountToTransfer = 50e18;

        vm.startPrank(user);
        mockErc20.approve(receiver, amountToApprove);
        vm.stopPrank();

        // send tokens from receiver to this contract
        vm.startPrank(receiver);
        mockErc20.transferFrom(user, address(this), amountToTransfer);
        vm.stopPrank();

        assertEq(amountToTransfer, mockErc20.balanceOf(address(this)));
    }
}
