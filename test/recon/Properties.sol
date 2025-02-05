// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Asserts} from "@chimera/Asserts.sol";
import {BeforeAfter} from "./BeforeAfter.sol";
import {IMint} from "./mocks/IMint.sol";
abstract contract Properties is BeforeAfter, Asserts {
    function property__invariant() public {
        uint256 rewards = rewardsManager.rewards(currentEpochEnd, currentVault, currentToken);
        uint256 rewardsBalance = IMint(currentToken).balanceOf(address(rewardsManager));
        t(rewardsBalance >= rewards, 'Rewards balance should always be >= reward');
        //NOTE  this could fail but who knows after how long, it would be better to track all 
        // the actual claimable rewards and the balance of the contract..
    }
}
