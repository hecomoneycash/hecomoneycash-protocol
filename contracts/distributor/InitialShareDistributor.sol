pragma solidity ^0.6.0;

import '@openzeppelin/contracts/math/SafeMath.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

import '../interfaces/IDistributor.sol';
import '../interfaces/IRewardDistributionRecipient.sol';

contract InitialShareDistributor is IDistributor {
    using SafeMath for uint256;

    event Distributed(address pool, uint256 cashAmount);

    bool public once = true;

    IERC20 public share;
    IRewardDistributionRecipient public usdthmcLPPool;
    uint256 public usdthmcInitialBalance;
    IRewardDistributionRecipient public usdtbasLPPool;
    uint256 public usdtbasInitialBalance;

    constructor(
        IERC20 _share,
        IRewardDistributionRecipient _usdthmcLPPool,
        uint256 _usdthmcInitialBalance,
        IRewardDistributionRecipient _usdtbasLPPool,
        uint256 _usdtbasInitialBalance
    ) public {
        share = _share;
        usdthmcLPPool = _usdthmcLPPool;
        usdthmcInitialBalance = _usdthmcInitialBalance;
        usdtbasLPPool = _usdtbasLPPool;
        usdtbasInitialBalance = _usdtbasInitialBalance;
    }

    function distribute() public override {
        require(
            once,
            'InitialShareDistributor: you cannot run this function twice'
        );

        share.transfer(address(usdthmcLPPool), usdthmcInitialBalance);
        usdthmcLPPool.notifyRewardAmount(usdthmcInitialBalance);
        emit Distributed(address(usdthmcLPPool), usdthmcInitialBalance);

        share.transfer(address(usdtbasLPPool), usdtbasInitialBalance);
        usdtbasLPPool.notifyRewardAmount(usdtbasInitialBalance);
        emit Distributed(address(usdtbasLPPool), usdtbasInitialBalance);

        once = false;
    }
}
