//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IdaoContract {
    function balanceOf(address, uint256) external view returns (uint256);
}

contract Dao {
    address public owner;
    uint256 nextProposal;
    uint256[] public validTokens;
    IdaoContract daoContract;

    constructor(){
        owner = msg.sender;
        nextProposal = 1;
        daoContract = IdaoContract(0x88B48F654c30e99bc2e4A1559b4Dcf1aD93FA656);
        validTokens = [13899442737259366268879373711294579734997432472560770870659951958291600375809];
    }

    struct proposal{
        uint256 id;
        bool exist;
        string description;
        uint deadline;
        uint256 votesUp;
        uint256 votesDown;
        address[] canVote;
        uint256 maxVotes;
        mapping(address => bool) voteStatus;
        bool countConducted;
        bool passed;
    }

    mapping(uint256 => proposal) public Proposals;

    event proposalCreated(
        uint256 id,
        string description,
        uint256 maxVotes,
        address proposer
    );

    event newVote(
        uint256 votesUp,
        uint256 votesDown,
        address voter,
        uint256 proposal,
        bool votedFor
    );

    event proposalCount(
        uint256 id,
        bool passed
    );

    function checkProposalEligibility(address _proposalist) private view returns(bool) {
        for (uint256 i = 0; i < validTokens.length; i++) {
            if(daoContract.balanceOf(_proposalist, validTokens[i]) >= 1 ) {
                return true;
            }
        }
        return false;
    }

    function checkVoteEligibility(uint256 _id, address _voter) private view returns(bool) {
        for (uint256 i = 0; i < Proposals[_id].canVote.length; i++) {
            if(Proposals[_id].canVote[i] == _voter) {
                return true;
            }
            
        }
        return false;
    }

    function createProposal(string memory _description, address[] memory _canVote) public {
        require(checkProposalEligibility(msg.sender), "Only NFT holders can put forth Proposals");

        proposal storage newProposal = Proposals[nextProposal];
        newProposal.id = nextProposal;
        newProposal.exist = true;
        newProposal.description = _description;
        newProposal.deadline = block.number + 100;
        newProposal.canVote = _canVote;
        newProposal.maxVotes = _canVote.length;

        emit proposalCreated(nextProposal, _description, _canVote.length, msg.sender);
        nextProposal++;
    }

    function voteOnProposal(uint256 _id, bool _vote) public {
        require(Proposals[_id].exists);
    }



}