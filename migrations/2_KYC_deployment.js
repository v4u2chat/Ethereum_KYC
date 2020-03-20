const KYC = artifacts.require("KYC");
module.exports = function(deployer) {
    deployer.deploy(KYC);
};
