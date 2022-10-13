// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AMM {
    IERC20 public immutable token0;
    IERC20 public immutable token1;
    uint public reserve0;
    uint public reserve1;
    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    constructor(address _token0, address _token1){
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function _mint(address _to, uint amount) private{
        balanceOf[_to] += amount;
        totalSupply += amount;
    }

    function _burn(address _from, uint amount) private{
        balanceOf[_from] -= amount;
        totalSupply -= amount;
    }

    function _update(uint _reserve0, uint _reserve1) private{
        reserve0 = _reserve0;
        reserve1 = _reserve1;
    }

    function swap(address _tokenIn, uint _amountIn) external returns (uint amountOut){
        require(_tokenIn == address(token0) || _tokenIn == address(token1), "Invalid token!");
        require(_amountIn > 0, "unsifficent balance!");
        bool isToken0 = _tokenIn == address(token0);
        (IERC20 tokenIn, IERC20 tokenOut, uint reserveIn, uint reserveOut ) = 
            isToken0 ? (token0, token1, reserve0, reserve1) : (token1, token0, reserve1, reserve0);
        tokenIn.transferFrom(msg.sender, address(this), _amountIn);
        uint amountInWithFee = (_amountIn * 997) / 1000; // 0.3% fee
        amountOut = (reserveOut * amountInWithFee) / (reserveIn + amountInWithFee); // dy = ydx / (x + dx)
        // transfert tokenOut to msg.sender
        tokenOut.transfer(msg.sender, amountOut);
        // update the reserve
        _update(token0.balanceOf(address(this)), token1.balanceOf(address(this)));
    }
  
}
