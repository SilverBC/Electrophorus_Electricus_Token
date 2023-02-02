const hre = require("hardhat");


async function main() {
  const EETF = await hre.ethers.getContractFactory("Faucet");
  const eetf = await EETF.deploy("0x496A0d71F1eACc340256dC184EEA7cbbB1CF3099");

  await eetf.deployed();

  console.log("success!", eetf.address);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
