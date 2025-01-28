// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseSetup} from "@chimera/BaseSetup.sol";
import {RewardsManager} from "src/RewardsManager.sol";

abstract contract Setup is BaseSetup {
    RewardsManager rewardsManager;

    function setup() internal virtual override {
        rewardsManager = new RewardsManager();
    }
}
