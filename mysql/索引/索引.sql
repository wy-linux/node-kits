-- ---------------------------------------> 创建1000w条数据大表、验证索引对查询效率的增益 <----------------------------------
-- 创建商品表、导入1000w条商品数据
CREATE TABLE `goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `sn` varchar(100) NOT NULL COMMENT '商品条码',
  `name` varchar(200) NOT NULL COMMENT 'SKU名称',
  `price` int(20) NOT NULL COMMENT '价格（分）',
  `num` int(10) NOT NULL COMMENT '库存数量',
  `alert_num` int(11) DEFAULT NULL COMMENT '库存预警数量',
  `image` varchar(200) DEFAULT NULL COMMENT '商品图片',
  `images` varchar(2000) DEFAULT NULL COMMENT '商品图片列表',
  `weight` int(11) DEFAULT NULL COMMENT '重量（克）',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `category_name` varchar(200) DEFAULT NULL COMMENT '类目名称',
  `brand_name` varchar(100) DEFAULT NULL COMMENT '品牌名称',
  `spec` varchar(200) DEFAULT NULL COMMENT '规格',
  `sale_num` int(11) DEFAULT '0' COMMENT '销量',
  `comment_num` int(11) DEFAULT '0' COMMENT '评论数',
  `status` char(1) DEFAULT '1' COMMENT '商品状态 1-正常，2-下架，3-删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

-- 由于1000w的数据量较大，如果直接加载1000w，会非常耗费CPU及内存，现拆分为5个部分，每一个部分为200w数据，load 5 次即可
load data local infile '/Users/wangyu/goods1.sql' into table `goods` fields terminated by ',' lines terminated by '\n';
load data local infile '/Users/wangyu/goods2.sql' into table `goods` fields terminated by ',' lines terminated by '\n';
load data local infile '/Users/wangyu/goods3.sql' into table `goods` fields terminated by ',' lines terminated by '\n';
load data local infile '/Users/wangyu/goods4.sql' into table `goods` fields terminated by ',' lines terminated by '\n';
load data local infile '/Users/wangyu/goods5.sql' into table `goods` fields terminated by ',' lines terminated by '\n';

-- 验证索引效率
SELECT * FROM goods WHERE sn = '100000003145001'; -- sn字段没有索引，耗时11.57 sec
create index idx_goods_sn on goods(sn) ; -- 创建索引，耗时30.56 sec
SELECT * FROM goods WHERE sn = '100000003145001'; -- sn字段有索引，耗时0.01 sec



-- ---------------------------------------> 创建小数据用户表、验证索引的使用规则 <----------------------------------
-- 创建表、插入数据
create table tb_user(
	id int primary key auto_increment comment '主键',
	name varchar(50) not null comment '用户名',
	phone varchar(11) not null comment '手机号',
	email varchar(100) comment '邮箱',
	profession varchar(11) comment '专业',
	age tinyint unsigned comment '年龄',
	gender char(1) comment '性别 , 1: 男, 2: 女',
	status char(1) comment '状态',
	createtime datetime comment '创建时间'
) comment '系统用户表';

INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('吕布', '17799990000', 'lvbu666@163.com', '软件工程', 23, '1', '6', '2001-02-02 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('曹操', '17799990001', 'caocao666@qq.com', '通讯工程', 33, '1', '0', '2001-03-05 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('赵云', '17799990002', '17799990@139.com', '英语', 34, '1', '2', '2002-03-02 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('孙悟空', '17799990003', '17799990@sina.com', '工程造价', 54, '1', '0', '2001-07-02 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('花木兰', '17799990004', '19980729@sina.com', '软件工程', 23, '2', '1', '2001-04-22 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('大乔', '17799990005', 'daqiao666@sina.com', '舞蹈', 22, '2', '0', '2001-02-07 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('露娜', '17799990006', 'luna_love@sina.com', '应用数学', 24, '2', '0', '2001-02-08 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('程咬金', '17799990007', 'chengyaojin@163.com', '化工', 38, '1', '5', '2001-05-23 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('项羽', '17799990008', 'xiaoyu666@qq.com', '金属材料', 43, '1', '0', '2001-09-18 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('白起', '17799990009', 'baiqi666@sina.com', '机械工程及其自动化', 27, '1', '2', '2001-08-16 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('韩信', '17799990010', 'hanxin520@163.com', '无机非金属材料工程', 27, '1', '0', '2001-06-12 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('荆轲', '17799990011', 'jingke123@163.com', '会计', 29, '1', '0', '2001-05-11 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('兰陵王', '17799990012', 'lanlinwang666@126.com', '工程造价', 44, '1', '1', '2001-04-09 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('狂铁', '17799990013', 'kuangtie@sina.com', '应用数学', 43, '1', '2', '2001-04-10 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('貂蝉', '17799990014', '84958948374@qq.com', '软件工程', 40, '2', '3', '2001-02-12 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('妲己', '17799990015', '2783238293@qq.com', '软件工程', 31, '2', '0', '2001-01-30 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('芈月', '17799990016', 'xiaomin2001@sina.com', '工业经济', 35, '2', '0', '2000-05-03 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('嬴政', '17799990017', '8839434342@qq.com', '化工', 38, '1', '1', '2001-08-08 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('狄仁杰', '17799990018', 'jujiamlm8166@163.com', '国际贸易', 30, '1', '0', '2007-03-12 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('安琪拉', '17799990019', 'jdodm1h@126.com', '城市规划', 51, '2', '0', '2001-08-15 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('典韦', '17799990020', 'ycaunanjian@163.com', '城市规划', 52, '1', '2', '2000-04-12 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('廉颇', '17799990021', 'lianpo321@126.com', '土木工程', 19, '1', '3', '2002-07-18 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('后羿', '17799990022', 'altycj2000@139.com', '城市园林', 20, '1', '0', '2002-03-10 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('姜子牙', '17799990023', '37483844@qq.com', '工程造价', 29, '1', '4', '2003-05-26 00:00:00');



-- 创建索引
-- name字段为姓名字段，该字段的值可能会重复，为该字段创建索引
CREATE INDEX idx_user_name ON tb_user(name);

-- phone手机号字段的值，是非空，且唯一的，为该字段创建唯一索引
CREATE UNIQUE INDEX idx_user_phone ON tb_user(phone);

-- 为profession、age、status创建联合索引
CREATE INDEX idx_user_pro_age_sta ON tb_user(profession,age,status);

-- 为email建立合适的索引来提升查询效率
CREATE INDEX idx_email ON tb_user(email);



-- 索引的使用规则
-- 1.最左前缀法则: 如果索引了多列（联合索引），要遵守最左前缀法则。最左前缀法则指的是查询从索引的最左列开始，并且不跳过索引中的列。如果跳跃某一列，索引将会部分失效(后面的字段索引失效)
explain select * from tb_user where profession = '软件工程' and age = 31 and status = '0'; -- key: idx_user_pro_age_sta, key_len: 54
explain select * from tb_user where profession = '软件工程' and age = 31; -- key: idx_user_pro_age_sta, key_len: 49
explain select * from tb_user where profession = '软件工程'; -- key: idx_user_pro_age_sta, key_len: 47
explain select * from tb_user where age = 31 and status = '0'; -- key: null, key_len: null
explain select * from tb_user where status = '0'; -- key: null, key_len: null
explain select * from tb_user where profession = '软件工程' and status = '0'; -- key: idx_user_pro_age_sta, key_len: 47

-- 2.范围查询: 联合索引中，出现范围查询(>,<)，范围查询右侧的列索引失效
-- 联合索引中，出现范围查询(>,<)，范围查询右侧的列索引失效
explain select * from tb_user where profession = '软件工程' and age > 30 and status = '0'; -- key: idx_user_pro_age_sta, key_len: 49
-- 把 > 改为 >= ，范围查询右侧的列索引生效
explain select * from tb_user where profession = '软件工程' and age >= 30 and status = '0'; -- key: idx_user_pro_age_sta, key_len: 54

-- 3.索引列运算: 在索引列上进行运算操作， 索引将失效
explain select * from tb_user where phone = '17799990015'; -- key: idx_user_phone, key_len: 46
explain select * from tb_user where substring(phone,10,2) = '15'; -- key: null, key_len: null

-- 4.字符串不加引号: 字符串类型的值进行索引查询时，如果不加引号，索引将失效
explain select * from tb_user where profession = '软件工程' and age = 31 and status = '0'; -- key: idx_user_pro_age_sta, key_len: 54
explain select * from tb_user where profession = '软件工程' and age = 31 and status = 0; -- key: idx_user_pro_age_sta, key_len: 49

-- 5.like查询: 如果仅仅是尾部模糊匹配，索引不会失效；如果是头部模糊匹配，索引将失效
explain select * from tb_user where profession like '软件%'; -- key: idx_user_pro, key_len: 47
explain select * from tb_user where profession like '%工程'; -- key: null, key_len: null
explain select * from tb_user where profession like '%工%';-- key: null, key_len: null

-- 6.or连接条件: 在or连接的条件中左右两侧字段都有索引时，索引才会生效
explain select * from tb_user where id = 10 or age = 23; -- key: null, key_len: null
explain select * from tb_user where phone = '17799990017' or age = 23; -- key: null, key_len: 46

-- 7.数据分布影响: 如果MySQL评估使用索引比全表更慢，则不使用索引
explain select * from tb_user where phone >= '17799990005'; -- key: null, key_len: null
explain select * from tb_user where phone >= '17799990015'; -- key: idx_user_phone, key_len: 46

-- 8.SQL提示
-- 使用profession字段作为查询条件会使用联合索引idx_user_pro_age_sta
explain select * from tb_user where profession = '软件工程'; -- key: idx_user_pro_age_sta, key_len: 47
-- 为profession字段创建单列索引
create index idx_user_pro on tb_user(profession);
-- 再次使用profession字段作为查询条件还是会使用联合索引idx_user_pro_age_sta
explain select * from tb_user where profession = '软件工程'; -- key: idx_user_pro_age_sta, key_len: 47
-- use index: 建议MySQL使用哪一个索引完成此次查询（仅仅是建议，MySQL内部还会再次进行评估）
explain select * from tb_user use index(idx_user_pro) where profession = '软件工程';
-- ignore index: 忽略指定的索引
explain select * from tb_user ignore index(idx_user_pro) where profession = '软件工程';
-- force index: 强制使用索引
explain select * from tb_user force index(idx_user_pro) where profession = '软件工程';

-- 9.覆盖索引:  查询使用了索引，并且需要返回的列，在该索引中已经全部能够找到
explain select id, profession from tb_user where profession = '软件工程' and age = 31 and status = '0'; -- Extra: Using where; Using Index
explain select id, profession, age, status from tb_user where profession = '软件工程' and age = 31 and status = '0'; -- Extra: Using where; Using Index
explain select id, profession, age, status, name from tb_user where profession = '软件工程' and age = 31 and status = '0'; -- Extra: Using index condition
explain select * from tb_user where profession = '软件工程' and age = 31 and status = '0'; -- Extra: Using index condition


