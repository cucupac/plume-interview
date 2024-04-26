// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import {ERC721} from "openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyNFT is ERC721 {
    constructor() ERC721("MyNFT", "MNFT") {}
}
