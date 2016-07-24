---
layout: post
title:  "将博客园的备份文章转换为markdown格式"
date:   2016-02-17 21:48:59
author:     "Richard Hao"
header-img: "//static.haoxilu.net/post-bg.jpg"
tags:
    - gem开发
description: ''
main-class: 'misc'
color: '#2DA0C3'
introduction: '导出博客园文章至Markdown'
---
## Summary
[![Build Status](https://travis-ci.org/haoxilu/cnblog_back_up_to_markdown.svg?branch=master)](https://travis-ci.org/haoxilu/cnblog_back_up_to_markdown)
[![codecov.io](https://codecov.io/github/haoxilu/cnblog_back_up_to_markdown/coverage.svg?branch=master)](https://codecov.io/github/haoxilu/cnblog_back_up_to_markdown?branch=master)

Convert [cnblog bakcup](http://i.cnblogs.com/BlogBackup.aspx) to markdown or markdown file.

Github: [https://github.com/haoxilu/cnblog_back_up_to_markdown](https://github.com/haoxilu/cnblog_back_up_to_markdown)

Ruby Gem: [https://rubygems.org/gems/cnblog_back_up_to_markdown](https://rubygems.org/gems/cnblog_back_up_to_markdown)
## Requirements
1. [Nokogiri](http://nokogiri.org/)
2. Ruby 1.9.3 or higher

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'reverse_markdown'
gem 'cnblog_back_up_to_markdown'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cnblog_back_up_to_markdown

## Usage

### Ruby

require

```ruby
require 'cnblog_back_up_to_markdown'
```

use

```ruby
file_path = File.expand_path("app/controllers/CNBlogs_BlogBackup_131_201311_201602.xml")
File.open(file_path) do |f|
  @articles = CnblogBackUpToMarkdown::convert(f)
end
```

### CommandLine
It's also possible to convert cnblog's backup file to mrakdown using this library.

	cnblog_parser convert CNBlogs_BlogBackup_131_201311_201602.xml


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

