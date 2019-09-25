#!/usr/bin/env bash
# Author:  rming <rmingwang AT gmail.com>
#
# Notes: openpilot install script
#
# Project home page:
#       http://doc.sdut.me/openpilot_install.html

clear
printf "
####################################################
#    openpilot 安装工具                             #
#    更多信息 http://doc.sdut.me/                   #
####################################################
"


# 配置每个 fork 文件存储位置
PATH_FORK=/data/forks
FORKS=("-" "openpilot" "dragonpilot" "gernby" "kegman" "arne182")
PATH_OPENPILOT=${PATH_FORK}/openpilot
PATH_DRAGONPILOT=${PATH_FORK}/dragonpilot
PATH_GERNBY=${PATH_FORK}/gernby
PATH_KEGMAN=${PATH_FORK}/kegman
PATH_ARNE182=${PATH_FORK}/arne182

# 配置每个 fork 的 git 地址
GIT_OPENPILOT=https://gitee.com/afaaa/openpilot.git
GIT_DRAGONPILOT=https://gitee.com/afaaa/dragonpilot.git
GIT_GERNBY=https://gitee.com/afaaa/gernby.git
GIT_KEGMAN=https://gitee.com/afaaa/kegman.git
GIT_ARNE182=https://gitee.com/afaaa/arne182.git

# 配置每个 fork 选取的 branch
BRANCH_OPENPILOT=("-" "devel" "release2")
BRANCH_DRAGONPILOT=("-" "devel-zhs" "devel-zht" "devel-en" "0.6.4-zhs" "0.6.4-zht" "0.6.4-en")
BRANCH_GERNBY=("-" "kegman-plusGernby-0.6.2" "poly-center-062" "poly-center-063")
BRANCH_KEGMAN=("-" "kegman-0.6.4" "kegman-0.6.3" "kegman-0.6.2" "kegman-0.5.9" "kegman-0.5.8-gold")
BRANCH_ARNE182=("-" "release2" "064-clean" "mapd")

# 构建结果文件
FILE_UI_BUILD=selfdrive/ui/ui.o
# OP的入口文件
FILE_OP_LAUNCH=launch_openpilot.sh


#################################################
# echo color
echo=echo
for cmd in echo /bin/echo; do
  $cmd >/dev/null 2>&1 || continue
  if ! $cmd -e "" | grep -qE '^-e'; then
    echo=$cmd
    break
  fi
done
CSI=$($echo -e "\033[")
CEND="${CSI}0m"
CDGREEN="${CSI}32m"
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"
CBLUE="${CSI}1;34m"
CMAGENTA="${CSI}1;35m"
CCYAN="${CSI}1;36m"
CSUCCESS="$CDGREEN"
CFAILURE="$CRED"
CQUESTION="$CMAGENTA"
CWARNING="$CYELLOW"
CMSG="$CCYAN"

