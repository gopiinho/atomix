// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @notice  Minimal ERC20 implementation complient with ERC-20 Token Standard.
 * @author  Atomix (https://github.com/gopiinho/atomix/blob/main/src/tokens/ERC20.sol)
 * @title   ERC20
 * @dev     If Overriding, do not violate the ERC20 invariants.
 *          Sum of all user balances must not exceed the totalSupply.
 */
abstract contract ERC20 {
    /*////////////////////////////////
                Errors
    ////////////////////////////////*/
    error ERC20InsufficientAllowance(address spender, uint256 allowedAmount, uint256 amount);

    /*////////////////////////////////
                Events
    ////////////////////////////////*/
    event Approval(address indexed from, address indexed to, uint256 indexed amount);
    event Transfer(address indexed from, address indexed to, uint256 indexed amount);

    /*////////////////////////////////
                Storage
    ////////////////////////////////*/
    string public name;
    string public symbol;
    uint8 public immutable decimals;

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    /*////////////////////////////////
                Functions
    ////////////////////////////////*/
    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function transfer(address to, uint256 amount) public virtual returns (bool) {
        balanceOf[msg.sender] -= amount;
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(msg.sender, to, amount);

        return true;
    }

    function approve(address spender, uint256 amount) public virtual returns (bool) {
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual returns (bool) {
        uint256 allowedAmount = allowance[from][msg.sender];

        if (allowedAmount < type(uint256).max) {
            if (allowedAmount < amount) {
                revert ERC20InsufficientAllowance(from, allowedAmount, amount);
            }
            unchecked {
                allowance[from][msg.sender] = allowedAmount - amount;
            }
        }

        balanceOf[from] -= amount;
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(from, to, amount);

        return true;
    }

    /*////////////////////////////////
            Internal Functions
    ////////////////////////////////*/
    function _mint(address to, uint256 amount) internal virtual {
        totalSupply += amount;

        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal virtual {
        totalSupply -= amount;

        unchecked {
            balanceOf[from] -= amount;
        }

        emit Transfer(from, address(0), amount);
    }
}
