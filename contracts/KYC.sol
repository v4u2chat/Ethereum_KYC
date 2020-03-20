    pragma solidity ^0.5.16;

    contract KYC {

        address admin;

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

        struct Request {
            string customerName;
            string customerData;
            address bankAddress;
            bool isAllowed;
        }
        event ContractInitialized();
        event CustomerRequestAdded();
        event CustomerRequestRemoved();
        event NewCustomerCreated();
        event CustomerRemoved();
        event CustomerInfoModified();

        constructor() public {
            emit ContractInitialized();
            admin = msg.sender;
        }

        mapping(string => Customer) customersInfo;  //  Mapping a customer's username to the Customer
        mapping(address => Bank) banks; //  Mapping a bank's address to the Bank
        mapping(string => Request) kycRequests; //  Mapping a customer's username to KYC request
        mapping(string => mapping(address => uint256)) upvotes; //To track upVotes of all customers vs banks

        /*********************************************************
        *            KYC functions
        *********************************************************/

        function addNewCustomerRequest(string memory custName, string memory custData) public payable returns(int){
            require(kycRequests[custName].bankAddress == address(0), "This user already has a KYC request with same data in process.");
            Request memory kycRequest = Request(custName,custData, msg.sender, false);
            kycRequests[custName] = kycRequest;
            emit CustomerRequestAdded();
            return 1;
        }

        function removeCustomerRequest(string memory custName) public payable returns(int){
            delete kycRequests[custName];
            emit CustomerRequestRemoved();
            return 1;
        }

        /*********************************************************
        *            Bank functions
        *********************************************************/

        function addCustomer(string memory custName,string memory custData) public payable {
            require(customersInfo[custName].validatedBank == address(0), "Customer already exists");
            Customer memory customerInfo = Customer(custName, custData, 0,msg.sender);
            customersInfo[custName] = customerInfo;
            emit NewCustomerCreated();
        }

        function removeCustomer(string memory custName) public payable returns(int){
            require(customersInfo[custName].validatedBank != address(0), "Customer not found");
            delete customersInfo[custName];
            emit CustomerRemoved();
            return 1;
        }

        function modifyCustomer(string memory custName,string memory custData) public payable returns(int){
            require(customersInfo[custName].validatedBank != address(0), "Customer not found");
            customersInfo[custName].data = custData;
            emit CustomerInfoModified();
            return 1;
        }

        function viewCustomer(string memory custName) public payable returns(string memory){
            require(customersInfo[custName].validatedBank != address(0), "Customer not found");
            return customersInfo[custName].data;
        }
        
        function upVoteCustomer(string memory custName) public payable returns(int){
            require(customersInfo[custName].validatedBank != address(0), "Customer not found");
            customersInfo[custName].upVotes++;
            upvotes[custName][msg.sender] = now;
            return 1;
        }

        /*********************************************************
        *            Internal functions
        *********************************************************/

        function areBothStringSame(string memory a, string memory b) private pure returns (bool) {
            if(bytes(a).length != bytes(b).length) {
                return false;
            } else {
                return keccak256(bytes(a)) == keccak256(bytes(b));
            }
        }
    }
