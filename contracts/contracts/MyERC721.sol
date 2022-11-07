// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyERC721 is ERC721,ERC721Enumerable, ERC721URIStorage {
    uint256 public _tokenId;
    address manager;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        manager = msg.sender;
        _tokenId=0;
    }

    function mint(address _recipient, string memory _tokenUrl) public returns(uint _mintTokenId){
        require(msg.sender == manager);
        require(bytes(_tokenUrl).length > 0,"The _tokenUrl must be have");
        uint newTokenId = _tokenId;
        _tokenId++;
        _mint(_recipient, newTokenId);
        _setTokenURI(newTokenId, _tokenUrl);
        return newTokenId;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal
    override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal 
    override(ERC721, ERC721URIStorage) 
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view 
    override(ERC721, ERC721URIStorage)
    returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
    public view
    override(ERC721, ERC721Enumerable)
    returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}