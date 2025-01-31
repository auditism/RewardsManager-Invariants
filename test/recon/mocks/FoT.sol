// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FoT is ERC20 {
    constructor() ERC20("Example token", "TKN") {}

    function mint(address to, uint256 amount) public virtual {
        _mint(to, amount);
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address sender = _msgSender();
        _executeTransfer(sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _executeTransfer(from, to, amount);
        return true;
    }

    function _executeTransfer(address from, address to, uint256 amount) internal {
        uint256 fee = (amount * 500) / 10_000;
        _transfer(from, address(123), fee);
        _transfer(from, to, amount - fee);
    }
}
