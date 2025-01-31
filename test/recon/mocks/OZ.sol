// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OZ is ERC20 {
    constructor() ERC20("Example token", "TKN") {}

    function mint(address to, uint256 amount) public virtual {
        _mint(to, amount);
    }
}
