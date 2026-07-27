// SPDX-License-Identifier: MIT
//version
pragma solidity ^0.8.20;
contract HelloWorld {
    string strVar = "Hello World";
  
    struct Info {
        string phrase;
        uint256 id;
        address addr;
    }

    Info[] infos;

    mapping(uint256 id => Info info) infoMapping;
  
    function sayHello(uint256 _id) public view returns(string memory) {
    for (uint256 i = 0; i < infos.length; i++) {
        if (infos[i].id == _id) {
            return infos[i].phrase;
        }
    }
    return "no info found";
}
    
    function setHelloWorld(string memory newString, uint256 _id) public {
        Info memory info = Info(newString, _id, msg.sender);
        infos.push(info);
    }


    function addinfo(string memory helloWorldStr) internal pure returns(string memory) {
        return string.concat(helloWorldStr, " from Frank's contract.");
    }
}
