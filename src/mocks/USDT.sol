// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title TestnetERC20
 * @dev ERC20 minting logic
 */
abstract contract TetherToken is ERC20, Ownable {
    // Map of address nonces (address => nonce)
    mapping(address => uint256) internal _nonces;

    constructor() ERC20("TETHER", "USDT") Ownable(msg.sender) {
        transferOwnership(msg.sender);
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }
    /**
     * @dev Function to mint tokens
     * @param value The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */

    function mint(uint256 value) public virtual onlyOwner returns (bool) {
        _mint(_msgSender(), value);
        return true;
    }

    /**
     * @dev Function to mint tokens to address
     * @param account The account to mint tokens.
     * @param value The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address account, uint256 value) public virtual returns (bool) {
        _mint(account, value);
        return true;
    }

    function nonces(address owner) public view returns (uint256) {
        return _nonces[owner];
    }
}
