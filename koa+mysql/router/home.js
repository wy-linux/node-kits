// 存放关于home的所有接口
const Router = require('koa-router')
const home = new Router()
const db = require('../utils/db')

home.get('/', async (ctx) => {
  ctx.body = "首页--首页"
})

home.get('/banner', async (ctx) => {
  const banners = await new Promise((resolve, reject) => {
    db.query('select * from banner', (err, data) => {
      if (err) throw err
      resolve(data)
    })
  })
  ctx.body = banners
})

home.get('/footer', async (ctx) => {
  ctx.body = "首页--底部"
})

module.exports = home