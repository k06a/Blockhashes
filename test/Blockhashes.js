const Blockhashes = artifacts.require('Blockhashes');

// async function advanceToBlock(number) {
//     if (web3.eth.blockNumber > number) {
//         throw Error(`block number ${number} is in the past (current is ${web3.eth.blockNumber})`);
//     }

//     while (web3.eth.blockNumber < number) {
//         await advanceBlock();
//     }
// }

// function getRawHeader(block, miner) {
//     const header = new BlockHeader({
//         parentHash: block.parentHash,
//         uncleHash: block.sha3Uncles,
//         coinbase: block.miner,
//         stateRoot: block.stateRoot,
//         transactionsTrie: block.transactionsRoot,
//         receiptTrie: block.receiptsRoot,
//         bloom: block.logsBloom,
//         difficulty: parseInt(block.difficulty, 10),
//         number: block.number,
//         gasLimit: block.gasLimit,
//         gasUsed: block.gasUsed,
//         timestamp: block.timestamp,
//         extraData: block.extraData,
//         mixHash: block.mixHash,
//         nonce: block.nonce,
//     });

//     if (miner) {
//         header.coinbase = miner;
//     }

//     return '0x' + header.serialize().toString('hex');
// }

contract('Blockhashes', function ([_, addr1]) {
    describe('Blockhashes', async function () {
        it('should be ok', async function () {
            this.blockhashes = await Blockhashes.new();
        });
    });
});
