// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract LessonFifteen {
    string private constant LESSON_IMAGE = "ipfs://QmduEWfVtmNnznWwEwesbG6xVrKMRfCGdoDkMnRWPNd12F";

    VulnerableContract private immutable i_vulnerableContract;

    constructor() {
        i_vulnerableContract = new VulnerableContract();
    }

    /*
     * CALL THIS FUNCTION!
     * 
     * @param your exploit address
     * @param the selector you want to use
     * @param yourTwitterHandle - Your twitter handle. Can be a blank string.
     */
    function solveChallenge(address yourAddress, bytes4 selector) external returns (bool) {
        if (OtherContract(yourAddress).getOwner() != msg.sender) {
            revert CourseCompletedNFT__NotOwnerOfOtherContract();
        }
        bool returnedOne = i_vulnerableContract.callContract(yourAddress);
        bool returnedTwo = i_vulnerableContract.callContractAgain(yourAddress, selector);

        if (!returnedOne && !returnedTwo) {
            revert CourseCompletedNFT__Nope();
        }
        return true;
    }

    function getHelper() public view returns (address) {
        return address(i_vulnerableContract);
    }
}

interface OtherContract {
    function getOwner() external returns (address);
}

contract VulnerableContract {
    uint256 public s_variable = 0;
    uint256 public s_otherVar = 0;

    function callContract(address yourAddress) public returns (bool) {
        (bool success,) = yourAddress.delegatecall(abi.encodeWithSignature("doSomething()"));
        require(success);
        if (s_variable != 123) {
            revert VulnerableContract__NopeCall();
        }
        s_variable = 0;
        return true;
    }

    function callContractAgain(address yourAddress, bytes4 selector) public returns (bool) {
        s_otherVar = s_otherVar + 1;
        (bool success,) = yourAddress.call(abi.encodeWithSelector(selector));
        require(success);
        if (s_otherVar == 2) {
            return true;
        }
        s_otherVar = 0;
        return false;
    }
}

error CourseCompletedNFT__Nope();
error VulnerableContract__Nope();
error VulnerableContract__NopeCall();
error CourseCompletedNFT__NotOwnerOfOtherContract();
