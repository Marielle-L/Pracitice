//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

// 健身记录追踪器：触发前端实时更新、解锁奖励
contract SimpleFitnesstTracker {
    address public owner;

// 结构体：把多个相关的数据打包成一个逻辑单位（属于同一个实体）
    struct UserProfile{
        string name;
        uint256 weight;
        bool isRegistered;
    }

    struct WorkoutActivity {
        string activityType;
        uint256 duration;
        uint256 distance;
        uint256 timestamp;
    } 

    mapping(address => UserProfile) public userProfiles;
    mapping(address => WorkoutActivity[]) private workoutHistory;
    mapping(address => uint256) public totalWorkouts;
    mapping(address => uint256) public totalDistance;

//事件：like defining a custom log format；当你的合约中发生重要事件时，你可以发出其中一个事件，它会被记录在交易日志中。然后，您的前端可以获取这些日志来显示消息、更新 UI 或实时触发操作。
    event UserRegistered(address indexed userAddress, string name, uint256 timestamp);
    event ProfileUpdated(address indexed userAddress,uint256 newWeight, uint256 timestamp);
    event WorkoutLogged(
        address indexed userAddress,
        string activityType,  
        uint256 duration,
        uint256 distance,     
        uint256 timestamp
    );
    event MilestoneAchieved(address indexed userAddress,string milestone,uint timestamp);
        
    constructor() {
        owner = msg.sender;
    }

//userProfiles[msg.sender].isRegistered ：从结构体中访问名为 isRegistered 的字段
    modifier onlyRegistered(){
        require(userProfiles[msg.sender].isRegistered, "User not registered");
        _;
    }

//注册用户
    function registerUser (string memory _name , uint256 _weight) public {
        require(!userProfiles[msg.sender].isRegistered, "User already registered");

        userProfiles[msg.sender] = UserProfile({
            name: _name, 
            weight :_weight,
            isRegistered: true
        });

        emit UserRegistered(msg.sender ,_name, block.timestamp);
    }

//记录与更新体重
    function updateWeight(uint256 _newWeight)  public onlyRegistered {
        UserProfile storage profile = userProfiles[msg.sender];

        if (_newWeight < profile.weight && (profile.weight - _newWeight)* 100/ profile.weight >= 5){
            emit MilestoneAchieved(msg.sender,"Weight Goal Reached", block.timestamp);
        }

        profile.weight - _newWeight;

        emit ProfileUpdated(msg.sender,_newWeight ,block.timestamp);

    } 

//记录锻炼情况（次数与里程）
    function logWorkout(string memory _activityType,uint256 _duration, uint256 _distance) public onlyRegistered{
        WorkoutActivity memory newWorkout = WorkoutActivity({
            activityType:_activityType , 
            duration : _duration,
            distance: _distance,   
            timestamp: block.timestamp  
        });
        
        workoutHistory[msg.sender].push(newWorkout);

        totalWorkouts[msg.sender] ++;
        totalDistance[msg.sender] += _distance;

        emit WorkoutLogged ( 
            msg.sender,
            _activityType ,
            _duration  , 
            _distance,
            block.timestamp
        );

        if (totalWorkouts[msg.sender] >= 100000 && totalDistance[msg.sender] - _distance < 100000) {
            emit MilestoneAchieved(msg.sender,"100K Total Distance ", block.timestamp);
        }

    }

//get 用户的锻炼情况
    function getUserWorkoutCourt() public view onlyRegistered returns (uint256){
        return workoutHistory[msg.sender].length;
    }
}
