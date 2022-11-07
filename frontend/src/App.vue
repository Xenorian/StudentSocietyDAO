<script setup>
import { RouterView } from 'vue-router'
// import UserWithLogout from './components/UserWithLogout.vue'
</script>

<template>
  <a-layout style="min-height: 100vh">
    <a-layout-sider v-model:collapsed="collapsed" collapsible>
      <div class="logo" />
      <a-menu v-model:selectedKeys="selectedKeys" theme="dark" mode="inline">
        <a-menu-item key="1" @click="changeContent('active_proposal')">
          <info-circle-outlined />
          <span>当前提案</span>
        </a-menu-item>
        <a-menu-item key="2" @click="changeContent('finished_proposal')">
          <check-circle-outlined />
          <span>已完成的提案</span>
        </a-menu-item>
        <a-menu-item key="3" @click="changeContent('account')">
          <user-outlined />
          <span>我的用户</span>
        </a-menu-item>
        <a-menu-item key="4" @click="changeContent('bonus')">
          <trophy-outlined />
          <span>小礼品</span>
        </a-menu-item>
        <a-menu-item key="5" @click="changeContent('info')">
          <info-outlined />
          <span>使用说明</span>
        </a-menu-item>
      </a-menu>
    </a-layout-sider>

    <a-layout>
      <a-layout-header class="header" style="background: #fff; padding: 0;">
        <div class="header-left">
          去中心化学生社团组织治理-网页版
        </div>

        <div class="header-right">
          <!-- <UserWithLogout /> -->
        </div>
  
      </a-layout-header>

      <a-layout-content style="margin: 32px">
        <div :style="{ padding: '24px', background: '#fff', minHeight: '360px' }">
          <Suspense>
            <router-view />
          </Suspense>
        </div>
      </a-layout-content>

      <a-layout-footer style="text-align: center">
        Created by Xenoria | Powered by Ant Design
      </a-layout-footer>
    </a-layout>
  </a-layout>

</template>


<script>
import { InfoOutlined,InfoCircleOutlined, CheckCircleOutlined, UserOutlined, TrophyOutlined } from '@ant-design/icons-vue';
import { defineComponent, ref } from 'vue';

export default defineComponent({
  components: {
    InfoCircleOutlined,
    CheckCircleOutlined,
    UserOutlined,
    TrophyOutlined,
    InfoOutlined
  },

  data() {
    return {
      collapsed: ref(false),
      selectedKeys: ref(['']),
    };
  },

  methods: {
    //change route on click in the left list
    changeContent(route){
        console.log(route)
        //get router object and push
        this.$router.push(route)
        //change the path
    }
  }

});
</script>

<style>
.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-left{
  padding-left: 24px;
}

.header-right {
  padding-right: 24px;
}

#components-layout-demo-side .logo {
  height: 32px;
  margin: 16px;
  background: rgba(255, 255, 255, 0.3);
}

.site-layout .site-layout-background {
  background: #fff;
}
[data-theme='dark'] .site-layout .site-layout-background {
  background: #141414;
}
</style>
