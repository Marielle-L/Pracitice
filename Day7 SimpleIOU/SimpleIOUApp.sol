//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract SimpleIOU {

    address public owner;

    mapping(address => bool) public registeredFriends;
    address[] public friendList;

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint)) debts;

    constructor(){
        owner = msg.sender;
        registeredFriends[msg.sender]=true;
        friendList.push(msg.sender);
    }

    modifier onlyOwner(){
        require(msg.sender==owner,"This action is not allowed for you");
        _;
    }

    modifier onlyRegisteredFriends(){
        require(registeredFriends[msg.sender],"You are not registered");
        _;
    }
//添加好友
    function addfriends(address _friend) public onlyOwner {
        require(_friend != address(0),"Invalid address");
        require(!registeredFriends[_friend],"Friend already registered");

        registeredFriends[_friend] = true;
        friendList.push(_friend);
    }

//存入钱包
    function depositIntoWallet() public payable onlyRegisteredFriends{
        require(msg.value>0,"Must send ETH");
        balances[msg.sender]+= msg.value;
    }

//记录债务
    function recordDebt(address _debtor, uint256 _amount) public onlyRegisteredFriends {
        require(_debtor != address(0), "Invalid address");
        require(registeredFriends[_debtor], "Address not registered");
        require(_amount > 0, "Amount must be greater than 0");

        debts[_debtor][msg.sender] += _amount;
    }

//从钱包支付
    function payFromWallet(address _creditor, uint256 _amount) public onlyRegisteredFriends{
        require(_creditor != address(0), "Invalid address");
        require(registeredFriends[_creditor], "Creditor not registered");
        require(_amount > 0, "Amount must be greater than 0");
        require(debts[msg.sender][_creditor] >= _amount, "Debt amount incorrect");
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        balances[msg.sender]-=_amount;
        balances[_creditor]+=_amount;
        debts[msg.sender][_creditor] -= _amount;
    }

//ETH的转移transfer与调用call
//Sending ETH using transfer()
    function transferEther(address payable _to, uint256 _amount) public onlyRegisteredFriends {
    require(_to != address(0), "Invalid address");
    require(registeredFriends[_to], "Recipient not registered");
    require(balances[msg.sender] >= _amount, "Insufficient balance");

    balances[msg.sender] -= _amount;
    _to.transfer(_amount);
    balances[_to] += _amount;
    }

//Alternative transfer method using call()
    function transferEtherViaCall(address payable _to, uint256 _amount) public onlyRegisteredFriends {
    require(_to != address(0), "Invalid address");
    require(registeredFriends[_to], "Recipient not registered");
    require(balances[msg.sender] >= _amount, "Insufficient balance");

    balances[msg.sender] -= _amount;

    (bool success, ) = _to.call{value: _amount}("");
    balances[_to] += _amount;
    require(success, "Transfer failed");
    }

//从钱包提取withdraw
    function withdraw(uint _amount) public onlyRegisteredFriends{
        require(balances[msg.sender]>=_amount,"Insufficient Balances");

        balances[msg.sender]-=_amount;

        (bool success, )=payable(msg.sender).call{value:_amount}("");
        require(success,"Withdrawl failed");
    }

//检查余额
    function checkBalances() public view onlyRegisteredFriends returns(uint256){
        return(balances[msg.sender]);
    }

}
