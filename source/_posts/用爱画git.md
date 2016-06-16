title: 用爱一起画git
tags: [Git,session]
postLink: understand-git-by-drawing
date: 2015-12-27 16:51:04
index: 这是我在项目组里讲过的一次git session,在此将所有slides添加讲解记录为博文.本文全文贯穿一个例子,先简单引进了git中的几个数据模型,然后通过画图方式帮助大家了解几个常用命令背后的行为.画图重心不涉及分支而是数据模型间的组织...
---

这是我在项目组里讲过的一次git session,在此将所有slides添加讲解记录为博文.本文全文贯穿一个例子,先简单引进了git中的几个数据模型,然后通过画图方式帮助大家了解几个常用命令背后的行为.画图重心不涉及分支而是数据模型间的组织.

* 首先附上夺眼球的标题页和博文/session愿景

![Slide 1](/css/images/git-session/slide1.png)
![Slide 1](/css/images/git-session/slide2.png)

---

* 正式内容开始了,首先将介绍我们贯穿全文的例子背景 ( 总体来说就是用git记录,更新主人公的恋爱状态,当然是瞎编的 ), 例子将随着剧情的变化给出不同的场景,每个场景对应一个git命令.

* 在本地初始化一个空仓库 ( 本文例为 `mylove` 目录下), 进入 `.git` 目录下将看到git的目录结构,我们重点关注的将是 **objects** 目录,后边的图画中的git对象也大多存放于此.此时该目录下普通文件为空.

* 本场景命令: ** git init **

![Slide 1](/css/images/git-session/slide3.png)

---
* 在本场景中, 主人公新建了 `status.txt` 文件, `git add .` 后 objects 目录下多出一个文件,随后提交第一个commit,objects目录又多出两个文件.那么这多出的三个文件到底用来干什么呢???

    * 其实这三个文件都是git对象,分别对应三种git数据模型 **blob**,**tree**,**commit**,其实还有第四种对象 **tag**.
    
    * **blob** 对应我们仓库里的普通**文件**,当你将一份文件add到仓库里时,git将会为你产生一个blob对象存于objects目录下.
    
    * **tree** 对应我们仓库里的一个**目录**,当你做一次commit时,git将会为你新增的目录产生tree对象存于objects目录下.
    
    * **commit** 对应我们的一次**提交行为**,当你做一次commit时,git将会为你产生tree对象(若有新目录)的同时产生commit对象,存于objects目录下.
    
    * 可以利用 `cat-file -t SHA-1-of-one-object` 查看一个对象的数据类型, SHA-1-of-one-object 的值为你看到一个objects下新增的文件的子目录+文件名

* 第一次提交后git的对象(blog,tree,commit)和引用(head,branch)间的关系组织如下图,图中已表明每一个对象和引用分别对应的事物

* 本场景命令: ** git add . ** ; ** git commit -m "first commit" **

![Slide 1](/css/images/git-session/slide4.png)

---
* 那么在这些git对象和引用种到底存储了什么内容,他们怎样组织起来的呢???
    
    * 如下图所示,引用HEAD文件中存的是当前branch的路径,默认为master
    
    * 如下图所示,而分支master文件中存的是一个SHA-1值,该值是一个commit对象的key,意为分支master当前指向该特定commit
    
    * 如下图所示,若找到对应master里存储的那个commit后我们看到该文件里存了若干信息,主要包括上一个commit对象的key,一些git对象的类型与key值,本次提交信息,提交者的信息与提交时间
    
    * 如下图所示,一个tree对象里存储的是一个或多个blob 对象的key,对应到仓库里则意味着该目录下现在这几个文件
    
    * 如下图所示,一个blob对象里存储的就是真实的文件内容啦
    
现在你能理解为什么主人公第一次commit后的git图如上所示了吧

![Slide 1](/css/images/git-session/slide5.png)

---

>Git 是一个内容寻址文件系统。 看起来很酷， 但这是什么意思呢？ 这意味着，Git 的核心部分是一个简单的键值对数据库（key-value data store）。

![Slide 1](/css/images/git-session/slide6.png)

---

* 第二次commit,主人公更改了status.txt的内容味'fall in love',新增了girl_friend目录及name.txt文件

* 第二次git结构图如下所示,图中所示的git对象都存在于objects目录下,只是那些灰色的对象并不链在当前branch的当前状态上了

![Slide 1](/css/images/git-session/slide7.png)

---
* 只要一个文件不改变(包括内容和文件名),git就不会为该文件在下次提交时新建blob对象,而对于一个目录来所,只要它下面任意一个文件或子目录有变化git都将重新建一个commit对象

![Slide 1](/css/images/git-session/slide8.png)

---
* 主人公的恋爱状态仍然是"fall in love",但是女主人公却换了,让我们一起来练习这次提交的git图

![Slide 1](/css/images/git-session/slide9.png)

![Slide 1](/css/images/git-session/slide10.png)

---
* 这次主人公要逃避现实了,他希望和xiaoli的那些happy time未曾发生,让我们回想一下第三次commit主要干了什么呢,对,主人公在第三次新增了一个events.txt,并写道'happy time with xiaoli'

* revet 本例中的第三次commit其实等同于 delet当时新增的event.txt文件,此时你发现问题来了,因为该文件后来有修改,此时revert会发生conflict,需要先修复,然后提交.revert会做一次新的提交.

* 本场景命令: ** git revert one-commit **

![Slide 1](/css/images/git-session/slide11.png)
![Slide 1](/css/images/git-session/slide12.png)

---

* 本场景中,相信git图已经很明确的告诉你这个命令的背后发生了什么

* 本场景命令: ** git reset --hard HEAD~2 **

![Slide 1](/css/images/git-session/slide13.png)
![Slide 1](/css/images/git-session/slide14.png)

---

* 猜一猜本场景中这个有趣的,我命名其为'主人公心路历程'的命令是什么吧? 答案是 ** git reflog **

![Slide 1](/css/images/git-session/slide15.png)
![Slide 1](/css/images/git-session/slide16.png)
