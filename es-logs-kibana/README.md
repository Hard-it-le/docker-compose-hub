# ELK 单节点部署

本分支使用 ElasticSearch 官方的镜像和 Docker-Compose 来创建单节点的 ELK，用于学习 ELK 操作；

各个环境版本：

-   操作系统：Mac M1

-   Docker：20.10.6
-   Docker-Compose：1.29.1
-   ELK Version：7.17.4
-   注：本分支仅仅采用通常的 ElasticSearch + LogStash + Kibana 组件

## 第一步、创建 Docker-Compose 的配置文件

```yaml
version: '3.2'

services:
    elasticsearch:
        image: elasticsearch:7.17.4
        volumes:
            - /etc/localtime:/etc/localtime
            - ./es/plugins:/usr/share/elasticsearch/plugins #插件文件挂载
            - ./es/data:/usr/share/elasticsearch/data #数据文件挂载
        ports:
            - '9200:9200'
            - '9300:9300'
        container_name: elasticsearch
        restart: always
        environment:
            - 'cluster.name=elasticsearch' #设置集群名称为elasticsearch
            - 'discovery.type=single-node' #以单一节点模式启动
            - 'ES_JAVA_OPTS=-Xms1024m -Xmx1024m' #设置使用jvm内存大小
        networks:
            - elk

    logstash:
        image: logstash:7.17.4
        container_name: logstash
        restart: always
        volumes:
            - /etc/localtime:/etc/localtime
            - './logstash/pipelines.yml:/usr/share/logstash/config/pipelines.yml'
            - './logstash/logstash-audit.conf:/usr/share/logstash/pipeline/logstash-audit.conf'
            - './logstash/logstash-user-action.conf:/usr/share/logstash/pipeline/logstash-user-action.conf'
        ports:
            - '5044:5044'
            - '50000:50000/tcp'
            - '50000:50000/udp'
            - '9600:9600'
        environment:
            LS_JAVA_OPTS: -Xms1024m -Xmx1024m
            TZ: Asia/Shanghai
            MONITORING_ENABLED: false
        links:
            - elasticsearch:es #可以用es这个域名访问elasticsearch服务
        networks:
            - elk
        depends_on:
            - elasticsearch

    kibana:
        image: kibana:7.17.4
        container_name: kibana
        restart: always
        volumes:
            - /etc/localtime:/etc/localtime
            - ./kibana/config/kibana.yml:/usr/share/kibana/config/kibana.yml
        ports:
            - '5601:5601'
        links:
            - elasticsearch:es #可以用es这个域名访问elasticsearch服务
        environment:
            - ELASTICSEARCH_URL=http://elasticsearch:9200 #设置访问elasticsearch的地址
            - 'elasticsearch.hosts=http://es:9200' #设置访问elasticsearch的地址
            - I18N_LOCALE=zh-CN
        networks:
            - elk
        depends_on:
            - elasticsearch

networks:
    elk:
        name: elk
        driver:
            bridge
            #  ik 分词器的安装

            # 集群 docker-compose exec elasticsearch elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.17.4/elasticsearch-analysis-ik-7.17.4.zip

            # 单点 bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.17.4/elasticsearch-analysis-ik-7.17.4.zip
```

在 Services 中声明了三个服务：

-   elasticsearch

-   logstash
-   kibana

### **ElasticSearch 服务的配置注意事项**：

-   discovery.type=single-node：将 ES 的集群发现模式配置为单节点模式；
-   /etc/localtime:/etc/localtime：Docker 容器中时间和宿主机同步；
-   /docker_es/data:/usr/share/elasticsearch/data：将 ES 的数据映射并持久化至宿主机中；
-   在启动 ES 容器时，需要先创建好宿主机的映射目录；并且配置映射目录所属，在 logstash 服务的配置中有几点需要特别注意：

### Logstash 服务的配置注意事项：

-   ./logstash.conf:/usr/share/logstash/pipeline/logstash.conf：将宿主机本地的 logstash 配置映射至 logstash 容器内部；
-
-
-   在 kibana 服务的配置中有几点需要特别注意：

### Kibana 服务的配置注意事项：

