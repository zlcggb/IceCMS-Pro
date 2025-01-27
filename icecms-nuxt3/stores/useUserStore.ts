import { defineStore } from "pinia";

export const useUserStore = defineStore('user', {
  state: () => ({
    name: '张三',
    age: 18,
    sex: '男'
  }),
  getters: {
    ageAdd: (state) => state.age++
  },
  actions: {
    ageChange() {
      this.age++
    }
  }
})
