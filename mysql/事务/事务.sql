CREATE DATABASE `sql_tutorial`;
SHOW DATABASES;
USE `sql_tutorial`;

CREATE TABLE `account`(
	`id` int auto_increment primary key comment '主键ID',
    `name` varchar(10) UNIQUE comment '姓名',
    `money` int comment '余额'
) comment '账户表';

INSERT INTO `account` VALUES (NULL, 'wangyu', 2000), (NULL, 'yuwang', 2000);
SELECT * FROM `account`;
-- 恢复数据
UPDATE `account` SET `money` = 2000 WHERE `name` = 'wangyu' OR `name` = 'yuwang';



-- 事务案例：转账操作
SELECT @@autocommit;
SET @@autocommit = 0; -- 设置手动提交

-- 1.查询wangyu账户余额
SELECT * FROM `account` WHERE `name` = 'wangyu';
-- 2.将wangyu账户余额-1000
UPDATE `account` SET `money` = `money` - 1000 WHERE `name` = 'wangyu';
-- 3.将yuwang账户余额+1000
UPDATE `account` SET `money` = `money` + 1000 WHERE `name` = 'yuwang';

COMMIT; -- 提交事务
ROLLBACK; -- 回滚事务



-- 事务方式二
SET @@autocommit = 1; -- 设置自动提交

START TRANSACTION; -- BEGIN;

-- 1.查询wangyu账户余额
SELECT * FROM `account` WHERE `name` = 'wangyu';
-- 2.将wangyu账户余额-1000
UPDATE `account` SET `money` = `money` - 1000 WHERE `name` = 'wangyu';
执行出错 ...
-- 3.将yuwang账户余额+1000
UPDATE `account` SET `money` = `money` + 1000 WHERE `name` = 'yuwang';

COMMIT; -- 提交事务
ROLLBACK; -- 回滚事务



-- 事务的隔离级别
SELECT @@TRANSACTION_ISOLATION;  -- 查看事务的隔离级别
-- 设置事务隔离级别  SESSION（当前窗口生效） GLOBAL（全局生效）
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

