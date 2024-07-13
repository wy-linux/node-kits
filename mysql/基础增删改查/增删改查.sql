-- 创建数据库、表、 插入数据
CREATE DATABASE `sql_tutorial`;
SHOW DATABASES;
USE `sql_tutorial`;
 
 CREATE TABLE `student`(
	`student_id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(20) NOT NULL,
    `major` VARCHAR(20) UNIQUE
    -- PRIMARY KEY(`student_id`)
 );
 
DESCRIBE `student`;
DROP TABLE `student`;

ALTER TABLE `student` ADD gpa DECIMAL(3,2);
ALTER TABLE `student` DROP COLUMN gpa;

SELECT * FROM `student`;
INSERT INTO `student` VALUES(1, 'wangyu', 'front end');
INSERT INTO `student` (`name`, `major`, `student_id`) VALUES('WY', 'back end', '3');
INSERT INTO `student` VALUES(2, 'yuwang', NULL);
 
INT                 -- 整数
DECIMAL(3,2)        -- 有小数点的数 3.22
VARCHAR(10)         -- 字串
BLOB                -- (Binary Large Object) 图片  影片  档案...
DATE                -- 'YYYY-MM-DD' 日期 2021-08-08
TIMESTAMP           -- 'YYYY-MM-DD HH:MM:SS'  记录时间



-- 修改、删除表格
SET SQL_SAFE_UPDATES = 0;
CREATE TABLE `student`(
	`student_id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(20) NOT NULL,
    `major` VARCHAR(20) UNIQUE,
    `score` INT
    -- PRIMARY KEY(`student_id`)
);
select * From  `student`;
INSERT INTO `student` VALUES(1, 'wangyu', 'front end', 100);
INSERT INTO `student` VALUES(2, 'yuwang', 'golang', 50);
INSERT INTO `student` VALUES(3, 'wy', 'node', 80);
INSERT INTO `student` VALUES(4, 'yw', 'back end', 77);

UPDATE `student`
SET `major` = 'back front', `name` = 'WY'
WHERE `major` = 'front end' OR `major` = 'back end';

DELETE FROM `student`
WHERE `name` = 'WY' AND `major` = 'back end';
-- WHERE `score` > 90;



-- 查询表格
SELECT * FROM `student`
WHERE `major` = 'golang' AND `student_id` = 2
-- WHERE `major` IN ('golang', 'node', 'front end')
-- WHERE `major` = 'golang' OR `score` <> 100
ORDER BY `score`, `student_id` DESC -- DESC大到小， ASC小到大
LIMIT 2;