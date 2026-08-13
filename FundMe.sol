//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// 1. 创建一个收款函数
// 2. 记录投资人并且查看
// 3. 在锁定期内，达到目标值，生产商可以提款
// 4. 在锁定期内，没有达到目标值，投资人在锁定期以后退款

contract FundMe{
    
    AggregatorV3Interface internal dataFeed;
    //常量 constant
    uint256 constant target=10*10**18;
    //合约拥有者
    address public owner;

    mapping(address => uint256) public fundersToAmount;
    //时间戳
    uint256 deploymentTimestamp;
    uint256 lockTime;

    address erc20Addr;
    
    uint constant MINIMUM_VALUE=10*10**18; //usd值
         //构造函数，引入后调用
    constructor(uint256 _lockTime){
        //sepolai testnet;
       dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
       owner = msg.sender;
       deploymentTimestamp=block.timestamp;
       _lockTime=lockTime;
    }


    function fund() external payable{
        // 判断交易值的大小是否小于最小值，require函数
        // require(condition，"xxxx");
        // 函数自动判断condition的布尔值，如果是否就revert,并执行xxx
        // revert 会返回所有的gas
        // 如果是true，继续执行
        require(convertETHtoUSD(msg.value) >=MINIMUM_VALUE,"send more ETH");

        fundersToAmount[msg.sender]+=msg.value;

    }

    function getChainlinkDataFeedLatestAnswer() public view returns (int256) {
        (
            /* uint80 roundId */,
            int256 answer,
            /*uint256 startedAt*/,
            /*uint256 updatedAt*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }

    function convertETHtoUSD(uint256 ethAmount) internal view returns (uint256) {
        //数量和价格
        uint256 ethPrice = uint256(getChainlinkDataFeedLatestAnswer());
        return ethAmount * ethPrice / 1e8;

    }
    
    function transformOwership(address newOwner) public onlyOwner {
        require(msg.sender==owner,"this cantract can only called by owner");
        owner = newOwner;
    }

    function getFund() external windowClosed onlyOwner  {
    require(convertETHtoUSD(address(this).balance) >= target, "Didn't fund enough");
    require(msg.sender == owner,"this contract can only called by owner");
    //三种转账方式
    //transfer:transfer ETH and revert if tx faild
    //address(地址需要payable,默认所以地址无法payable，需类型转换).transfer(vaule)
    //payable(msg.sender).transfer(address(this).balance);

    //send:transfer ETC return failse id faild
    //bool success=paysalbe(address).send(vaule)  地址需要payable,默认所以地址无法payable，
    //需类型转换
    //bool success=payable(msg.sender).send(address(this).balance);
    //require(success,"tx faild")

    //call(官方推荐)
    //transfer ETH with data return vaule with fanction
    //(bool,)=payable(msg.sender).call(vaule:address(this).balance){""}
    bool success;
    (success,)=payable(msg.sender).call{value: address(this).balance}("");
    require(success,"tx faild");
    //前两个是纯转账，第三个是带数据的,在0.8.x之后transfer和send无法使用
    }
    function refund() external windowClosed{
        require(convertETHtoUSD(address(this).balance) <= target,"money is enough");
        require(fundersToAmount[msg.sender] !=0,"there is no fund for ");
        fundersToAmount [msg.sender]=0;
        bool success;
        (success,)=payable(msg.sender).call{value:fundersToAmount[msg.sender] }("");
        require(success,"tx faild");

    }
    
    function setFundersToAmount(address funder, uint256 amountToUpdate) external{
        require(msg.sender == erc20Addr, "you do not have permission to call this funtion");
        fundersToAmount[funder] = amountToUpdate;
        
    }
    function setErc20Addr(address _erc20Addr) public onlyOwner {
        erc20Addr = _erc20Addr;
    }

    modifier windowClosed() {
        require(block.timestamp >= deploymentTimestamp + lockTime, "window is not closed");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "this function can only be called by owner");
        _;
    }
}