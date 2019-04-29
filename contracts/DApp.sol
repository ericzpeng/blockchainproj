pragma solidity ^0.5.0;

/* @title Codeology Blockchain Project - Spring 2019
		@author Eric Peng & Emily Wang
*/

contract Casino {
	// Add different class variables here that you might need to use to store data
	address owner;
	// YOUR CODE HERE
	uint public maxAmountOfBets;
	uint public minAmountOfBets;
	uint public numberOfBets;
	uint timeStart;
	mapping (address => uint) bets;
	mapping (address => uint) amountBet;
	address payable[] betters;

	// Create a constructor here!
	// The constructor will be used to configure different parameters you might want to
	// initialize with the creation of the contract (i.e. minimum bet, max amount of bets, etc.)
	constructor () public {
		owner = msg.sender;
		// YOUR CODE HERE
		maxAmountOfBets = 5;
		minAmountOfBets = 2;
		numberOfBets = 0;
		betters = new address payable[](maxAmountOfBets);
	}

	// Below is a modifier, and the purpose of this modifier is to execute the other functions
	// in the Smart Contract once a certain limit has been reached (num of players > set amount)
	// of players to begin with. You can put the name of the modifier in the functions below to
	// have them run only when the modifier is true, as seen with the generateWinningNumber function
	modifier onEndGame(){
		if ((numberOfBets >= maxAmountOfBets)) {
		    _;
		} else if ((numberOfBets >= minAmountOfBets) && (timeStart + 2 minutes <= now)) {
				_;
		}
	}

	// Construct the function to conduct a bet here!
	// The function can will be passed in a number to bet, and you can access
	// the user's address and amount bet with msg.sender and msg.value respectively.
	function bet(uint numberToBet) public payable{
		bets[msg.sender] = numberToBet;
		amountBet[msg.sender] = msg.value;
		numberOfBets++;
		timeStart = now;
	}

	// Make a random number generator here! (We'll get into variants of at a future week, but
	// you can use what cryptozombies.io discussed here!)
	function generateWinningNumber() public onEndGame returns (uint) {
		string memory hash = "ericpengemilywang";
		for (uint i = 0; i < numberOfBets; i++) {
			hash = string(abi.encodePacked(hash, betters[i], bets[betters[i]]));
		}
		uint rand = uint(keccak256(abi.encodePacked(hash)));
    return rand % 10;
	}

	// Distribute the prizes! Send the ether to the winners with the .transfer function,
	// and call the resetData function to reset the different states of the contract!
	function distributePrizes() onEndGame public {
		// YOUR CODE HERE
		uint winningNum = generateWinningNumber();
		for (uint j = 0; j < numberOfBets; j++) {
			if (bets[betters[j]] == winningNum) {
				betters[j].transfer(amountBet[betters[j]] * 2);
			}
		}
		resetData();
	}

	// Reset the data of the Smart Contract here!
	function resetData() public {
		numberOfBets = 0;
		timeStart = now;
		betters = new address payable[](maxAmountOfBets);
	}
}
