// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {WETH} from "../src/tokens/WETH.sol";

contract WETHTest is Test {
    WETH weth;
    address user;
    uint256 startingBalance = 1 ether;
    uint256 amountToDeposit = 0.5 ether;

    function setUp() public {
        weth = new WETH();
        user = makeAddr("USER");
        vm.deal(user, startingBalance);
    }

    modifier userDepositsEther() {
        vm.startPrank(user);
        weth.deposit{value: amountToDeposit}();
        vm.stopPrank();
        _;
    }

    function testDeposit() public userDepositsEther {
        uint256 userWethBalanceAfterDeposit = weth.balanceOf(user);

        assertEq(address(weth).balance, amountToDeposit);
        assertEq(weth.totalSupply(), userWethBalanceAfterDeposit);
        assertEq(amountToDeposit, userWethBalanceAfterDeposit);
    }

    function testWithdraw() public userDepositsEther {
        uint256 originalDepositAmount = amountToDeposit;
        uint256 amountToWithdraw = 0.25 ether;

        vm.startPrank(user);
        weth.withdraw(amountToWithdraw);
        vm.stopPrank();

        uint256 userWethBalanceAfterWithdraw = weth.balanceOf(user);

        assertEq(address(weth).balance, originalDepositAmount - amountToWithdraw);
        assertEq(userWethBalanceAfterWithdraw, originalDepositAmount - amountToWithdraw);
        assertEq(weth.totalSupply(), userWethBalanceAfterWithdraw);
    }

    function testFallbackDeposit() public {
        assertEq(weth.balanceOf(user), 0);
        assertEq(weth.totalSupply(), 0);

        vm.startPrank(user);
        (bool success,) = address(weth).call{value: amountToDeposit}("");
        require(success, "Transfer failed");
        vm.stopPrank();

        uint256 userWethBalanceAfterSendingEth = weth.balanceOf(user);

        assertEq(userWethBalanceAfterSendingEth, amountToDeposit);
        assertEq(address(weth).balance, amountToDeposit);
        assertEq(weth.totalSupply(), userWethBalanceAfterSendingEth);
    }

    function testWithdrawFailsIfETHTransferFails() public userDepositsEther {
        RejectEther rejector = new RejectEther();

        vm.startPrank(user);
        weth.transfer(address(rejector), amountToDeposit);
        vm.stopPrank();

        vm.startPrank(address(rejector));
        vm.expectRevert(WETH.WETH__TransferFailed.selector);
        weth.withdraw(amountToDeposit);
        vm.stopPrank();
    }
}

contract RejectEther {
    receive() external payable {
        revert("Rejects ETH");
    }
}
