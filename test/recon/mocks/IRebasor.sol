// OpenZeppelin Contracts (last updated v5.1.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.20;

interface IRebasor {
    function rebaseDown(address rebasee, uint256 percentage) external;
    function rebaseUp(address rebasee, uint256 percentage) external;
}
