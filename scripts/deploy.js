const hre = require("hardhat");


async function main() {
  const EET = await hre.ethers.getContractFactory("Electrophorus_Electricus_Token");
  const eet = await EET.deploy(1000000,10);

  await eet.deployed();

  console.log("success!", eet.address);


}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
