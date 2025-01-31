// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {RewardsManager} from "src/RewardsManager.sol";
// import {BeforeAfter} from "../BeforeAfter.sol";
import {Properties} from "../../../Properties.sol";
import {vm} from "@chimera/Hevm.sol";
import {TargetHelper} from "../../TargetHelper.sol";

abstract contract UCT_addRewards_accrue is BaseTargetFunctions, Properties {
    function rewardsManager_notifyTransfer(address from, address to, uint256 amount) public onlyVault {
        rewardsManager.notifyTransfer(from, to, amount);
    }

    //ACCRUE

    function rewardsManager_accrueUser(uint256 epochId) public {
        rewardsManager.accrueUser(epochId, currentVault, currentUser);
    }

    function rewardsManager_accrueVault(uint256 epochId) public {
        rewardsManager.accrueVault(epochId, currentVault);
    }

    //ADDBULK

    function rewardsManager_addBulkRewards(uint256 epochStart, uint256 epochEnd, uint256[] memory amounts) public {
        rewardsManager.addBulkRewards(epochStart, epochEnd, currentVault, currentToken, amounts);
    }

    function rewardsManager_addBulkRewardsLinearly(uint256 epochStart, uint256 epochEnd, uint256 total) public {
        rewardsManager.addBulkRewardsLinearly(epochStart, epochEnd, currentVault, currentToken, total);
    }

    //ADD REWARDS

    function rewardsManager_addReward(uint256 epochId, uint256 amount) public {
        rewardsManager.addReward(epochId, currentVault, currentToken, amount); //NOTE Epoch must be bigger
    }
}
