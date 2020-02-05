pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/crowdsale/emission/MintedCrowdsale.sol";

contract PupperCoinCrowdSale is Crowdsale, MintedCrowdsale {

    constructor(
        uint rate, // rate in TKNbits
        address payable wallet, // sale beneficiary
        PupperCoin token // the PupperCoin itself that the PupperCoinCrowdSale will work with
    )
        Crowdsale(rate, wallet, token)
        public
    {
        // constructor can stay empty
    }
}

contract PupperTokenSaleDeployer {

    address public pupper_sale_address;
    address public token_address;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet // this address will receive all Ether raised by the sale
    )
        public
    {
        // create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol); 
        token_address = address(token);

        // create the PupperCoinCrowdSale and tell it about the token
        PupperCoinCrowdSale pupper_sale = new PupperCoinCrowdSale(1, wallet, token);
        pupper_sale_address = address(pupper_sale);

        // make the PupperCoinCrowdSale contract a minter, then have the PupperTokenSaleDeployer renounce its minter role
        token.addMinter(pupper_sale_address);
        token.renounceMinter();
    }
}
