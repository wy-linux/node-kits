// 存放关于login的所有接口
const Router = require('koa-router')
const login = new Router()
const bodyparser = require('koa-bodyparser')
const jwt = require('jsonwebtoken')
const db = require('../utils/db')

login.use(bodyparser())

login.post('/register', async (ctx) => {
  const {account, pwd} = ctx.request.body
  const users = await new Promise((reslove, reject) => {
    db.query(`select * from users where account='${account}'`, (err, data) => {
      if(err) throw err
      reslove(data)
    })
  })

  if(users.length > 0) { //有账号，验证密码
    if(users[0].pwd === pwd) {
      ctx.body = {
        msg: '登录成功',
        token: users[0].token,
        account
      }
    } else {
      ctx.body = {
        msg: "账号或密码错误"
      }
    }
  } else { //没有账号，直接注册
    //创建token， expiresIn: 一小时过期
    const token = jwt.sign({account, pwd}, 'secret',{expiresIn: 3600})
    const insertSql = `insert into users (account, pwd, token) values ('${account}', '${pwd}', '${token}')`
    const res = await new Promise((reslove, reject) => {
      db.query(insertSql, (err, data) => {
        if(err) throw err
        const res = {
          msg:'注册成功',
          token,
          account
        }
        reslove(res)
      })
    })
    ctx.body = res
  }
})

module.exports = login