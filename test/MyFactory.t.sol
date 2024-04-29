// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MyFactory} from "../src/MyFactory.sol";

import {IERC20Metadata} from "openzeppelin/contracts/interfaces/IERC20Metadata.sol";

contract FactoryTest is Test {
    MyFactory public factory;

    address admin = address(this);

    function setUp() public {
        factory = new MyFactory(admin);
    }

    /// @dev
    // - the returned ERC20 address should non-zero
    // - the name of the ERC20 address should match what was sent in upon creation
    // - the symbol of the ERC20 address should match what was sent in upon creation
    function test_CreateERC20_NoDecimals() public {
        // Act
        vm.prank(admin);
        address newToken = factory.createERC20("MyToken", "MTKN");

        // Call the token
        string memory tokenName = IERC20Metadata(newToken).name();
        string memory tokenSymbol = IERC20Metadata(newToken).symbol();
        uint8 tokenDecimals = IERC20Metadata(newToken).decimals();

        // Test to make sure the event happened

        // Assertions
        assertNotEq(newToken, address(0));
        assertEq(tokenName, "MyToken");
        assertEq(tokenSymbol, "MTKN");
        assertEq(tokenDecimals, 0);
    }

    /// @dev
    // - the returned ERC20 address should non-zero
    // - the name of the ERC20 address should match what was sent in upon creation
    // - the symbol of the ERC20 address should match what was sent in upon creation
    function test_CreateERC20() public {
        // Act
        vm.prank(admin);
        address newToken = factory.createERC20("MyToken", "MTKN", 18);

        // Call the token
        string memory tokenName = IERC20Metadata(newToken).name();
        string memory tokenSymbol = IERC20Metadata(newToken).symbol();
        uint8 tokenDecimals = IERC20Metadata(newToken).decimals();

        // Test to make sure the event happened

        // Assertions
        assertNotEq(newToken, address(0));
        assertEq(tokenName, "MyToken");
        assertEq(tokenSymbol, "MTKN");
        assertEq(tokenDecimals, 18);
    }

    /// @dev
    // - the function should revert if it's called by a sender that is not the admin.
    function test_CannotCreateERC20_Unauthorized(address sender) public {
        // Assumptions
        vm.assume(sender != admin);

        // Act
        vm.prank(sender);
        vm.expectRevert(MyFactory.Unauthorized.selector);
        factory.createERC20("MyToken", "MTKN");
    }
}
