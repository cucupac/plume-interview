// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MyNFT} from "../src/MyNFT.sol";

contract CounterTest is Test {
    MyNFT public nft;

    function setUp() public {
        nft = new MyNFT();

        // Example:
        // nft.setupSomthing();
    }
}
