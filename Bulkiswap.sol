
// SPDX-License-Identifier: MIT

// uniswap v2 router: 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
// uniswap v2 factory: 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
// uniswap v2 init_hash : 0x96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f 
// // init code hash found @ https://kovan.etherscan.io/address/0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D#code

// sushiswap router: 0x1b02da8cb0d097eb8d57a175b88c7d8b47997506 
// sushiswap factory: 0xc35DADB65012eC5796536bD9864eD8773aBc74C4
// sushiswap v2 init_hash : 0xe18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303

// DAI: 0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa
// WETH: 0xd0A1E359811322d97991E03f863a0C30C2cF029C
// uni token 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984
// [1000000,0,["0xd0A1E359811322d97991E03f863a0C30C2cF029C", "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984"]]
// [[1000000,0,["0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa", "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984"]],[1000000,0,["0xd0A1E359811322d97991E03f863a0C30C2cF029C", "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984"]]]
pragma solidity  >=0.6.0;
pragma experimental ABIEncoderV2;

interface IERC20 {
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

interface iExchangeRouter{
     function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
        
}
//Core Fund Logic contract to manage Investments, track compounding returns, provide withdrawals

contract bulkyswap{
    struct SwapParams{
        uint amountIn;
        uint amountOutMin;
        address[] path;
    }
    uint constant MAX_UINT_VALUE = type(uint).max;
    
    iExchangeRouter public constant ExchangeRouter = iExchangeRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    IERC20 constant WETH  = IERC20(0xd0A1E359811322d97991E03f863a0C30C2cF029C);
    IERC20 constant DAI = IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa);
    
    constructor() public {
        DAI.approve(address(ExchangeRouter), MAX_UINT_VALUE);
        WETH.approve(address(ExchangeRouter), MAX_UINT_VALUE);
    }
    
    //To freeze fund from manager and swap all tokens back to baseToken for Investors to Withdraw
    function try1(SwapParams memory swap1) external{
            IERC20(swap1.path[0]).transferFrom(msg.sender, address(this), swap1.amountIn*1e12);
            ExchangeRouter.swapExactTokensForTokens(swap1.amountIn*1e12, swap1.amountOutMin, swap1.path, msg.sender, now);
    }
    
    //For Investor: Withdaw an investment from the fund
    function execute(SwapParams[] memory swapList) external {
        for(uint i; i<swapList.length; i++){
            IERC20(swapList[i].path[0]).transferFrom(msg.sender, address(this), swapList[i].amountIn*1e12);
            ExchangeRouter.swapExactTokensForTokens(swapList[i].amountIn*1e12, swapList[i].amountOutMin, swapList[i].path, msg.sender, now);
        }
    }

    
}    


