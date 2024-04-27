// 存放关于list的所有接口
const Router = require('koa-router')
const list = new Router()


list.get('/', async (ctx) => {
  ctx.body = "列表页--首页"
})

list.get('/yinger', async (ctx) => {
  ctx.body = "列表页--婴儿"
})

list.get('/wanju', async (ctx) => {
  ctx.body = "列表页--玩具"
})

module.exports = list