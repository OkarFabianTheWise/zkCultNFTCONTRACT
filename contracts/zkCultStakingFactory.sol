//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

library Address {
    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    function functionCall(
        address target,
        bytes memory data
    ) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(
        address target,
        bytes memory data
    ) internal view returns (bytes memory) {
        return
            functionStaticCall(
                target,
                data,
                "Address: low-level static call failed"
            );
    }

    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(
        address target,
        bytes memory data
    ) internal returns (bytes memory) {
        return
            functionDelegateCall(
                target,
                data,
                "Address: low-level delegate call failed"
            );
    }

    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

library SafeERC20 {
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(
                oldAllowance >= value,
                "SafeERC20: decreased allowance below zero"
            );
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(
                token,
                abi.encodeWithSelector(
                    token.approve.selector,
                    spender,
                    newAllowance
                )
            );
        }
    }

    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        bytes memory returndata = address(token).functionCall(
            data,
            "SafeERC20: low-level call failed"
        );
        if (returndata.length > 0) {
            // Return data is optional
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }
}

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721 is IERC165 {
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );

    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256 tokenId) external view returns (address owner);

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function transferFrom(address from, address to, uint256 tokenId) external;

    function approve(address to, uint256 tokenId) external;

    function getApproved(
        uint256 tokenId
    ) external view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) external;

    function isApprovedForAll(
        address owner,
        address operator
    ) external view returns (bool);

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}

