// SPDX-License-Identifier: MIT
pragma solidity 0.7.3;


interface IUniswap {
    function swapExactTokensForETH(
            uint amountIn, 
            uint amountOutMin, 
            address[] calldata path, 
            address to, uint deadline
        ) external returns(uint[] memory amounts);
    
    function WETH() external pure returns(address);
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract UniswapIntegrator{
    IUniswap uniswap;

    constructor(address _uniswap) {
        uniswap = IUniswap(_uniswap);
    }

    function swapTokensForEth(address _token, uint _amountIn, uint _amountOut, uint deadline) public{
        //tokens need to be approved to be spent on this contract before this operation
        IERC20(_token).transferFrom(msg.sender, address(this), _amountIn);
        address[] memory path = new address[] (2);
        path[0] = _token;
        path[1] = uniswap.WETH();
        IERC20(_token).approve(address(uniswap), _amountIn);
        uniswap.swapExactTokensForETH(_amountIn, _amountOut, path, msg.sender, deadline);
    }
}