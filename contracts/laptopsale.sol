// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.12;
import "StringLib.sol";

contract LaptopSale {
    address public seller;          // Records the identity of the seller
    address public buyer;           // Records the identity of the buyer accepted by seller
    address public potentialBuyer;  // Proposed purchaser - makes offer and waits for seller to accept
    string public laptopDescription;
    uint public price;              // Price of the laptop
    bool public sold;               // Indicates whether laptop has been sold

    // Events
    event OfferAccepted(address buyer);                 // Let the world know when offer accepted from buyer
    event SoldEvent(address seller, uint256 price);     // Let the world know when the laptop is sold
    
    // Clause 1: Seller becomes a party to the contract when the contract is deployed
    //           to the blockchain
    constructor() {
        seller = msg.sender;
    }

    // Clause 1: Description of the laptop
    function setDescription(string memory _laptopDescription) public {
        require(msg.sender == seller, "Only seller can set the description");
        laptopDescription = _laptopDescription;
    }

    // Clause 1: Buyer makes offer to become party to the contract
    function offerToPurchase() public {
        require(msg.sender != seller, "Seller cannot make offer to purchase their own laptop");
        potentialBuyer = msg.sender;
    }

    // Clause 1: Seller accepts offer to purchase
    function acceptOffer() public {
        require(msg.sender == seller, "Only the seller can accept an offer");
        require(potentialBuyer != address(0x0), "Nobody has made an offer yet");
        buyer = potentialBuyer;
        emit OfferAccepted(msg.sender);
    }

    // Clause 2: Set the price of the laptop
    function setPrice(uint _price) public {
        require(msg.sender == seller, "Only the seller can set the price");
        price = _price;
    }

    // Clause 2: Buyer pays purchase price
    function buy() public payable {
        require(!sold, "Laptop has already been sold");
        require(price != 0, "Price not set");
        require(msg.sender != seller, "Seller can't purchase their own laptop");
        require(msg.sender == buyer, "You are not a party to this contract");

        string memory priceString = StringUtils.uintToString(price);
        string memory priceMessage = string.concat("Price is fixed at ", priceString );
        require(msg.value == price, priceMessage);

        // Transfer payment
        payable(msg.sender).transfer(msg.value);
        // Let the world know
        emit SoldEvent(msg.sender, msg.value);
        // Record the laptop as sold
        sold = true;
    }
}
