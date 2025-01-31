// OpenZeppelin Contracts (last updated v5.1.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IMint {
    function mint(address receiver, uint256 amt) external;
    function approve(address receiver, uint256 amt) external;
}
