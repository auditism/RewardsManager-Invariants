// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
// import {BeforeAfter} from "./BeforeAfter.sol";
import {Properties} from "../Properties.sol";
import {vm} from "@chimera/Hevm.sol";
import {IMint} from "../mocks/IMint.sol";
import {TargetHelper} from "./TargetHelper.sol";

abstract contract Switches is BaseTargetFunctions, Properties, TargetHelper {
    //probably need a function to warp time with the fuzza block.timestap + amount

    function addHalfEpoch() public {
        if (timestamp < 3.156e9) {
            //@NOTE 100 years
            timestamp += (604800 / 2); //NOTE add half epoch
            vm.warp(timestamp);
        }
    }

    function switch_vault(uint256 index) public {
        currentVault = vaults[index % vaults.length];
    }

    function switch_user(uint256 index) public {
        currentUser = users[index % users.length];
    }

    function switch_token(uint256 index) public {
        currentToken = tokens[index % tokens.length];
    }

    function mintTokens(uint256 amt) public {
        IMint(currentToken).mint(address(this), amt);
        IMint(currentToken).approve(address(rewardsManager), amt);
    }

    function switch_epochs(uint256 epochStart, uint256 epochEnd, uint256 upcomingEpoch) public {
        (epochEnd, epochStart) = return_epoch_start_end(epochEnd, epochStart);
        currentUpcomingEpoch = return_upcomingEpoch(upcomingEpoch);
        currentEpochStart = epochStart;
        currentEpochEnd = epochEnd;
    }
}
