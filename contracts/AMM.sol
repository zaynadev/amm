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

    function mint(address _to, uint amount) public{
        balanceOf[_to] += amount;
        totalSupply += amount;
    }

    function burn(address _from, uint amount) public{
        balanceOf[_from] -= amount;
        totalSupply -= amount;
    }
  
}
