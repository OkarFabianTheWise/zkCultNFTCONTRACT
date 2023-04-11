import { Wallet, utils } from "zksync-web3";
import * as ethers from "ethers";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { Deployer } from "@matterlabs/hardhat-zksync-deploy";

// compile command: npx hardhat compile
// deploy command: npx hardhat deploy-zksync 


// An example of a deploy script that will deploy and call a simple contract.
export default async function (hre: HardhatRuntimeEnvironment) {
  console.log(`Running deploy script for the cult staking pool and factory contract`);

  // Initialize the wallet.
  const wallet = new Wallet("962ade0e36cfd80711fe663d194c56cc75571925a47e3c8cc378f5eba5b563bb");

// Create deployer object and load the artifact of the contract you want to deploy.
  const deployer = new Deployer(hre, wallet);
  const poolArtifact = await deployer.loadArtifact("zkCultStakingPool");
  const factoryArtifact = await deployer.loadArtifact("zkCultStakingFactory");

  // CONSTRUCTOR VARIABLES
  const _nftCollection = "0x7D24d59d5968677F31Ab9c25941F6909585965AB"; // replace with actual address of NFT collection
  const _rewardToken = "0xB3d6Fb1BC452c6f87875832EEd00e315914969e6"; // actual address of reward token
  const _nftValueTokenAddr = "0x5Eb1Da89177A65d4Ab781d83E3eB9E551592183F"; // replace with actual address of NFT value token
  const _amountOfValueToken = 0; // replace with actual amount of value token
  const _nftTokenLogo = "https://example.com/_nftTokenLogo.png"; //URL OF LOGO
  const _rewardTokenLogo = "https://example.com/_rewardTokenLogo.png"; // URL OF REWARD TOKEN LOGO
  const _websiteURL = "https://zkcult.monster"; //URL OF WEBSITE
  const _lockDuration = 1; // REPLACE WITH ACTUAL LOCK DURATION IN DAYS
  const _rewardPerDay = 1; // REPLACE WITH ACTUAL REWARD PER DAY
  const _poolOwner = "0x8afACaec5DAd5F03cB3913eA2Ab1609D937b3ff3"; // replace with actual address of pool owner
  const _endTime = 0//Math.floor(Date.now() / 1000) + 3600; set end time to 1 hour from now

  // Estimate contract deployment fee
  const deploymentFee1 = await deployer.estimateDeployFee(poolArtifact, [
    _nftCollection,
    _rewardToken,
    _nftValueTokenAddr,
    _amountOfValueToken,
    _nftTokenLogo,
    _rewardTokenLogo,
    _websiteURL,
    _lockDuration,
    _rewardPerDay,
    _poolOwner,
    _endTime
  ]);

  const _zkCult = "0xc9d249fe7994d0f1787741264Bb161B0801B7f75";
  const _zkCultAmount = ethers.utils.parseEther("0"); // Replace with the amount of zkCult to be used in deployment
  const _ethAmount = ethers.utils.parseEther("0.001"); // Replace with the amount of Ether to be used in deployment

  const deploymentFee2 = await deployer.estimateDeployFee(factoryArtifact, [
    _zkCult,
    _zkCultAmount,
    _ethAmount
  ]);

  //_zkCult, _zkCultAmount, _ethAmountDeploy this contract. The returned object will be of a `Contract` type, similarly to ones in `ethers`.
  const parsedFee1 = ethers.utils.formatEther(deploymentFee1.toString());
  const parsedFee2 = ethers.utils.formatEther(deploymentFee2.toString());
  console.log(`The pool deployment estimated: ${parsedFee1} ETH`);
  console.log(`The factory deployment estimated: ${parsedFee2} ETH`);
  

  const nftpool = await deployer.deploy(poolArtifact, [
    _nftCollection,
    _rewardToken,
    _nftValueTokenAddr,
    _amountOfValueToken,
    _nftTokenLogo,
    _rewardTokenLogo,
    _websiteURL,
    _lockDuration,
    _rewardPerDay,
    _poolOwner,
    _endTime
  ]);

  const nftfactory = await deployer.deploy(factoryArtifact, [
    _zkCult,
    _zkCultAmount,
    _ethAmount
  ]);

  console.log(nftpool.interface.encodeDeploy([
    _nftCollection,
    _rewardToken,
    _nftValueTokenAddr,
    _amountOfValueToken,
    _nftTokenLogo,
    _rewardTokenLogo,
    _websiteURL,
    _lockDuration,
    _rewardPerDay,
    _poolOwner,
    _endTime
  ]));
  console.log("nftfactory hex")
  console.log(nftfactory.interface.encodeDeploy([
    _zkCult,
    _zkCultAmount,
    _ethAmount
  ]));

  // Show the contract info.
  const pooladdress = nftpool.address;
  const factoryaddress = nftfactory.address;
  console.log(`${poolArtifact.contractName} was deployed to ${pooladdress}`);
  console.log(`${factoryArtifact.contractName} was deployed to ${factoryaddress}`);
}
