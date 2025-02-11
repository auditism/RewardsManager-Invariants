// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract Rebasor is ERC20("LIDO", "stETH"), ERC20Burnable {
    function mint(address receiver, uint256 amt) public {
        _mint(receiver, amt);
    }

    function rebaseDown(address rebasee, uint256 percentage) public {
        percentage %= 10_000;
        uint256 balance = balanceOf(rebasee);
        uint256 fee = balance * percentage / 10_000;
        _burn(rebasee, fee);
    }

    function rebaseUp(address rebasee, uint256 percentage) public {
        percentage %= 10_000;
        uint256 balance = balanceOf(rebasee);
        uint256 fee = balance * percentage / 10_000;
        _mint(rebasee, fee);
    }
}
