// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyERC20 is ERC20 {

    address internal m_manager;

    constructor(string memory name, string memory symbol) ERC20(name, symbol){
        m_manager = msg.sender;
        _mint(address(0xC7BE50b41764105Ea30F684De13baa675617877E),20);
    }


    function bonus(address user,uint32 mount) external{
        require(msg.sender==m_manager);
        _mint(user,mount);
    }

    function burn(address user,uint32 mount) external{
        require(msg.sender==m_manager);
        _burn(user,mount);
    }
}