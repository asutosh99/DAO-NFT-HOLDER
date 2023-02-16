
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IFakeNFTMarketplace { 
    function getPrice() external view returns (uint256);

    function available(uint256 _tokenId) external view returns (bool);
    function purchase(uint256 _tokenId) external payable;
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


constructor (address _nftMarketplace,address _cryptoDevsNFT) payable {
   nftMarketplace = IFakeNFTMarketplace(_nftMarketplace);
    cryptoDevsNFT = ICryptoDevsNFT(_cryptoDevsNFT);
}
   modifier nftHolderOnly {
    require(cryptoDevsNFT.balaceOf(msg.sender)>0,"you are a not nft Holder");
    _;
   }

  function createProposal(uint256 _nftTokenId) external nftHolderOnly returns(uint256){
   
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
         uint256 tokenId = cryptoDevsNFT.tokenOfOwnerByIndex(msg.sender, i);
        if (proposal.voters[tokenId] == false) {
            votercount++;
            proposal.voters[tokenId] = true;
        }
    }
     require(votercount > 0, "ALREADY_VOTED");

    if (vote == Vote.YAY) {
        proposal.yayVotes += votercount;
    } else {
        proposal.nayVotes += votercount;
    }
  }
  
  modifier inactiveProposalOnly(uint256 proposalIndex) {
    require(
        proposals[proposalIndex].deadline <= block.timestamp,
        "DEADLINE_NOT_EXCEEDED"
    );
    require(
        proposals[proposalIndex].executed == false,
        "PROPOSAL_ALREADY_EXECUTED"
    );
    _;
}

function executeProposal(uint256 proposalIndex)
    external
    nftHolderOnly
    inactiveProposalOnly(proposalIndex)
{
    Proposal storage proposal = proposals[proposalIndex];

    // If the proposal has more YAY votes than NAY votes
    // purchase the NFT from the FakeNFTMarketplace
    if (proposal.yayVotes > proposal.nayVotes) {
        uint256 nftPrice = nftMarketplace.getPrice();
        require(address(this).balance >= nftPrice, "NOT_ENOUGH_FUNDS");
        nftMarketplace.purchase{value: nftPrice}(proposal.nftTokenId);
    }
    proposal.executed = true;
}

function withdrawEther() external onlyOwner {
    uint256 amount = address(this).balance;
    require(amount > 0, "Nothing to withdraw; contract balance empty");
    payable(owner()).transfer(amount);
}

receive() external payable {}

fallback() external payable {}

}

