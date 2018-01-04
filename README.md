# Elephanteum
## What is it?

__Elephanteum__ is an elephant market where you can get some virtual elephants for free.    
When all elephants will be distributed, you can sell your elephants on auction with certain minimum price.

## What's the point?

This app is written to demostrate possibility of upgrading business logic in dapps while the storage remains the same.   
You can found storage library original repository  [here](https://github.com/ChronoBank/solidity-storage-lib).

## How to test?

For now, I've tested project only in testrpc.
To run tests you must have [Truffle](https://github.com/trufflesuite/truffle) and [TestRPC](https://www.npmjs.com/package/ethereumjs-testrpc) installed.      
Start TestRPC by running  

     testrpc   
     
And launch tests by running from the app dir

     truffle test --network testrpc --reset --compile