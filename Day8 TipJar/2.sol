//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TipJar{
    address public owner;

    uint256 public totalTipsReceived;

//汇率；if 1 USD = 0.0005 ETH, then the rate would be 5 * 10^14
    mapping(string => uint256) public conversionRates;  

//不同人交的tips
    mapping(address => uint256) public tipPerPerson;

//可支持交换的货币（字符串）
    string[] public supportedCurrencies;

//不同货币对应的ETH
    mapping(string => uint256) public tipsPerCurrency;

    constructor() {
        owner = msg.sender;
        addCurrency("USD", 5 * 10**14);  // 1 USD = 0.0005 ETH
        addCurrency("EUR", 6 * 10**14);  // 1 EUR = 0.0006 ETH
        addCurrency("JPY", 4 * 10**12);  // 1 JPY = 0.000004 ETH
        addCurrency("INR", 7 * 10**12);  // 1 INR = 0.000007ETH ETH
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "You're not allowed to do that!");  //only the owner can interact with this contract and send funds in this contract
        _;
    }
    
//添加货币和汇率
    function addCurrency(string memory _currencyCode, uint256 _rateToEth) public onlyOwner{
        require(_rateToEth > 0,"Conversion rate must be greater than 0");
        bool currencyExists = false;
        for (uint i = 0;i< supportedCurrencies.length;i++){
            if (keccak256(bytes(supportedCurrencies[i])) == keccak256(bytes(_currencyCode))){
                currencyExists = true;
                break;
            }
        }
        if (!currencyExists) {
            supportedCurrencies.push(_currencyCode);
        }

        conversionRates[_currencyCode]=_rateToEth;
    }

//Currency 转为Eth
    function convertToEth(string memory _currencyCode, uint256 _amount) public view returns(uint256){
        require(conversionRates[_currencyCode] > 0, "Currency not supported");
        uint256 ethAmount = _amount * conversionRates[_currencyCode];
        return ethAmount;
    }

// Send a tip in ETH
    function tipInEth() public payable{
        require(msg.value > 0, "Tip amount must be greater than 0");
        tipPerPerson[msg.sender] += msg.value;
        totalTipsReceived += msg.value;
        tipsPerCurrency["ETH"] += msg.value;
    }

//Send a tip in Currency
    function tipInCurrency(string memory _currencyCode, uint256 _amount) public payable{
         require(conversionRates[_currencyCode] > 0, "Currency not supported");
        require(_amount > 0, "Amount must be greater than 0");
        uint256 ethAmount = convertToEth(_currencyCode, _amount);
        require(msg.value == ethAmount, "Sent ETH doesn't match the converted amount");
        tipPerPerson[msg.sender] += msg.value;
        totalTipsReceived += msg.value;
        tipsPerCurrency[_currencyCode] += _amount;
    }

//取出所有tips
    function withdrawTips() public onlyOwner{
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0,"No tips to withdraw");
        (bool success,) = payable(owner).call{value:contractBalance}("");
        require(success,"Teansfer failed");
        totalTipsReceived = 0;

    }

//转移所有权
    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "Invalid address");
        owner = _newOwner;
    }

//get所有支持的货币
    function getSupportedCurrencies() public view returns (string[] memory) {
        return supportedCurrencies;
    }
    
//get合约内全部金额
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
//get某个人的tips contribution  
    function getTipperContribution(address _tipper) public view returns (uint256) {
        return tipPerPerson[_tipper];
    }
    
//以特定货币支付的小费总额
    function getTipsInCurrency(string memory _currencyCode) public view returns (uint256) {
        return tipsPerCurrency[_currencyCode];
    }

//get汇率
    function getConversionRate(string memory _currencyCode) public view returns (uint256) {
        require(conversionRates[_currencyCode] > 0, "Currency not supported");
        return conversionRates[_currencyCode];
    }
}
