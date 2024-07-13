-- ------------------------------------> 多表查询案例 <--------------------------------------------
-- 部门表、员工表
create table dept(
    id   int auto_increment comment 'ID' primary key,
    name varchar(50) not null comment '部门名称'
)comment '部门表';

create table emp(
    id  int auto_increment comment 'ID' primary key,
    name varchar(50) not null comment '姓名',
    age  int comment '年龄',
    job varchar(20) comment '职位',
    salary int comment '薪资',
    entrydate date comment '入职时间',
    managerid int comment '直属领导ID',
    dept_id int comment '部门ID'
)comment '员工表';



-- 添加外键
alter table emp add constraint fk_emp_dept_id foreign key (dept_id) references dept(id);

INSERT INTO dept (id, name) VALUES (1, '研发部'), (2, '市场部'),(3, '财务部'), (4, '销售部'), (5, '总经办'), (6, '人事部');

INSERT INTO emp (id, name, age, job, salary, entrydate, managerid, dept_id)
VALUES (1, '金庸', 66, '总裁', 20000, '2000-01-01', null, 5),
       (2, '张无忌', 20, '项目经理', 12500, '2005-12-05', 1, 1),
       (3, '杨逍', 33, '开发', 8400, '2000-11-03', 2, 1),
       (4, '韦一笑', 48, '开发', 11000, '2002-02-05', 2, 1),
       (5, '常遇春', 43, '开发', 10500, '2004-09-07', 3, 1),
       (6, '小昭', 19, '程序员鼓励师', 6600, '2004-10-12', 2, 1),
       (7, '灭绝', 60, '财务总监', 8500, '2002-09-12', 1, 3),
       (8, '周芷若', 19, '会计', 48000, '2006-06-02', 7, 3),
       (9, '丁敏君', 23, '出纳', 5250, '2009-05-13', 7, 3),
       (10, '赵敏', 20, '市场部总监', 12500, '2004-10-12', 1, 2),
       (11, '鹿杖客', 56, '职员', 3750, '2006-10-03', 10, 2),
       (12, '鹤笔翁', 19, '职员', 3750, '2007-05-09', 10, 2),
       (13, '方东白', 19, '职员', 5500, '2009-02-12', 10, 2),
       (14, '张三丰', 88, '销售总监', 14000, '2004-10-12', 1, 4),
       (15, '俞莲舟', 38, '销售', 4600, '2004-10-12', 14, 4),
       (16, '宋远桥', 40, '销售', 4600, '2004-10-12', 14, 4),
       (17, '陈友谅', 42, null, 2000, '2011-10-12', 1, null);

-- 多表查询 -- 笛卡尔积
select * from emp , dept where emp.dept_id = dept.id;



-- 内连接演示
-- 1. 查询每一个员工的姓名 , 及关联的部门的名称 (隐式内连接实现)
-- 表结构: emp , dept
-- 连接条件: emp.dept_id = dept.id

select emp.name , dept.name from emp , dept where emp.dept_id = dept.id ;

select e.name,d.name from emp e , dept d where e.dept_id = d.id;



-- 2. 查询每一个员工的姓名 , 及关联的部门的名称 (显式内连接实现)  --- INNER JOIN ... ON ...
-- 表结构: emp , dept
-- 连接条件: emp.dept_id = dept.id

select e.name, d.name from emp e inner join dept d  on e.dept_id = d.id;

select e.name, d.name from emp e join dept d  on e.dept_id = d.id;



-- 外连接案例
-- 1. 查询emp表的所有数据, 和对应的部门信息(左外连接)
-- 表结构: emp, dept
-- 连接条件: emp.dept_id = dept.id

select e.*, d.name from emp e left outer join dept d on e.dept_id = d.id;

select e.*, d.name from emp e left join dept d on e.dept_id = d.id;



-- 2. 查询dept表的所有数据, 和对应的员工信息(右外连接)

select d.*, e.* from emp e right outer join dept d on e.dept_id = d.id;

select d.*, e.* from dept d left outer join emp e on e.dept_id = d.id;



-- 自连接案例
-- 1. 查询员工 及其 所属领导的名字
-- 表结构: emp

select a.name , b.name from emp a , emp b where a.managerid = b.id;



-- 2. 查询所有员工 emp 及其领导的名字 emp , 如果员工没有领导, 也需要查询出来
-- 表结构: emp a , emp b

