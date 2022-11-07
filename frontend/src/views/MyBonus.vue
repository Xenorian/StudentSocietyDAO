<template>
    <div v-if="showDetail">
      您的钱包地址: {{AccountAddr.AccountAddr}}
    </div>
    <div v-else ref="wallet_addr" class="addr">
      尚未连接到钱包
    </div>
    
    <a-button v-if="button1=='1'" disabled>
      现在还不能领取小礼品哦
    </a-button>

    <a-button v-if="button1=='2'" type="primary" @click="handle_click">
      领取小奖品
    </a-button>

    <div v-if="button1=='3'">
      <p> 您的纪念品ID : {{Souvenir.id}} </p>
      <p> 您的纪念品内容: {{Souvenir.content}} </p>
    </div>

    <a-modal v-model:visible="visible" 
      title="领取纪念品" @ok="onFinish" >

      <a-form
      :model="formState"
      name="basic"
      :label-col="{ span: 6 }"
      :wrapper-col="{ span: 16 }"
      autocomplete="off">
  
      <a-form-item
        label="纪念品内容"
        name="content"
        :rules="[{ required: true, message: '请输入纪念品内容' }]">

        <a-textarea v-model:value="formState.content" />
      </a-form-item>
    </a-form>
        
    </a-modal>
  </template>
  
  <script>
  import { defineComponent, ref, reactive } from 'vue';
  import {DAOContract} from "../main.js";
  import {AccountAddr} from "../main.js";
  import { Modal } from 'ant-design-vue';
  
  export default defineComponent({
    async setup(){
      const showDetail = ref(false);
      const button1 = ref('1')
      const visible = ref(false);
      const formState = reactive({
        content: '',
      });
      const Souvenir=reactive({
        id: '',
        content: ''
      })

      const onFinish = async() =>{
        if(formState.content==''){
          alert("请输入纪念品内容")
          return;
        }
        
        try{
          await DAOContract.methods.getERC721(formState.content).send({
            from: AccountAddr.AccountAddr
          });
          // let id= await DAOContract.methods.getUserERC721ID(AccountAddr.AccountAddr).call();

          Modal.success({
            title: '领取成功',
            content: '您已成功领取纪念品'
          });
        }catch(error){
          Modal.error({
            title: '错误',
            content: error.message
          });
          visible.value=false;
        }
      }

      const handle_click = async() => {
        visible.value=true;
      };

      if(AccountAddr.isEmpty()==false){
        await DAOContract.methods.stateCheck().send({
          from: AccountAddr.AccountAddr
        });

        let passtimes = await DAOContract.methods.getPassTimes(AccountAddr.AccountAddr).call();
        if(passtimes>=3){
          button1.value='2';

          try{
            Souvenir.id = await DAOContract.methods.getUserERC721ID(AccountAddr.AccountAddr).call();
            Souvenir.content = await DAOContract.methods.getUserERC721URI(AccountAddr.AccountAddr).call();
            button1.value='3';
          }catch(error){
            button1.value='2';
          }
        }
        showDetail.value=true;
      }
  
      return {
        button1,
        AccountAddr,
        showDetail,
        visible,
        formState,
        Souvenir,
        onFinish,
        handle_click,
      }
    },
  
  });
  </script>
  
  <style>
  .addr{
    padding-bottom: 24px;
  }
  </style>