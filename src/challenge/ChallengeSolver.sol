// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract VulnerableContract {
    uint256 public s_variable = 0;
    uint256 public s_otherVar = 0;

    address private immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function doSomething() public {
        s_variable = 123;
        s_otherVar = 6;
    }

    //* selector: 0x54fc2cb2
    function doSomethingElse() public {}

    function getOwner() external view returns (address) {
        return i_owner;
    }
}
