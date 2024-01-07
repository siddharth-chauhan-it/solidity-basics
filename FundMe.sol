// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "./PriceConverter.sol";

// Definition of an error to avoid storing require() error string for gas efficiency. (Solidity 0.8.4^)
error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    // 771,375 gas
    // 751,449 gas using 'constant' for variable MINIMUM_USD 
    uint256 public constant MINIMUM_USD = 50 * 1e18; // 1 * 10 ** 18

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    // using 'immutable' for gas efficiency
    address public immutable i_owner; 

    // 'constructor()' is a special function, 'function' keyword is not required!
    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough"); // 1e18 = 1 * 10 ** 18 == 1000000000000000000
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        // reset the mapping
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0; 
        }

        // reset the funders array
        funders = new address[](0);

        // withdraw the funds
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner {
        // Check if the withdrawer is an owner
        // require(msg.sender == i_owner, "Not owner!");

        // More gas efficient way to check owner (Storing the error string "Not owner!" is skipped)
        if(msg.sender != i_owner) { revert NotOwner(); } // 'revert' is more gas efficient than 'require' (Solidity 0.8.4^)
        
        // Execute rest of the code of the modified function
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}

// Other Topics Left
// 1. Enums
// 2. Events
// 3. Try / Catch
// 4. Function Selectors
// 5. abi.encode / decode
// 6. Hashing
// 7. Yul / Assembly
