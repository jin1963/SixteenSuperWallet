// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/**
 * THBC Whale Reward Staking — owner-verified BSC Whale purchases.
 * Fixed reward: 33 THBC per 1 USDT, 500-day lock, zero interest.
 *
 * SECURITY MODEL: owner verifies BSC transaction off-chain before calling
 * recordPurchase(). Solidity does NOT verify transaction receipts or BscScan.
 * One purchase transaction hash can be recorded only once on-chain.
 */
interface ITHBC {
    function balanceOf(address) external view returns (uint256);
    function transfer(address,uint256) external returns (bool);
    function transferFrom(address,address,uint256) external returns (bool);
    function decimals() external view returns (uint8);
}

contract THBCWhaleRewardStaking {
    uint256 public constant LOCK_DURATION = 500 days;
    uint256 public constant THBC_PER_USDT = 33;
    uint256 private constant UNIT = 1e18;

    ITHBC public immutable thbc;
    address public owner;
    bool public paused;
    uint256 public totalReserved;
    uint256 public totalFunded;
    uint256 public totalWithdrawn;
    uint256 private locked;

    struct Stake {
        bytes32 purchaseTxHash;
        uint256 purchaseUSDT;
        uint256 principalTHBC;
        uint64 startedAt;
        uint64 unlockAt;
        bool withdrawn;
    }

    mapping(address => Stake[]) private stakes;
    mapping(bytes32 => bool) public processedPurchase;
    mapping(bytes32 => address) public purchaseBeneficiary;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Funded(address indexed sender, uint256 amount);
    event RewardStaked(address indexed user, bytes32 indexed purchaseTxHash, uint256 purchaseUSDT, uint256 amountTHBC, uint256 stakeId, uint256 unlockAt);
    event Withdrawn(address indexed user, uint256 indexed stakeId, uint256 amountTHBC);
    event PausedUpdated(bool paused);

    modifier onlyOwner() { require(msg.sender == owner, "Not owner"); _; }
    modifier nonReentrant() {
        require(locked == 0, "Reentrant");
        locked = 1;
        _;
        locked = 0;
    }

    constructor(address thbcToken) {
        require(thbcToken != address(0), "Zero token");
        thbc = ITHBC(thbcToken);
        require(thbc.decimals() == 18, "THBC must use 18 decimals");
        owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Zero owner");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function setPaused(bool value) external onlyOwner {
        paused = value;
        emit PausedUpdated(value);
    }

    function rewardFor(uint256 purchaseUSDT) public pure returns (uint256) {
        require(
            purchaseUSDT == 1000 * UNIT ||
            purchaseUSDT == 3000 * UNIT ||
            purchaseUSDT == 5000 * UNIT ||
            purchaseUSDT == 10000 * UNIT,
            "Unsupported Whale tier"
        );
        return purchaseUSDT * THBC_PER_USDT;
    }

    function fund(uint256 amountTHBC) external onlyOwner nonReentrant {
        require(amountTHBC > 0, "Zero amount");
        uint256 beforeBalance = thbc.balanceOf(address(this));
        _safeTransferFrom(msg.sender, address(this), amountTHBC);
        require(thbc.balanceOf(address(this)) - beforeBalance == amountTHBC, "Fee-on-transfer not supported");
        totalFunded += amountTHBC;
        emit Funded(msg.sender, amountTHBC);
    }

    /**
     * Only the trusted owner can attest to a successful purchase.
     * The owner DApp MUST verify receipt status, destination Whale Core,
     * buyer, packageId, USDT transfer amount, and uniqueness before calling.
     */
    function recordPurchase(bytes32 txHash, address buyer, uint256 purchaseUSDT)
        external onlyOwner nonReentrant returns (uint256 stakeId)
    {
        require(!paused, "Paused");
        require(txHash != bytes32(0), "Zero tx hash");
        require(buyer != address(0), "Zero buyer");
        require(!processedPurchase[txHash], "Already recorded");
        uint256 amount = rewardFor(purchaseUSDT);
        require(thbc.balanceOf(address(this)) >= totalReserved + amount, "Insufficient THBC reserve");
        processedPurchase[txHash] = true;
        purchaseBeneficiary[txHash] = buyer;
        stakeId = stakes[buyer].length;
        uint64 start = uint64(block.timestamp);
        uint64 unlock = uint64(block.timestamp + LOCK_DURATION);
        stakes[buyer].push(Stake(txHash, purchaseUSDT, amount, start, unlock, false));
        totalReserved += amount;
        emit RewardStaked(buyer, txHash, purchaseUSDT, amount, stakeId, unlock);
    }

    function withdraw(uint256 stakeId) external nonReentrant {
        require(stakeId < stakes[msg.sender].length, "Unknown stake");
        Stake storage s = stakes[msg.sender][stakeId];
        require(!s.withdrawn, "Already withdrawn");
        require(block.timestamp >= s.unlockAt, "Locked");
        s.withdrawn = true;
        totalReserved -= s.principalTHBC;
        totalWithdrawn += s.principalTHBC;
        _safeTransfer(msg.sender, s.principalTHBC);
        emit Withdrawn(msg.sender, stakeId, s.principalTHBC);
    }

    function stakeCount(address user) external view returns (uint256) { return stakes[user].length; }
    function getStake(address user, uint256 id) external view returns (Stake memory) { return stakes[user][id]; }
    function availableSurplus() public view returns (uint256) {
        uint256 bal = thbc.balanceOf(address(this));
        return bal > totalReserved ? bal - totalReserved : 0;
    }
    function withdrawSurplus(address to, uint256 amount) external onlyOwner nonReentrant {
        require(to != address(0), "Zero recipient");
        require(amount <= availableSurplus(), "Reserved funds");
        _safeTransfer(to, amount);
    }

    function _safeTransfer(address to, uint256 amount) internal {
        (bool ok, bytes memory result) = address(thbc).call(
            abi.encodeWithSelector(ITHBC.transfer.selector, to, amount)
        );
        require(ok && (result.length == 0 || abi.decode(result, (bool))), "THBC transfer failed");
    }
    function _safeTransferFrom(address from, address to, uint256 amount) internal {
        (bool ok, bytes memory result) = address(thbc).call(
            abi.encodeWithSelector(ITHBC.transferFrom.selector, from, to, amount)
        );
        require(ok && (result.length == 0 || abi.decode(result, (bool))), "THBC transferFrom failed");
    }
}
