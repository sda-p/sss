// SPDX-License-Identifier: MIT
pragma solidity 0.8.6;
 
import "https://github.com/0xcert/ethereum-erc721/src/contracts/tokens/nf-token-metadata.sol";
import "https://github.com/0xcert/ethereum-erc721/src/contracts/ownership/ownable.sol";
 
contract newNFT is NFTokenMetadata, Ownable 
{

address payable feeAddress;
uint constant public galPrice = 0.01 ether;
uint constant public giftGals = 55;
uint constant public publicGals = 5000;
uint constant public purchaseLimit = 5;

bool public allowListActive = true;
mapping(address => bool) private allowList;

uint constant public maxGals = giftGals + publicGals;
string constant private metaAddress = "https://safedogecoommoon.com/metadata/";
string constant private jsonAppend = ".json";
uint public currentGal = 0;

constructor() 
{
    nftName = "EtherFrogs Extended Ultimate";
    nftSymbol = "EFR2";
    feeAddress = payable(msg.sender);
}

function toggleAllowList() public onlyOwner
{
    allowListActive = !allowlistActive;
}

function updateRecipient(address payable _newAddress) public onlyOwner
{
    feeAddress = _newAddress;
}

function uintToBytes(uint v) private pure returns (bytes32 ret) {
        if (v == 0) 
        {
            ret = '0';
        }
        else 
        {
            while (v > 0) 
            {
                ret = bytes32(uint(ret) / (2 ** 8));
                ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
                v /= 10;
            }
        }
        return ret;
}

 
function mint(uint8 _galnum) public payable
{
    require(currentGal < maxGals, "All Gals have been minted.");
    require((currentGal + _galnum) <= maxGals, "Tried to mint more Gals than are left.");
    require(msg.value >= galPrice*_galnum, "Insufficient price for the selected amount.");
    require(_galnum < purchaseLimit, "Cannot mint more than 5 gals at a time.");
    if (allowlistActive)
    {
        
    }
    
    bytes32 gal;
    bytes memory concat;
    for(uint i=0; i < _galnum; i++)
    {
        gal = uintToBytes(currentGal);
        concat = abi.encodePacked(metaAddress, gal, jsonAppend);
        super._mint(msg.sender, currentGal);
        super._setTokenUri(currentGal, string(concat));
        currentGal=currentGal+1;
    }
    feeAddress.transfer(msg.value);
}
 
}
