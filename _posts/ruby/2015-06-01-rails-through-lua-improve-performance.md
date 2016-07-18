---
layout: post
title:  "Ruby通过Lua脚本提高Redis查询性能"
date:   2016-06-01 11:38:59
author:     "Richard Hao"
header-img: "//static.haoxilu.net/post-bg.jpg"
tags:
    - ruby
---

> 基于Ruby的`reids-rb` gem包 

首先，我简单介绍一下，本文中案例的基本场景，即，在一个博客系统中，将所有的评论存储或缓存到Redis中，当我们需要分页取出评论的过程。

初始化数据到Redis，我们将会用到中Redis的两种类型，一个是Hash，另一个是Zset（有序集合）。zset主要是用来存储评论的id和评论的时间，用于分页取评论信息，hash中存储的是每一条评论的具体信息。

`keys: article:id:comments comment:id:id`

#### 基于`redis-rb` 公共代码

1. `Gemfile`

```ruby
source 'https://rubygems.org'
gem 'redis'
```

2. `redis_client.rb`
 
```ruby
require 'redis'

$redis = Redis.new(host: '127.0.0.1', port: 6379)
```


#### 使用Redis的方式查询

ruby代码

```ruby
  def self.get_comment_by_article(article_id, last_time, per_page = 10)
      comment_hash = []
      comment_ids = $redis.zrevrangebyscore("article:#{article_id}:comments", last_time, 0, limit: [0, per_page])
      comment_ids.each do |item|
        comment_hash << $redis.hgetall("comment:id:#{item}")
      end

      return comment_hash
    end

```

#### 使用Lua的方式查询

1. Lua 脚本

```lua
-- get-comment-by-article_id

local rep = {}
local comment_ids_table = redis.call('ZREVRANGEBYSCORE', KEYS[1], ARGV[1], ARGV[2], 'LIMIT', 0, ARGV[3] )
for i, v in pairs(comment_ids_table) do
  local comment_key = string.format("comment:id:%d", v)
  table.insert(rep,redis.call('hgetall', comment_key))
end
return rep
```

2. Ruby实现代码

```ruby
  def self.get_comment_by_article(article_id, last_time, per_page = 10)
      # 获取Lua脚本
      lua_script = nil
      File.open("lib/get-article-by-post.lua") do |file|
        lua_script = file.read()
      end
      script_sha1 = Digest::SHA1.hexdigest(lua_script)
      keys = [ "article:#{article_id}:comments" ]
      args = [ last_time, 0, per_page ]

      # 执行redis.eval
      comment_list = []
      begin
         comment_list = $redis.evalsha(script_sha1, keys, args)
      rescue => e
        if e.message.match(/NOSCRIPT/)
           comment_list = $redis.eval(lua_script, keys, args)
        else
          raise
        end
      end

      # 处理查询结果
      comment_hash = []
      comment_list.each do |item|
         comment_hash << Hash[*item]
      end

      return comment_hash
    end
```

#### 性能对比

代码

```ruby
require 'benchmark'
require_relative 'lib/lua_redis_fetch'
require_relative 'lib/redis_fetch'

puts "#{'#' * 10} -- benchmark -- #{'#' * 10}"

lua_redis_time = Benchmark.realtime do
  Lua::LuaRedisFetch.get_comment_by_article(1, Time.now.to_f)
end

puts "lua fetch: #{lua_redis_time}"


redis_time = Benchmark.realtime do
  RedisRb::RedisFetch.get_comment_by_article(1, Time.now.to_f)
end

puts "redis fetch: #{redis_time}"
```

运行结果

```bash
########## -- benchmark -- ##########
lua fetch: 0.0016556469781789929
redis fetch: 0.003393028018763289
```

明显看出使用lua脚本的性能较高，现在使用的Redis是本来redis，当项目上线后使用远程Redis，lua的性能更能够体现出来。不适用lua脚本，会有多次Redis连接通信，网络损耗较大。

#### 建议

1.  当进行简单的单条数据查询使用原生redis查询
2.  当进行复杂的查询使用Lua能显著提高查询性能
3.  使用Lua脚本能减少同Redis 的网络通信