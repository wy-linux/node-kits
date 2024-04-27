// 创建banner表格(终端运行)
// create table banner (
//   id INT NOT NULL PRIMARY KEY,
//   imgUrl VARCHAR(100) NOT NULL
// );

// 添加数据
const db = require('./db')
const data = [
  {id: 0, imgUrl: '/images/vue.png'},
  {id: 1, imgUrl: '/images/react.png'},
  {id: 2, imgUrl: '/images/angular.png'}
]

data.map(val=>{
  // 这里记住，如果是字符串，必须在变量外层套一个引号，否则会出现sql语句报错
  let sql = `INSERT INTO banner VALUES (${val.id}, '${val.imgUrl}')`;
  db.query(sql, (err, data)=>{
      if(err) console.log(err);
      console.log(data)
  })
})
