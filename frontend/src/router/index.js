import { createRouter, createWebHistory } from 'vue-router'
import Active_p from '../views/ActiveProposal.vue'
import Fin_p from '../views/FinishedProposal.vue'
import Account from '../views/MyAccount.vue'
import Bonus from '../views/MyBonus.vue'
import Info from '../views/MyInfo.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: Active_p
    },
    {
      path: '/active_proposal',
      name: 'active_proposal',
      component: Active_p
      //component: () => import('../views/AboutView.vue')
    },
    {
      path: '/finished_proposal',
      name: 'finished_proposal',
      component: Fin_p
    },
    {
      path: '/account',
      name: 'account',
      component: Account
    },
    {
      path: '/bonus',
      name: 'bonus',
      component: Bonus
    },
    {
      path: '/info',
      name: 'info',
      component: Info
    }
  ]
})

export default router
