//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

//追踪追踪当前所有者；限制对敏感功能的访问；允许转让所有权；发出事件，以便公开记录所有权变更
contract Ownable{
    address private owner;

    event transferOwner(address indexed oldOwner,address indexed newOwner);

    constructor(){
        owner=msg.sender;
        emit transferOwner(address(0),msg.sender);
    }

    modifier onlyOwner(){
        require(owner == msg.sender,"Only owner can call this functinon");
        _;
    }

    function ownerAddress() public view returns(address){
        return owner;
    }

    function transferOwnership(address _newOwner) public onlyOwner{
        require(_newOwner!=address(0),"Invalid Address");
        address previous = owner;
        owner = _newOwner;
        emit transferOwner(previous,_newOwner);
    }

}
