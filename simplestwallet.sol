pragma solidity 0.4.18;

contract SimplestWallet {
    
    // hardcode addresses and threshold at time of deployment.
    address[] constant public owners = [ 0xdeaddeaddeaddeaddeaddeaddeaddeaddeaddead, 0xcafecafecafecafecafecafecafecafecafecafe, 0xbeefbeefbeefbeefbeefbeefbeefbeefbeefbeef];
    uint8 constant public threshold = 2;
    uint256 public nonce;
    
    function execute(uint8[] sigV, bytes32[] sigR, bytes32[] sigS, address destination, uint value, bytes data) public {

        require(sigV.length == owners.length && sigR.length == owners.length && sigS.length == owners.length);
        uint8 recovered;
        
        // Follows ERC191 signature scheme: https://github.com/ethereum/EIPs/issues/191
        bytes32 txHash = keccak256(byte(0x19), byte(0), this, destination, value, data, nonce);
    
        for (uint i = 0; i < owners.length; i++) {
            if (owners[i] == ecrecover(txHash, sigV[i], sigR[i], sigS[i]))
                recovered++;
        }
        
        require(recovered >= threshold);
        nonce = nonce + 1;

        require(destination.call.value(value)(data));
    }
    
    function () public payable {}
}
