---
layout: post
title:  "Sass入门"
date:   2016-01-18 10:07:42
author:     "Richard Hao"
header-img: "//static.haoxilu.net/post-bg.jpg"
tags:
    - 前端
---
学习Sass（官网：[Sass](http://sass-lang.com)）之前需要了解什么是Sass,Sass全称：Syntactically Awesome StyleSheets，中文的大概意思是“语法样式表”。从字面意思来讲，就是把css样式增加了一些语法。其实其功能也是差不多的。css本身是有自身的语法，但是并没有变量、条件判断、循环、函数等编程语言的基本语法，Sass就是提供了css缺失的功能。一般将Sass等称为“Css预处理器”。

	“Css预处理器”：
		CSS 预处理器是一种语言用来为 CSS 增加一些编程的的特性，无需考虑浏览器的兼容
	性问题，例如你可以在 CSS 中使用变量、简单的程序逻辑、函数等等在编程语言中的一些
	基本技巧，可以让你的 CSS 更见简洁，适应性更强，代码更直观等诸多好处

作为css预处理器，不仅仅只有Sass一种，还包括LESS(官网：[LESS](http://lesscss.org/))、Stylus（官网：[Stylus](http://stylus-lang.com/)）,它们之间的异同这里不再赘述，如果感兴趣的朋友可以[查看这篇文章](http://www.oschina.net/question/12_44255)，本文主要介绍[Sass](http://sass-lang.com)。如果你对为什么选择Sass有疑问，请查看视频[《How I use SASS》](https://www.youtube.com/watch?v=1XmUUa_pWw8)（自备[梯子](http://getizi.com/?r=5d2f34d8aeda1be3)）	

## 环境安装

- Sass是使用Ruby开发的，在使用之前需要电脑安装Ruby环境(本文基于mac，其他系统请自行Google,Google请自备[梯子](http://getizi.com/?r=5d2f34d8aeda1be3))。
	详细查看：教程0--教程3。地址：[https://ruby-china.org/wiki/install_ruby_guide](https://ruby-china.org/wiki/install_ruby_guide)
	
- 安装Sass gem 

	`gem install sass`
	
	查看安装是否成功：
	`sass -v` 能够输出版本号，表示安装成功。

## 预处理
- 通过命令行运行sass
	
	`sass input.scss output.css`
	
	将input.scss 转换为css文件

- 监控Sass文件的变化，自动转换为css文件
	1. 监控单个文件 `sass input.scss output.css`
	2. 监控目录 `sass --watch app/sass:public/stylesheets`

- 编译风格：详细查看[编译风格文档](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#output_style)

	1. nested：嵌套缩进的css代码，它是默认值。
	2. expanded：没有缩进的、扩展的css代码。
	3. compact：简洁格式的css代码。
	4. compressed：压缩后的css代码。(生产环境使用)
	
	ex: `sass --style compressed test.sass test.css`
	
## 语法
- 展现方式，有sass和scss两种。其不同点在下面代码中可以非常清晰的看到。
	
	1. sass样式:
	
		```sass
		$font-stack:    Helvetica, sans-serif
		$primary-color: #333
	
		body
	  		font: 100% $font-stack
	 	 	color: $primary-color
		```
		
	2. scss样式：

		```scss
		$font-stack:    Helvetica, sans-serif;
		$primary-color: #333;
	
		body {
		  font: 100% $font-stack;
		  color: $primary-color;
		}
		```
		
	sass的样式是Sass刚刚问世的时候的样式，后来随着发展增加了scss的样式，目前两种样式Scss都是支持的。sass没有花括号，与原生的css样式相差较大，scss基本上是和css的代码样式是一样的，更符合之前写css代码习惯。我个人建议使用第二种scss的方式。

- 注释

	Sass注释包括三中注释风格：`//注释`、`/* 注释 */`、`/*! 注释 */`。下面分别介绍不同的注释方式。
	1. `//注释`：单行注释，预处理后消失，只存在sass文件中。
	2. `/* 注释 */`：标准css注释，会保留到编译后的文件中。
	3. `/*! 注释 */`：常用于版权声明，使用压缩模式预处理后，依旧会保留此注释。

-  变量
	
	Scss中的变量定义使用`$`开头，例如：`$my-color: #333` 需要调用的地方直接：`body { color: $my-color }`
	
	下面查看完整例子：
	
	``` scss
	$font-stack:    Helvetica, sans-serif;
	$primary-color: #333;
	
	body {
	  font: 100% $font-stack;
	  color: $primary-color;
	}
	
	```
		
	预处理后生成的代码：
		
	```css
	body {
  		font: 100% Helvetica, sans-serif;
  		color: #333;
	}
	```
	
	变量调用还有另外一种方式：
	
	```scss
	$left: left;
	
	body{
		margin-#{$left}:10px;
	}
	```
	
	这种方式是将变量嵌套在字符串中，使用`#{}`。
	
- 嵌套
	
	Sass 支持标签属性等嵌套。
	
	1. 标签嵌套，Sass代码如下：
	
	```scss
	nav {
	  ul {
	    margin: 0;
	    padding: 0;
	    list-style: none;
	  }
	
	  li { display: inline-block; }
	
	  a {
	    display: block;
	    padding: 6px 12px;
	    text-decoration: none;
	  }
	}
	```
	预处理后的css代码如下：
	
	```css
	nav ul {
	  margin: 0;
	  padding: 0;
	  list-style: none;
	}
	
	nav li {
	  display: inline-block;
	}
	
	nav a {
	  display: block;
	  padding: 6px 12px;
	  text-decoration: none;
	}
	```
	
	2. 属性嵌套
	
	 Sass代码(切记不要讲属性color后面的`:`漏掉)：
	
	```scss
　　p {
　　　border: {
　　　　　color: red;
　　　}
　　}
	```
	预处理后css代码：
	
	```css
	p {
		border-color: red;
	}
	```
	3. 引用父类元素。使用符号`&`
	
		Sass代码：
	
	```scss
	a {
　　　	&:hover { color: blue; }
	}
	```
	预处理后的css代码：
	
	```css
	a : hover {
		color: blue;
	}
	```
##高级用法

- 局部模板

	在Sass中，可以创建一个局部文件，然后在其他的文件中引入局部文件。局部文件的命名一般以`_`开头，如`_partial.scss`。在另一文件中可以同过`@import`引入,这样在浏览器看到css文件只有一个。
	
- 导入局部文件

	导入局部文件的关键字是`@import`。其不仅仅可以import`.scss`文件，还可以import`.css`文件，当导入`.css`功能时，同css中`@import "file.css"`的功能一致。
	
	局部Sass文件：
	
	```scss
	// _reset.scss

	html,
	body,
	ul,
	ol {
	   margin: 0;
	  padding: 0;
	}
	```
	
	导入局部文件：
	
	```scss
	// base.scss

	@import 'reset';
	
	body {
	  font: 100% Helvetica, sans-serif;
	  background-color: #efefef;
	}
	```
	
	最终生成的css文件：
	
	```css
	html, body, ul, ol {
	  margin: 0;
	  padding: 0;
	}
	
	body {
	  font: 100% Helvetica, sans-serif;
	  background-color: #efefef;
	}
	```
	
- Mixins（混合）
	
	Mixins定义方式：
	
	```scss
	@mixin Mixins名称（参数:参数值）{
    /*公用样式*/
	}
	```
	定义成为模块后，需要通过`@include`进行调用mixin，调用代码如下：
	
	```scss
	selector {
   		@includ Mixins名称(参数值);
	}
	```
	
	下面来看一个例子：
	
	Sass 文件:
	
	```scss
	@mixin border-radius($radius) {
	  -webkit-border-radius: $radius;
	     -moz-border-radius: $radius;
	      -ms-border-radius: $radius;
	          border-radius: $radius;
	}
	
	.box { @include border-radius(10px); }
	```
	预处理后的css文件：
	
	```css
	.box {
	  -webkit-border-radius: 10px;
	  -moz-border-radius: 10px;
	  -ms-border-radius: 10px;
	  border-radius: 10px;
	}
	```
	
- Extend/Inheritance(扩展或继承)

	Sass中可以从一个选择器，继承另一个选择器。其关键字是：`@extend`。
	
	下面看一个例子，可以直观的展现继承关系：
	
	Sass代码：
	
	```scss
	.message {
	  border: 1px solid #ccc;
	  padding: 10px;
	  color: #333;
	}
	
	.success {
	  @extend .message;
	  border-color: green;
	}
	
	.error {
	  @extend .message;
	  border-color: red;
	}
	
	.warning {
	  @extend .message;
	  border-color: yellow;
	}
	```
	
	上面例子中，`.success`、`.error`、`.warning`都通过`@extend`关键字继承了`.message`选择器。下面看一下生成的css代码：
	
	```css
	.message, .success, .error, .warning {
	  border: 1px solid #cccccc;
	  padding: 10px;
	  color: #333;
	}
	
	.success {
	  border-color: green;
	}
	
	.error {
	  border-color: red;
	}
	
	.warning {
	  border-color: yellow;
	}
	```
	
- 操作符

	在学习一门新的编程语言中基本上都会有介绍操作符的章节，但是css这门独特的编程语言确没有这种方式，但是通过Sass，可以让我们编写css程序的时候也能有操作符、条件循环语句、自定义函数等。下面将介绍操作符。
	
	在Sass中的操作符包括 `+`、`-`、`*`、`/`。具体不用介绍，大家应该都明白。下面我们直接来看一个例子：
	
	Sass代码
	
	```scss
	.container { width: 100%; }
	
	
	article[role="main"] {
	  float: left;
	  width: 600px / 960px * 100%;
	}
	
	aside[role="complimentary"] {
	  float: right;
	  width: 300px / 960px * 100%;
	}
	```
	预处理后的css代码：
	
	```css
	.container {
	  width: 100%;
	}
	
	article[role="main"] {
	  float: left;
	  width: 62.5%;
	}
	
	aside[role="complimentary"] {
	  float: right;
	  width: 31.25%;
	}
	```
	不仅仅上述的宽度可以通过操作符进行技术，css的颜色也可以通过技术得到一个新的颜色，例如 `#777 + #888`其最后的结果是`white`
	
- 数据类型

	Sass支持7中主要的数据类型：
	
	1. numbers：数字类型 (e.g. 1.2, 13, 10px)
	
	2. strings：字符串类型，既可以是`""`号，也可以是`''`，还可以直接省略 (e.g. "foo", 'bar', baz)
	
	3. colors: 颜色类型 (e.g. blue, #04a3f9, rgba(255, 0, 0, 0.5))
	
	4. booleans: 布尔类型 (e.g. true, false)
	
	5. nulls： 空类型 (e.g. null)
	
	6. lists：集合，可以通过空格或者逗号进行lists值得分隔 (e.g. 1.5em 1em 0 2em, Helvetica, Arial, sans-serif)
	
	7. maps ：键值对 (e.g. (key1: value1, key2: value2))
	
- 条件语句

	条件语句无非就是if-else格式，下面介绍一下格式。
	
	定义方式：
		
	1. if方式，关键字：`@if`

		```scss
		@if true {
			/* 样式 */
		}
		```
	
	2. if-else,关键字：`@if @else`
	
		```scss
		@if true {
			/* 样式 */
		} @esle{
			/* 样式 */
		}
		```
	
- 循环语句
	
	SASS支持for循环：

	```scss
　　@for $i from 1 to 10 {
　　　　.border-#{$i} {
　　　　　　border: #{$i}px solid blue;
　　　　}
　　}
	```
	　　
	也支持while循环：

	```scss
		$i: 6;
	　　@while $i > 0 {
	　　　　.item-#{$i} { width: 2em * $i; }
	　　　　$i: $i - 2;
	　　}
	```
	each命令，作用与for类似：

	```scss
	@each $member in a, b, c, d {
　　　　.#{$member} {
　　　　　　background-image: url("/image/#{$member}.jpg");
　　　　}
　　}
	```
- 自定义函数

	Sass支持自定义函数。函数的定义和调用如下所示：
	
	```scss
　　@function double($n) {
　　　　@return $n * 2;
　　}
　　#sidebar {
　　　　width: double(5px);
　　}
	```

##总结
Sass的基本用法，上文中都有介绍到，如果还有其它问题，或本文没有介绍到的地方，请查看[官方文档](http://sass-lang.com/documentation/file.SASS_REFERENCE.html)。

 

