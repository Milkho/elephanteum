# Elephanteum
## What is it?

__Elephanteum__ is an elephant market where you can get some virtual elephants for free.    
When all elephants will be distributed, you can sell your elephants on auction with certain minimum price.

## What's the point?

This app is written to demostrate possibility of upgrading smart contracts in Solidity.   
For this reason the app contains two controllers that can operate with one storage and proxy contract, which manages which contract has access to storage.  


In order to show benefits of this architecture approach first controller called  _ElephanteumCore_   has functions that have security vulnerabities (they're open for [re-entrancy attacks](https://medium.com/@gus_tavo_guim/reentrancy-attack-on-smart-contracts-how-to-identify-the-exploitable-and-an-example-of-an-attack-4470a2d8dfe4)). In this time, other controller, called _ElephanteumAdvancedCore_ has fixed implementation. We can easily replace deployed controller that has vulnerabities by new one without needing to replace proxy contract. 

## How to test?

For now, I've tested project only in testrpc.
To run tests you must have [Truffle](https://github.com/trufflesuite/truffle) and [TestRPC](https://www.npmjs.com/package/ethereumjs-testrpc) installed.      
Start TestRPC by running  

     testrpc   
     
And launch tests by running from the app dir

     truffle test --network testrpc --reset --compile
