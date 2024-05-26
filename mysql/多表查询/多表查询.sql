-- 创建员工表
CREATE TABLE `employee`(
	`emp_id` INT PRIMARY KEY,
    `name` VARCHAR(20),
    `birth_date` DATE,
    `sex` VARCHAR(1),
    `salary` INT,
    `branch_id` INT ,
    `sup_id` INT
);
-- 创建部门表
CREATE TABLE `branch`(
    `branch_id` INT PRIMARY KEY,
	`branch_name` VARCHAR(20),
	`manager_id` INT,
	FOREIGN KEY (`manager_id`) REFERENCES `employee`(`emp_id`) ON DELETE SET NULL
);
-- 为员工表新增外键
ALTER TABLE `employee`
ADD FOREIGN KEY(`branch_id`)
REFERENCES `branch`(`branch_id`)
ON DELETE SET NULL;

ALTER TABLE `employee`
ADD FOREIGN KEY(`sup_id`)
REFERENCES `employee`(`emp_id`)
ON DELETE SET NULL;
-- 创建客户表
CREATE TABLE `client`(
    `client_id` INT PRIMARY KEY,
	`client_name` VARCHAR(20),
	`phone` VARCHAR(20)
);
-- 创建work_with表
CREATE TABLE `works_with`(
    `emp_id` INT ,
	`client_id` INT,
	`total_sales` INT,
    PRIMARY KEY(`emp_id`, `client_id`),
	FOREIGN KEY (`emp_id`) REFERENCES `employee`(`emp_id`) ON DELETE CASCADE,
	FOREIGN KEY (`client_id`) REFERENCES `client`(`client_id`) ON DELETE CASCADE
);

-- 新增部门表格数据
alter table `branch` convert to character set utf8;
INSERT INTO `branch` VALUES(1, '研发', null);
INSERT INTO `branch` VALUES(2, '行政', null);
INSERT INTO `branch` VALUES(3, '资讯', null);
-- 新增员工表格数据
alter table `employee` convert to character set utf8;
INSERT INTO `employee` VALUES(206, '小黄', '1998-10-08', 'F', 50000, 1, NULL);
INSERT INTO `employee` VALUES(207, '小绿', '1985-09-16', 'M', 29000, 2, 206);
INSERT INTO `employee` VALUES(208, '小黑', '2000-12-19', 'M', 35000, 3, 206);
INSERT INTO `employee` VALUES(209, '小白', '1997-01-22', 'F', 39000, 3, 207);
INSERT INTO `employee` VALUES(210, '小花', '1925-11-10', 'F', 84000, 1, 207);
-- 更改部门表格外键manager_id
UPDATE `branch`
SET `manager_id` = 206
WHERE `branch_id` = 1;
UPDATE `branch`
SET `manager_id` = 207
WHERE `branch_id` = 2;
UPDATE `branch`
SET `manager_id` = 208
WHERE `branch_id` = 3;
-- 新增客户表格数据
alter table `client` convert to character set utf8;
INSERT INTO `client` VALUES(400, '阿狗', '254354335');
INSERT INTO `client` VALUES(401, '阿猫', '25633899');
INSERT INTO `client` VALUES(402, '旺来', '45354345');
INSERT INTO `client` VALUES(403, '露西', '54354365');
INSERT INTO `client` VALUES(404, '艾瑞克', '18783783');
-- 新增销售金额表格数据
alter table `works_with` convert to character set utf8;
INSERT INTO `works_with` VALUES(206, 400, '70000');
INSERT INTO `works_with` VALUES(207, 401, '24000');
INSERT INTO `works_with` VALUES(208, 402, '9800');
INSERT INTO `works_with` VALUES(208, 403, '24000');
INSERT INTO `works_with` VALUES(210, 404, '87940');
-- 1. 取得所有员工数据
SELECT * FROM `employee`;
-- 2. 取得所有客户数据
SELECT * FROM `client`;
-- 3.按照薪水低到高取得员工数据
SELECT * FROM `employee`
ORDER BY `salary`;
-- 4.取得薪水前3高的员工资料
SELECT * FROM `employee`
ORDER BY `salary` DESC
LIMIT 3;
-- 5.取得所有员工名字
SELECT `name` FROM `employee`;
	-- 去重处理
	SELECT DISTINCT `sex` FROM `employee`;



-- aggregate functions 聚合函数
-- 1.取得员工人数
SELECT COUNT(*) FROM `employee`;
SELECT COUNT(`sup_id`) FROM `employee`;
-- 2.取得所有出生于 1970-01-01 之后的女性员工人数
SELECT COUNT(*) FROM `employee`
WHERE `birth_date` > '1970-0101' AND `sex` = 'F';
-- 3.取得所有员工的平均薪水
SELECT AVG(`salary`) FROM `employee`;
-- 4.取得所有员工的薪水总和
SELECT SUM(`salary`) FROM `employee`;
-- 5.取得员工最高的薪水
SELECT MAX(`salary`) FROM `employee`;
-- 6.取得员工最低的薪水
SELECT MIN(`salary`) FROM `employee`;



-- wildcards 万用字元  % 代表多个字元, _代表一个字元
-- 1.取得电话号码尾数是335的客户
SELECT * FROM `client`
WHERE `phone` LIKE '%335';
-- 2.取得姓艾的客户
SELECT * FROM `client`
WHERE `client_name` LIKE '艾%';
-- 3.取得生日在12月的员工
SELECT * FROM `employee`
WHERE `birth_date` LIKE '_____12%';



-- union 联集
-- 1.员工名字 union 客户名字
SELECT `name` FROM `employee`
UNION
SELECT `client_name` FROM `client`
UNION
SELECT `branch_name` FROM `branch`;
-- 2.员工id + 员工名字 union 客户id + 客户名字
SELECT `emp_id` AS `total_id`, `name` AS `total_id` FROM `employee`
UNION
SELECT `client_id`, `client_name` FROM `client`;
-- 3. 员工薪水 union 销售金额
SELECT `salary` AS `totla_money` FROM `employee`
UNION
SELECT `total_sales` FROM `works_with`;



-- join连接
-- 取得所有部门经理的名字
-- SELECT * FROM `employee`
SELECT `employee`.`emp_id`, `employee`.`name`, `branch`.`branch_name` FROM `employee` 
-- LEFT JOIN `branch`
RIGHT JOIN `branch`
ON `employee`.`emp_id` = `branch`.`manager_id`;



-- subquery 子查询
-- 1.找出研发部门经理的名字
SELECT `name` FROM `employee`
WHERE `emp_id` = (
	SELECT `manager_id` FROM `branch`
    WHERE `branch_name` = '研发'
);
-- 2.找出对单一客户销售金额超过50000的员工名字
SELECT `name` FROM `employee`
WHERE `emp_id` IN(
	SELECT `emp_id` FROM `works_with`
    WHERE `total_sales` > 50000
);