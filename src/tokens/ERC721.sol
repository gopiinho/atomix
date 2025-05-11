// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @notice  Minimal ERC721 implementation compliant with ERC-721 Non-Fungible Token Standard.
 * @author  Atomix (https://github.com/gopiinho/atomix/blob/main/src/tokens/ERC721.sol)
 * @title   ERC721
 */
abstract contract ERC721 {
    /*////////////////////////////////
                Events  
    ////////////////////////////////*/
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /*////////////////////////////////
                Storage
    ////////////////////////////////*/
    uint256 totalSupply;

    string public name;
    string public symbol;

    function tokenURI(uint256 tokenId) external view virtual returns (string memory);

    mapping(uint256 => address) public ownerOf;
    mapping(address => uint256) public balanceOf;

    /*////////////////////////////////
                Functions
    ////////////////////////////////*/
    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }
}
