// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
// import {BeforeAfter} from "./BeforeAfter.sol";
import {Properties} from "../Properties.sol";
import {vm} from "@chimera/Hevm.sol";
import {IMint} from "../mocks/IMint.sol";
import {IRebasor} from "../mocks/IRebasor.sol";
import {TargetHelper} from "./TargetHelper.sol";
import {console} from "forge-std/console.sol";

abstract contract Switches is BaseTargetFunctions, Properties, TargetHelper {
    //probably need a function to warp time with the fuzza block.timestap + amount

    function pushEpoch() public {
        //NOTE is this necessary ?
        if (timestamp < 3.156e9) {
            //@NOTE 100 years
            timestamp += (604800); //NOTE  epoch
            vm.warp(timestamp);

            //  should also call switchepochs
        }
        // switch_epochs();
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
        (currentEpochEnd, currentEpochStart) = _return_epoch_start_end(epochEnd, epochStart);
        currentUpcomingEpoch = _return_upcomingEpoch(upcomingEpoch);
    }

    function rebaseUp(uint256 amt) public {
        IRebasor(tokens[5]).rebaseUp(address(rewardsManager), amt);
    }

    function rebaseDown(uint256 amt) public {
        IRebasor(tokens[5]).rebaseDown(address(rewardsManager), amt);
    }
}
