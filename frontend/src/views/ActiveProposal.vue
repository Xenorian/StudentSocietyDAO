<template>
    <div v-if="showDetail">
      <createProposalForm @refresh="refresh">
      </createProposalForm>
      当前余额: {{AccountAddr.AccountBalance}}
    </div>

    <el-table :data="queryData" 
    style="width: 100%"
    border
    scrollbar-always-on
    height="500"
    @current-change="handleCurrentChange">
      <el-table-column prop="name" label="提案名称" width="300" />
      <el-table-column prop="content" label="提案内容" width="1200" />
      <el-table-column prop="agree" label="赞同数" />
      <el-table-column prop="disagree" label="反对数" />
      <el-table-column label="操作" width="120">
        <template v-slot="scope">
          <a @click="vote_agree(scope.row.index)">赞成</a>
          <a-divider type="vertical" />
          <a @click="vote_disagree(scope.row.index)">反对</a>
        </template>
      </el-table-column>
    </el-table>
  </template>

  <script>
  import { defineComponent } from 'vue';
  import { ref } from 'vue';
  import { Modal } from 'ant-design-vue';
  import createProposalForm from "../components/CreateProposal.vue";
  import {DAOContract} from "../main.js";
  import {AccountAddr} from "../main.js";

  export default defineComponent({
    components: {
      createProposalForm
    },

    async setup() {
      const getAccountInfo = async () => {
      if (DAOContract) {
          let ab = await DAOContract.methods.get_balance().call()
          AccountAddr.editAccountBalance(ab)
      } else {
          alert('Contract not exists.')
      }
      };

      const get_activeProposal = async () => {
      if(AccountAddr.isEmpty()) {
          Modal.error({
          title: 'error',
          content: '还没有连接钱包哦',
        });
          return null;
      }

      if (DAOContract) {
          try {
            showDetail.value = true;

            await DAOContract.methods.stateCheck().send({
              from: AccountAddr.AccountAddr
            });

            const data = await DAOContract.methods.getActiveProposals().call();
              await getAccountInfo();
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

      const refresh = async() => {
        await get_activeProposal().then(res =>{queryData.value=res});
      }

      const queryData = ref(null);
      const currentRow = ref();
      const showDetail = ref(false);
      await refresh();

      const vote_agree = async(index) =>{
        await DAOContract.methods.vote(index, true).send({
          from: AccountAddr.AccountAddr
        });
        await refresh();
        alert("投票成功")
      }

      const vote_disagree = async(index) =>{
        await DAOContract.methods.vote(index, false).send({
          from: AccountAddr.AccountAddr
        });
        await refresh();
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
        refresh,
        showDetail,
        AccountAddr,
        handleCurrentChange,
        getAccountInfo,
      };
    },
  
  });
  </script>