// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract FallbackExample {
    uint256 public result;

    // 'receive()' is a special function, 'function' keyword is not required!
    // 'receive()' gets triggered every time we send the transaction
    // and we don't specify the function and keep the 'calldata' blank!
    // (Sending native currency only without the 'calldata')
    receive() external payable { 
        result = 1;
    }

    // 'fallback()' is a special function, 'function' keyword is not required!
    // 'fallback()' gets triggered only if the calldata is invalid and not empty! (eg: 0x00)
    fallback() external payable {
        result = 2;
    }
}