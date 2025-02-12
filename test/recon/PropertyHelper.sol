// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BeforeAfter} from "./BeforeAfter.sol";

contract PropertyHelper is BeforeAfter {
    //        epochId             vault           user        used
    mapping(uint256 => mapping(address => mapping(address => bool))) public hasUsedReap;
    //        epochId             vault            user        points
    mapping(uint256 => mapping(address => mapping(address => uint256))) public tearedReapedPoints;

    mapping(uint256 => mapping(address => mapping(address => uint256))) public tearedReapedShares;

    modifier handleReapTear() {
        _populateMappingPoints();
        _populateMappingBool();
        _;
    }

    function _populateMappingBool() internal {
        uint256 loopLength = currentEpochEnd - currentEpochStart;
        for (uint256 i; i <= loopLength; i++) {
            hasUsedReap[currentEpochStart + i][currentVault][currentUser] = true;
        }
    }

    function _populateMappingPoints() internal {
        uint256 loopLength = currentEpochEnd - currentEpochStart;
        for (uint256 i; i <= loopLength; i++) {
            uint256 points = rewardsManager.points(currentEpochEnd, currentVault, currentUser);
            tearedReapedPoints[currentEpochStart + i][currentVault][currentUser] = points;
        }
    }

    function _adjustShare() internal {
        uint256 shares = rewardsManager.shares(currentEpochEnd, currentVault, currentUser);
        tearedReapedShares[currentEpochStart][currentVault][currentUser] += shares;
    }
}
