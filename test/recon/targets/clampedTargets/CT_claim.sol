// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {RewardsManager} from "src/RewardsManager.sol";
// import {BeforeAfter} from "../../BeforeAfter.sol";
// import {Properties} from "../../Properties.sol";
import {vm} from "@chimera/Hevm.sol";
import {TargetHelper} from "../TargetHelper.sol";
import {UCT_Claim} from "./unclampedTargets/UCT_Claim.sol";

abstract contract CT_claim is UCT_Claim {
    function rewardsManager_clamped_claimReward() public {
        rewardsManager_claimReward(currentEpochEnd);
    }

    function rewardsManager_claimRewardS(uint256 amt) public {
        (
            uint256[] memory epochs,
            address[] memory selectedUsers,
            address[] memory claimTokens,
            address[] memory claimVault
        ) = _generateClaimInput(amt);

        rewardsManager.claimRewards(epochs, selectedUsers, claimTokens, claimVault);
    }

    function rewardsManager_clamped_claimBulkTokensOverMultipleEpochs() public {
        rewardsManager_claimBulkTokensOverMultipleEpochs(currentEpochStart, currentEpochEnd);
    }

    function rewardsManager_clamped_claimRewardEmitting() public {
        rewardsManager_claimRewardEmitting(currentEpochEnd);
    }

    function rewardsManager_clamped_claimRewardReferenceEmitting() public {
        rewardsManager_claimRewardReferenceEmitting(currentEpochEnd);
    }

    function rewardsManager_clamped_reap() public {
        RewardsManager.OptimizedClaimParams memory parameters = _return_OptimizedClaimParams();
        rewardsManager_reap(parameters);
    }

    function rewardsManager_clamped_tear() public {
        RewardsManager.OptimizedClaimParams memory parameters = _return_OptimizedClaimParams();
        rewardsManager_tear(parameters);
    }
}
