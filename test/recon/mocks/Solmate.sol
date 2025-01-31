// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import {ERC20} from "lib/solmate/src/tokens/ERC20.sol";

contract Solmate is ERC20 {
    constructor() ERC20("Example token", "TKN", 18) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