select a.name '员工', b.name '领导' from emp a left join emp b on a.managerid = b.id;



-- union all , union
-- 1. 将薪资低于 5000 的员工 , 和 年龄大于 50 岁的员工全部查询出来.

select * from emp where salary < 5000
union all
select * from emp where age > 50;

select * from emp where salary < 5000
union
select * from emp where age > 50;



-- -------------------------------------- 子查询案例 ------------------------

-- 标量子查询
-- 1. 查询 "销售部" 的所有员工信息
-- a. 查询 "销售部" 部门ID
select id from dept where name = '销售部';

-- b. 根据销售部部门ID, 查询员工信息
select * from emp where dept_id = (select id from dept where name = '销售部');



-- 2. 查询在 "方东白" 入职之后的员工信息

-- a. 查询 方东白 的入职日期
select entrydate from emp where name = '方东白';

-- b. 查询指定入职日期之后入职的员工信息
select * from emp where entrydate > (select entrydate from emp where name = '方东白');



-- 列子查询
-- 1. 查询 "销售部" 和 "市场部" 的所有员工信息
-- a. 查询 "销售部" 和 "市场部" 的部门ID
select id from dept where name = '销售部' or name = '市场部';

-- b. 根据部门ID, 查询员工信息
select * from emp where dept_id in (select id from dept where name = '销售部' or name = '市场部');



-- 2. 查询比 财务部 所有人工资都高的员工信息
-- a. 查询所有 财务部 人员工资
select id from dept where name = '财务部';

select salary from emp where dept_id = (select id from dept where name = '财务部');

-- b. 比 财务部 所有人工资都高的员工信息
select * from emp where salary > all ( select salary from emp where dept_id = (select id from dept where name = '财务部') );



-- 3. 查询比研发部其中任意一人工资高的员工信息
-- a. 查询研发部所有人工资
select salary from emp where dept_id = (select id from dept where name = '研发部');

-- b. 比研发部其中任意一人工资高的员工信息
select * from emp where salary > some ( select salary from emp where dept_id = (select id from dept where name = '研发部') );



-- 行子查询
-- 1. 查询与 "张无忌" 的薪资及直属领导相同的员工信息 ;
-- a. 查询 "张无忌" 的薪资及直属领导
select salary, managerid from emp where name = '张无忌';

-- b. 查询与 "张无忌" 的薪资及直属领导相同的员工信息 ;
select * from emp where (salary,managerid) = (select salary, managerid from emp where name = '张无忌');



-- 表子查询
-- 1. 查询与 "鹿杖客" , "宋远桥" 的职位和薪资相同的员工信息
-- a. 查询 "鹿杖客" , "宋远桥" 的职位和薪资
select job, salary from emp where name = '鹿杖客' or name = '宋远桥';

-- b. 查询与 "鹿杖客" , "宋远桥" 的职位和薪资相同的员工信息
select * from emp where (job,salary) in ( select job, salary from emp where name = '鹿杖客' or name = '宋远桥' );



-- 2. 查询入职日期是 "2006-01-01" 之后的员工信息 , 及其部门信息
-- a. 入职日期是 "2006-01-01" 之后的员工信息
select * from emp where entrydate > '2006-01-01';

-- b. 查询这部分员工, 对应的部门信息;
select e.*, d.* from (select * from emp where entrydate > '2006-01-01') e left join dept d on e.dept_id = d.id ;



-- ---------------------------------------> 多表查询案例 <----------------------------------
-- 薪资表
create table salgrade(
    grade int,
    losal int,
    hisal int
) comment '薪资等级表';

insert into salgrade values (1,0,3000);
insert into salgrade values (2,3001,5000);
insert into salgrade values (3,5001,8000);
insert into salgrade values (4,8001,10000);
insert into salgrade values (5,10001,15000);
insert into salgrade values (6,15001,20000);
insert into salgrade values (7,20001,25000);
insert into salgrade values (8,25001,30000);



-- 1. 查询员工的姓名、年龄、职位、部门信息 （隐式内连接）
-- 表: emp , dept
-- 连接条件: emp.dept_id = dept.id

select e.name , e.age , e.job , d.name from emp e , dept d where e.dept_id = d.id;



-- 2. 查询年龄小于30岁的员工的姓名、年龄、职位、部门信息（显式内连接）
-- 表: emp , dept
-- 连接条件: emp.dept_id = dept.id

select e.name , e.age , e.job , d.name from emp e inner join dept d on e.dept_id = d.id where e.age < 30;



