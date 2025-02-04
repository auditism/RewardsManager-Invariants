// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {TargetFunctions} from "./TargetFunctions.sol";
import {FoundryAsserts} from "@chimera/FoundryAsserts.sol";
import {RewardsManager} from "src/RewardsManager.sol";
import "forge-std/console.sol";
// forge test --match-test test_crytic

contract CryticToFoundry is Test, TargetFunctions, FoundryAsserts {
    function setUp() public {
        setup();
    }

    function test_crytic() public {
        pushEpoch();
        pushEpoch();
        pushEpoch();

        switch_epochs(0, 1, 0);

        switch_user(0);
        switch_vault(0);
        switch_token(0);
        mintTokens(1000e18);
        rewardsManager_clamped_addReward(10e18);
        rewardsManager_clamped_notifyTransfer_Deposit(1e18);

        pushEpoch();
        pushEpoch();
        pushEpoch();

        switch_epochs(1, 50, 33);

        RewardsManager.OptimizedClaimParams memory parameter = _return_OptimizedClaimParams();
        rewardsManager.tear(parameter);
    }


}
