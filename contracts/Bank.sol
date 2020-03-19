pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

import "./Customer.sol";

contract Bank {

    struct Bank {
        string name;
        address ethAddress;
        uint256 reports;
        uint256 kycCount;
        bool kycPermission;
        string regNumber;
    }

    event NewCustomerCreated(Customer customer);
    event CustomerRemoved(Customer customer);
    event CustomerInfoModified(Customer customer);
    
    // list of all customers
    Customer[] public customers;

function addCustomer(string memory custName,string memory custData,address bankAddress) public payable {
        for(uint i = 0; i < customers.length; ++ i) {
            if(areBothStringSame(customers[i].name, custName) && areBothStringSame(customers[i].data, custData)) {
                return;
            }
        }
        customers.length ++;
        customers[customers.length - 1] = Customer(custName, custData, 0,0, false,bankAddress);
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
}