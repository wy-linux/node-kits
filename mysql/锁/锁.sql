-- ---------------------------------------> 创建表、插入数据的步骤见 索引 tb_user 表<----------------------------------



-- 全局锁: 全局锁就是对整个数据库实例加锁，加锁后整个实例就处于只读状态，后续的DML的写语句，DDL语句，已经更新操作的事务提交语句都将被阻塞
-- 加全局锁
flush tables with read lock;

-- 数据备份
mysqldump -u root –p 1234 wangyu > wangyu.sql;

-- 释放锁
unlock tables;



-- 表级锁
-- 表锁: 表共享读锁（read lock)、表独占写锁（write lock）
lock tables tb_user read; -- read lock 不会阻塞当前与其他客户端对表的读取操作，但会阻塞当前与其他客户端对该表的写入操作
lock tables tb_user write; -- write lock 不会阻塞当前客户端的读写操作，但会阻塞其他客户端的读写操作

-- 元数据锁: 元数据锁（meta data lock，简写MDL），MDL加锁过程是系统自动控制，在访问一张表的时候会自动加上。MDL锁主要作用是维护表元数据的数据一致性，在表上有活动事务的时候，不可以对元数据进行写入操作。为了避免DML与DDL冲突，保证读写的正确性
-- select 、select ...lock in share mode 等语句时，添加的是元数据共享锁（SHARED_READ /SHARED_WRITE）。元数据共享锁之间是兼容的，与元数据排他锁（EXCLUSIVE）互斥
-- alter table ... 等语句时，添加的是元数据排他锁（EXCLUSIVE），与其他的MDLz(包括共享锁与排她锁)都互斥
select object_type,object_schema,object_name,lock_type,lock_duration from performance_schema.metadata_locks; -- 查看元数据锁的加锁情况

-- 意向锁:为了避免DML在执行时，加的行锁与表锁的冲突，在InnoDB中引入了意向锁，使得表锁不用检查每行数据是否加锁，使用意向锁来减少表锁的检查
-- 意向共享锁(IS): 由语句select ... lock in share mode添加，与表锁共享锁(read)兼容，与表锁排他锁(write)互斥
-- 意向排他锁(IX): 由insert、update、delete、select...for update添加，与表锁共享锁(read)及排他锁(write)都互斥，意向锁之间不会互斥
select object_schema,object_name,index_name,lock_type,lock_mode,lock_data from performance_schema.data_locks; -- 意向锁及行锁的加锁情况



-- 行级锁
-- 共享锁（S）：允许一个事务去读一行，阻止其他事务获得相同数据集的排它锁
-- 排他锁（X）：允许获取排他锁的事务更新数据，阻止其他事务获得相同数据集的共享锁和排他锁
-- INSERT UPDATE DELETE 排他锁 
-- SELECT（正常） 不加任何锁
-- SELECT ... LOCK IN SHARE MODE 共享锁
-- SELECT ... FOR UPDATE 排他锁

-- 临键锁（Next-Key Lock）: 行锁和间隙锁组合，同时锁住数据，并锁住数据前面的间隙Gap
-- 默认情况下，InnoDB在 REPEATABLE READ 事务隔离级别运行，InnoDB使用 next-key 锁进行搜索和索引扫描。在某些特定的情况下，临键锁会优化为间隙锁或行锁
-- 索引上的范围查询(唯一索引)，对查询范围内所有记录加临键锁，还会对满足查询范围的无穷大（正负无穷大）加临键锁

-- 间隙锁（Gap Lock）: 锁定索引记录间隙（不含该记录），确保索引记录间隙不变，防止其他事务在这个间隙进行insert，产生幻读
-- 索引上的等值查询(唯一索引)，给不存在的记录加锁时, 临键锁会优化为间隙锁 。
-- 索引上的等值查询(非唯一普通索引)，对当前查询的记录加临键锁，对当前查询记录的后一个记录加间隙锁

-- 行锁（Record Lock）：锁定单个行记录的锁，防止其他事务对此行进行update和delete
-- 针对唯一索引进行检索时，对已存在的记录进行等值匹配时，将会自动优化为行锁
-- InnoDB的行锁是针对于索引加的锁，不通过索引条件检索数据，那么InnoDB将对表中的所有记录加锁，此时行锁就会升级为表锁
