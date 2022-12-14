## Docker Repo

A repository stores some dockerfiles or docker-compose files for quickly starting service or service cluster.

一个使用 Docker-Compose 快速搭建各种服务组件或服务组件集群的仓库；

About Docker-Compose：

-   Official：[Docker-Compose Official Doc](https://docs.docker.com/compose/)

<br/>

### Finished

### Single

| middleware                                                                                    | Info                                | --  | --  |     |
| --------------------------------------------------------------------------------------------- | ----------------------------------- | --- | --- | --- |
| [redis-single](https://github.com/Hard-it-le/docker-compose-hub/tree/main/redis/redis-single) | redis-v6.2.7-single                 |     |     |     |
| [mySQL-single](https://github.com/Hard-it-le/docker-compose-hub/tree/main/mysql/mysql-single) | mysql-v8.0.27-single                |     |     |     |
| [elk-single](https://github.com/Hard-it-le/docker-compose-hub/tree/main/es-logs-kibana)       | elk-v7.17.4-single                  |     |     |     |
| [pgSQL-single](https://github.com/Hard-it-le/docker-compose-hub/tree/main/pgsql)              | pgsql-v14.5-single                  |     |     |     |
| [zk-kafka-single](https://github.com/Hard-it-le/docker-compose-hub/tree/main/zk-kafka)        |                                     |     |     |     |
| [mongoDB-single](https://github.com/Hard-it-le/docker-compose-hub/tree/main/mongoDB)          | monger-v6.0-single                  |     |     |     |
| [neo4j-single](https://github.com/Hard-it-le/docker-compose-hub/tree/main/neo4j)              | neo4j-vneo4j:4.4.9-community-single |     |     |     |
|                                                                                               |                                     |     |     |     |

### Cluster

| Image                                                                                           | Date       | Info                        | Note                                                                                                                                                                |
| ----------------------------------------------------------------------------------------------- | ---------- | --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [zookeeper-v3.4-cluster](https://github.com/JasonkayZK/docker_repo/tree/zookeeper-v3.4-cluster) | 2020-04-26 | zookeeper-3.4 cluster       | 3 or more nodes                                                                                                                                                     |
| [kafka-v2.4.1-cluster](https://github.com/JasonkayZK/docker_repo/tree/kafka-v2.4.1-cluster)     | 2020-04-26 | kafka-v2.4.1-cluster        | zookeeper cluster & kafka cluster                                                                                                                                   |
| [elk-v7.1-single](https://github.com/JasonkayZK/docker_repo/tree/elk-v7.1-single)               | 2021-05-15 | ELK-v7.1.0-single           | Compose ELK Single-Node<br />(Without Filebeat)                                                                                                                     |
| [elk-stack-v7.1-single](https://github.com/JasonkayZK/docker_repo/tree/elk-stack-v7.1-single)   | 2021-05-15 | ELK-Stack-v7.1.0-single     | Compose ELK Single-Node<br />(Full-Stack with Filebeat)                                                                                                             |
| [hadoop-v2.7-single](https://github.com/JasonkayZK/docker_repo/tree/hadoop-v2.7-single)         | 2021-06-25 | Hadoop-v2.7-Single          | Directly run with Docker                                                                                                                                            |
| [redash-single](https://github.com/JasonkayZK/docker_repo/tree/redash-single)                   | 2021-08-08 | Redash-v8                   | Directly run Redash with Docker                                                                                                                                     |
| [hadoop-3.1.3-cluster](https://github.com/JasonkayZK/docker_repo/tree/hadoop-3.1.3-cluster)     | 2021-08-21 | Hadoop-3.1.3-cluster        | Run Hadoop-3.1.3 cluster with Docker                                                                                                                                |
| [epic-games-claimer](https://github.com/JasonkayZK/docker_repo/tree/epic-games-claimer)         | 2021-09-04 | Epic-game-claimer           | Auto gain free epic game everyday                                                                                                                                   |
| [elk-v7.14-single](https://github.com/JasonkayZK/docker_repo/tree/elk-v7.14-single)             | 2021-09-11 | ELK-Stack-v7.14.0-single    | Update version: [elk-stack-v7.1-single](https://github.com/JasonkayZK/docker_repo/tree/elk-stack-v7.1-single)<br />Contributed by [wwhai](https://github.com/wwhai) |
| [mysql-federated](https://github.com/JasonkayZK/docker-repo/tree/mysql-federated)               | 2021-11-09 | MySQL Federated Engine Demo | A demo to show how Federated Engine works in MySQL<br />Blog: [MySQL 跨数据库查询方案总结](https://jasonkayzk.github.io/2021/11/09/MySQL跨数据库查询方案总结/)      |
|                                                                                                 |            |                             |                                                                                                                                                                     |
