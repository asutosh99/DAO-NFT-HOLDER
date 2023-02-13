// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract FakeNFTMarketplace {
    //  map-- tokens,purchase,getPrice,available

    mapping(uint256 => address) tokens;
    uint256 nftPrice = 0.1 ether;

    function purchase(uint256 _tokenId) external payable {
        require(msg.value == nftPrice, "please give more ether");
        tokens[_tokenId] = msg.sender;
    }

    function getPrice() external view returns (uint256) {
        return nftPrice;
    }

    function avaliable(uint256 _tokenId) external view returns (bool) {
        if (tokens[_tokenId] == address(0)) {
            return true;
        }
        return false;
    }
}
