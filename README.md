# Elephanteum
## What is it?

__Elephanteum__ is an elephant market where you can get some virtual elephants (for free).    
When all elephants will be distributed, you can sell your elephants on auction with certain minimum price.

## What's the point?

This app is written to demostrate possibility of upgrading smart contracts in Solidity.   
For this reason the app contains two controllers that can operate with one storage and proxy contract, which manages which contract has access to storage.  


In order to show benefits of this architecture approach, first controller, called  _ElephanteumCore_   has functions that has security vulnerabities (open for re-entrancy attacks). In this time, other controller, called _ElephanteumAdvancedCore_ has fixed implementation. We can easily replace deployed controller that has vulnerabities by new without needing to replace proxy contract.

## How to test?

For now, I tested project only in testrpc.
To run tests you must have [Truffle](https://github.com/trufflesuite/truffle) and [TestRPC](https://www.npmjs.com/package/ethereumjs-testrpc) installed.      
Start TestRPC by running  

     testrpc   
     
And after that launch tests by running from the app dir command 

     truffle test --network testrpc --reset --compile
