// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {Properties} from "../../../Properties.sol";
import {RewardsManager} from "src/RewardsManager.sol";
import {TargetHelper} from "../../TargetHelper.sol";
import {vm} from "@chimera/Hevm.sol";

abstract contract UCT_Claim is BaseTargetFunctions, Properties, TargetHelper {
    function rewardsManager_claimReward(uint256 epochId) public {
        rewardsManager.claimReward(epochId, currentVault, currentToken, currentUser);
    }

    function rewardsManager_claimBulkTokensOverMultipleEpochs(uint256 epochStart, uint256 epochEnd) public tracking {
        rewardsManager.claimBulkTokensOverMultipleEpochs(epochStart, epochEnd, currentVault, tokens, currentUser);
    }

    function rewardsManager_claimRewardEmitting(uint256 epochId) public {
        rewardsManager.claimRewardEmitting(epochId, currentVault, currentToken, currentUser);
    }

    function rewardsManager_claimRewardReferenceEmitting(uint256 epochId) public tracking {
        rewardsManager.claimRewardReferenceEmitting(epochId, currentVault, currentToken, currentUser);
    }

    function rewardsManager_reap(RewardsManager.OptimizedClaimParams memory params) public handleReapTear {
        rewardsManager.reap(params);
    }

    function rewardsManager_tear(RewardsManager.OptimizedClaimParams memory params) public handleReapTear {
        rewardsManager.tear(params);
    }
}
