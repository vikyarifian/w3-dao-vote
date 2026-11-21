// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./DepartmentWhitelist.sol";

contract DaoVote {
    struct Proposal {
        uint256 id;
        address proposer;
        string title;
        string description;
        uint256 startTime;
        uint256 endTime;
        uint256 forVotes;
        uint256 againstVotes;
        bool executed;
        string departemen;
    }

    DepartmentWhitelist public whitelist;
    uint256 public proposalCount;

    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event ProposalCreated(
        uint256 indexed id,
        address indexed proposer,
        string title,
        uint256 startTime,
        uint256 endTime,
        string departemen
    );

    event VoteCast(
        uint256 indexed proposalId,
        address indexed voter,
        bool support,
        uint256 weight
    );

    event ProposalExecuted(uint256 indexed id);

    constructor(address _whitelist) {
        require(_whitelist != address(0), "Invalid whitelist address");
        whitelist = DepartmentWhitelist(_whitelist);
    }

    function createProposal(
        string memory title,
        string memory description,
        uint256 duration,
        string memory departemen
    ) public returns (uint256) {
        require(whitelist.isWhitelisted(msg.sender), "Voter is not whitelisted");
        require(duration > 0, "Duration must be greater than zero");

        proposalCount++;
        uint256 proposalId = proposalCount;

        Proposal storage newProposal = proposals[proposalId];
        newProposal.id = proposalId;
        newProposal.proposer = msg.sender;
        newProposal.title = title;
        newProposal.description = description;
        newProposal.startTime = block.timestamp;
        newProposal.endTime = block.timestamp + duration;
        newProposal.forVotes = 0;
        newProposal.againstVotes = 0;
        newProposal.executed = false;
        newProposal.departemen = departemen;

        emit ProposalCreated(
            proposalId,
            msg.sender,
            title,
            block.timestamp,
            block.timestamp + duration,
            departemen
        );

        return proposalId;
    }

    function castVote(uint256 proposalId, bool support) public {
        require(whitelist.isWhitelisted(msg.sender), "Voter is not whitelisted");
        require(proposalId > 0 && proposalId <= proposalCount, "Proposal does not exist");

        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp >= proposal.startTime, "Voting has not started");
        require(block.timestamp <= proposal.endTime, "Voting has ended");
        require(!hasVoted[proposalId][msg.sender], "Already voted on this proposal");

        hasVoted[proposalId][msg.sender] = true;

        if (support) {
            proposal.forVotes++;
        } else {
            proposal.againstVotes++;
        }

        emit VoteCast(proposalId, msg.sender, support, 1);
    }

    // Workaround for Solidity ABI encoder limitation: struct with multiple dynamic string types must be explicitly copied from storage to memory
    function getProposal(uint256 proposalId) public view returns (Proposal memory) {
        require(proposalId > 0 && proposalId <= proposalCount, "Proposal does not exist");
        return proposals[proposalId];
    }

    function executeProposal(uint256 proposalId) public {
        require(proposalId > 0 && proposalId <= proposalCount, "Proposal does not exist");
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp > proposal.endTime, "Voting period has not ended");
        require(!proposal.executed, "Proposal already executed");
        require(proposal.forVotes > proposal.againstVotes, "Proposal did not pass");

        proposal.executed = true;
        emit ProposalExecuted(proposalId);
    }
}
