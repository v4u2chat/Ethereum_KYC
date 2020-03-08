pragma solidity ^0.5.9;

contract KYC {
    struct Customer {
        string name;
        string data;
        uint256 upVotes;
        address validatedBank;
    }

    struct Bank {
        string name;
        string regNumber;
        uint256 upVotes;
        address ethAddress;
    }
}
