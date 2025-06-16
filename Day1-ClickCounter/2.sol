//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;
/*
1.License Identifier – declare a license to clarify how others can use the code
2.Pragma Directive – Setting the Solidity Version
3.Defining the Smart Contract - live on the blockchain permanently
*/
contract ClickCounter {
    
    uint256 public count=0;
//声明状态变量，自动生成getter函数:function counter() public view returns (uint256) {return counter;}

    function click() public{

        count++;

    } 

    function reset() public{

        count=0;
    }

    function decresment() public{

        require(count>=0,"count cannot be negative");

        count--;

    }
}
