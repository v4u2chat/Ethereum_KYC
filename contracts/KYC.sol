pragma solidity ^0.5.16;

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

    struct Request {
        string customerName;
        address bankAddress;
        bool isAllowed;
    }
    event ContractInitialized();
    event NewCustomerRequest();
    event NewCustomerCreated();
    event CustomerRemoved();
    event CustomerInfoModified();

    constructor() public {
		emit ContractInitialized();
	}

    // list of all customers
    mapping(string => Customer) customersInfo;
    // list of all Banks/Organisations
    Bank[] public banks;
    // list of all requests
    Request[] public customerRequests;
    // list of all valid KYCs
    Request[] public validKYCs;

    /*********************************************************
     *            Bank functions
     *********************************************************/

    function addCustomer(string memory custName,string memory custData,address bankAddress) public payable {
        
        Customer memory customerInfo = Customer(custName, custData, 0,bankAddress);
        customersInfo[custName] = customerInfo;
        emit NewCustomerCreated();
    }

    function removeCustomer(string memory custName) public payable returns(int){
        delete customersInfo[custName];
        emit CustomerRemoved();
        return 1;
    }

    function modifyCustomer(string memory custName,string memory custData) public payable returns(int){
        
        Customer memory customerInfo = customersInfo[custName];
        customerInfo.data = custData;
        emit CustomerInfoModified();
        return 1;
    }

    function viewCustomer(string memory custName) public payable returns(string memory){
        
        Customer storage customerInfo = customersInfo[custName];
        return customerInfo.data;
    }
     /*********************************************************
     *            KYC functions
     *********************************************************/

    function addNewCustomerRequest(string memory custName, address bankAddress) public payable {
        for(uint i = 0; i < customerRequests.length; ++ i) {
            if(areBothStringSame(customerRequests[i].customerName, custName) && customerRequests[i].bankAddress ==bankAddress) {
                return;
            }
        }
        customerRequests.length ++;
        customerRequests[customerRequests.length - 1] = Request(custName, bankAddress, false);
        emit NewCustomerRequest();
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
