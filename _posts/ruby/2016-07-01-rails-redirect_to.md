---
layout: post
title: "Rails 中`redirect_to articles_path` 和 `redirect_to articles_path, status: 302` 有区别吗？"
date: 2016-07-01 11:38:59
image: '//static.haoxilu.net/post-bg.jpg'
description: 'Rails 中`redirect_to articles_path` 和 `redirect_to articles_path, status: 302`其实是没有区别的'
main-class: 'css'
color: '#2DA0C3'
tags:
- ruby
- ruby on rails
introduction: 'Rails 中`redirect_to articles_path` 和 `redirect_to articles_path, status: 302`其实是没有区别的'
---

先放两行代码，然后介绍一下问题的由来？
```ruby
redirect_to articles_path
```

```ruby
redirect_to articles_path, status: 302
```

今天技术leader突然找我，说有一行代码有问题。`redirect_to articles_path, status: 302` 是有问题的，跳转是不能用这种方式的，response header 是不一样的，云云..... 说的我晕晕呼呼的，我没听懂，只好回答好的，我改。but， 作为一个有好奇心的程序员，肯定不能就此罢手，一定要刨根问底。

解决这类问题的最好方式就是去查看rails中有关redirect_to 的相关源码（[源码地址](https://github.com/rails/rails/blob/master/actionpack/lib/action_controller/metal/redirecting.rb)）。

下面允许我贴关键方法的代码：

```ruby
def redirect_to(options = {}, response_status = {})
      raise ActionControllerError.new("Cannot redirect to nil!") unless options
      raise ActionControllerError.new("Cannot redirect to a parameter hash!") if options.is_a?(ActionController::Parameters)
      raise AbstractController::DoubleRenderError if response_body

# 关键点一： self.status , 进入`_extract_redirect_to_status`方法查看详细实现
      self.status        = _extract_redirect_to_status(options, response_status)
      self.location      = _compute_redirect_to_location(request, options)
      self.response_body = "<html><body>You are being <a href=\"#{ERB::Util.unwrapped_html_escape(location)}\">redirected</a>.</body></html>"
    end
```

```ruby
def _extract_redirect_to_status(options, response_status)
    # 关键点二：判断是否存在`status` 的key
        if options.is_a?(Hash) && options.key?(:status)
          Rack::Utils.status_code(options.delete(:status))
        elsif response_status.key?(:status)
          Rack::Utils.status_code(response_status[:status])
        else
          302 # 如果未定义response_status 默认为302
        end
      end
    
```

看完上面的两个方法已经把结论说的非常清楚了，最后稍微总结一下。

*  `redirect_to articles_path` 和 `redirect_to articles_path, status: 302` 调用结果完全相同，写法全评个人喜好或团队规则
* 建议重定向时直接使用`redirect_to articles_path`, 只有当需要指定返回的的状态码是调用`redirect_to articles_path, status: 500`
