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

        function approve(address _spender, uint _value) override {

        // To change the approve amount you first have to reduce the addresses`
        //  allowance to zero by calling `approve(_spender, 0)` if it is not
        //  already 0 to mitigate the race condition described here:
        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
        uint256 allowanced = allowance(msg.sender, _spender);
        require(!((_value != 0) && (allowanced != 0)), 'value 0 or allowance ! 0');

        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
    }
}
