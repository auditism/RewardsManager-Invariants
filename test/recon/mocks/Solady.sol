// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import {ERC20} from "lib/solady/src/tokens/ERC20.sol";

contract Solady is ERC20 {
    function name() public view override returns (string memory) {
        return "Solady";
    }

    function symbol() public view override returns (string memory) {
        return "FTG";
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
