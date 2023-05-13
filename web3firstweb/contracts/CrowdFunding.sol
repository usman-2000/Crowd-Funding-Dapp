// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    constructor() {}

    struct Campaign{
        address owner;
        string title;
        string description;
        uint256 deadline;
        uint256 target;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    mapping(uint256 => Campaign) public campaigns;
    uint256 public numberOfCampaigns = 0;

    function createCampaign(address _owner, string memory _title , string memory _description, uint _deadline, uint _target , string memory _image)public returns(uint256){
        Campaign storage campaign = campaigns[numberOfCampaigns];

        require(campaign.deadline < block.timestamp," Deadline should be ahead");

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.deadline = _deadline;
        campaign.target = _target;
        campaign.image = _image;
        campaign.amountCollected = 0;

        numberOfCampaigns ++;

        return numberOfCampaigns - 1;
    }

    function donateToCampaign(uint256 _id)public payable{
        Campaign storage campaign = campaigns[_id];

        uint256 amount = msg.value;
        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent,) = payable(campaign.owner).call{value:amount}("");

        if(sent){
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    function getDonators(uint _index)public view returns(address[] memory , uint256[] memory){
        return (campaigns[_index].donators, campaigns[_index].donations);
    }

    function getCampaigns()view public returns(Campaign[] memory){
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for(uint256 i = 0 ; i < numberOfCampaigns ; i++){
            Campaign memory item = campaigns[i];

            allCampaigns[i] = item;
        }

        return allCampaigns;
    }

}