library SafeMath {
    function tryAdd(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function trySub(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    function tryMul(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    function tryDiv(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    function tryMod(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        _status = _ENTERED;

        _;

        _status = _NOT_ENTERED;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _transferOwnership(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IERC721Enumerable is IERC721 {
    function totalSupply() external view returns (uint256);

    function tokenOfOwnerByIndex(
        address owner,
        uint256 index
    ) external view returns (uint256);

    function tokenByIndex(uint256 index) external view returns (uint256);
}

interface INFTTokenInfo is IERC721Enumerable {
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

interface ITokenInfo {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint256);
}

interface IzkCultStakingPool {
    function getEndTime() external view returns (uint256);
}

contract zkCultStakingPool is ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    struct StakedToken {
        address staker;
        uint256 tokenId;
        string tokenURI;
    }

    struct UnstakedToken {
        uint256 tokenId;
        string tokenURI;
    }

    // Staker info
    struct UserInfo {
        uint256 amount;
        StakedToken[] stakedTokens;
        uint256 rewardDebt; // Reward debt. See explanation below.
        uint256 unlockTime;
        uint256 totalEarned;
    }

    struct TokenInfo {
        address tokenAddress;
        string name;
        string symbol;
        uint256 decimals;
        string logo;
    }

    struct NFTTokenInfo {
        address tokenAddress;
        string name;
        string symbol;
        string logo;
    }

    struct NFTValueInfo {
        address tokenAddress;
        string name;
        string symbol;
        uint256 decimals;
        uint256 amountOfValueToken;
    }

    // Info of this pool
    struct PoolInfo {
        NFTTokenInfo nftTokenInfo;
        TokenInfo rewardTokenInfo;
        NFTValueInfo nftValueInfo;
        string websiteURL;
        uint256 lastRewardTime; // Last timestamp that Tokens distribution occurs.
        uint256 accRewardPerShare; // Accumulated Tokens per share, times 1e12. See below.
        uint256 rewardPerDay;
        address poolOwner;
        uint256 lockDuration;
        uint256 endTime;
    }

    PoolInfo public poolInfo;

    uint256 totalStaked;
    uint256 totalClaimed;

    bool isEndedStaking;

    mapping(address => UserInfo) public userInfos;

    // Mapping of Token Id to staker. Made for the SC to remeber
    // who to send back the ERC721 Token to.
    mapping(uint256 => address) public stakerAddresses;

    address wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    address owner;
    event Stake(address indexed user, uint256 indexed tokenId);
    event Unstake(address indexed user, uint256 indexed tokenId);
    event Claim(address indexed user, uint256 pending);

    constructor(
        address _nftCollection,
        address _rewardToken,
        address _nftValueTokenAddr,
        uint256 _amountOfValueToken,
        string memory _nftTokenLogo,
        string memory _rewardTokenLogo,
        string memory _websiteURL,
        uint256 _lockDuration,
        uint256 _rewardPerDay,
        address _poolOwner,
        uint256 _endTime
    ) {
        poolInfo.nftTokenInfo = NFTTokenInfo(
            _nftCollection,
            ITokenInfo(_nftCollection).name(),
            ITokenInfo(_nftCollection).symbol(),
            _nftTokenLogo
        );
        poolInfo.rewardTokenInfo = TokenInfo(
            _rewardToken,
            ITokenInfo(_rewardToken).name(),
            ITokenInfo(_rewardToken).symbol(),
            ITokenInfo(_rewardToken).decimals(),
            _rewardTokenLogo
        );
        poolInfo.nftValueInfo = NFTValueInfo(
            _nftValueTokenAddr,
            ITokenInfo(_nftValueTokenAddr).name(),
            ITokenInfo(_nftValueTokenAddr).symbol(),
            ITokenInfo(_nftValueTokenAddr).decimals(),
            _amountOfValueToken
        );
        poolInfo.websiteURL = _websiteURL;
        poolInfo.lockDuration = _lockDuration;
        poolInfo.rewardPerDay = _rewardPerDay;
        poolInfo.poolOwner = _poolOwner;
        poolInfo.endTime = _endTime;

        isEndedStaking = false;

        owner = msg.sender;
    }

    receive() external payable {}

    fallback() external payable {}

    function checkAdmin(address sender) internal view {
        require(
            sender == poolInfo.poolOwner || sender == owner,
            "Unauthorized"
        );
    }

    function checkRewardable(uint256 amount) internal view {
        require(amount <= rewardRemaining(), "Insufficient tokens in the Pool");
    }

    function checkNFTOwner(uint256 tokenId, address sender) internal view {
        require(stakerAddresses[tokenId] == sender, "You don't own this token");
    }

    function getSecondsPassed(
        uint256 from,
        uint256 to
    ) internal pure returns (uint256) {
        return to.sub(from);
    }

    function rewardRemaining() public view returns (uint256) {
        uint256 remainingReward = IERC20(poolInfo.rewardTokenInfo.tokenAddress)
            .balanceOf(address(this));
        if (
            address(IERC20(poolInfo.rewardTokenInfo.tokenAddress)) ==
            wethAddress
        ) {
            remainingReward = address(this).balance;
        }
        return remainingReward;
    }

    // View function to see pending Reward on frontend.
    function pendingReward(address _user) public view returns (uint256) {
        UserInfo storage user = userInfos[_user];

        uint256 _accRewardPerShare = poolInfo.accRewardPerShare;

        uint256 lpSupply = totalStaked;

        if (
            block.timestamp > poolInfo.lastRewardTime &&
            lpSupply != 0 &&
            !isEndedStaking
        ) {
            uint256 secs = getSecondsPassed(
                poolInfo.lastRewardTime,
                block.timestamp
            );

            uint256 reward = secs.mul(poolInfo.rewardPerDay).div(86400);

            _accRewardPerShare = _accRewardPerShare.add(
                reward.mul(1e12).div(lpSupply)
            );
        }
        return
            user.amount.mul(_accRewardPerShare).div(1e12).sub(user.rewardDebt);
    }

    function updatePool() internal {
        if (block.timestamp <= poolInfo.lastRewardTime) {
            return;
        }

        uint256 lpSupply = totalStaked;

        if (lpSupply == 0) {
            poolInfo.lastRewardTime = block.timestamp;
            return;
        }
        if (!isEndedStaking) {
            uint256 secs = getSecondsPassed(
                poolInfo.lastRewardTime,
                block.timestamp
            );
            uint256 reward = secs.mul(poolInfo.rewardPerDay).div(86400);

            poolInfo.accRewardPerShare = poolInfo.accRewardPerShare.add(
                reward.mul(1e12).div(lpSupply)
            );
            poolInfo.lastRewardTime = block.timestamp;
        }
    }

    function transferToken(
        IERC20 _token,
        address _receiver,
        uint256 _amount
    ) internal {
        uint256 balance = _token.balanceOf(address(this));
        if (address(_token) == wethAddress) {
            balance = address(this).balance;
        }

        require(_amount <= balance, "Insufficient tokens in the Pool");

        if (address(_token) == wethAddress) {
            (bool sent, ) = payable(_receiver).call{value: _amount}("");
            require(sent, "Failed to send ETH");
        } else {
            _token.safeTransfer(_receiver, _amount);
        }
    }

    // claim reward tokens from STAKING.
    function claim() public nonReentrant {
        UserInfo storage user = userInfos[msg.sender];

        updatePool();

        uint256 pending = user
            .amount
            .mul(poolInfo.accRewardPerShare)
            .div(1e12)
            .sub(user.rewardDebt);

        require(pending > 0, "Insufficient pending rewards to claim");

        checkRewardable(pending);
        transferToken(
            IERC20(poolInfo.rewardTokenInfo.tokenAddress),
            address(msg.sender),
            pending
        );
        user.totalEarned += pending;
        totalClaimed += pending;

        user.rewardDebt = user.amount.mul(poolInfo.accRewardPerShare).div(1e12);

        emit Claim(msg.sender, pending);
    }

    function _stake(uint256 _tokenId) internal nonReentrant {
        INFTTokenInfo(poolInfo.nftTokenInfo.tokenAddress).transferFrom(
            msg.sender,
            address(this),
            _tokenId
        );

        string memory _tokenURI = INFTTokenInfo(
            poolInfo.nftTokenInfo.tokenAddress
        ).tokenURI(_tokenId);

        StakedToken memory stakedToken = StakedToken(
            msg.sender,
            _tokenId,
            _tokenURI
        );

        userInfos[msg.sender].stakedTokens.push(stakedToken);

        userInfos[msg.sender].amount++;

        stakerAddresses[_tokenId] = msg.sender;

        totalStaked++;

        emit Stake(msg.sender, _tokenId);
    }

    function stake(uint256[] memory _tokenIds) public {
        require(block.timestamp < poolInfo.endTime, "Staking's ended");

        if (poolInfo.lastRewardTime == 0) {
            poolInfo.lastRewardTime = block.timestamp;
        }

        UserInfo storage user = userInfos[msg.sender];

        updatePool();

        if (user.amount > 0) {
            uint256 pending = user
                .amount
                .mul(poolInfo.accRewardPerShare)
                .div(1e12)
                .sub(user.rewardDebt);
            if (pending > 0) {
                checkRewardable(pending);
                transferToken(
                    IERC20(poolInfo.rewardTokenInfo.tokenAddress),
                    address(msg.sender),
                    pending
                );
                user.totalEarned += pending;
                totalClaimed += pending;
            }
        }

        for (uint256 i = 0; i < _tokenIds.length; i++) {
            require(
                INFTTokenInfo(poolInfo.nftTokenInfo.tokenAddress).ownerOf(
                    _tokenIds[i]
                ) == msg.sender,
                "Not a owner"
            );
            _stake(_tokenIds[i]);
        }

        user.rewardDebt = user.amount.mul(poolInfo.accRewardPerShare).div(1e12);
        user.unlockTime = block.timestamp + poolInfo.lockDuration;
    }

    function _unstake(uint256 _tokenId) internal nonReentrant {
        uint256 index = 0;
        for (
            uint256 i = 0;
            i < userInfos[msg.sender].stakedTokens.length;
            i++
        ) {
            if (
                userInfos[msg.sender].stakedTokens[i].tokenId == _tokenId &&
                userInfos[msg.sender].stakedTokens[i].staker != address(0)
            ) {
                index = i;
                break;
            }
        }

        userInfos[msg.sender].stakedTokens[index].staker = address(0);

        if (userInfos[msg.sender].amount > 0) userInfos[msg.sender].amount--;

        stakerAddresses[_tokenId] = address(0);

        INFTTokenInfo(poolInfo.nftTokenInfo.tokenAddress).transferFrom(
            address(this),
            msg.sender,
            _tokenId
        );

        totalStaked--;

        emit Unstake(msg.sender, _tokenId);
    }

    function unstake(uint256[] memory _tokenIds) public {
        UserInfo storage user = userInfos[msg.sender];

        require(user.amount > 0, "Unstake: insufficient staked NFTs");
        require(
            user.unlockTime <= block.timestamp,
            "May not do normal withdraw early"
        );

        updatePool();

        uint256 pending = user
            .amount
            .mul(poolInfo.accRewardPerShare)
            .div(1e12)
            .sub(user.rewardDebt);
        if (pending > 0) {
            checkRewardable(pending);
            transferToken(
                IERC20(poolInfo.rewardTokenInfo.tokenAddress),
                address(msg.sender),
                pending
            );
            user.totalEarned += pending;
            totalClaimed += pending;
        }

        for (uint256 i = 0; i < _tokenIds.length; i++) {
            checkNFTOwner(_tokenIds[i], msg.sender);
            _unstake(_tokenIds[i]);
        }

        user.rewardDebt = user.amount.mul(poolInfo.accRewardPerShare).div(1e12);
    }

    function emergencyUnstake() public {
        UserInfo storage user = userInfos[msg.sender];

        uint256 amount = user.amount;

        require(amount > 0, "Insufficient staked tokens to unstake");

        updatePool();

        user.amount = 0;
        user.rewardDebt = 0;
        user.unlockTime = 0;

        for (uint256 i = 0; i < user.stakedTokens.length; i++) {
            if (user.stakedTokens[i].staker != address(0)) {
                checkNFTOwner(user.stakedTokens[i].tokenId, msg.sender);
                _unstake(user.stakedTokens[i].tokenId);
            }
        }
    }

    function emergencyRewardWithdraw(uint256 _amount) external {
        checkAdmin(msg.sender);
        require(_amount <= rewardRemaining(), "Insufficient tokens");
        transferToken(
            IERC20(poolInfo.rewardTokenInfo.tokenAddress),
            address(msg.sender),
            _amount
        );
    }

    function getEndTime() external view returns (uint256) {
        return poolInfo.endTime;
    }

    // get status
    function getPoolStatus()
        external
        view
        returns (uint256, uint256, uint256, bool, PoolInfo memory)
    {
        uint256 remainingReward = rewardRemaining();
        return (
            totalStaked,
            totalClaimed,
            remainingReward,
            isEndedStaking,
            poolInfo
        );
    }

    function getUserStatus(
        address _user
    ) external view returns (uint256, UserInfo memory, UnstakedToken[] memory) {
        uint256 pending = pendingReward(_user);
        UserInfo memory userInfo = userInfos[_user];
        uint256 bal = INFTTokenInfo(poolInfo.nftTokenInfo.tokenAddress)
            .balanceOf(_user);
        UnstakedToken[] memory unstakedTokens = new UnstakedToken[](bal);
        for (uint256 i = 0; i < bal; i++) {
            uint256 _tokenId = INFTTokenInfo(poolInfo.nftTokenInfo.tokenAddress)
                .tokenOfOwnerByIndex(_user, i);
            unstakedTokens[i].tokenId = _tokenId;
            unstakedTokens[i].tokenURI = INFTTokenInfo(
                poolInfo.nftTokenInfo.tokenAddress
            ).tokenURI(_tokenId);
        }
        return (pending, userInfo, unstakedTokens);
    }

    function updateEndTime(uint256 _endTime) external {
        checkAdmin(msg.sender);
        poolInfo.endTime = _endTime;
    }

    function updateRewardPerDay(uint256 _rewardPerDay) external {
        checkAdmin(msg.sender);
        updatePool();
        poolInfo.rewardPerDay = _rewardPerDay;
    }

    function updateLockDuration(uint256 _lockDuration) external {
        checkAdmin(msg.sender);
        poolInfo.lockDuration = _lockDuration;
    }

    function updateNFTLogo(string memory _logo) external {
        checkAdmin(msg.sender);
        poolInfo.nftTokenInfo.logo = _logo;
    }

    function updateRewardTokenLogo(string memory _logo) external {
        checkAdmin(msg.sender);
        poolInfo.rewardTokenInfo.logo = _logo;
    }

    function updateNFTValueInfo(
        address _nftValueTokenAddr,
        uint256 _amountOfValueToken
    ) external {
        checkAdmin(msg.sender);
        poolInfo.nftValueInfo = NFTValueInfo(
            _nftValueTokenAddr,
            ITokenInfo(_nftValueTokenAddr).name(),
            ITokenInfo(_nftValueTokenAddr).symbol(),
            ITokenInfo(_nftValueTokenAddr).decimals(),
            _amountOfValueToken
        );
    }

    function stopStaking() external {
        checkAdmin(msg.sender);
        updatePool();
        isEndedStaking = true;
    }

    function resumeStaking() external {
        checkAdmin(msg.sender);
        isEndedStaking = false;
        poolInfo.lastRewardTime = block.timestamp;
        updatePool();
    }

    function updatePoolOwner(address _newOwner) external {
        checkAdmin(msg.sender);
        poolInfo.poolOwner = _newOwner;
    }
}

contract zkCultStakingFactory is Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    struct PoolInfo {
        address poolAddress;
        address nftTokenAddress;
        address rewardTokenAddress;
        uint256 createdAt;
    }

    PoolInfo[] public poolInfos;
    mapping(address => address) public poolOwners;

    struct CreatePoolParams {
        IERC721 nftCollection;
        IERC20 rewardToken;
        IERC20 nftValueToken;
        uint256 amountOfValueToken;
        string nftTokenLogo;
        string rewardTokenLogo;
        string websiteURL;
        uint256 rewardSupply;
        uint256 zkCultAmount;
        uint256 lockDuration;
        uint256 rewardPerDay;
        uint256 endTime;
    }

    struct PaymentInfo {
        IERC20 zkCult;
        uint256 zkCultAmount;
        uint256 ethAmount;
    }

    PaymentInfo public paymentInfo;

    address public noNeedChargeFeeToken =
        0xC6759a4Fc56B3ce9734035a56B36e8637c45b77E; //if user use this token as a stake token or reward token to create a pool, he/she will not be charged with creation fee

    mapping(address => bool) public isExcludedFromCreationFee;

    address wethAddress = 0x5AEa5775959fBC2557Cc8789bC1bf90A239D9a91;

    event CreatedNewPool(address indexed user, address indexed poolAddress);

    constructor(IERC20 _zkCult, uint256 _zkCultAmount, uint256 _ethAmount) {
        require(
            address(_zkCult) != address(0) && address(_zkCult) != wethAddress,
            "Invalid pay token"
        );
        paymentInfo = PaymentInfo(_zkCult, _zkCultAmount, _ethAmount);
    }

    receive() external payable {}

    fallback() external payable {}

    function checkPoolOwner(address poolAddr, address sender) internal view {
        require(
            sender == owner() || poolOwners[poolAddr] == sender,
            "Not allowed to call"
        );
    }

    function createNewPool(CreatePoolParams memory params) public payable {
        if (
            address(params.rewardToken) != noNeedChargeFeeToken &&
            !isExcludedFromCreationFee[address(params.nftCollection)]
        ) {
            require(
                params.zkCultAmount >= paymentInfo.zkCultAmount,
                "Insufficient zkCult to create Pool"
            );

            require(
                msg.value >= paymentInfo.ethAmount,
                "Insufficient ETH to create Pool"
            );
        }

        uint256 _rewardAmount = params.rewardSupply;
        if (address(params.rewardToken) == wethAddress) {
            _rewardAmount = msg.value;
            if (
                address(params.rewardToken) != noNeedChargeFeeToken &&
                !isExcludedFromCreationFee[address(params.nftCollection)]
            ) {
                _rewardAmount = _rewardAmount.sub(paymentInfo.ethAmount);
            }
        }

        require(address(params.nftCollection) != address(0), "Invalid NFT");
        require(
            address(params.rewardToken) != address(0),
            "Invalid reward token"
        );
        require(params.rewardPerDay > 0, "Invalid reward per day");
        require(
            params.rewardSupply > 0 && _rewardAmount >= params.rewardSupply,
            "Insufficient reward supply"
        );

        if (
            address(params.rewardToken) != noNeedChargeFeeToken &&
            !isExcludedFromCreationFee[address(params.nftCollection)]
        ) {
            paymentInfo.zkCult.safeTransferFrom(
                msg.sender,
                address(this),
                paymentInfo.zkCultAmount
            );
        }

        zkCultStakingPool pool = new zkCultStakingPool(
            address(params.nftCollection),
            address(params.rewardToken),
            address(params.nftValueToken),
            params.amountOfValueToken,
            params.nftTokenLogo,
            params.rewardTokenLogo,
            params.websiteURL,
            params.lockDuration,
            params.rewardPerDay,
            msg.sender,
            params.endTime
        );

        if (address(params.rewardToken) != wethAddress) {
            params.rewardToken.safeTransferFrom(
                msg.sender,
                address(pool),
                params.rewardSupply
            );
        } else {
            (bool sent, ) = payable(address(pool)).call{
                value: params.rewardSupply
            }("");
            require(sent, "Failed to send ETH");
        }

        poolInfos.push(
            PoolInfo({
                poolAddress: address(pool),
                nftTokenAddress: address(params.nftCollection),
                rewardTokenAddress: address(params.rewardToken),
                createdAt: block.timestamp
            })
        );
        poolOwners[address(pool)] = msg.sender;

        isExcludedFromCreationFee[address(params.nftCollection)] = false;

        emit CreatedNewPool(msg.sender, address(pool));
    }

    function getIsExcludedFromCreationFee(
        address _nftTokenAddress,
        address _rewardTokenAddress
    ) external view returns (bool) {
        return (_rewardTokenAddress == noNeedChargeFeeToken ||
            isExcludedFromCreationFee[_nftTokenAddress]);
    }

    function updatePoolOwner(
        zkCultStakingPool _pool,
        address _newOwner
    ) external {
        checkPoolOwner(address(_pool), msg.sender);
        for (uint256 i = 0; i < poolInfos.length; i++) {
            if (poolInfos[i].poolAddress == address(_pool)) {
                poolOwners[address(_pool)] = _newOwner;
                break;
            }
        }
        _pool.updatePoolOwner(_newOwner);
    }

    function getAllPoolInfos()
        public
        view
        returns (PoolInfo[] memory, PoolInfo[] memory)
    {
        uint256 _liveCounts = 0;
        uint256 _expiredCounts = 0;

        for (uint256 i = 0; i < poolInfos.length; i++) {
            if (
                IzkCultStakingPool(poolInfos[i].poolAddress).getEndTime() >
                block.timestamp
            ) {
                _liveCounts++;
            } else {
                _expiredCounts++;
            }
        }

        PoolInfo[] memory livePools = new PoolInfo[](_liveCounts);
        PoolInfo[] memory expiredPools = new PoolInfo[](_expiredCounts);
        _liveCounts = 0;
        _expiredCounts = 0;

        for (uint256 i = 0; i < poolInfos.length; i++) {
            if (
                IzkCultStakingPool(poolInfos[i].poolAddress).getEndTime() >
                block.timestamp
            ) {
                livePools[_liveCounts] = poolInfos[i];
                _liveCounts++;
            } else {
                expiredPools[_expiredCounts] = poolInfos[i];
                _expiredCounts++;
            }
        }
        return (livePools, expiredPools);
    }

    function updatePayTokenAndPayAmount(
        IERC20 _zkCult,
        uint256 _zkCultAmount,
        uint256 _ethAmount
    ) external onlyOwner {
        paymentInfo = PaymentInfo(_zkCult, _zkCultAmount, _ethAmount);
    }

    function updateNoNeedChargeToken(IERC20 _token) external onlyOwner {
        noNeedChargeFeeToken = address(_token);
    }

    function excludeFromCreationFee(
        address _nftTokenAddress,
        bool isExcluded
    ) external onlyOwner {
        isExcludedFromCreationFee[_nftTokenAddress] = isExcluded;
    }

    function ownerWithdrawPayTokens() public nonReentrant onlyOwner {
        uint256 bal = 0;
        bal = address(this).balance;
        require(bal > 0, "No ETH to withdraw");
        (bool sent, ) = payable(owner()).call{value: bal}("");
        require(sent, "Failed to send ETH");

        bal = paymentInfo.zkCult.balanceOf(address(this));
        require(bal > 0, "No tokens to withdraw");
        paymentInfo.zkCult.safeTransfer(msg.sender, bal);
    }
}
