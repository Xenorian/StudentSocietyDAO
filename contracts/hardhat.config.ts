import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.9",
  networks: {
    ganache: {
      // rpc url, change it according to your ganache configuration
      url: 'http://localhost:7545',
      // the private key of signers, change it according to your ganache user
      accounts: [
        '0xee51ad27563ccc0ee1f21880c2bea35b0648df7d46a72cd98ed6c488a9599294',
      ]
    },
  },
};

export default config;
