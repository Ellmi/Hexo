title: 利用TDD思维实现email的正则表达
tags: [TDD,Regex]
showLanguage: false
date: 2015-12-16 21:30:14
index: 在本文中将利用TDD的思维来探讨email的正则表达式。适用于初学者理解TDD和正则表达式的入门。之所以为利用TDD思维而不直言利用TDD是因为在真实开发实践中的TDD实现细节和本文例子略有不同，不希望被误导。而正则表达是软件开发者的利器，你有什么理由不获得这项技能呢...
---
在本文中将利用TDD的思维来探讨email的正则表达式。适用于初学者理解TDD和正则表达式的入门。之所以为利用**TDD思维**而不直言利用**TDD**是因为在真实开发实践中的TDD实现细节和本文例子略有不同，不希望被误导。而正则表达是软件开发者的利器，有什么理由不去获得这项技能呢？

## TDD思维

TDD（测试驱动开发）思维是如下一个过程：开发人员进行某方法或接口的开发时，先不急于下手写逻辑，而是进行“我想要什么”的思考，并以此驱动逻辑的实现。

具体来说，“我想要什么”在TDD中依赖于测试代码的实现来表达,比如我要写个 `function A`,那么首先要做的是思考我希望A能干什么，假设我思考的结果是方法A当且仅某标志字段x为true时将data存于result中，那么随后要做的事是，

* 写一条测试来覆盖刚才思考结果里的一种状况
* 开发人员以让测试通过为目的进行功能代码的实现

重复上述过程，再写一条测试，再次以让已存测试通过为目的修改功能代码。以此循环直到`function A`能满足所有期待。

## 正则表达

正则表达式用于字符串的处理，一旦掌握便是程序员的利器。匹配路径、处理log、验证合法、抓取各类信息必不可少。而当你经历过用正则一行便可替换原来若干行代码的重构时，将会增加对它的热爱。

## 实战

**目标：利用TDD思维写出邮件地址的正则表达式**

语言：java
测试框架：junit
IDE：idea

在最初练习TDD时，你可能会遇到“啊？先写测试吗，我该怎么写，完全不知道要怎么下手”，此时你可以做的是
**baby step** ，即像婴儿学迈步那样走出很小很简单的一步。首先让我们来思考，我们想要的邮件正则表达式应该是怎样的（可以转化为思考我认为什么样的邮件为合法），按你所能想到的最简单的开始走起，比如我想到的是

* 邮件地址中必须包含一个‘@’符号，即该正则需要求邮件中必须含‘@’符。


``` java
@Test
public void shouldHasAtMarkInEmail() {                                                                   
    assertTrue("Should has a @ mark in the middle!", Pattern.matches(emailRegex, "yanmin@test.com"));
    assertFalse("Should has a @ mark in the middle!", Pattern.matches(emailRegex, "asdfhj"));
    assertFalse("Should has a @ mark in the middle!", Pattern.matches(emailRegex, "@hjddh"));
}
```

**运行测试：失败**

测试中， `emailRegex` 是我们想要获取的正则表达式。此时运行测试甚至连编译都不会通过，因为我们的功能代码为0连 `emailRegex` 都未曾定义。于是我们被驱动着去实现以通过测试为目的的功能代码，如下：

``` java
String emailRegex = ".＋@.＋";
```

``` java
STRING EMAILREGEX = ".+@.+";
```

**运行测试：成功**

Note: 项目中只会在测试中调用所测接口而不是将功能代码写入测试中，此外一般不会特意为某一正则表达式写测试

---
完成我们的baby step后添加第二条测试，驱动我们去写出更好的正则表达式

* 邮件地址‘@’符号的前后只能是'a-z'或'.'，即该正则需要求邮件符合前述规则。

``` java
@Test
public void shouldBeSpecificCharacters() {
    assertTrue("Characters should be a-z or dot!", Pattern.matches(emailRegex, "yanmin@test.com"));
    assertFalse("Characters should be a-z or dot!", Pattern.matches(emailRegex, "asASh@hjddh"));
}
```

**运行2个测试：第一个成功第二个失败**

修改 `emailRegex` 如下：

``` java
String emailRegex = "[a-z.]+@[a-z.]+";
```

**运行2个测试：全部成功**

---
增加第三条规则

* '.'只能出现在邮件地址‘@’后，出现1～3次，不可与'@'自身相邻，不在结尾，即该正则需要求邮件符合前述规则。

``` java
@Test
public void shouldHasCorrectDotMarks() {
    assertTrue("Wrong dot!", Pattern.matches(emailRegex, "yanmin@test.com"));
    assertFalse("Wrong dot!", Pattern.matches(emailRegex, "asadf@hj"));
    assertFalse("Wrong dot!", Pattern.matches(emailRegex, "asadf@.sfsd.com"));
    assertFalse("Wrong dot!", Pattern.matches(emailRegex, "asa.df@sfsd.com"));
    assertFalse("Wrong dot!", Pattern.matches(emailRegex, "asadf@hj..com"));
}
```

**运行3个测试：前两个成功第三个失败**

修改 `emailRegex` 如下：

``` java
String emailRegex = "[a-z]+@[a-z]+([a-z]+\.){1,3}[a-z]+";
```

**运行3个测试：全部成功**

---
增加第四条规则

* 邮件地址最后一个‘.’后的字符为2～4个，即该正则需要求邮件符合前述规则。

``` java
@Test
public void shouldHasTwoToFourCharactersAfterTheLastDot() {
    assertFalse("Wrong ending!", Pattern.matches(emailRegex, "ymxing@test.comcosf"))
}
```

**运行4个测试：前三个成功第四个失败**

修改 `emailRegex` 如下：

``` java
String emailRegex = "[a-z]+@[a-z]+([a-z]+\.){1,3}[a-z]{2,4}";
```

**运行4个测试：全部成功**

---
增加第五条规则

* 邮件地址总长不超50个字符，即该正则需要求邮件符合前述规则。

``` java
@Test
public void shouldHasMaxLengthFifty() {
    assertFalse("Wrong length", Pattern.matches(emailRegex, "asdfghjklkjasdfgdsdfdsasdfghjgfdsadfghfhgfdsasdfghjkjhgfdjhgfg@thoughtworks.com"));
}
```

**运行5个测试：前四个个成功第五个失败**

修改 `emailRegex` 如下：

``` java
String emailRegex = "^(?=.{1,50}$)[a-z]+@([a-z]+\.){1,3}[a-z]{2,4}";
```

**运行5个测试：全部成功**

至此一条邮件正则表达式通过TDD方式驱动写出，你通过例子理解到TDD是怎样一个过程了吗，至于本文中的正则表达式并非终点，可在本站其他相关博文进行详细学习。


