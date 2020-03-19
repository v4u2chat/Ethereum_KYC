pragma solidity ^0.5.16;

contract Customer {
    struct Customer {
        string name;
        string data;
        uint256 upVotes;
        uint256 downVotes;
        bool kycStatus;
        address validatedBank;
    }
}