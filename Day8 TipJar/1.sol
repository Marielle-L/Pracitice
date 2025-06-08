//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract TipJar {
    address public owner;
    
    uint256 public totalTipsReceived;
    
    mapping(string => uint256) public conversionRates;

    mapping(address => uint256) public tipPerPerson;
    string[] public supportedCurrencies;  // List of supported currencies
    mapping(string => uint256) public tipsPerCurrency;

