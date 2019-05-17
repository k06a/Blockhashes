const Migrations = artifacts.require('./Migrations.sol');
const Blockhashes = artifacts.require('./Blockhashes.sol');

module.exports = function (deployer) {
    deployer.deploy(Migrations);
    deployer.deploy(Blockhashes);
};