-   ELASTICSEARCH_URL=http://elasticsearch:9200：配置 ES 的地址；

-   /etc/localtime:/etc/localtime：Docker 容器中时间和宿主机同步；

## 第二步、配置 LogStash 配置

下面是 LogStash 的配置，在使用时可以自定义：

logstash.conf

input { tcp { mode => "server" host => "0.0.0.0" port => 5044 codec => json } }

output { elasticsearch { hosts => ["http://elasticsearch:9200"] index => "%{[service]}-%{+YYYY.MM.dd}" } stdout { codec
=> rubydebug } }

使用方法使用前必看：

① 修改 ELK 版本

可以修改在.env 中的 ES_VERSION 字段，修改你想要使用的 ELK 版本；

② LogStash 配置

修改 logstash.conf 为你需要的日志配置；

③ 修改 ES 文件映射路径

修改 docker-compose 中 elasticsearch 服务的 volumes，将宿主机路径修改为你实际的路径：

volumes:

-   /etc/localtime:/etc/localtime
-   -   /docker_es/data:/usr/share/elasticsearch/data

*   -   [your_path]: /usr/share/elasticsearch/data

        并且修改宿主机文件所属：

sudo chown -R 1000:1000 [your_path] 随后使用 docker-compose 命令启动：

docker-compose up -d Creating network "docker_repo_default" with the default driver Creating docker_repo_elasticsearch_1
... done Creating docker_repo_kibana_1 ... done Creating docker_repo_logstash_1 ... done 在 portainer 中可以看到三个容器
全部被成功创建：

访问<ip>:5601/可以看到 Kibana 也成功启动：

测试通过 API 进行数据的 CRUD 向 ES 中增加数据：

curl -XPOST "http://127.0.0.1:9200/ik_v2/chinese/3?pretty" -H "Content-Type: application/json" -d ' { "id" : 3,
"username" : "测试测试", "description" : "测试测试" }'

# 返回

{ "\_index" : "ik_v2", "\_type" : "chinese", "\_id" : "3", "\_version" : 1, "result" : "created", "\_shards" : { "total"
: 2, "successful" : 1, "failed" : 0 }, "\_seq_no" : 0, "\_primary_term" : 1 } 获取数据：

curl -XGET "http://127.0.0.1:9200/ik_v2/chinese/3?pretty"

# 返回

{ "\_index" : "ik_v2", "\_type" : "chinese", "\_id" : "3", "\_version" : 1, "\_seq_no" : 0, "\_primary_term" : 1,
"found" : true, "\_source" : { "id" : 3, "username" : "测试测试", "description" : "测试测试" } } 修改数据：

curl -XPOST 'localhost:9200/ik_v2/chinese/3/\_update?pretty' -H "Content-Type: application/json" -d '{ "doc" : {
"username" : "testtest" } } }'

# 返回

{ "\_index" : "ik_v2", "\_type" : "chinese", "\_id" : "3", "\_version" : 2, "result" : "updated", "\_shards" : { "total"
: 2, "successful" : 1, "failed" : 0 }, "\_seq_no" : 1, "\_primary_term" : 1 } 再次查询：

curl -XGET "http://127.0.0.1:9200/ik_v2/chinese/3?pretty"

# 返回

{ "\_index" : "ik_v2", "\_type" : "chinese", "\_id" : "3", "\_version" : 2, "\_seq_no" : 1, "\_primary_term" : 1,
"found" : true, "\_source" : { "id" : 3, "username" : "testtest", "description" : "测试测试" } } 可以看到，username 已经
成功被修改！

在 Kibana 中查看目前我们的 Kibana 中是不存在 Index 索引的，需要先创建；

在 Management 中点击 Kibana 下面的 Index Management，并输入上面我们插入的索引 ik_v2：

创建成功后可以在 Discover 中查看：

大体单节点的 ELK 就部署成功，可以使用了！

|     |     |     |     |
| --- | --- | --- | --- |
|     |     |     |     |
|     |     |     |     |
|     |     |     |     |
|     |     |     |     |
|     |     |     |     |
|     |     |     |     |
|     |     |     |     |
|     |     |     |     |
|     |     |     |     |
|     |     |     |     |
|     |     |     |     |
