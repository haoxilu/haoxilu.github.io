---
layout: post
title:  "Redis 使用Lua脚本——基本使用"
date:   2016-05-01 11:38:59
author:     "Richard Hao"
header-img: "//static.haoxilu.net/post-bg.jpg"
tags:
    - redis
---

> Redis在2.6版引入了对Lua的支持。

* 使用Lua可以非常明显的提升Redis的效率。

#### Redis的一些命令

1. `EVAL` 执行Lua脚本
2. `EVALSHA` 执行Lua脚本的sha1
3. `SCRIPT LOAD` 加载Lua脚本到Redis Script
4. `SCRIPT FLUSH` 清空Redis Script
5. `SCRIPT EXISTS` 判断是否存在Rdis Script中

#### `EVAL`

```bash
127.0.0.1:6379> eval "return 'Hello, world' " 0
"Hello, world"
```

在服务器中的Lua环境相当于定义了以下函数, 并且运行函数：
```lua
func f_9d4977f841f29202b7138237c28943c49565851b()
    return 'Hello, world'
end
```
格式是固定的，为`f_` + Lua脚本的sha1值

#### `EVALSHA`

```bash
127.0.0.1:6379> evalsha 9d4977f841f29202b7138237c28943c49565851b 0
"Hello, world"
}
```

在服务器中的Lua环境中直接调用函数。

```lua
f_9d4977f841f29202b7138237c28943c49565851b()
```
这个地方需要特别注意的是，在没有执行过`eval`或`script load`的lua脚本，直接调用会报错，错误信息如下：`(error) NOSCRIPT No matching script. Please use EVAL.`

#### `SCRIPT LOAD`

```bash
127.0.0.1:6379> script load "return 'Hello, world' "
"9d4977f841f29202b7138237c28943c49565851b"
```

`script load` 会将Lua脚本加载到lua_script字典中。


#### `SCRIPT EXISTS`

```bash
127.0.0.1:6379> script exists 9d4977f841f29202b7138237c28943c49565851b
1) (integer) 1
```

检查Lua脚本的sha1值是否存在lua_scripot字典中。

#### `SCRIPT FLUSH`

```bash
127.0.0.1:6379> script flush
OK
```

清空lua_script字典。

#### Redis 执行Lua脚本的过程

```plain
          发送命令请求
          EVAL "return redis.call('DBSIZE')" 0
Caller ------------------------------------------> Redis

          为脚本 "return redis.call('DBSIZE')"
          创建 Lua 函数
Redis  ------------------------------------------> Lua

          绑定超时处理钩子
Redis  ------------------------------------------> Lua

          执行脚本函数
Redis  ------------------------------------------> Lua

               执行 redis.call('DBSIZE')
Fake Client <------------------------------------- Lua

               伪客户端向服务器发送
               DBSIZE 命令请求
Fake Client -------------------------------------> Redis

               服务器将 DBSIZE 的结果
               （Redis 回复）返回给伪客户端
Fake Client <------------------------------------- Redis

               将命令回复转换为 Lua 值
               并返回给 Lua 环境
Fake Client -------------------------------------> Lua

          返回函数执行结果（一个 Lua 值）
Redis  <------------------------------------------ Lua

          将 Lua 值转换为 Redis 回复
          并将该回复返回给客户端
Caller <------------------------------------------ Redis
```

#### Redis使用Lua的注意事项

1. 如果Lua脚本中包括全局变量时，会报错。定义变量时不要落下`local`关键字。
2. 一定要确保Lua脚本已经通过`load script`或`eval`加载或执行脚本之后再调用`evalsha`。
3. 在一主多从的环境中，一定要注意使用`evalsha`时，从服务有可能会出现未成功加载lua脚本的情况。
4. redis配置文件中一定要设置lua超时钩子`lua-time-limit 5000 `。