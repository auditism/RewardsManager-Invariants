// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Setup} from "./Setup.sol";
import {IMint} from "./mocks/IMint.sol";


// ghost variables for tracking state variable values before and after function calls
abstract contract BeforeAfter is Setup {
// should I track rewards per epoch  ??

struct Vars {
    uint256 balance;
}



Vars internal _before;
Vars internal _after;

modifier tracking() {
    __before();
    _;
    __after();
}

function __before() internal {
    _before.balance = IMint(currentToken).balanceOf(currentUser);
}

function __after() internal {
    _after.balance = IMint(currentToken).balanceOf(currentUser);

}
}
