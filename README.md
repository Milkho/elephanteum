# Elephanteum
## What is it?

__Elephanteum__ is an elephant market where you can get some virtual elephants (for free).    
When all elephants will distributed, you can sell your elephants on auction with certain minimum price.

## What's the point?

This app is written to demostrate possibility of upgrading smart contracts in Solidity.   
For this reason the app contains two controllers that can operate with one storage and transfer it to each other.  


Basic controller, called  _ElephanteumCore_   has only functions for getting and trasfering your elephants.
In this time, more advanced controller, called _ElephanteumAdvancedCore_ has additional functions for auction selling, bidding and withdrawing your balances.

## How to test?

For now, I tested project only in testrpc.
To run test you must have [Truffle](https://github.com/trufflesuite/truffle) and [TestRPC](https://github.com/trufflesuite/ganache-cli)    
Then run (in separate terminal/console window)   

     testrpc   
     
And after that launch tests running from the app dir command 

     truffle test --network testrpc --reset --compile
   
## Where are docs?

I will write the docs for the code soon. Honestly.