# fork_select
while :; do echo
  echo -e 'Fork 选择:'
  fork_count=$[${#FORKS[@]} - 1]
  for i in "${!FORKS[@]}"; do
    [[ ${i} -eq "0" ]] && continue
    echo -e "\t${CBLUE}${i}. ${FORKS[$i]}${CEND}"
  done
  read -e -p "请输入序号 ${CRED}[1-${fork_count}]${CEND}：" fork_select
  fork_select=${fork_select:-1}
  if [[ "${fork_select}" -gt "${fork_count}" ]] || [[ "${fork_select}" -lt "1" ]]; then
    echo -e "\n${CWARNING}请输入正确的序号！[1-5]${CEND}"
  else
    echo -e "===========================\n"
    FORK_L=${FORKS[$fork_select]}
    FORK=`echo ${FORK_L} | tr 'a-z' 'A-Z'`
    break
  fi
done

# branch_select
OP_BRANCHES=(`eval echo "$""{BRANCH_"${FORK}"[@]}"`)
while :; do echo
  echo -e '分支选择:'
  branch_count=$[${#OP_BRANCHES[@]} - 1]
  for i in "${!OP_BRANCHES[@]}"; do
    [[ ${i} -eq "0" ]] && continue
    echo -e "\t${CBLUE}${i}. ${OP_BRANCHES[$i]}${CEND}"
  done

  read -e -p "请输入序号 ${CRED}[1-${branch_count}]${CEND}：" branch_select
  branch_select=${branch_select:-1}
  
  if [[ "${branch_select}" -gt "${branch_count}" ]] || [[ "${branch_select}" -lt "1" ]]; then
    echo -e "\n${CWARNING}请输入正确的序号！[1-${branch_count}]${CEND}"
  else
    echo -e "===========================\n"
    OP_BRANCH=${OP_BRANCHES[$branch_select]}
    break
  fi
done

VAR_OP_PATH=`eval echo "$""PATH_${FORK}"`
VAR_OP_GIT=`eval echo "$""GIT_${FORK}"`

OP_PATH=${VAR_OP_PATH}
OP_GIT=${VAR_OP_GIT}


echo -e "\n${CSUCCESS}已选Fork: ${FORK_L} \n已选分支：${OP_BRANCH}${CEND}"
echo -e "===========================\n"

echo -e "\n${CBLUE}正在更新代码......${CEND}"
# 创建 forks 目录
if [ ! -d "${PATH_FORK}" ]; then
  mkdir -p "${PATH_FORK}"
  if [[ "$?" -ne "0" ]]; then
    echo -e "\n${CFAILURE}${PATH_FORK} 目录创建失败，请检查目录权限${CEND}"
    exit 1
  fi
fi

if [ ! -d "${OP_PATH}" ]; then
  # 目录不存在，第一次安装
  git clone -b ${OP_BRANCH} ${OP_GIT} ${OP_PATH}
  if [[ "$?" -ne "0" ]]; then
    echo -e "\n${CFAILURE}git clone 失败，请检查后重试${CEND}"
    exit 1
  fi
else
  git -C ${OP_PATH} pull
  if [[ "$?" -ne "0" ]]; then
    echo -e "\n${CFAILURE}git pull 失败，请检查后重试${CEND}"
    exit 1
  fi
  git -C ${OP_PATH} checkout ${OP_BRANCH}
  if [[ "$?" -ne "0" ]]; then
    echo -e "\n${CFAILURE}git checkout 失败，请检查后重试${CEND}"
    exit 1
  fi
fi

echo -e "===========================\n"

# 是否需要切换到当前选择的分支
read -e -p "${CWARNING}是否切换到该分支${CEND} ${CRED}[Y/n]${CEND}：" is_change_fork
is_change_fork=${is_change_fork:-y}
is_change_fork=`echo ${is_change_fork} | tr 'yn' 'YN'`

if [[ "${is_change_fork}" == "N" ]];then
  echo -e "${CSUCCESS}\n操作完成！\n${CEND}"
  exit 0
fi


# 创建软链
ENV_OP_PATH=/data/openpilot
if [ ! -L "${ENV_OP_PATH}" ]; then
    ms=`date +%s_%N`
    mv "${ENV_OP_PATH}" "${PATH_FORK}/backup_${ms}"
fi
rm -f ${ENV_OP_PATH}
ln -sf ${OP_PATH} ${ENV_OP_PATH}


# 是否需要编译
echo -e "\n"
read -e -p "${CWARNING}是否编译该分支${CEND} ${CRED}[Y/n]${CEND}：" is_make_fork
is_make_fork=${is_make_fork:-y}
is_make_fork=`echo ${is_make_fork} | tr 'yn' 'YN'`

if [[ "${is_make_fork}" == "N" ]];then
  echo -e "${CSUCCESS}\n操作完成！\n${CEND}"
  exit 0
fi

# 编译
cd ${ENV_OP_PATH} && make
if [[ "$?" -ne "0" ]]; then
  echo -e "\n${CFAILURE}openpilot 编译失败，请检查后重试${CEND}"
  exit 1
fi

# 是否需要重启
read -e -p "${CWARNING}是否重启 EON${CEND} ${CRED}[Y/n]${CEND}：" is_reboot
is_reboot=${is_reboot:-y}
is_reboot=`echo ${is_reboot} | tr 'yn' 'YN'`

if [[ "${is_reboot}" == "N" ]];then
  echo -e "${CSUCCESS}\n操作完成！\n${CEND}"
  exit 0
fi

echo -e "${CSUCCESS}\n系统重启中......\n${CEND}"
if [[ -f "/comma.sh" ]];then
  reboot
fi
exit 0

