pragma solidity ^0.5.1;

contract LandToken {
    string  public name = "LAND TOKEN";
    string  public symbol = "LAND";
    string  public standard = "LAND TOKEN v1.0";
    uint256 public totalSupply;

    // Event to be triggered once a transfer has been made.
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    // Event to be triggered once approval is done.
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf; // Token balance of specific address
    mapping(address => mapping(address => uint256)) public allowance; // This function returns the current approved number of tokens by an owner to a specific delegate, as set in the approve function.

    constructor (uint256 _initialSupply) public {
        // Owner of the token gets all the token supply
        balanceOf[msg.sender] = _initialSupply;
        totalSupply = _initialSupply;
    }

    // Transfer total amount of tokens from the main main contract address to the specified address and return true if successful
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }
    
  
    // allow an owner i.e. msg.sender to approve a delegate account, possibly the marketplace itself, to withdraw tokens from his account and to transfer them to other accounts.
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }
    
    // Transfer funds to third party account i.e. from one token holder to another
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);

        return true;
    }
}
