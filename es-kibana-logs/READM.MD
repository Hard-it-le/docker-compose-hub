## ELK 单节点

本分支使用 ElasticSearch 官方的镜像和 Docker-Compose 来创建单节点的 ELK，用于学习 ELK；

各个环境版本：

-   操作系统：CentOS 7
-   Docker：20.10.6
-   Docker-Compose：1.29.1
-   ELK Version：7.17.4

**注：本分支仅仅采用通常的 ElasticSearch + LogStash + Kibana 组件，而未使用 FileBeat；**

<br/>

### 项目说明

首先，在配置文件`.env`中声明了 ES 以及各个组件的版本：

.env

```
ES_VERSION=7.1.0
```

其次，创建 Docker-Compose 的配置文件：

docker-compose.yml

```yaml
version: '3.4'

services:
    elasticsearch:
        image: 'docker.elastic.co/elasticsearch/elasticsearch:${ES_VERSION}'
        environment:
            - discovery.type=single-node
        volumes:
            - /etc/localtime:/etc/localtime
            - /docker_es/data:/usr/share/elasticsearch/data
        ports:
            - '9200:9200'
            - '9300:9300'

    logstash:
        depends_on:
            - elasticsearch
        image: 'docker.elastic.co/logstash/logstash:${ES_VERSION}'
        volumes:
            - ./logstash.conf:/usr/share/logstash/pipeline/logstash.conf
        ports:
            - '5044:5044'
        links:
            - elasticsearch

    kibana:
        depends_on:
            - elasticsearch
        image: 'docker.elastic.co/kibana/kibana:${ES_VERSION}'
        environment:
            - ELASTICSEARCH_URL=http://elasticsearch:9200
        volumes:
            - /etc/localtime:/etc/localtime
        ports:
            - '5601:5601'
        links:
            - elasticsearch
```

在 Services 中声明了三个服务：

-   elasticsearch；
-   logstash；
-   kibana；

在 elasticsearch 服务的配置中有几点需要特别注意：

-   `discovery.type=single-node`：将 ES 的集群发现模式配置为单节点模式；
-   `/etc/localtime:/etc/localtime`：Docker 容器中时间和宿主机同步；
-   `/docker_es/data:/usr/share/elasticsearch/data`：将 ES 的数据映射并持久化至宿主机中；

> **在启动 ES 容器时，需要先创建好宿主机的映射目录；**
>
> **并且配置映射目录所属，例如：**
>
> ```bash
> sudo chown -R 1000:1000 /docker_es/data
> ```

在 logstash 服务的配置中有几点需要特别注意：

-   `./logstash.conf:/usr/share/logstash/pipeline/logstash.conf`：将宿主机本地的 logstash 配置映射至 logstash 容器内部；

在 kibana 服务的配置中有几点需要特别注意：

-   `ELASTICSEARCH_URL=http://elasticsearch:9200`：配置 ES 的地址；
-   `/etc/localtime:/etc/localtime`：Docker 容器中时间和宿主机同步；

下面是 LogStash 的配置，在使用时可以自定义：

logstash.conf

```conf
input {
  tcp {
    mode => "server"
    host => "0.0.0.0"
    port => 5044
    codec => json
  }
}

output {
  elasticsearch {
    hosts => ["http://elasticsearch:9200"]
    index => "%{[service]}-%{+YYYY.MM.dd}"
  }
  stdout { codec => rubydebug }
}
```

<br/>

### 使用方法

> **使用前必看：**
>
> **① 修改 ELK 版本**
>
> 可以修改在`.env`中的`ES_VERSION`字段，修改你想要使用的 ELK 版本；
>
> **② LogStash 配置**
>
> 修改`logstash.conf`为你需要的日志配置；
>
> **③ 修改 ES 文件映射路径**
>
> 修改`docker-compose`中`elasticsearch`服务的`volumes`，将宿主机路径修改为你实际的路径：
>
> ```diff
> volumes:
>   - /etc/localtime:/etc/localtime
> -  - /docker_es/data:/usr/share/elasticsearch/data
> + - [your_path]:/usr/share/elasticsearch/data
> ```

随后使用 docker-compose 命令启动：

```bash
docker-compose up -d
```

<br/>

### 测试

#### 通过 API 进行数据的 CRUD

向 ES 中增加数据：

```bash
curl -XPOST "http://127.0.0.1:9200/ik_v2/chinese/3?pretty"  -H "Content-Type: application/json" -d '
{
    "id" : 3,
    "username" :  "测试测试",
    "description" :  "测试测试"
}'

# 返回
{
  "_index" : "ik_v2",
  "_type" : "chinese",
  "_id" : "3",
  "_version" : 1,
  "result" : "created",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 0,
  "_primary_term" : 1
}
```

获取数据：

```bash
curl -XGET "http://127.0.0.1:9200/ik_v2/chinese/3?pretty"

# 返回
{
  "_index" : "ik_v2",
  "_type" : "chinese",
  "_id" : "3",
  "_version" : 1,
  "_seq_no" : 0,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "id" : 3,
    "username" : "测试测试",
    "description" : "测试测试"
  }
}
```

修改数据：

```bash
curl -XPOST 'localhost:9200/ik_v2/chinese/3/_update?pretty' -H "Content-Type: application/json" -d '{
    "doc" : {
            "username" : "testtest"
        }
    }
}'

# 返回
{
  "_index" : "ik_v2",
  "_type" : "chinese",
  "_id" : "3",
  "_version" : 2,
  "result" : "updated",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 1,
  "_primary_term" : 1
}
```

再次查询：

```bash
curl -XGET "http://127.0.0.1:9200/ik_v2/chinese/3?pretty"

# 返回
{
  "_index" : "ik_v2",
  "_type" : "chinese",
  "_id" : "3",
  "_version" : 2,
  "_seq_no" : 1,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "id" : 3,
    "username" : "testtest",
    "description" : "测试测试"
  }
}
```

可以看到，username 已经成功被修改！

<br/>

#### 在 Kibana 中查看

目前我们的 Kibana 中是不存在 Index 索引的，需要先创建；

在 Management 中点击`Kibana`下面的`Index Management`，并输入上面我们插入的索引`ik_v2`：

![](https://cdn.jsdelivr.net/gh/jasonkayzk/docker_repo@elk-v7.1-single/images/demo_3.png)

创建成功后可以在`Discover`中查看：

![](https://cdn.jsdelivr.net/gh/jasonkayzk/docker_repo@elk-v7.1-single/images/demo_4.png)

大体单节点的 ELK 就部署成功，可以使用了！

<br/>

### 其他
