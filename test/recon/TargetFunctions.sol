// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

// import {TargetHelper} from "./targets/TargetHelper.sol";`
import {Switches} from "./targets/Switches.sol";

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {BeforeAfter} from "./BeforeAfter.sol";
import {Properties} from "./Properties.sol";
import {vm} from "@chimera/Hevm.sol";
import {CT_addRewards_acrrue} from "./targets/clampedTargets/CT_addRewards_acrrue.sol";
import {CT_claim} from "./targets/clampedTargets/CT_claim.sol";
import {RewardsManager} from "src/RewardsManager.sol";

abstract contract TargetFunctions is Switches, CT_addRewards_acrrue, CT_claim {}
