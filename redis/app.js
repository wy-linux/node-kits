const Koa = require('koa')
const { createClient } = require('redis');

const app = new Koa()
const port = 3000

app.use(async (ctx, next) => {
  const client = await createClient({
    url: 'redis://localhost:6379'
  })
    .on('error', err => console.log('Redis Client Error', err))
    .connect()

  // set设置key、value,相同key之间相互覆盖
  await client.set('name', 'wangyu');
  await client.set('name', 'yuwang');
  const value = await client.get('name');
  console.log(value)

  //HSET设置哈希结构
  await client.HSET('wangyu', 'name', 'wy');
  await client.HSET('wangyu', 'age', 24);
  await client.HSET('wangyu', 'job', '前端开发');
  const wangyu = await client.HGETALL('wangyu');
  console.log(wangyu)

  //事务
  await client.HSET('前端开发', '页面', 'React');
  const [Bff, server, frame3D, native3D, HGETALL, hVals] = await client
    .multi()
    .HSET('前端开发', 'Bff', 'Node')
    .HSET('前端开发', 'server', 'Golang')
    .HSET('前端开发', 'frame3D', 'Three')
    .HSET('前端开发', 'native3D', 'WebGL')
    .HGETALL('前端开发')
    .hVals('前端开发')
    .exec();
    console.log('前端开发事务：',{
      Bff,
      server,
      frame3D,
      native3D,
      HGETALL,
      hVals
    })
  await client.disconnect();

})

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
})