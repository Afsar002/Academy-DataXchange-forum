// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InfoExchange {

    struct Information {
        string data;
        address payable seller;
        uint price;
        bool isSold;
    }

    mapping(uint => Information) public infoList;
    uint public infoCount = 0;

    event InformationAdded(uint infoId, address seller, uint price);
    event InformationPurchased(uint infoId, address buyer);

    function addInformation(string memory _data, uint _price) public {
        infoList[infoCount] = Information({
            data: _data,
            seller: payable(msg.sender),
            price: _price,
            isSold: false
        });

        emit InformationAdded(infoCount, msg.sender, _price);
        infoCount++;
    }

    function purchaseInformation(uint _infoId) public payable {
        Information storage info = infoList[_infoId];
        
        require(!info.isSold, "Information already sold");
        require(msg.value >= info.price, "Not enough Ether sent");

        info.seller.transfer(info.price);
        info.isSold = true;

        emit InformationPurchased(_infoId, msg.sender);
    }

    function getInformation(uint _infoId) public view returns (string memory) {
        Information storage info = infoList[_infoId];
        
        require(info.isSold, "Information not yet sold");

        return info.data;
    }
}
