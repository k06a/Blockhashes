pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "solidity-rlp/contracts/RLPReader.sol";


contract Blockhashes {
    using SafeMath for uint256;
    using RLPReader for RLPReader.RLPItem;

    mapping(uint256 => uint256) private _requests;
    mapping(uint256 => bytes32) private _blockhashes;

    event RequestCreated(uint256 indexed blockNumber);
    event RequestResolved(uint256 indexed blockNumber);

    function blockhashes(uint256 blockNumber) public view returns(bytes32) {
        if (blockNumber >= block.number.sub(256)) {
            return blockhash(blockNumber);
        }
        return _blockhashes[blockNumber];
    }

    function request(uint256 blockNumber) public payable {
        require(_requests[blockNumber] == 0);
        _requests[blockNumber] = msg.value;
        emit RequestCreated(blockNumber);
    }

    function resolve(uint256 blockNumber) public {
        _resolve(blockNumber, blockhash(blockNumber));
    }

    function resolve(uint256 blockNumber, bytes memory blocksData, uint256[] memory starts) public {
        require(starts.length > 0 && starts[starts.length - 1] == blocksData.length, "Wrong starts argument");

        bytes32 expectedHash = blockhashes(blockNumber);
        for (uint i = 0; i < starts.length - 1; i++) {
            uint256 offset = starts[i];
            uint256 length = starts[i + 1].sub(offset);

            uint256 ptr;
            bytes32 result;
            // solium-disable-next-line security/no-inline-assembly
            assembly {
                ptr := add(add(blocksData, 0x20), offset)
                result := keccak256(ptr, length)
            }

            require(result == expectedHash, "Blockhash didn't match");
            expectedHash = bytes32(RLPReader.RLPItem({len: length, memPtr: ptr}).toList()[0].toUint());
        }

        uint256 index = blockNumber.add(1).sub(starts.length);
        _resolve(index, expectedHash);
    }

    function _resolve(uint256 blockNumber, bytes32 hash) internal {
        require(hash != bytes32(0));

        if (_blockhashes[blockNumber] == bytes32(0)) {
            uint256 reward = _requests[blockNumber];
            if (reward > 0) {
                msg.sender.transfer(reward);
                _requests[blockNumber] = 0;
            }
            _blockhashes[blockNumber] = hash;
            emit RequestResolved(blockNumber);
        }
    }
}
