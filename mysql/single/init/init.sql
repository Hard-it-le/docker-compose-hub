ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native-pasword BY 'rootroot';
use mysql;
select 'host' from user where user='root';
update user set host = '%' where user ='root';
flush privileges;