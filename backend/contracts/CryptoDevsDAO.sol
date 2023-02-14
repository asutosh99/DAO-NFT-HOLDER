
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IFakeNFTMarketplace {
    function purchase(uint256)external payable;
    function avaliable(uint256 _tokenId) external view returns (b;ool);
     function getPrice() external view returns (uint256)
}

interface ICryptoDevsNFT{
    function balaceOf(address owner) external view returns(uint256);
 function tokenOfOwnerByIndex(address owner, uint256 index)
        external
        view
        returns (uint256);
}

contract CryptoDevsDao is Ownable{
struct  Proposal {
      uint256 nftTokenId;
    uint256 deadline;
    uint256 yayVotes;
    uint256 nayVotes;
    bool executed;
      mapping(uint256 => bool) voters;
}
mapping (uint256=>Proposal) public proposals;

uint256 numProposals;

IFakeNFTMarketplace nftMarketplace;
ICryptoDevsNFT cryptoDevsNFT;

constructor (address _nftMarketpalce,address _cryptoDevsNFT) {
  nftMarketplace=IcryptoDevNft(_cryptoDevsNFT);
  cryptoDevsNFT=ICryptoDevsNFT(_nftMarketpalce);
}
   modifier nftHolderOnly {
    require(cryptoDevsNFT.balaceOf(owner)>0,"you are a not nft Holder");
    _;
   }

  function createProposal(address _tokenId) external nftHolderOnly returns(uint256){
    require(nftMarketplace.available(_nftTokenId), "NFT_NOT_FOR_SALE");
    Proposal storage proposal = proposals[numProposals];
    proposal.nftTokenId = _nftTokenId;
    // Set the proposal's voting deadline to be (current time + 5 minutes)
    proposal.deadline = block.timestamp + 5 minutes;

    numProposals++;

    return numProposals - 1;
  }

  modifier activeProposalOnly(uint256 _proposalIndex){
    require(proposals[_proposalIndex].deadline>block.timestamp,"not a active proposal");
    _;
  }

  enum Vote{
    YAY,
    NAY
  }

  function voteOnProposal(uint256 _proposalIndex, Vote vote) 
  external 
  nftHolderOnly
 activeProposalOnly(_proposalIndex) {
    Proposal storage proposal=proposals[_proposalIndex];
    uint256 voterBalance=cryptoDevsNFT.balaceOf(msg.sender);

    uint votercount;

    for(uint i=0;i<voterBalance;i++ ){
      
    }
  }
  
  

}

