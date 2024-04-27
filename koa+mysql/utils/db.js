const mysql = require('mysql')

//连接池
const pool = mysql.createPool({
  host: 'localhost', //服务器地址（内网ip）
  port: 3306, //mysql运行端口
  database: 'koa',
  user: 'root',
  password: 'root',
  charset   : 'utf8mb4',
  collation : 'utf8mb4_unicode_ci'
})

//对数据库进行增删改查的基础方法
function query(sql, callback) {
  pool.getConnection(function(err, connection) {
    connection.query(sql, function(err, rows) {
      callback(err, rows)
      connection.release() //中断连接
    })
  })
}

module.exports = {
  query
}