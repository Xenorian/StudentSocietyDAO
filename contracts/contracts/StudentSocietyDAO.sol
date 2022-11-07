// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment the line to use openzeppelin/ERC20
// You can use this dependency directly because it has been installed already

import "./MyERC20.sol";
import "./MyERC721.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

//global_index point to a invalid addr, global_index-1 is the maximum
//active_index point to earliest active one
contract StudentSocietyDAO {
    // MyERC20
    MyERC20 public studentERC20;

    function get_balance() external view returns(uint32){
        return uint32(studentERC20.balanceOf(msg.sender));
    }

    mapping(address => bool) claimedMap;
    // get airdrop
    function airdrop() external {
        //Check status
        require(claimedMap[msg.sender] == false, "This user has claimed airdrop already");
        //ERC20 - mint
        studentERC20.bonus(msg.sender, 10);
        //Set status
        claimedMap[msg.sender] = true;
    }

    // MyERC721
    MyERC721 public studentSouvenir;
    mapping(address => bool) ERC721_claimed;
    mapping(address => uint256) findIDbyAddr;

    // get ERC721
    function getERC721(string memory url) external{
        //Check status
        require(ERC721_claimed[msg.sender] == false, "This user has claimed ERC721 already");
        //ERC721 - mint
        studentSouvenir.mint(msg.sender, url);
        //Set status
        ERC721_claimed[msg.sender] = true;
        findIDbyAddr[msg.sender] = studentSouvenir._tokenId()-1;
    }

    function getUserERC721URI(address user) view external
    returns(string memory)
    {
        require(ERC721_claimed[user]==true);

        return studentSouvenir.tokenURI(findIDbyAddr[user]);
    }

    function getUserERC721ID(address user) view external
    returns(uint256){
        require(ERC721_claimed[user]==true);

        return findIDbyAddr[user];
    }

    function getPassTimes(address user) view external
    returns(uint32)
    {
        return passTimes[user];
    }


    // self-increment index
    uint32 global_index;
    uint32 active_index;
    // set a default_duration
    uint256 default_duration;
    // set a vote limit
    uint32 vote_limit;

    // use a event if you want
    event ProposalInitiated(uint32 proposalIndex);

    // data struct of proposal
    struct Proposal {
        // check existence
        bool existence;
        // store the status
        bool active;

        uint32 index;      // index of this proposal
        address proposer;  // who make this proposal

        // time is start from 1970/1/1 00:00:00
        uint256 startTime; // proposal start time
        uint256 duration;  // proposal duration

        string name;       // proposal name
        string content;    // proposal content

        // vote data
        uint32 agree;
        uint32 disagree;
    }

    // one addr can only vote once for a proposal
    mapping(uint32 => mapping(address => uint32)) voteTimes;
    mapping(address => uint32) passTimes;

    mapping(uint32 => Proposal) public proposals; // A map from proposal index to proposal
    
    
    function getActiveProposals() external view returns (Proposal[] memory){
        uint32 active_num;
        if(active_index>global_index){
            active_num=0;
        }else{
            active_num=global_index-active_index;
        }

        Proposal[] memory dynamic_ret = new Proposal[](active_num);
        for(uint32 i=active_index;i< global_index;i++){
            dynamic_ret[i-active_index] = (proposals[i]);
        }
        return dynamic_ret;
    }

    function getFinishedProposals() external view returns (Proposal[] memory){
        uint32 finished_num = active_index;

        Proposal[] memory dynamic_ret = new Proposal[](finished_num);
        for(uint32 i=0;i< finished_num;i++){
            dynamic_ret[i] = (proposals[i]);
        }
        return dynamic_ret;
    }

    constructor() {
        // maybe you need a constructor
        studentERC20 = new MyERC20("ZJUToken", "ZJUTokenSymbol");
        studentSouvenir = new MyERC721("ZJU-Souvenir","Z-NFT");
        global_index=0;
        active_index=0;
        default_duration=120;
        vote_limit=1;
    }

    function stateCheck() public {
        for(uint32 i=active_index;i<global_index;i++){
            if(block.timestamp>proposals[i].startTime+proposals[i].duration){
                proposals[i].active = false;
                //update the state
                (passTimes[proposals[i].proposer])++;
                studentERC20.bonus(proposals[i].proposer, proposals[i].agree+proposals[i].disagree-1);
                active_index++;
            }
        }
    }

    function createProposal(string memory m_name,string memory m_content) public {
        require(studentERC20.balanceOf(msg.sender) > 0, "balance is not enough");
        studentERC20.burn(msg.sender,1);

        stateCheck();
        proposals[global_index]=Proposal({
            index : global_index,
            proposer : msg.sender,
            startTime : block.timestamp,
            duration : default_duration,
            name : m_name,
            content : m_content,
            agree : 1,
            disagree : 0,
            existence: true,
            active: true
        });

        ((voteTimes[global_index])[msg.sender])++;
        global_index=global_index+1;
    }

    // vote for a proposal
    function vote(uint32 m_index,bool agree) public{
        stateCheck();
        require(proposals[m_index].existence == true, "no such proposal");
        require((voteTimes[global_index])[msg.sender] < vote_limit, "exceed vote times limit");
        require(studentERC20.balanceOf(msg.sender) > 0, "balance is not enough");
        require(proposals[m_index].active == true, "proposal is finished");

        ((voteTimes[global_index])[msg.sender])++;
        studentERC20.burn(msg.sender,1);
        if(agree){
            (proposals[m_index].agree)++;
        }else{
            (proposals[m_index].disagree)++;
        }
    }
}
