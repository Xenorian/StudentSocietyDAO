import { createApp } from 'vue'
import App from './App.vue'
import router from './router'

//ant-design
import Antd from 'ant-design-vue'
import 'ant-design-vue/dist/antd.css'
//Element-plus
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'

import './assets/main.css'
//Web3
import {web3, DAOContract} from "./utils/contracts";

const GanacheTestChainId = '0x539' 
// Ganache默认的ChainId = 0x539 = Hex(1337)
const GanacheTestChainName = 'Ganache Test Chain'
const GanacheTestChainRpcUrl = 'http://127.0.0.1:7545'

class GlobalData{
    constructor(){
        this.AccountAddr='null';
    }
    editAccountAddr(addr){
        this.AccountAddr=addr;
    }

    editAccountBalance(balance){
        this.AccountBalance=balance;
    }

    isEmpty(){
        if(this.AccountAddr=='null'){
            return true;
        }else{
            return false;
        }
    }
    AccountAddr;
    AccountBalance;
}

let AccountAddr = new GlobalData();
const initCheckAccounts = async () => {
    const {ethereum} = window;
    if (Boolean(ethereum && ethereum.isMetaMask)) {
        // 尝试获取连接的用户账户
        const accounts = await web3.eth.getAccounts()
        if(accounts && accounts.length) {
            AccountAddr.editAccountAddr(accounts[0]);
            let ab = await DAOContract.methods.get_balance().call();
            AccountAddr.editAccountBalance(ab);
        }
    }
}

await initCheckAccounts();

const app = createApp(App)

app.use(router)
app.use(Antd)
app.use(ElementPlus)

app.mount('#app')

export {web3,DAOContract,
    GanacheTestChainId,
    GanacheTestChainName,
    GanacheTestChainRpcUrl,
    AccountAddr}