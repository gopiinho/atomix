// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @notice  Minimal ERC721 implementation compliant with ERC-721 Non-Fungible Token Standard.
 * @author  Atomix (https://github.com/gopiinho/atomix/blob/main/src/tokens/ERC721.sol)
 * @title   ERC721
 */
abstract contract ERC721 {
    /*////////////////////////////////
                Errors
    ////////////////////////////////*/
    error ERC721__ZeroAddress();
    error ERC721__NotAuthorized();
    error ERC721__NotAllowed(address spender);
    error ERC721__NotOwner(address owner, uint256 tokenId);

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

    mapping(uint256 => address) public getApproved;
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    /*////////////////////////////////
                Functions
    ////////////////////////////////*/
    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function approve(address spender, uint256 tokenId) public virtual {
        address owner = ownerOf[tokenId];

        require(msg.sender == owner, ERC721__NotAllowed(spender));

        getApproved[tokenId] = spender;

        emit Approval(owner, spender, tokenId);
    }

    function setApprovalForAll(address operator, bool approved) public virtual {
        isApprovedForAll[msg.sender][operator] = approved;

        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function transferFrom(address from, address to, uint256 tokenId) public virtual {
        require(from == ownerOf[tokenId], ERC721__NotOwner(from, tokenId));
        require(to != address(0), ERC721__ZeroAddress());
        require(
            msg.sender == from || isApprovedForAll[from][msg.sender] || msg.sender == getApproved[tokenId],
            ERC721__NotAuthorized()
        );

        unchecked {
            balanceOf[from]--;
            balanceOf[to]++;
        }

        ownerOf[tokenId] = to;

        delete getApproved[tokenId];

        emit Transfer(from, to, tokenId);
    }
}
