//SPDX-License-Identifier；MIT
pragma solidity ^0.8.0;

constract EtherPiggyBank{

    address public bankManager;
    address[] members;
    mapping(address => bool) public registeredMembers;
    mapping(address => uint256) balance;

    
}
