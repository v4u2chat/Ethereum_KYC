pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

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
    event NewCustomerCreated(Customer customer);
    event CustomerRemoved(Customer customer);
    event CustomerInfoModified(Customer customer);

    constructor() public {
		emit ContractInitialized();
	}

    // list of all customers
    Customer[] public customers;
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
        for(uint i = 0; i < customers.length; ++ i) {
            if(areBothStringSame(customers[i].name, custName) && areBothStringSame(customers[i].data, custData)) {
                return;
            }
        }
        customers.length ++;
        customers[customers.length - 1] = Customer(custName, custData, 0,bankAddress);
        emit NewCustomerCreated(customers[customers.length - 1]);
    }

    function removeCustomer(string memory custName) public payable returns(int){
        
        Customer memory removedCustomer;
        for(uint i = 0; i < customers.length; ++ i) {
            if(areBothStringSame(customers[i].name, custName)) {
                removedCustomer = customers[i];
                
                for(uint j = i+1; j < customers.length; ++ j) {
                    customers[j-1] = customers[j];
                }
            }
        }
        customers.length --;
        emit CustomerRemoved(removedCustomer);
        return 1;
    }

    function modifyCustomer(string memory custName,string memory custData) public payable returns(int){
        
        for(uint i = 0; i < customers.length; ++ i) {
            if(areBothStringSame(customers[i].name, custName)) {
                customers[i].data = custData;
	            customers[i].validatedBank = msg.sender;
                emit CustomerInfoModified(customers[i]);
                return 1;
            }
        }
        return 0;
    }

    function viewCustomer(string memory custName) public payable returns(string memory){
        
        for(uint i = 0; i < customers.length; ++ i) {
            if(areBothStringSame(customers[i].name, custName)) {
               return  customers[i].data;
            }
        }
        return "No Customer found with name ";
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
