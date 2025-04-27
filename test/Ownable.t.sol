// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Ownable} from "../src/auth/Ownable.sol";
import {MockOwnable} from "./mocks/MockOwnable.sol";

contract OwnableTest is Test {
    Ownable ownable;
    MockOwnable mockOwnable;
    address nonOwner;

    function setUp() public {
        mockOwnable = new MockOwnable();
        nonOwner = makeAddr("NON_OWNER");
    }

    function testThisContractIsOwner() public view {
        assertEq(mockOwnable.owner(), address(this));
    }

    function testOnlyOwnerCanRunAuthorizedFunctions() public {
        vm.startPrank(nonOwner);
        vm.expectRevert(abi.encodeWithSelector(Ownable.Ownable__NotOwner.selector, nonOwner));
        mockOwnable.incrementNumber();
        vm.stopPrank();
    }

    function testCanTransferOwnership() public {
        mockOwnable.transferOwnership(nonOwner);
        assertEq(mockOwnable.owner(), nonOwner);
    }
}
