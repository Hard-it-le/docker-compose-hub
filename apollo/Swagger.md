# Swagger API

## 一、什么是 Open API

Open API 规范 (OpenAPI Specification) 以前叫做 Swagger 规范，是 REST API 的 API 描述格式。

Open API 文件允许描述整个 API ，包括：

-   每个访问地址的类型。 POST 或 GET 
-   每个操作的参数。包括输入输出参数
-   认证方法
-   连接信息，声明，使用团队和其 他信息

Open API 规范可以使用 YAML 或 JSON 格式进行编写。这样更利于我们和机器进行阅读

OpenAPI 规范（ OAS ）为 RESTful API 定义了一个与语言无关的标准接口，允许人和计算机发现和理解服务的功能，而无需访问源代码
，文档或通过网络流量检查。正确定义后，消费者可以使用最少量的实现逻辑来理解远程服务并与之交互。然后，文档生成工具可以使用
OpenAPI 定义来显示 API ，使用各种编程语言生成服务器和客户端的代码生成工具，测试工具以及许多其他用例。

[OpenAPI](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3. 0.0.md#oasDocument)

## 二、什么是 Swagger API

Swagger 简介 Swagger 是一套围绕 Open API 规范构建的开源工具，可以帮助设计，构建，记录和使用 REST API 。

Swagger 工具包括的组件：

-   Swagger Editor ：基于浏览器编辑器，可以在里面编写 Open API 规范。类似 Markdown 具有实时预览描述文件的功能。

-   Swagger UI ：将 Open API 规范呈现为交互式 API 文档。用可视化 UI 展示描述文件。
-   Swagger Codegen ：将 OpenAPI 规范生成为服务器存根和客户端库。通过 Swagger Codegen 可以将描述文件生成 html 格式和
    cwiki 形式的接口文档，同时也可以生成多种言语的客户端和服务端代码。

-   Swagger Inspector ：将 Open API 规范呈现为交互式 API 文档。用可视化 UI 展示描述文件，但是可以返回更多信息，也会保存
    请求的实际参数数据。

-   Swagger Hub ：集成了上面所有项目的各个功能，你可以以项目和版本为单位，将你的描述文件上传到 Swagger Hub 中。在
    Swagger Hub 中可以完成上面项目的所有工作，需要注册账号，分免费版和收费版。

使用 Swagger 目的就是把相关的信息存储在定义的描述文件中，描述文件一般情况是 json 格式，但是也允许 yml 格式，后端开发通过维护这个描述文件去更新接口文档以及生成各端代码

## 三、Swagger2 常用注解

### Api

@Api 是类上注解。控制整个类生成接口信息的内容。

-   tags ：类的名称。可以有多个值，多个值表示多个副本。
-   description: 描述

### ApiOperation

@ApiOperation 写在方法上，对方法进行总体描述。

-   value ：接口描述
-   notes ：提示信息

### ApiParam

@ApiParam 写在方法参数前面。用于对参数进行描述或说明是否为必添项等说明。

-   name ：参数名称
-   value ：参数描述
-   required ：是否是必须

### ApiModel

@ApiModel 是类上注解，主要应用 Model ，也就是说这个注解一般都是写在实体类上。

-   value ：名称 
-   description ：描述

### ApiModelProperty

@ApiModelProperty 可以用在方法或属性上。用于当对象作为参数时定义这个字段的内容。

-   value ：描述
-   name ：重写属性名
-   required ：是否是必须的
-   example ：示例内容
-   hidden ：是否隐藏。

### ApiIgnore

@ApiIgnore 用于方法或类或参数上，表示这个方法或类被忽略。

### ApiImplicitParam

@ApiImplicitParam 用在方法上，表示单独的请求参数，用于对参数进行描述或说明是否为必添项等说明。

-   name ：属性名
-   value ：描述
-   required ：是否是必须的
-   paramType ：属性类型
-   dataType ：数据类型

四、Swagger API 用法

### 编写 SpringBoot 项目

编写 SpringBoot 项目，项目中 controller 中包含一个 Handler ，测试项目，保证程序可以正确运行。

```java
@RestController
@RequestMapping("/people")
public class DemoController {

  @RequestMapping("/getPeople")
    public People getPeople(Long id, String name) {

        People peo = new People();
        peo.setId(id);
        peo.setName(name);
        peo.setAddress("海淀");
        return peo;
    }
}
```

### 导入 Spring-fox 依赖

在项目的 pom.xml 中导入 Spring-fox 依赖。目前最新版本为 2.9.2 ，所以导入的依赖也是这个版本。其中 springfox-swagger2 是核
心内容的封装。 springfox-swagger-ui 是对 swagger-ui 的封装。

```xml
<dependency>
    <groupId>io. springfox</groupId>
    <artifactId>springfox-swagger2</artifactId>
    <version>2.9.2</version>
</dependency>
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger-ui</artifactId>
    <version>2.9.2</version>
</dependency>
```

### 添加 Swagger 启动注解

在 SpringBoot 的启动类中添加 @EnableSwagger2 注解。添加此注解后表示对当前项目中全部控制器进行扫描。应用 Swagger2

```java
@SpringBootApplication
@EnableSwagger2
public class DemoApp {
    public static void main(String [] args) {
        SpringApplication.run(DemoApp. class, args);
    }
}
```

### 访问 swagger-ui 页面

启动项目后在浏览器中输入 http://ip:port/swagger-ui.html 即可以访问到 swagger-ui 页面，在页面中可以可视化的进行操作项目中
所有接口。

## 五、Swagger 项目常用配置

一般情况下项目中都会统一配置一个 config 文件夹，存放一些公用的配置，比如 Swagger 配置等

### 配置基本信息

-   Docket ：摘要对象，通过对象配置描述文件的信息。
-   apiInfo: 设置描述文件中 info。参数类型 ApiInfo
-   select(): 返回 ApiSelectorBuilder 对象，通过对象调用 build() 可以创建 Docket 对象
-   ApiInfoBuilder ： ApiInfo 构建器。

### 设置扫描的包

通过 apis() 方法设置哪个包中内容被扫描

### 自定义注解设置不需要生成接口文档的方法

#### 自定义注解

```java
@Target({ElementType.METHOD})
@Retention(RetentionPolicy. RUNTIME)
public @interface NotIncludeSwagger {}
```

#### 添加规则

-  public ApiSelectorBuilder apis(Predicate<RequestHandler> selector) 可以设置生成规则。 
- public static <T> Predicate<T> not(Predicate<T> predicate) : 表示不允许的条件。 
- withMethodAnnotation ：表示此注解是方法级别注解。

#### 添加 NotIncludeSwagger 注解

在不需要生成接口文档的方法上面添加 @NotIncludeSwagger 注解后，该方法将不会被 Swagger 进行生成在接口文档中。

### 设置范围

-  public ApiSelectorBuilder paths(Predicate<String> selector) 可以设置满足什么样规则的 url 被生成接口文档。可以使用正
  则表达式进行匹配

### 示例文件

```java
@Configuration
@EnableSwagger2
public class Swagger2Config {

    @Bean
    public Docket getUserDocket() {
        ApiInfo apiInfo = new ApiInfoBuilder()
                .title("Demo Open API") // api标题
                .description("Demo Open API") // api描述
                .version("3.0") // 版本号
                .build();
        return new Docket(DocumentationType.SWAGGER_2) // 文档类型（swagger2）
                .apiInfo(apiInfo) // 设置包含在json ResourceListing响应中的api元信息
                .select() // 启动用于api选择的构建器
                .apis(RequestHandlerSelectors.basePackage("cn.demo.security")) // 扫描接口的包
                .paths(PathSelectors.any()) // 路径过滤器（扫描所有路径）
                .build().enable(true);
    }

}
```