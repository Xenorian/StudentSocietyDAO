<script lang="ts">
import { defineComponent, reactive } from 'vue';
import { DAOContract} from "../main.js";
import { ref } from 'vue';
import { AccountAddr} from "../main.js";

export default defineComponent({
  setup(props, context) {
    const visible = ref(false);
    const confirmLoading = ref(false);
    // for father component
    const refresh = ref(false);

    const formState = reactive({
      topic: '',
      content: '',
    });

    const onFinish = async () => {
        if(Object.keys(formState.topic).length==0){
            alert('请输入提案标题');
        }else if(Object.keys(formState.content).length==0){
            alert('请输入提案内容');
        }else{
            await makeProposal();
            context.emit('refresh');

            visible.value=false;
            formState.topic='';
            formState.content='';
        }
    };

    const makeProposal = async () => {
      if(AccountAddr.isEmpty()) {
          alert('You have not connected wallet yet.')
          return
      }

      if (DAOContract) {
          try {
              await DAOContract.methods.createProposal(formState.topic,formState.content).send({
                  from: AccountAddr.AccountAddr
              })
              alert('提交成功')
          } catch (error) {
              alert(error.message)
          }

      } else {
          alert('Contract not exists.')
      }
    };

    const newProposal = () =>{
        visible.value = true;
    };

    return {
      formState,
      refresh,
      visible,
      confirmLoading,
      onFinish,
      newProposal,
      makeProposal
    };
  },

});
</script>

<template>
    <a-button type="primary" @click="newProposal">
      新建提案
    </a-button>

    <a-modal v-model:visible="visible" 
      title="新建提案" @ok="onFinish" 
      :confirm-loading="confirmLoading">

      <a-form
      :model="formState"
      name="basic"
      :label-col="{ span: 6 }"
      :wrapper-col="{ span: 16 }"
      autocomplete="off">

      <a-form-item
        label="Topic"
        name="topic"
        :rules="[{ required: true, message: '请输入提案标题' }]">

        <a-input v-model:value="formState.topic" />
      </a-form-item>
  
      <a-form-item
        label="Content"
        name="content"
        :rules="[{ required: true, message: '请输入提案内容' }]">

        <a-textarea v-model:value="formState.content" />
      </a-form-item>
    </a-form>
        
    </a-modal>
  </template>