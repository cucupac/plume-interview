// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import {ERC721} from "openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC20} from "openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyNFT is ERC721 {
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}
}

contract MyToken is ERC20 {
    uint8 private __decimals;

    constructor(string memory _name, string memory _symbol, uint8 _decimals) ERC20(_name, _symbol) {
        __decimals = _decimals;
    }

    function decimals() public view override returns (uint8) {
        return __decimals;
    }
}

contract MyFactory {
    // storage
    address public admin;

    // error
    error Unauthorized();

    // events
    /// @notice An event emitted when a new ERC-20 token is created.
    /// @param deployer The account that deployed the ERC-20 token contract.
    /// @param newToken The address of the newly-deployed ERC-20 token.
    event TokenCreated(address indexed deployer, address indexed newToken);

    /// @notice An event emitted when a new ERC-721 token is created.
    /// @param deployer The account that deployed the ERC-721 token contract.
    /// @param newNFT The address of the newly-deployed ERC-721 token.
    event NFTCreated(address indexed deployer, address indexed newNFT);

    /// @notice An event emitted when a the admin of this contract is updated.
    /// @param newAdmin The address of the new admin account.
    event AdminChange(address indexed newAdmin);

    constructor(address _admin) {
        admin = _admin;
    }

    /// @notice Creates a new ERC-20 contract.
    /// @param _name The name of the ERC-20 token contract.
    /// @param _symbol The symbol of the ERC-20 token contract.
    /// @return newToken The newly-deployed ERC-20 token contact address.
    function createERC20(string memory _name, string memory _symbol, uint8 _decimals)
        public
        payable
        onlyAdmin
        returns (address newToken)
    {
        newToken = address(new MyToken(_name, _symbol, _decimals));
        emit TokenCreated(msg.sender, newToken);
    }

    /// @notice Creates a new ERC-20 contract.
    /// @param _name The name of the ERC-20 token contract.
    /// @param _symbol The symbol of the ERC-20 token contract.
    /// @return newToken The newly-deployed ERC-20 token contact address.
    function createERC20(string memory _name, string memory _symbol)
        public
        payable
        onlyAdmin
        returns (address newToken)
    {
        newToken = address(new MyToken(_name, _symbol, 0));
        emit TokenCreated(msg.sender, newToken);
    }

    /// @notice Creates a new ERC-721 contract.
    /// @param _name The name of the ERC-721 token contract.
    /// @param _symbol The symbol of the ERC-721 token contract.
    /// @return newNFT The newly-deployed ERC-721 token contact address.
    function createERC721(string memory _name, string memory _symbol)
        public
        payable
        onlyAdmin
        returns (address newNFT)
    {
        newNFT = address(new MyNFT(_name, _symbol));
        emit NFTCreated(msg.sender, newNFT);
    }

    /// @notice Updates the admin account on this factory contract.
    /// @param _newAdmin The new admin account address.
    function setAdmin(address _newAdmin) public payable onlyAdmin {
        admin = _newAdmin;
        emit AdminChange(_newAdmin);
    }

    /// @notice Check if the caller is the owner of factory contract.
    modifier onlyAdmin() {
        if (msg.sender != admin) revert Unauthorized();
        _;
    }
}
