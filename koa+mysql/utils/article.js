// 创建联表数据（，终端运行）
// CREATE TABLE article(
// 	id INT PRIMARY KEY COMMENT '资讯id',
//     title VARCHAR(20) COMMENT '标题',
//     author VARCHAR(20) COMMENT '作者',
//     date VARCHAR(20) COMMENT '日期',
//     imgUrl VARCHAR(100) COMMENT '配图',
//     content LONGTEXT COMMENT '内容-存储html标签',
// 		FOREIGN KEY (id) REFERENCES zixun(id)
// );

const db = require('./db')
const fs = require('fs')

// 读取文件的函数
function readFileFn(subject){
    return new Promise((resolve, reject)=>{
        fs.readFile(`../assets/${subject}.txt`, (err, data)=>{
            if(err) throw err;
            resolve(data.toString())
        })
    })
}

let vueContent, reactContent, angularContent;
var fn = async () => {
  	// 分别读取这几份txt文件
    vueContent = await readFileFn('vue');
    reactContent = await readFileFn('react');
    angularContent = await readFileFn('angular');

    let data = [
        {id: 0, title: "一套框架多种平台 移动端&桌面端", author: "张三丰", date: "2013-03-22", imgUrl: "/images/dt.png", content: angularContent},
        {id: 1, title: "渐进式的JavaScript 框架", author: "小鱼儿", date: "2014-04-23", imgUrl: "/images/dt.png", content: vueContent},
        {id: 2, title: "一套框架多种平台 移动端&桌面端", author: "花无缺", date: "2015-05-24", imgUrl: "/images/dt.png", content: reactContent}
    ]

    data.map(val=>{
        let sql = `INSERT INTO article VALUES (${val.id}, '${val.title}', '${val.author}', '${val.date}', '${val.imgUrl}', '${val.content}')`;
        db.query(sql, (err, data)=>{
            if(err) console.log(err);
            console.log(data)
        })
    })
}
fn();