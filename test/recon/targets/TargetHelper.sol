// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {Properties} from "../Properties.sol";
import {RewardsManager} from "src/RewardsManager.sol";
import {console} from "forge-std/console.sol";
import {IMint} from "../mocks/IMint.sol";

abstract contract TargetHelper is BaseTargetFunctions, Properties {
    // NOTE returns epoch < currentEpoch
    function _endedEpochs(uint256 epoch) internal returns (uint256) {
        return epoch % rewardsManager.currentEpoch();
    }
    //NOTE returns upcommingEpoch >= Epoch

    function _return_upcomingEpoch(uint256 epoch) internal returns (uint256) {
        epoch = epoch % 5000;
        uint256 currentEpoch = rewardsManager.currentEpoch();
        if (epoch < currentEpoch) {
            return epoch + currentEpoch;
        } else {
            return epoch;
        }
    }

    //NOTE returns array of length with random inputs < 1000 eth
    function _generateAmounts(uint256 length) internal view returns (uint256[] memory) {
        uint256[] memory _amounts = new uint256[](length);

        for (uint256 i = 0; i < length; i++) {
            _amounts[i] = uint256(keccak256(abi.encode(block.timestamp, i))) % 1000 ether;
        }
        return _amounts;
    }

    //NOTE returns epochStart <= epochEnd < currentEpoch
    function _return_epoch_start_end(uint256 epochEnd, uint256 epochStart) internal returns (uint256, uint256) {
        epochEnd = _endedEpochs(epochEnd);
        epochStart %= epochEnd + 1;
        return (epochEnd, epochStart);
    }
    //NOTE returns struct

    function _return_OptimizedClaimParams() public returns (RewardsManager.OptimizedClaimParams memory parameter) {
        parameter = RewardsManager.OptimizedClaimParams({
            epochStart: currentEpochStart,
            epochEnd: currentEpochEnd,
            vault: currentVault,
            tokens: tokens
        });
        return parameter;
    }

    //NOTE return currentEpoch <= epochStart <= epochEnd

    function _return_upcoming_EpochStartEnd(uint256 epochStart) internal returns (uint256, uint256 epochEnd) {
        uint256 currentEpoch = rewardsManager.currentEpoch();
        epochEnd = currentUpcomingEpoch;

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

    function _clamp_rewards_sent(uint256 amt) internal returns (uint256) {
        uint256 balance = IMint(currentToken).balanceOf(address(this));
        return amt %= balance + 1;
    }

    // NOTE length arrays with epochs, users, tokens, vaults.
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

            uint256 userIndex = uint256(keccak256(abi.encode(seed, i))) % users.length;
            selectedUsers[i] = users[userIndex];

            uint256 tokenIndex = uint256(keccak256(abi.encode(seed, i))) % tokens.length;
            claimTokens[i] = tokens[tokenIndex];

            uint256 vaultIndex = uint256(keccak256(abi.encode(seed, i))) % vaults.length;
            claimVault[i] = vaults[vaultIndex];
        }
    }
}
