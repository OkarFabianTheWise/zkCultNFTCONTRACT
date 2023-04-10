# zkCultNFTCONTRACT
deploy nft pool contract + factory
# zkCultpool
┌─────────────────────────────────────────────────────────────────────────────┐
│Warning: It looks like you are checking for 'block.timestamp' in your code,│which might lead to  unexpected behavior.                                     │
│Due to the nature of the zkEVM, the timestamp of a block actually refers to   │
│the timestamp of the whole batch that will be sent to L1 (meaning, the │timestamp of this batch started being processed).  
│We will provide a custom method to access the L2 block timestamp from the │smart contract code in the future
└─────────────────────────────────────────────────────────────────────────────┘       
--> contracts/zkCultStakingFactory.sol
