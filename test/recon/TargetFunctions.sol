// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {vm} from "@chimera/Hevm.sol";
import {CT_addRewards_acrrue} from "./targets/clampedTargets/CT_addRewards_acrrue.sol";
import {CT_claim} from "./targets/clampedTargets/CT_claim.sol";

abstract contract TargetFunctions is CT_addRewards_acrrue, CT_claim {}
