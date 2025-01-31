// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseSetup} from "@chimera/BaseSetup.sol";
import {RewardsManager} from "src/RewardsManager.sol";
import {OZ} from "./mocks/OZ.sol";
import {FoT} from "./mocks/FoT.sol";
import {Solady} from "./mocks/Solady.sol";
import {Solmate} from "./mocks/Solmate.sol";
import {USDT} from "./mocks/USDT.sol";
import {stETH} from "./mocks/stETH.sol";
import {vm} from "@chimera/Hevm.sol";

abstract contract Setup is BaseSetup {
    RewardsManager rewardsManager;
    //
    USDT usdt;
    stETH steth;
    Solmate solmate;
    Solady solady;
    OZ oz;
    FoT fot;

    //

    //In Use variables
    address currentVault;
    address currentUser;
    address currentToken;
    uint256 timestamp;

    //EPOCHS in Use
    uint256 currentEpochStart;
    uint256 currentEpochEnd;
    uint256 currentUpcomingEpoch;

    //
    address[] users;
    address[] vaults;
    address[] tokens;

    // USERS
    address owner = address(this);
    address bob = address(123);
    address patrick = address(234);
    address schneider = address(345);
    // VAULTS
    address vaultOne = address(1);
    address vaultTwo = address(2);
    address vaultThree = address(3);
    address vaultFour = address(4);

    modifier onlyVault() {
        vm.prank(currentVault);
        _;
    }

    function setup() internal virtual override {
        rewardsManager = new RewardsManager();

        //USERS
        users.push(owner);
        users.push(bob);
        users.push(schneider);
        users.push(patrick);

        //VAULTS
        vaults.push(vaultOne);
        vaults.push(vaultTwo);
        vaults.push(vaultThree);
        vaults.push(vaultFour);
        //TOKENS
        usdt = new USDT();
        solmate = new Solmate();
        solady = new Solady();
        oz = new OZ();
        steth = new stETH();
        fot = new FoT();

        tokens.push(address(usdt));
        tokens.push(address(solmate));
        tokens.push(address(solady));
        tokens.push(address(oz));
        tokens.push(address(fot));
        tokens.push(address(steth));
    }
}

// OPTIMIZED PARAMS
// RewardsManager.OptimizedClaimParams currentParams {
//     uint256 epochStart,
//     uint256 epochEnd,
//     currentVault,
//     tokens;
// }
