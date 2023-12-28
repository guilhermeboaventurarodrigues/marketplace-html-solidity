// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTMarketplace is ERC721{
    struct NFT {
        address owner;
        uint256 price;
        bool isForSale;
    }

    mapping(uint256 => NFT) private _nfts;

    constructor() ERC721("NFT Marketplace", "NFTM"){}

    function createNFT(uint256 tokenId, uint256 price) public {
        _safeMint(msg.sender, tokenId);
        _nfts[tokenId] = NFT(msg.sender, price, false);
    }

    function setNFTForSale(uint256 tokenId, bool forSale) public {
        require(ownerOf(tokenId) == msg.sender, "Voce nao e o dono do token");
        _nfts[tokenId].isForSale = forSale;
    }

    function buyNFT(uint256 tokenId) public payable{
        require(_nfts[tokenId].isForSale, "Token nao esta para venda");
        require(msg.value >= _nfts[tokenId].price, "Saldo insuficiente");

        address payable seller = payable(ownerOf(tokenId));
        address payable buyer = payable(msg.sender);
        uint256 price = _nfts[tokenId].price;

        _transfer(seller, buyer, tokenId);
        _nfts[tokenId].isForSale = false;
        seller.transfer(price);
    }

    function getNFT(uint256 tokenId) public view returns(address owner, uint256 price, bool isForSale){
        NFT memory nft = _nfts[tokenId];
        return (nft.owner, nft.price, nft.isForSale);
    }
}