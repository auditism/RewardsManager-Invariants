// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

//NOTE https://github.com/GalloDaSballo/rebased-fee-wrapper-fuzz/blob/main/src/Rebasor.sol

contract FakeRebasableETH {
    uint256 public totalBalance;
    uint256 public totalShares; // All issued shares
    mapping(address => uint256) public sharesOf; // All issued shares

    // shares[account] * _getTotalPooledEther() / _getTotalShares()

    function getSharesByPooledEth(uint256 ethAmount) public view returns (uint256) {
        if (totalBalance == 0) {
            return ethAmount;
        }
        return ethAmount * totalShares / totalBalance;
    }

    function getPooledEthByShares(uint256 sharesAmount) public view returns (uint256) {
        if (totalShares == 0) {
            return 0;
        }
        return sharesAmount * totalBalance / totalShares;
    }

    function addUnderlying(uint256 value) external {
        totalBalance += value;
    }

    function removeUnderlying(uint256 value) external {
        totalBalance -= value;
    }

    function depositAndMint(uint256 value) external returns (uint256 minted) {
        minted = getSharesByPooledEth(value);
        totalBalance += value;
        totalShares += minted;

        sharesOf[msg.sender] += minted;
    }

    function balanceOf(address acc) external view returns (uint256) {
        return getPooledEthByShares(sharesOf[acc]);
    }
}

// https://gist.github.com/rayeaster/99402460c7f990a70594e5b1a697ed88
// contract Rebasor {
//     FakeRebasableETH public STETH;

//     uint256 public stFFPSg; // Global Index
//     uint256 public stFeePerUnitg = 1e18; // Global Fee accumulator per stake unit
//     uint256 public stFeePerUnitgError;

//     uint256 public allShares;
//     uint256 public allStakes;

//     mapping(address => uint256) public sharesDeposited;

//     mapping(address => uint256) public stakes;

//     mapping(address => uint256) public stFFPScdp;

//     mapping(address => uint256) public stFeePerUnitcdp;

//     uint256 lastFeeIndex;
//     uint256 lastIndexTimestamp;
//     uint256 constant public INDEX_UPD_INTERVAL = 43200; // 12 hours

//     // 50%
//     uint256 constant public FEE = 5_000;
//     uint256 constant public MAX_BPS = 10_000;

//     /**
//         Learnings
//             Total Shares and Total Balance could be packed into one var (128 + 128)
//             This avoids rounding issues later
//      */

//     constructor() public {
//         STETH = new FakeRebasableETH();
//         _syncIndex();
//     }

//     function deposit(uint256 amt) external {
//         // suppose we are deposit share directly
//         uint _stake = _computeNewStake(amt);

//         allShares += amt;
//         sharesDeposited[msg.sender] += amt;

//         allStakes += _stake;
//         stakes[msg.sender] += _stake;

//         uint256 cachedIndex = STETH.getPooledEthByShares(1e18);
//         // Index of deposit
//         stFFPScdp[msg.sender] = cachedIndex;
//         stFeePerUnitcdp[msg.sender] = stFeePerUnitg;

//         // Global index
//         stFFPSg = cachedIndex;
//     }

//     function collateralCDP(address cdp) external returns (uint256) {
//         uint256 newIndex = STETH.getPooledEthByShares(1e18);
//         uint256 originalDeposit = sharesDeposited[msg.sender];
//         uint256 cachedIndex = stFFPScdp[msg.sender];

//         // Early return if no change
//         if(newIndex == cachedIndex) {
//             return _getUnderlyingFromShare(originalDeposit, cachedIndex);
//         }

//         // Handle change, add fees to delta and return new coll
//         if(newIndex > cachedIndex) {
//             // Handle Profit
//             getIndexAfterFees(cachedIndex, newIndex);
//             // update collateral for the CDP
//             _updateCdpAfterFee(cdp);
//         } else if (newIndex < cachedIndex) {
//             // Handle Slashing
//             getIndexAfterSlash(cachedIndex, newIndex);
//         }
//         stFFPScdp[msg.sender] = newIndex;
//         return _getUnderlyingFromShare(sharesDeposited[msg.sender], newIndex);
//     }

