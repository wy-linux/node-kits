-- ---------------------------------------> 创建表、插入数据的步骤见 索引 <----------------------------------



-- ---------------------------------------> SQL优化 <----------------------------------
-- 1.主键优化: 插入数据时，尽量选择顺序插入，选择使用AUTO_INCREMENT自增主键，尽量不要使用UUID做主键或者是其他自然主键，如身份证号、手机号等。

-- 2.order by优化
-- MySQL的排序，有两种方式：
  -- Using filesort : 通过表的索引或全表扫描，读取满足条件的数据行，然后在排序缓冲区sort buffer中完成排序操作，所有不是通过索引直接返回排序结果的排序都叫 FileSort 排序。
  -- Using index : 通过有序索引顺序扫描直接返回有序数据，这种情况即为 using index，不需要额外排序，操作效率高。

-- 删除phone、name字段的索引
drop index idx_user_phone on tb_user;
drop index idx_user_name on tb_user;

-- 执行排序sql
explain select id,age,phone from tb_user order by age; -- Extra: Using filesort
explain select id,age,phone from tb_user order by age, phone; -- Extra: Using filesort

-- 为age、phone字段创建联合索引
create index idx_user_age_phone_aa on tb_user(age, phone);

-- 创建索引后，根据age，phone进行升序排序
explain select id,age,phone from tb_user order by age; -- Extra: Using index
explain select id,age,phone from tb_user order by age, phone; -- Extra: Using index

-- 创建索引后，根据age，phone进行降序排序
explain select id,age,phone from tb_user order by age desc , phone desc; -- Extra: Backward index scan; Using index

-- 根据phone，age进行升序排序，phone在前，age在后（最左前缀法则）
explain select id,age,phone from tb_user order by phone, age; -- Extra: Using index; Using filesort

-- 根据age, phone进行降序一个升序，一个降序
explain select id,age,phone from tb_user order by age asc, phone desc; -- Extra: Using index; Using filesort

-- 创建联合索引(age 升序排序，phone 倒序排序)
create index idx_user_age_phone_ad on tb_user(age asc, phone desc);

-- 再次执行age升序、phone降序的排序sql
explain select id,age,phone from tb_user order by age asc, phone desc; -- Extra: Using index;

-- 3.group by优化
-- 将 tb_user 表的索引全部删除掉
drop index idx_user_pro_age_sta on tb_user;
drop index idx_user_pro on tb_user;
drop index idx_email on tb_user;
drop index idx_user_age_phone_aa on tb_user;
drop index idx_user_age_phone_ad on tb_user;

-- 按照profession字段分组
explain select profession , count(*) from tb_user group by profession; -- key: null, key_len: null, Extra: Using temporary

-- 给 profession、age、status 字段创建一个联合索引
create index idx_user_pro_age_sta on tb_user(profession , age , status);

-- 再次按照profession字段分组
explain select profession , count(*) from tb_user group by profession; -- key: idx_user_pro_age_sta, key_len: 54, Extra: Using index

-- 按照profession、age字段分组
explain select profession , count(*) from tb_user group by profession, age; -- key: idx_user_pro_age_sta, key_len: 54, Extra: Using index

-- 按照age字段分组（最左前缀法则）
explain select age , count(*) from tb_user group by age; -- key: idx_user_pro_age_sta, key_len: 54, Extra: Using index; Using temporary

-- 4.limit优化
-- 查询goods表（10000000数据大表），不断提高limit偏移量，查看执行sql耗时
select * from goods limit 0, 10; -- 0.00 sec
select * from goods limit 1000000, 10; -- 1.80 sec
select * from goods limit 5000000, 10; -- 6.19 sec
select * from goods limit 9000000, 10; -- 10.79 sec

-- 通过覆盖索引加子查询形式进行优化limit查询
select t.* from goods t , (select id from goods order by id limit 2000000,10) a where t.id = a.id; -- 3.94 sec

-- 5.count优化: count效率排序 count(字段) < count(主键 id) < count(1) ≈ count(*)
-- count(主键): InnoDB 引擎会遍历整张表，把每一行的 主键id 值都取出来，返回给服务层。服务层拿到主键后，直接按行进行累加(主键不可能为null)
-- count(字段): 没有not null 约束 : InnoDB 引擎会遍历整张表把每一行的字段值都取出来，返回给服务层，服务层判断是否为null，不为null，计数累加。
            -- 有not null 约束：InnoDB 引擎会遍历整张表把每一行的字段值都取出来，返回给服务层，直接按行进行累加。
-- count(数字): InnoDB 引擎遍历整张表，但不取值。服务层对于返回的每一行，放一个数字“1”进去，直接按行进行累加。
-- count(*): InnoDB引擎并不会把全部字段取出来，而是专门做了优化，不取值，服务层直接按行进行累加。
