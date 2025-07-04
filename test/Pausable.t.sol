// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Pausable} from "../src/utils/Pausable.sol";
import {MockPausable} from "./mocks/MockPausable.sol";

contract PausableTest is Test {
    Pausable pausable;
    MockPausable mockPausable;
    address admin;

    function setUp() public {
        admin = makeAddr("ADMIN");
        vm.startPrank(admin);
        mockPausable = new MockPausable();
        vm.stopPrank();
    }

    modifier pausesContract() {
        vm.startPrank(admin);
        mockPausable.pause();
        vm.stopPrank();
        _;
    }

    modifier unpausesContract() {
        vm.startPrank(admin);
        mockPausable.unpause();
        vm.stopPrank();
        _;
    }

    function testIsUnpausedByDefault() public view {
        bool state = mockPausable.paused();
        assertEq(state, false);
    }

    function testCanPauseContract() public pausesContract {
        bool state = mockPausable.paused();
        assertEq(state, true);
    }

    function testCanUnpauseContract() public pausesContract {
        bool beforeState = mockPausable.paused();
        assertEq(beforeState, true);

        vm.startPrank(admin);
        mockPausable.unpause();
        vm.stopPrank();

        bool state = mockPausable.paused();
        assertEq(state, false);
    }

    function testFunctionsAreDisabledWhenPaused() public pausesContract {
        vm.expectRevert(abi.encodeWithSelector(Pausable.Pausable__Paused.selector));
        mockPausable.incrementNumber();
    }

    function testPauseGuardedFunctionsAreDisabledWhenNotPaused() public {
        mockPausable.incrementNumber();
        vm.expectRevert(abi.encodeWithSelector(Pausable.Pausable__NotPaused.selector));
        mockPausable.decrementNumber();
    }

    function testPauseGuardedFunctionsWorkWhenPaused() public {
        uint256 startingNumber = mockPausable.number();
        vm.assertEq(startingNumber, 0);

        // Increment to 3
        mockPausable.incrementNumber();
        mockPausable.incrementNumber();
        mockPausable.incrementNumber();

        vm.startPrank(admin);
        mockPausable.pause();
        vm.stopPrank();

        mockPausable.decrementNumber();
        uint256 endingNumber = mockPausable.number();
        // 1+1+1-1 = 3-1 = 2
        assertEq(endingNumber, 2);
    }
}
