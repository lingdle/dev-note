# 开发指南： Checkstyle 快速接入指南

## 遵循理念
- ##### Checkstyle 最终目的是：保证提交到仓库中的代码都是 Checkstyle 审查通过的代码
- ##### Checkstyle 最佳时机是：代码提交到仓库之前
- ##### Checkstyle 最佳方式是：仅对本地提交代码增量做 Checkstyle 审查
- ##### Checkstyle 审查原则是： Checkstyle 审查规则应在组织内保持统一，不可频繁随意修改变更。如需变更时应协商集权处理：协商后由负责人变更
- ##### Checkstyle 使用规则是： Checkstyle 审查不允许关闭，不允许忽略，必须在代码提交到仓库之前第一时间修复 Checkstyle 审查问题
- ##### Checkstyle 审查债务处理推荐方案是：历史代码未做 Checkstyle 审查，应在后续涉及代码改动提交仓库时做  Checkstyle 审查，在修复完 Checkstyle 问题后才能提交，以此来增量偿还 Checkstyle 审查债务。

## 接入说明：
- 本文 Checkstyle 审查方式为：在 git commit 之前对 git status 中记录的文件执行 Checkstyle 审查
- [Checkstyle](https://checkstyle.org/) 版本为：[checkstyle-9.3-all.jar](https://github.com/checkstyle/checkstyle/releases/tag/checkstyle-9.3) 适用JDK8+版本
- Checkstyle 规则使用的是基于 [google_checks](https://raw.githubusercontent.com/checkstyle/checkstyle/master/src/main/resources/google_checks.xml) 修正版规则 [custom-checkstyle](https://gitee.com/lingdle/dev-note/raw/master/checkstyle/custom-checkstyle.xml)
- 本文脚本以 Linux OS bash shell 为示例： Windows 可以使用 git-bash 执行

---
## 接入步骤： `1. 安装 --> 2. 修正  --> 3. 检查 : 预计耗时 1min`
> Linux OS 示例： Windows 可以使用 git-bash 执行


#### 1. 安装
1.1 进入项目根目录${project-repo-home-dir}（即包含：.git 文件夹的目录）

```
${project-repo-home-dir} # 当前位置
├── .git
│    ├── hooks
│   ...
...
```
1.2 下载 [install-pre-commit-checkstyle.sh](https://gitee.com/lingdle/dev-note/raw/master/checkstyle/install-pre-commit-checkstyle.sh) 文件到 checkstyle 目录下并赋权

```shell
curl --create-dirs -o  ./checkstyle/install-pre-commit-checkstyle.sh https://gitee.com/lingdle/dev-note/raw/master/checkstyle/install-pre-commit-checkstyle.sh && chmod u+x ./checkstyle/install-pre-commit-checkstyle.sh
```
1.3 执行 install-pre-commit-checkstyle.sh 按提示继续操作

```shell
./checkstyle/install-pre-commit-checkstyle.sh
```
执行脚本后最终目录结构如下：
```
${project-repo-home-dir} #当前项目位置
├── .git
│    ├── hooks
│        ├── pre-commit
│   ...
├── checkstyle
│    ├── checkstyle-9.3-all.jar
│    ├── checkstyle.xml
│    ├── install-pre-commit-checkstyle.sh
│    ├── pre-commit.sh
...
```

#### 2. 修正【非必须】
** 当 `.git/hooks/pre-commit` 存在时: **
- 需要自行移植 [pre-commit-java-checkstyle.sh](https://gitee.com/lingdle/dev-note/raw/master/checkstyle/pre-commit-java-checkstyle.sh) 脚本内容，追加到 `.git/hooks/pre-commit`

#### 3. 检查
##### 运行 git commit 提交代码 `git commit -m 'fix: add checkstyle audit' -a`
##### Checkstyle 接入成功时有类似如下日志：

```
==============================
Checkstyle start...
    check file set:
    --------------------------
    ...
    --------------------------
开始检查……
检查完成。
Errors 0
Checkstyle done...
==============================

```