-- 3. 查询拥有员工的部门ID、部门名称
-- 表: emp , dept
-- 连接条件: emp.dept_id = dept.id

select distinct d.id , d.name from emp e , dept d where e.dept_id = d.id;



-- 4. 查询所有年龄大于40岁的员工, 及其归属的部门名称; 如果员工没有分配部门, 也需要展示出来
-- 表: emp , dept
-- 连接条件: emp.dept_id = dept.id
-- 外连接

select e.*, d.name from emp e left join dept d on e.dept_id = d.id where e.age > 40 ;



-- 5. 查询所有员工的工资等级
-- 表: emp , salgrade
-- 连接条件 : emp.salary >= salgrade.losal and emp.salary <= salgrade.hisal

select e.* , s.grade , s.losal, s.hisal from emp e , salgrade s where e.salary >= s.losal and e.salary <= s.hisal;

select e.* , s.grade , s.losal, s.hisal from emp e , salgrade s where e.salary between s.losal and s.hisal;



-- 6. 查询 "研发部" 所有员工的信息及 工资等级
-- 表: emp , salgrade , dept
-- 连接条件 : emp.salary between salgrade.losal and salgrade.hisal , emp.dept_id = dept.id
-- 查询条件 : dept.name = '研发部'

select e.* , s.grade from emp e , dept d , salgrade s where e.dept_id = d.id and ( e.salary between s.losal and s.hisal ) and d.name = '研发部';



-- 7. 查询 "研发部" 员工的平均工资
-- 表: emp , dept
-- 连接条件 :  emp.dept_id = dept.id

select avg(e.salary) from emp e, dept d where e.dept_id = d.id and d.name = '研发部';



-- 8. 查询工资比 "灭绝" 高的员工信息。
-- a. 查询 "灭绝" 的薪资
select salary from emp where name = '灭绝';

-- b. 查询比她工资高的员工数据
select * from emp where salary > ( select salary from emp where name = '灭绝' );



-- 9. 查询比平均薪资高的员工信息
-- a. 查询员工的平均薪资
select avg(salary) from emp;

-- b. 查询比平均薪资高的员工信息
select * from emp where salary > ( select avg(salary) from emp );



-- 10. 查询低于本部门平均工资的员工信息
-- a. 查询指定部门平均薪资  1
select avg(e1.salary) from emp e1 where e1.dept_id = 1;
select avg(e1.salary) from emp e1 where e1.dept_id = 2;

-- b. 查询低于本部门平均工资的员工信息
select * from emp e2 where e2.salary < ( select avg(e1.salary) from emp e1 where e1.dept_id = e2.dept_id );



-- 11. 查询所有的部门信息, 并统计部门的员工人数
select d.id, d.name , ( select count(*) from emp e where e.dept_id = d.id ) '人数' from dept d;

select count(*) from emp where dept_id = 1;



-- 学生表、课程表、学生课程中间表
create table student
(
    id   int auto_increment primary key comment '主键ID',
    name varchar(10) comment '姓名',
    no   varchar(10) comment '学号'
) comment '学生表';

insert into student
values (null, '黛绮丝', '2000100101'),
       (null, '谢逊',
        '2000100102'),
       (null, '殷天正', '2000100103'),
       (null, '韦一笑', '2000100104');

create table course
(
    id   int auto_increment primary key comment '主键ID',
    name varchar(10) comment '课程名称'
) comment '课程表';

insert into course
values (null, 'Java'),
       (null, 'PHP'),
       (null, 'MySQL'),
       (null, 'Hadoop');

create table student_course
(
    id        int auto_increment comment '主键' primary key,
    studentid int not null comment '学生ID',
    courseid  int not null comment '课程ID',
    constraint fk_courseid foreign key (courseid) references course (id),
    constraint fk_studentid foreign key (studentid) references student (id)
) comment '学生课程中间表';

insert into student_course
values (null, 1, 1),
       (null, 1, 2),
       (null, 1, 3),
       (null, 2, 2),
       (null, 2, 3),
       (null, 3, 4);



-- 12. 查询所有学生的选课情况, 展示出学生名称, 学号, 课程名称
-- 表: student , course , student_course
-- 连接条件: student.id = student_course.studentid , course.id = student_course.courseid

select s.name , s.no , c.name from student s , student_course sc , course c where s.id = sc.studentid and sc.courseid = c.id ;















