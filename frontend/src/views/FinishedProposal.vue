<template>
  <el-table :data="queryData" 
  style="width: 100%"
  border
  scrollbar-always-on
  height="500"
  @current-change="handleCurrentChange">
    <el-table-column prop="name" label="提案名称" width="300" />
    <el-table-column prop="content" label="提案内容" width="1200" />
    <el-table-column label="通过/不通过" width="120">
      <template v-slot="scope">
        <a-tag v-if="queryData[scope.row.index].agree >
          queryData[scope.row.index].disagree" color="red">通过</a-tag>
        <a-tag v-else color="green">不通过</a-tag>
      </template>
    </el-table-column>
    <el-table-column prop="agree" label="赞同数" />
    <el-table-column prop="disagree" label="反对数" />
  </el-table>
</template>

<script>
import { defineComponent } from 'vue';
import { ref } from 'vue';
import { Modal } from 'ant-design-vue';

import {DAOContract} from "../main.js";
import {AccountAddr} from "../main.js";

export default defineComponent({

  async setup() {
    const getAccountInfo = async () => {
    if (DAOContract) {
        let ab = await DAOContract.methods.get_balance().call()
        AccountAddr.editAccountBalance(ab)
    } else {
        alert('Contract not exists.')
    }
    };

    const get_finishedProposal = async () => {
    if(AccountAddr.isEmpty()) {
        Modal.error({
        title: 'error',
        content: '还没有连接钱包哦',
      });
        return null;
    }

    if (DAOContract) {
        try {
          await DAOContract.methods.stateCheck().send({
            from: AccountAddr.AccountAddr
          });

          const data = await DAOContract.methods.getFinishedProposals().call();
            await getAccountInfo();
            console.log(data);
            return data;
        } catch (error) {
            Modal.error({
              title: 'error',
              content: error.message,
            });
            return null;
        }
    } else {
        return null;
    }};

    const queryData = ref(null);
    const currentRow = ref();
    await get_finishedProposal().then(res =>{queryData.value=res});

    const vote_agree = () =>{
      DAOContract.method.vote(currentRow.value.index, true).send({
        from: AccountAddr.AccountAddr
      });

      alert("投票成功")
    }

    const vote_disagree = () =>{
      DAOContract.method.vote(currentRow.value.index, false).send({
        from: AccountAddr.AccountAddr
      });

      alert("投票成功")
    }
    
    const handleCurrentChange = (val) => {
      currentRow.value = val
    }
    return {
      queryData,
      currentRow,
      vote_agree,
      vote_disagree,
      AccountAddr,
      handleCurrentChange,
      getAccountInfo,
    };
  },

});
</script>