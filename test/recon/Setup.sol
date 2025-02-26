// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseSetup} from "@chimera/BaseSetup.sol";
import {FoT} from "./mocks/FoT.sol";
import {OZ} from "./mocks/OZ.sol";
import {RewardsManager} from "src/RewardsManager.sol";
import {Solady} from "./mocks/Solady.sol";
import {Solmate} from "./mocks/Solmate.sol";
import {stETH} from "./mocks/stETH.sol";
import {USDT} from "./mocks/USDT.sol";
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
    uint256 currentEpochStart; // NOTE epochStart <= epochEnd < currentEpoch | only used 3 times, is it necessary it to have as state v?
    //update : tried to remove it but it made things uglier so we gon keep it
    uint256 currentEpochEnd; // NOTE epochEnd < currentEpoch
    uint256 currentUpcomingEpoch; // NOTE currentUpcomingEpoch >= currentEpoch

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
