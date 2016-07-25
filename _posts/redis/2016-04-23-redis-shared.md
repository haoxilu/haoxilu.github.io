---
layout: post
title:  "Redis基本使用分享"
date:   2016-04-23 11:38:59
author:     "Richard Hao"
header-img: "//static.haoxilu.net/post-bg.jpg"
tags:
    - redis
description: ''
main-class: 'dev'
color: '#2DA0C3'
introduction: 'Redis基本用法'
---

## Redis介绍

### Redis是什么
***RE***mote ***DI***ctionary ***S***erver(Redis) 是一个由Salvatore Sanfilippo写的key-value存储系统。Redis提供了一些丰富的数据结构，包括 **lists**, **sets**, **ordered sets** 以及 **hashes** ，当然还有和Memcached一样的 **strings**结构.Redis当然还包括了对这些数据结构的丰富操作。
### Redis的优点
性能极高 – Redis能支持超过 100K 每秒的读写频率。

丰富的数据类型 – Redis支持二进制案例的 **Strings**, **Lists**, **Hashes**, **Sets** 及 **Ordered Sets** 数据类型操作。

原子 – Redis的所有操作都是原子性的，同时Redis还支持对几个操作全并后的**原子性**执行。
丰富的特性 – Redis还支持 **publish/subscribe**, 通知, key 过期等等特性。

## [Keys](https://redis.readthedocs.org/en/2.4/key.html)

### Redis中key的命名(非硬性规定)

	a:b:c # 中间用冒号隔开

### Key删除

```shell
> set demo_key 123_value
> get demo_key
"123_value"
> del demo_key # 删除一个key
(integer) 1
> del key1 key2 key3 key4 #删除多个key
(integer) 4
```

### Key pattern

> 查找符合给定模式的key

KEYS *命中数据库中所有key。

KEYS h?llo命中hello， hallo and hxllo等。

KEYS h*llo命中hllo和heeeeello等。

KEYS h[ae]llo命中hello和hallo，但不命中hillo。

特殊符号用"\"隔开

```shell
> set user:1000 1000
> set user:2000 2000
> set user:3000 3000
> keys user:*
1) "user:1000"
2) "user:2000"
3) "user:3000"
```



## Redis数据类型

### [Strings](http://www.cnblogs.com/stephen-liu74/archive/2012/03/14/2349815.html])

> 字符串类型的Value最多可以容纳的数据长度是512M

