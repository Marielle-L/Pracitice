// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PollStation{

    // []数组array-store multiple arrangements' names
    // 映射 keyType => valueType
    string[] public candidateNames;
    mapping(string => uint256) voteCount;
    mapping(address => bool) voteState;
    mapping(string => bool) candidateExists;

    // arrayName.push 往数组末尾添加元素(候选者信息)
    function addCandidateNames(string memory _candidateNames) public{
        require(!candidateExists[name], "Candidate already exists.");
        candidateNames.push(_candidateNames);
        voteCount[_candidateNames] = 0;
        candidateExists[_candidateNames] = true;
    }

    //返回候选者信息
    function getcandidateNames() public view returns (string[] memory){
        return candidateNames;
    }

    //投票 保证候选者存在且防止同一地址多次投票
    function vote(string memory _candidateNames) public{
        require(!voteState[msg.sender], "You have already voted.");
        require(candidateExists[_candidateNames], "Candidate does not exist."); 

        voteCount[_candidateNames] += 1;
        voteState[msg.sender]= true;
    }

    //获得候选者票数
    function getVote(string memory _candidateNames) public view returns (uint256){
        return voteCount[_candidateNames];
    }

}
