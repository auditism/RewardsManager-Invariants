// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {RewardsManager} from "src/RewardsManager.sol";
import {Switches} from "../Switches.sol";
import {TargetHelper} from "../TargetHelper.sol";
import {UCT_addRewards_accrue} from "./unclampedTargets/UCT_addRewards_accrue.sol";
import {vm} from "@chimera/Hevm.sol";

abstract contract CT_addRewards_acrrue is UCT_addRewards_accrue, TargetHelper, Switches {
    //NOTE add state var for epochs

    function rewardsManager_clamped_notifyTransfer(uint256 amt) public {
        rewardsManager_notifyTransfer(currentUser, users[amt % users.length], amt);
    }

    function rewardsManager_clamped_notifyTransfer_Deposit(uint256 amt) public {
        rewardsManager_notifyTransfer(address(0), currentUser, amt);
    }

    function rewardsManager_clamped_notifyTransfer_Withdraw(uint256 amt) public {
        rewardsManager_notifyTransfer(currentUser, address(0), amt);
    }

    // Add Rewards //
    function rewardsManager_clamped_addReward(uint256 amt) public {
        amt = _clamp_rewards_sent(amt);
        rewardsManager_addReward(currentUpcomingEpoch, amt);
    }

    function rewardsManager_clamped_addBulkRewards(uint256 epochStart) public {
        (uint256 epochStart, uint256 epochEnd) = _return_upcoming_EpochStartEnd(epochStart);
        uint256 totalEpochs = (epochEnd - epochStart) + 1;
        uint256[] memory amounts = _generateAmounts(totalEpochs); //NOTE max (1000-1) eth per epoch

        rewardsManager_addBulkRewards(epochStart, epochEnd, amounts);
    }

    function rewardsManager_clamped_addBulkRewardsLinearly(uint256 epochStart, uint256 total) public {
        total = _clamp_rewards_sent(total);
        (uint256 epochStart, uint256 epochEnd) = _return_upcoming_EpochStartEnd(epochStart);

        rewardsManager_addBulkRewardsLinearly(epochStart, epochEnd, total);
    }
}