![String](http://static.haoxilu.net/qdaily%2Fshare%2Fredis-string.jpg)

```shell
> set mykey somevalue
OK
> get mykey
"somevalue"
```

原子递增（`decr`递减）

```shell
> set counter 100
OK
> incr counter
(integer) 101
> incr counter
(integer) 102
> incrby counter 50
(integer) 152
```

### [Lists](http://www.cnblogs.com/stephen-liu74/archive/2012/02/14/2351859.html)

> List类型是按照插入顺序排序的字符串链表。List中可以包含的最大元素数量是4294967295。可以出现重复数据

![List](http://static.haoxilu.net/qdaily%2Fshare%2Fredis-list.jpg)

```shell
> rpush mylist A
(integer) 1
> rpush mylist B
(integer) 2
> lpush mylist first
(integer) 3
> lrange mylist 0 -1
1) "first"
2) "A"
3) "B"
```

```shell
> rpush mylist a b c
(integer) 3
> rpop mylist
"c"
> rpop mylist
"b"
> rpop mylist
"a"
```

### [Hashes](http://www.cnblogs.com/stephen-liu74/archive/2012/03/19/2352932.html)

> Hashes类型的value是一个k-v容器

![Hash](http://static.haoxilu.net/qdaily%2Fshare%2Fredis-hash.jpg)

```shell
> hmset user:1000 username antirez birthyear 1977 verified 1
OK
> hget user:1000 username
"antirez"
> hget user:1000 birthyear
"1977"
> hgetall user:1000
1) "username"
2) "antirez"
3) "birthyear"
4) "1977"
5) "verified"
6) "1"
```
删除value里面的字段或者增加字段

```shell
> hdel user:1000 verified  # 删除value里面的字段
1
> hkeys user:1000
1)username
2)birthyear
> hsetnx user:1000 status 1 # 给value添加字段并赋值
> hkeys user:1000
1)username
2)birthyear
3)status
```

### [Sets](http://www.cnblogs.com/stephen-liu74/archive/2012/03/21/2352512.html)

> Set类型是无序的字符集合，不允许出现重复元素

![Set](http://static.haoxilu.net/qdaily%2Fshare%2Fredis-set.jpg)

```shell
> sadd myset 1 2 3
(integer) 3
> smembers myset
1) 3
2) 1
3) 2
```

### [Ordered Sets](http://www.cnblogs.com/stephen-liu74/archive/2012/03/23/2354994.html)(zset、Sorted-Sets)

> Sorted-Sets类似Sets,主要差别Sorted-Sets能够排序(每一个成员都会有一个score)

![ZSet](http://static.haoxilu.net/qdaily%2Fshare%2Fredis-zset.jpg)

```shell
> zadd hackers 1940 "Alan Kay"
(integer) 1
> zadd hackers 1957 "Sophie Wilson"
(integer 1)
> zadd hackers 1953 "Richard Stallman"
(integer) 1
> zadd hackers 1949 "Anita Borg"
(integer) 1
> zadd hackers 1965 "Yukihiro Matsumoto"
(integer) 1
> zadd hackers 1914 "Hedy Lamarr"
(integer) 1
> zadd hackers 1916 "Claude Shannon"
(integer) 1
> zadd hackers 1969 "Linus Torvalds"
(integer) 1
> zadd hackers 1912 "Alan Turing"
(integer) 1
```

```shell
> zrange hackers 0 -1
1) "Alan Turing"
2) "Hedy Lamarr"
3) "Claude Shannon"
4) "Alan Kay"
5) "Anita Borg"
6) "Richard Stallman"
7) "Sophie Wilson"
8) "Yukihiro Matsumoto"
9) "Linus Torvalds"
```

## [Redis超时](http://www.redis.cn/topics/data-types-intro.html#redis)（设置key的过期时间）

设置key的过期时间

```shell
> set key some-value
OK
> expire key 5
(integer) 1
> get key (immediately)
"some-value"
> get key (after some time)
(nil)
```

通过`PERSIST `命令取消深知key的过期时间

```shell
> set hello 123
OK
> expire hello 10
(integer) 1
> persist hello
(integer) 1
```

通过`TT`L命令查看key的剩余过期时间

```shell
> set key 100 ex 10
OK
> ttl key
(integer) 9
```

##[Sort](https://redis.readthedocs.org/en/2.4/key.html#sort)

> SORT key [BY pattern] [LIMIT offset count] [GET pattern [GET pattern ...]] [ASC | DESC] [ALPHA] [STORE destination]

> 返回或保存给定列表、集合、有序集合key中经过排序的元素。

```shell
# 将数据一一加入到列表中

redis> LPUSH today_cost 30
(integer) 1

redis> LPUSH today_cost 1.5
(integer) 2

redis> LPUSH today_cost 10
(integer) 3

redis> LPUSH today_cost 8
(integer) 4

# 排序

redis> SORT today_cost
1) "1.5"
2) "8"
3) "10"
4) "30"

```

```shell
> sort today_cost limit 0 2 desc
1) "30"
2) "10"
```

## Redis [事务](http://redisdoc.com/topic/transaction.html)

和mysql的事务有很大的区别。Redis事务相当于批量提交，出错没有回滚。

```shell
redis 127.0.0.1:6379> MULTI
OK
redis 127.0.0.1:6379> SET tutorial redis
QUEUED
redis 127.0.0.1:6379> GET tutorial
QUEUED
redis 127.0.0.1:6379> INCR visitors
QUEUED
redis 127.0.0.1:6379> EXEC

1) OK
2) "redis"
3) (integer) 1
```

> `MULTI` 开启事务

> `EXEC` 执行事务

> `DISCARD` 取消事务

> `WATCH`  可以为 Redis 事务提供 check-and-set （CAS）行为。

## Ruby Gem

### [redis-rb](https://github.com/redis/redis-rb)

1. wiki: [http://inch-ci.org/github/redis/redis-rb](http://inch-ci.org/github/redis/redis-rb)

	A Ruby client library for Redis

2. 使用

 ```ruby
 $redis = Redis.new(:host => "10.0.1.1", :port => 6380, :db => 15)
 ```

 ```ruby
 $redis.set("mykey", "hello world")
 $redis.get("mykey")
 ```
方法名同`redis-cli`命令名相同

### [redis-objects](https://github.com/nateware/redis-objects)

1. 介绍

 A Ruby client library for Redis

 对reids的封装，调用更符合Ruby的命名规范，并且可以在model中使用.

2.	使用

 ```ruby
 class Team < ActiveRecord::Base
	   include Redis::Objects

	   lock :trade_players, :expiration => 15  # sec
	   value :at_bat
	   counter :hits
	   counter :runs
	   counter :outs
	   counter :inning, :start => 1
	   list :on_base
	   list :coaches, :marshal => true
	   set  :outfielders
	   hash_key :pitchers_faced  # "hash" is taken by Ruby
   sorted_set :rank, :global => true
 end
 ```

 ```ruby
 @team = Team.find_by_name('New York Yankees')
 @team.on_base << 'player1'
 @team.on_base << 'player2'
 @team.on_base << 'player3'
 @team.on_base    # ['player1', 'player2', 'player3']
 @team.on_base.pop
 @team.on_base.shift
 @team.on_base.length  # 1
 @team.on_base.delete('player2')
 ```

3. 生成的Redis key的格式为：

	`model_name:id:field_name`

###[redis-namespace](https://github.com/resque/redis-namespace)

This gem adds a Redis::Namespace class which can be used to namespace Redis keys. http://redis.io

为 redis key 添加命名空间

#####使用

```ruby
redis = Redis.new(host: redis_config['host'], port: redis_config['port'], password: redis_config['password'])
$redis = Redis::Namespace.new(redis_config['namespace'], redis: redis)
```

使用redis-namespace后生成的key的值：`namespace:model_name:id:field_name`

### redis-rb、redis-object、redis-namespace

redis.yml

```yml
defaults: &defaults
  host: 127.0.0.1
  port: 6379
  namespace: qdaily4
  password: qdaily
development:
  <<: *defaults
test:
  <<: *defaults
production:
  <<: *defaults
```

redis.rb 文件

```ruby
require 'redis'
require 'redis-namespace'
require 'redis/objects'

redis_config = YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env]

redis = Redis.new(host: redis_config['host'], port: redis_config['port'], password: redis_config['password'])
$redis = Redis::Namespace.new(redis_config['namespace'], redis: redis)
Redis::Objects.redis = $redis
```


### [其它Redis Client for Ruby客户端](https://www.ruby-toolbox.com/categories/Redis)



## 推荐
Medis: Mac下Redis管理工具
[Download](https://github.com/luin/medis/releases)
![Medis](http://getmedis.com/screen.png)
![Medis](http://a1.mzstatic.com/us/r30/Purple69/v4/c2/a4/d1/c2a4d16b-2944-57d1-5bc2-00ac1d15a182/screen800x500.jpeg)

## 参考资料

1. Redis资料汇总专题 [http://blog.nosqlfan.com/html/3537.html](http://blog.nosqlfan.com/html/3537.html)
2. Redis系统性介绍 [http://blog.nosqlfan.com/html/3139.html](http://blog.nosqlfan.com/html/3139.html)
3. Redis学习手册(String数据类型)[http://www.cnblogs.com/stephen-liu74/archive/2012/03/14/2349815.html](http://www.cnblogs.com/stephen-liu74/archive/2012/03/14/2349815.html)
4. Redis学习手册(Hashes数据类型)[http://www.cnblogs.com/stephen-liu74/archive/2012/03/19/2352932.html](http://www.cnblogs.com/stephen-liu74/archive/2012/03/19/2352932.html)
5. Redis学习手册(List数据类型)[http://www.cnblogs.com/stephen-liu74/archive/2012/02/14/2351859.html](http://www.cnblogs.com/stephen-liu74/archive/2012/02/14/2351859.html)
6. Redis学习手册(Set数据类型)[http://www.cnblogs.com/stephen-liu74/archive/2012/03/21/2352512.html](http://www.cnblogs.com/stephen-liu74/archive/2012/03/21/2352512.html)
7. Redis学习手册(Sorted-Sets数据类型)[http://www.cnblogs.com/stephen-liu74/archive/2012/03/23/2354994.html](http://www.cnblogs.com/stephen-liu74/archive/2012/03/23/2354994.html)
8. Reids设计与实现[http://redisbook.com/](http://redisbook.com/)
9. 哈希对象[http://redisbook.com/preview/object/hash.html](http://redisbook.com/preview/object/hash.html)

## 提高
1. 主从复制[http://www.cnblogs.com/stephen-liu74/archive/2012/03/30/2364717.html](http://www.cnblogs.com/stephen-liu74/archive/2012/03/30/2364717.html)
2. 事务队列[http://www.cnblogs.com/stephen-liu74/archive/2012/03/28/2357783.html](http://www.cnblogs.com/stephen-liu74/archive/2012/03/28/2357783.html)
3. redis远程调用[http://blog.fens.me/linux-redis-install/](http://blog.fens.me/linux-redis-install/)
4. 事务[http://redisbook.readthedocs.org/en/latest/feature/transaction.html](http://redisbook.readthedocs.org/en/latest/feature/transaction.html)
5. [国内外三个不同领域巨头分享的Redis实战经验及使用场景](http://www.csdn.net/article/2013-10-07/2817107-three-giant-share-redis-experience/1)
