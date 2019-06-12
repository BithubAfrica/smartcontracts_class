pragma solidity ^0.5.1;

contract LandTransaction {
    // Person structure containing all properties needed for a person to buy land.
    struct Person {
        string name;
        address payable account;
    }
    
    // Land Structure containing all properties required for land to be sold in this contract.
    struct Land {
        uint propertyID;
        Person owner;
        uint cost;
    }
    
    // set variables to private to avoid manipulation from bad actors.
    Person private owner;
    Person private buyer;
    Land private property;
    
    constructor (string memory ownerName, uint landID, uint cost) public {
        owner = Person(ownerName, msg.sender);
        property = Land(landID, owner, cost);
    }
    
    // Function modifier that makes sure that only the owner of the land executes the function
    modifier OwnerOnly {
        require(msg.sender == owner.account);
        _;
    }
    
    // Event to be emited when a buyer is added to the contract.
    event AddedBuyer(string name, address account);
    
    // Owner of the land should be the only one to add a buyer.
    function addBuyer(string memory name, address payable account) public OwnerOnly {
        buyer = Person(name, account);
        emit AddedBuyer(name, account);
    }
    
    // Function modifier that requires only buyers to execute the function.
    modifier BuyerOnly {
        require(msg.sender == buyer.account);
        _;
    }
    
    // Event that triggers when land is bought.
    event LandBought(uint landId, uint amount);
    
    // Transfer funds and ownership of land
    function buyLand() BuyerOnly public payable {
        require(msg.value >= property.cost);
        address(owner.account).transfer(msg.value);
        property.owner = buyer;
        
        emit LandBought(property.propertyID, property.cost);
    }
    
    // Function for getting the balance of the contract address.
    function getBalance() public returns (uint) {
        return address(this).balance;
    }
    
    function() external payable {
        
    }
}
