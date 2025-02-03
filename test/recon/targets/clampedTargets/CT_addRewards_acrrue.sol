// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {RewardsManager} from "src/RewardsManager.sol";
// import {BeforeAfter} from "../../BeforeAfter.sol";
// import {Properties} from "../../Properties.sol";
import {vm} from "@chimera/Hevm.sol";
import {TargetHelper} from "../TargetHelper.sol";
import {UCT_addRewards_accrue} from "./unclampedTargets/UCT_addRewards_accrue.sol";
import {Switches} from "../Switches.sol";
import {console} from "forge-std/console.sol";

abstract contract CT_addRewards_acrrue is UCT_addRewards_accrue, TargetHelper, Switches {
    //NOTE add state var for epochs

    function rewardsManager_clamped_notifyTransfer(uint256 amt) public {
        rewardsManager_notifyTransfer(currentUser, users[amt % users.length], amt);
    }

    function rewardsManager_clamped_notifyTransferDeposit(uint256 amt) public {
        rewardsManager_notifyTransfer(address(0), currentUser, amt);
    }

    function rewardsManager_clamped_notifyTransferWithdraw(uint256 amt) public {
        rewardsManager_notifyTransfer(currentUser, address(0), amt);
    }

    // Add Rewards
    function rewardsManager_clamped_addReward(uint256 amt) public {
        rewardsManager_addReward(currentUpcomingEpoch, amt);
    }

    function rewardsManager_clamped_addBulkRewards(uint256 epochStart) public {
        (uint256 epochStart, uint256 epochEnd) = _return_upcoming_EpochStartEnd(epochStart);
        uint256 totalEpochs = (epochEnd - epochStart) + 1;
        uint256[] memory amounts = generateAmounts(totalEpochs); //NOTE max (1000-1) eth

        rewardsManager_addBulkRewards(epochStart, epochEnd, amounts);
    }

    function rewardsManager_clamped_addBulkRewardsLinearly(uint256 epochStart, uint256 total) public {
        (uint256 epochStart, uint256 epochEnd) = _return_upcoming_EpochStartEnd(epochStart);

        rewardsManager_addBulkRewardsLinearly(epochStart, epochEnd, total);
    }

    // function rewardsManager_getVaultNextEpochInfo() public {
    //     //ended epochs
    //     RewardsManager.UserInfo memory info = rewardsManager.getUserNextEpochInfo(currentEpochEnd, currentVault, currentUser, 0);
    //     uint256 uETP = info.userEpochTotalPoints;
    //     t(uETP == 0, 'QnD canary');

    // }
}
