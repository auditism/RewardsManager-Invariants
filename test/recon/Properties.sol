// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Asserts} from "@chimera/Asserts.sol";
import {BeforeAfter} from "./BeforeAfter.sol";
import {IMint} from "./mocks/IMint.sol";
import {PropertyHelper} from "./PropertyHelper.sol";
import {RewardsManager} from "src/RewardsManager.sol";

abstract contract Properties is BeforeAfter, Asserts, PropertyHelper {
    function property_points_soundness() public {
        //maybe fails
        // if reap and tear delete points, consider adding a bool if it got hit during that epoch and we sub it ?
        uint256 userSum = _user_points_sum();
        lte(userSum, rewardsManager.totalPoints(currentEpochEnd, currentVault), "user sum bigger than total sum");
        //NOTE why lte and not eq you may ask ? that's a good q
    }

    function property_sumShare_is_totalSupply() public {
        //maybe fails
        uint256 sumUserShares = _sum_user_shares();
        (uint256 totalShares,) = rewardsManager.getTotalSupplyAtEpoch(currentEpochEnd, currentVault);
        eq(sumUserShares, totalShares, "shares don't match totalSupply");
    }

    function property_doomsday_withdraw() public {
        uint256 userClaimableRewards = _claimableRewards();
        lte(userClaimableRewards, IMint(currentToken).balanceOf(address(rewardsManager)), "protocol is insolvent");
    } //NOTE This one should break because of rebasor::rebaseDown / FoT

    function property_rewards_received_match_points() public {
        //only claimRewardReferenceEmitting & claimBulkTokensOverMultipleEpochs
        uint256 userEpochPoints = rewardsManager.points(currentEpochEnd, currentVault, currentUser);
        uint256 epochPoints = rewardsManager.totalPoints(currentEpochEnd, currentVault);
        uint256 epochRewards = rewardsManager.rewards(currentEpochEnd, currentVault, currentToken);
        uint256 expectedUserRewards = (userEpochPoints * epochRewards) / epochPoints;
        uint256 claimedRewards = _after.balance - _before.balance;
        eq(expectedUserRewards, claimedRewards, "Rewards Amounts do not match");
        //NOTE if there is no accrual, we have to copy the function's math ?
    }

    // NOTE This property verifies shares * timeInEpoch
    function property_points_calculation() public {
       //FAILS
        uint256 userShares = rewardsManager.shares(currentEpochEnd, currentVault, currentUser);
        uint256 maxTime;
        uint256 startTime;

        if (userShares != 0) {
            //User has accrued / deposited
            uint256 lastBalanceChangeTime =
                rewardsManager.lastUserAccrueTimestamp(currentEpochEnd, currentVault, currentUser);
            RewardsManager.Epoch memory epochData = rewardsManager.getEpochData(currentEpochEnd);
            maxTime = epochData.endTimestamp; // currentEpochEnd < currentEpoch
            startTime = lastBalanceChangeTime == 0 ? epochData.startTimestamp : lastBalanceChangeTime;
        }
        uint256 points = (maxTime - startTime) * userShares;
        eq(points, rewardsManager.points(currentEpochEnd, currentVault, currentUser), "points mismatch");
    }

    function _user_points_sum() internal returns (uint256 userSumPoints) {
        for (uint256 i; i < users.length; i++) {
            userSumPoints += rewardsManager.points(currentEpochEnd, currentVault, users[i]);
            if (hasUsedReap[currentEpochEnd][currentVault][currentUser]) {
                userSumPoints += tearedReapedPoints[currentEpochEnd][currentVault][currentUser];
            }
        }
        return userSumPoints;
    }

    function _sum_user_shares() internal returns (uint256 sumShares) {
        for (uint256 i; i < users.length; i++) {
            (uint256 userBalance,) = rewardsManager.getBalanceAtEpoch(currentEpochEnd, currentVault, users[i]);
            sumShares += userBalance; //NOTE can I trust the contract's function?
            sumShares += tearedReapedShares[currentEpochEnd][currentVault][users[i]];
        }
        return sumShares;
    }

    function _claimableRewards() internal returns (uint256 availableRewards) {
        uint256 currentEpoch = rewardsManager.currentEpoch();
        for (uint256 i; i < users.length; i++) {
            for (uint256 j = 1; j < rewardsManager.currentEpoch(); i++) {
                //NOTE can I loop through all epochs ?
                uint256 userEpochPoints = rewardsManager.points(j, currentVault, users[i]);
                uint256 userEpochWithdrawn = rewardsManager.pointsWithdrawn(j, currentVault, users[i], currentToken);
                uint256 epochRewards = rewardsManager.rewards(j, currentVault, currentToken);

                availableRewards +=
                    (userEpochPoints - userEpochWithdrawn) * epochRewards / rewardsManager.totalPoints(j, currentVault);
            }
        }
    }
}
