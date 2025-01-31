// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {Properties} from "../Properties.sol";
import {RewardsManager} from "src/RewardsManager.sol";
import {console} from "forge-std/console.sol";

abstract contract TargetHelper is BaseTargetFunctions, Properties {
    function upToThisEpoch(uint256 epoch) internal returns (uint256) {
        return epoch % rewardsManager.currentEpoch() + 1;
    }

    function endedEpochs(uint256 epoch) internal returns (uint256) {
        return epoch % rewardsManager.currentEpoch();
    }

    function return_upcomingEpoch(uint256 epoch) internal returns (uint256) {
        epoch = epoch % 5000;
        uint256 currentEpoch = rewardsManager.currentEpoch();
        if (epoch < currentEpoch) {
            return epoch + currentEpoch;
        } else {
            return epoch; // Or another logic for this case
        }
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
    //NOTE We want it to return currentEpoch >= epochStart >= epochEnd

    function _return_upcoming_EpochStartEnd(uint256 epochStart) internal returns (uint256, uint256 epochEnd) {
        uint256 currentEpoch = rewardsManager.currentEpoch(); // 4
        epochEnd = currentUpcomingEpoch; // 5
            // epochStart = 6; // 6

        if (epochStart > epochEnd) {
            // Swap them if start is less than end
            (epochStart, epochEnd) = (epochEnd, epochStart);
        }

        // Then clamp epochStart to be >= currentEpoch
        if (epochStart < currentEpoch) {
            epochStart = currentEpoch;
        }
        return (epochStart, epochEnd);
    }

    function _generateClaimInput(uint256 length)
        internal
        returns (
            uint256[] memory epochs,
            address[] memory selectedUsers,
            address[] memory claimTokens,
            address[] memory claimVault
        )
    {
        uint256 currentEpoch = rewardsManager.currentEpoch();

        epochs = new uint256[](length);
        selectedUsers = new address[](length);
        claimTokens = new address[](length);
        claimVault = new address[](length);

        bytes32 seed = keccak256(abi.encode(block.timestamp));

        for (uint256 i = 0; i < length; i++) {
            epochs[i] = uint256(keccak256(abi.encode(seed, i))) % currentEpoch;

            uint256 userIndex = uint256(keccak256(abi.encode(seed, i))) % 4;
            selectedUsers[i] = users[userIndex];

            uint256 tokenIndex = uint256(keccak256(abi.encode(seed, i))) % 6;
            claimTokens[i] = tokens[tokenIndex];

            uint256 vaultIndex = uint256(keccak256(abi.encode(seed, i))) % 4;
            claimVault[i] = vaults[vaultIndex];
        }
    }
}
