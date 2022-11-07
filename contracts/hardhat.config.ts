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
        '0xfae4afec888f36edab44d817ced6c89db0d29bc99b596d0040736862bea86e46',
      ]
    },
  },
};

export default config;
