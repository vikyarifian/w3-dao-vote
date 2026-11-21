// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract DepartmentWhitelist {
    address public owner;

    mapping(address => bool) public whitelistedVoters;
    mapping(address => string) public voterDepartment;
    uint256 public totalWhitelisted;

    event VoterStatusChanged(address indexed voter, string departemen, bool status);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setVoter(address voter, string memory departemen, bool status) external onlyOwner {
        require(voter != address(0), "Invalid voter address");

        if (whitelistedVoters[voter] != status) {
            if (status) {
                totalWhitelisted++;
            } else {
                totalWhitelisted--;
            }
            whitelistedVoters[voter] = status;
        }

        voterDepartment[voter] = departemen;

        emit VoterStatusChanged(voter, departemen, status);
    }

    function isWhitelisted(address voter) external view returns (bool) {
        return whitelistedVoters[voter];
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid new owner");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}
