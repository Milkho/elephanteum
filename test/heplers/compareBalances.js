module.exports = async (previousBalance, currentBalance, amount) => {
    var strPrevBalance = String(previousBalance);
    var digitsToCompare = 8;
    var subPrevBalance = strPrevBalance.substr(strPrevBalance.length - digitsToCompare, strPrevBalance.length);
    var strBalance = String(currentBalance);
    var subCurrBalance = strBalance.substr(strBalance.length - digitsToCompare, strBalance.length);
    assert.equal(Number(subCurrBalance), Number(subPrevBalance) + amount, "Account balance incorrect");
  };