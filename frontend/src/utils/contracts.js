import Addresses from './contract-addresses.json'
import StudentSocietyDAO from './abis/StudentSocietyDAO.json'
import Web3 from 'web3'

// @ts-ignore
// 创建web3实例
// 可以阅读获取更多信息https://docs.metamask.io/guide/provider-migration.html#replacing-window-web3
let web3 = new Web3(window.web3.currentProvider)

// 修改地址为部署的合约地址
const DAOAddress = Addresses.DAO
const DAOABI = StudentSocietyDAO.abi

// 获取合约实例
const DAOContract = new web3.eth.Contract(DAOABI, DAOAddress);

// 导出web3实例和其它部署的合约
export {web3, DAOContract}