//     // update global index and accumulator when there is a staking reward to split as fee
//     function getIndexAfterFees(uint256 prevIndex, uint256 newIndex) public {
//         require(newIndex > prevIndex);
//         require(block.timestamp - lastIndexTimestamp > INDEX_UPD_INTERVAL, "!updateTooFrequent");

// //        uint256 deltaIndexAfterFees = deltaIndex - deltaIndexFees;
// //        uint256 newRebaseIndex = prevIndex + deltaIndexAfterFees;

//         (uint256 _deltaFeeSplitShare, uint256 _deltaPerUnit, uint256 _newErrorPerUnit) = calcFeeUponStakingReward(newIndex, prevIndex);
//         stFeePerUnitgError = _newErrorPerUnit;

//         require(_deltaPerUnit > 0, "!feePerUnit");
//         stFeePerUnitg += _deltaPerUnit;
//         stFFPSg = newIndex;
//         lastIndexTimestamp = block.timestamp;

//         require((allShares * 1e18) > _deltaFeeSplitShare, "!tooBigFee");
//         allShares = ((allShares * 1e18) - _deltaFeeSplitShare) / 1e18;
//     }

//     // update global index when there is a staking slash
//     function getIndexAfterSlash(uint256 prevIndex, uint256 newIndex) public {
//         require(prevIndex > newIndex);
//         require(block.timestamp - lastIndexTimestamp > INDEX_UPD_INTERVAL, "!updateTooFrequent");
//         stFFPSg = newIndex;
//         lastIndexTimestamp = block.timestamp;
//     }

//     function getGrowthAfterFees() external {

//     }

//     function getValueAtCurrentIndex() external view returns (uint256) {
//         return _getUnderlyingFromShare(sharesDeposited[msg.sender], STETH.getPooledEthByShares(1e18));
//     }

//     function getValueAfterFees() external view returns (uint256) {

//     }

//     function _syncIndex() internal {
//         stFFPSg = STETH.getPooledEthByShares(1e18);
//         lastIndexTimestamp = block.timestamp;
//     }

//     // note the first returned _deltaFeeSplitShare is scaled by 1e18
//     function calcFeeUponStakingReward(uint256 _newIndex, uint256 _prevIndex) public view returns (uint256, uint256, uint256) {
//         uint256 deltaIndex = _newIndex - _prevIndex;
//         uint256 deltaIndexFees = deltaIndex * FEE / MAX_BPS;

//         // we take the fee for all CDPs immediately and update the global index/accumulator
//         uint256 _deltaFeeSplit = deltaIndexFees * allShares;
//         uint256 _deltaFeeSplitShare = _deltaFeeSplit * STETH.getSharesByPooledEth(1e18) / 1e18 + stFeePerUnitgError;
//         uint256 _deltaPerUnit = _deltaFeeSplitShare / allStakes;
//         return (_deltaFeeSplitShare, _deltaPerUnit, (_deltaFeeSplitShare - (_deltaPerUnit * allStakes)));
//     }

//     function _updateCdpAfterFee(address cdp) internal {
//         uint _oldStake = stakes[cdp];
//         uint _feeSplitDistributed = _oldStake * (stFeePerUnitg - stFeePerUnitcdp[cdp]) + _oldStake * stFeePerUnitgError / allStakes;
//         require((sharesDeposited[cdp] * 1e18) > _feeSplitDistributed, "!tooBigFeeForCDP");
//         sharesDeposited[cdp] = ((sharesDeposited[cdp] * 1e18) - _feeSplitDistributed) / 1e18;
//         stFeePerUnitcdp[cdp] = stFeePerUnitg;

//         uint _newStake = _computeNewStake(sharesDeposited[cdp]);
//         allStakes += _newStake;
//         allStakes -= _oldStake;
//         stakes[cdp] = _newStake;
//     }

//     function _computeNewStake(uint _deposit) internal view returns (uint) {
//         uint stake;
//         if (allShares == 0) {
//             stake = _deposit;
//         } else {
//             stake = _deposit * allStakes / allShares;
//         }
//         return stake;
//     }

//     function _getUnderlyingFromShare(uint _share, uint _index) internal view returns (uint){
//         return _share * _index / 1e18;
//     }
// }
