<template>
  <a-button v-model:type="button1_type" @click="handle_click">
    <wallet-outlined />
    连接到钱包
  </a-button>

  <div class="addr">
    {{state.wallet_addr}}
  </div>

  <a-button v-if="showDetail" type="primary" @click="get_airdrop">
    <wallet-outlined />
    领取初始积分
  </a-button>
  
  <div class="balance" v-if="showDetail">
    当前余额: {{state.wallet_balance}}
  </div>
</template>

<script lang="ts">
import { WalletOutlined } from '@ant-design/icons-vue';
import { defineComponent, ref , reactive } from 'vue';
import { DAOContract} from "../main.js";
import {AccountAddr} from "../main.js";
import {GanacheTestChainId,GanacheTestChainName
,GanacheTestChainRpcUrl} from "../main.js";
      
export default defineComponent({
  components: {
    WalletOutlined,
  },


  setup(){
    const button1_type = ref('default');
    let showDetail = ref(false);
    const state = reactive({ 
      wallet_addr: '尚未连接到钱包',
      wallet_balance: '0' });
    
    if(AccountAddr.isEmpty()==false){
      state.wallet_addr=AccountAddr.AccountAddr;
      state.wallet_balance=AccountAddr.AccountBalance;
      showDetail.value=true;
      button1_type.value = 'primary';
    }

    const handle_click = () => {
      onClickConnectWallet().then( res => {
        button1_type.value = 'primary';
        showDetail.value=true;
        state.wallet_addr=AccountAddr.AccountAddr;
      }).then(getAccountInfo).then( res =>{
        state.wallet_balance=AccountAddr.AccountBalance;
      })

      console.log(DAOContract);
    };

    const get_airdrop = async () => {
        if(AccountAddr.isEmpty()) {
            alert('You have not connected wallet yet.')
            return
        }

        if (DAOContract) {
            try {
                await DAOContract.methods.airdrop().send({
                    from: AccountAddr.AccountAddr
                })
                await getAccountInfo();
                state.wallet_balance=AccountAddr.AccountBalance;
                alert('You have claimed ZJU Token.')
            } catch (error) {
                alert(error.message)
            }

        } else {
            alert('Contract not exists.')
        }
    }

    return {
      button1_type,
      showDetail,
      handle_click,
      get_airdrop,
      state,
    }
  },

});

const onClickConnectWallet = async () => {
  // 查看window对象里是否存在ethereum（metamask安装后注入的）对象
  // @ts-ignore
  const {ethereum} = window;
  if (!Boolean(ethereum && ethereum.isMetaMask)) {
      alert('MetaMask is not installed!');
      return
  }

  try {
      // 如果当前小狐狸不在本地链上，切换Metamask到本地测试链
      if (ethereum.chainId !== GanacheTestChainId) {
          const chain = {
              chainId: GanacheTestChainId, // Chain-ID
              chainName: GanacheTestChainName, // Chain-Name
              rpcUrls: [GanacheTestChainRpcUrl], // RPC-URL
          };

          try {
              // 尝试切换到本地网络
              await ethereum.request({method: "wallet_switchEthereumChain", params: [{chainId: chain.chainId}]})
          } catch ( switchError ) {
              // 如果本地网络没有添加到Metamask中，添加该网络
              if (switchError.code === 4902) {
                  await ethereum.request({ method: 'wallet_addEthereumChain', params: [chain]
                  });
              }
          }
      }

      // 小狐狸成功切换网络了，接下来让小狐狸请求用户的授权
      await ethereum.request({method: 'eth_requestAccounts'});
      // 获取小狐狸拿到的授权用户列表
      let accounts = await ethereum.request({method: 'eth_accounts'});
      AccountAddr.editAccountAddr(accounts[0]);
  } catch (error) {
      alert(error.message)
  }
}

const getAccountInfo = async () => {
  if (DAOContract) {
      let ab = await DAOContract.methods.get_balance(AccountAddr.AccountAddr).call()
      AccountAddr.editAccountBalance(ab)
  } else {
      alert('Contract not exists.')
  }
}

</script>

<style>
.addr{
  padding-top: 24px;
}

.balance{
  padding-top: 24px;
}
</style>