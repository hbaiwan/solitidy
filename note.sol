// SPDX-License-Identifier: MIT
//version
pragma solidity ^0.8.20;
contract HelloWorld{
    bool boolVar_1 = true;
    bool boolVar_2 =false;
    uint unitVar=2;
    //u是无符号的意思
    //unit256 是(0-2^256-1)
    int intVar=-1;
    //int可以存负数
    //bytes(数字)数字代表可以存储存储几个字节
    //最大是32,存贮字符串的 
    bytes32 bytes32Var="HelloWorld";
    //string是动态的bytes
    string strVar="Hello World";
    //address是地址
    address addVar=0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    //函数 function 括号内 参数输入
    //可见度标识符 在合约内部，和子合约interal，只被合约外部调,其他账户用exteral
    //public prevate（仅合约内部）
    //范围分四个 合约内部 合约外部 子合约 外部账户
    //view 是只读   
   function sayHello() public view returns (string memory) {
    return addinfo(strVar);
    }
    function setsayHello(string memory newString) public {
    strVar = newString;
    }
    function addinfo(string memory HelloWorldstr) internal pure returns ( string memory){
        return string.concat(HelloWorldstr," from Frank cantract.") ;
    }

//  存储模式   
// 1.storage  永久性存储 不可再更改
// 
// 2.memory  暂时性存储
// 3.calldata 暂时性存储
// 4.stack
// 5.codes
// 6.logs

// 数据类型 
// struct 结构体
// array 数组
// mapping 映射 键值对
// import {HelloWoeld} from ''
// 引入
// 1.直接引入本地文件下的合约   ./
// 2.引入网上公开的合约  直接写url
// 3.引入其他公司的一些合约,通过包引入  @campanyName(公司名)/product(产品名)/contract

}
