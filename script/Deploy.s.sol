// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Script.sol";
import "../src/DepartmentWhitelist.sol";
import "../src/DaoVote.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envOr("PRIVATE_KEY", uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80));

        vm.startBroadcast(deployerPrivateKey);

        DepartmentWhitelist whitelist = new DepartmentWhitelist();
        whitelist.setVoter(vm.addr(deployerPrivateKey), "IT", true);

        DaoVote daoVote = new DaoVote(address(whitelist));

        vm.stopBroadcast();
    }
}
