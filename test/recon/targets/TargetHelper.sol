// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {Properties} from "../Properties.sol";
import {RewardsManager} from "src/RewardsManager.sol";


abstract contract TargetHelper is BaseTargetFunctions, Properties {
    function upToThisEpoch(uint256 epoch) internal returns (uint256) {
        return epoch % rewardsManager.currentEpoch() + 1;
    }

    function endedEpochs(uint256 epoch) internal returns (uint256) {
        return epoch % rewardsManager.currentEpoch();
    }

    function return_upcomingEpoch(uint256 epoch) internal returns (uint256) {
        epoch = epoch % 5000; //100 years
        if (epoch < rewardsManager.currentEpoch()) return epoch + rewardsManager.currentEpoch();
    }

    function generateAmounts(uint256 length) internal view returns (uint256[] memory) {
        uint256[] memory _amounts = new uint256[](length);
        for (uint256 i = 0; i < length; i++) {
            _amounts[i] = uint256(keccak256(abi.encode(block.timestamp, i))) % 1000 ether;
        }
        return _amounts;
    }

    function return_epoch_start_end(uint256 epochEnd, uint256 epochStart) internal returns (uint256, uint256) {
        epochEnd = endedEpochs(epochEnd);
        epochStart %= epochEnd + 1;
        return (epochEnd, epochStart);
    }

    function return_OptimizedClaimParams() public returns (RewardsManager.OptimizedClaimParams memory) {
        RewardsManager.OptimizedClaimParams memory parameter = RewardsManager.OptimizedClaimParams({
            epochStart: currentEpochStart,
            epochEnd: currentEpochEnd,
            vault: currentVault,
            tokens: tokens
        });
    }

    function _return_upcoming_EpochStartEnd(uint256 epoch) internal returns (uint256 epochStart, uint256 epochEnd) {
    uint256 currentEpoch = rewardsManager.currentEpoch();
    uint256 epochEnd = currentUpcomingEpoch;

    (epochStart, epochEnd) = epoch > epochEnd 
        ? (epochEnd, epoch) 
        : (epoch, epochEnd);

    epochStart = epochStart < currentEpoch ? currentEpoch : epochStart;

    // Ensure start <= end (swap if necessary)

}
}
