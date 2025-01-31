// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {TargetFunctions} from "./TargetFunctions.sol";
import {FoundryAsserts} from "@chimera/FoundryAsserts.sol";
import "forge-std/console.sol";
// forge test --match-test test_crytic

contract CryticToFoundry is Test, TargetFunctions, FoundryAsserts {
    function setUp() public {
        setup();
    }

    function test_crytic() public {
        switch_token(0);
        mintTokens(10000e18);
        pushEpoch();
        pushEpoch();
        pushEpoch();
        pushEpoch();
        switch_epochs(5, 15, 5);
        switch_vault(1);
        rewardsManager_clamped_addBulkRewards(6);
    }
}
