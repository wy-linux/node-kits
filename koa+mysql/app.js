const Koa = require('koa2')
const path = require('path')
const router = require('./router')
const cors = require('koa2-cors')
const static = require('koa-static')

const app = new Koa()
const port = 3000


/**
  router.routes(): 启动路由
  router.allowedMethods(): 允许任何请求(get, post , put)
 */
app.use(static(path.join(__dirname, './assets')))
app.use(cors())
app.use(router.routes(), router.allowedMethods())

// app.use(async (ctx) => {
//   ctx.response.body = "Hello, Koa"
// })

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
})