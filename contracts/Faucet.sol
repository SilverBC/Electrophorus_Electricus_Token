// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns(bool);
    function balanceOf(address account) external view returns(uint256);

}

contract Faucet{
    address payable owner;
    IERC20 public token;
    uint256 public withdrawalAmount = 20 * (10**18);
    uint256 public timeDelay = 2 minutes;

    event Deposit(address from, uint256 value);
    event Widthdraw(address to, uint256 value);

    mapping(address => uint256) accessTime; 

    constructor(address tokenaddress) payable{
        owner = payable(msg.sender);
        token = IERC20(tokenaddress);
    }

    function requestTokens() public {
        require(msg.sender != address(0), "invalid address");
        require(token.balanceOf(address(this)) >= withdrawalAmount, "we are severely lacking the funds :(");
        require(block.timestamp >= accessTime[msg.sender], "2 minutes must pass before you can use the faucet again");

        accessTime[msg.sender] = block.timestamp + timeDelay;
        token.transfer(msg.sender, withdrawalAmount);

    }

    receive() external payable{
        emit Deposit(msg.sender, msg.value);
    }
 
    function getBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function setWithdrawal(uint256 amount) public onlyOwner{
        withdrawalAmount = amount * (10**18);
    }

    function setTimeDelay(uint256 amount) public onlyOwner{
        timeDelay = amount * 1 minutes;
    }
    function withdraw(uint256 amount) public onlyOwner{
        emit Widthdraw(owner, amount * (10**18));
        token.transfer(owner, amount * (10**18));
    }
    function withdrawAll() public onlyOwner{
        emit Widthdraw(owner, token.balanceOf(address(this)));
        token.transfer(owner, token.balanceOf(address(this)));
    }


    modifier onlyOwner(){
        require(msg.sender == owner, "Only the owner may use this function");
        _;
    }


}