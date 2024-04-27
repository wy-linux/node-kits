const Router = require('koa-router')
const router = new Router()
const list = require('./list')
const home = require('./home')
const login = require('./login')

router.use('/list', list.routes(), list.allowedMethods())
router.use('/home', home.routes(), home.allowedMethods())
router.use('/login', login.routes(), login.allowedMethods())


// "/"重定向到"/home"
router.redirect('/', '/home')


module.exports = router