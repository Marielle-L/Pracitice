//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleIOU{
    address public owner;

    mapping(address => bool) public registeredFriends;
    address[] public friendList;

    mapping(address => uint256) public balances;

    mapping(address => mapping(address => uint256)) public debts; 

    
    
