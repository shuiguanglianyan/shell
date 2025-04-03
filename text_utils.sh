#!/bin/bash

# 用法说明
usage() {
  echo "多列文本处理工具 - 支持去重、计数、排序、批量修改"
  echo "用法: $0 [选项] [输入文件]"
  echo "选项:"
  echo "  -d <分隔符>     指定输入/输出的列分隔符（默认：空格）"
  echo "  -k <列号>       指定操作的列（默认：整行）"
  echo "  -c              计数模式（显示重复次数）"
  echo "  -u              去重模式（默认按首次出现保留）"
  echo "  -s <排序方式>   n（数字排序）、r（逆序）、k（按列排序，需配合 -k 使用）"
  echo "  -m 'sed脚本'    批量修改文本（兼容 sed 语法，如 's/old/new/g'）"
  echo "  -o <输出文件>   结果输出到文件"
  echo "示例:"
  echo "  $0 -d ',' -k 2 -c -s nrk3 input.txt"
  echo "  # 按第2列统计频率，按第三列数值逆序排序"
  exit 1
}

# 初始化变量
delimiter=" "
column=0
count_mode=0
unique_mode=0
sort_opt=""
sed_script=""
output=""

# 解析参数
while getopts "d:k:cus:m:o:" opt; do
  case $opt in
    d) delimiter="$OPTARG" ;;
    k) column="$OPTARG" ;;
    c) count_mode=1 ;;
    u) unique_mode=1 ;;
    s) sort_opt="$OPTARG" ;;
    m) sed_script="$OPTARG" ;;
    o) output="$OPTARG" ;;
    *) usage ;;
  esac
done
shift $((OPTIND -1))

input_file="${1:-/dev/stdin}"  # 支持文件或管道输入

# 处理流程
process() {
  local cmd="cat \"$input_file\""

  # Step 1: 批量修改文本（sed）
  [ -n "$sed_script" ] && cmd+=" | sed '$sed_script'"

  # Step 2: 分隔符处理（tr）
  [ "$delimiter" != " " ] && cmd+=" | tr '$delimiter' '\t'"

  # Step 3: 去重或计数（awk/uniq）

  if [ $count_mode -eq 1 ]; then
    if [ $column -eq 0 ]; then
      cmd+=" | sort | uniq -c"
    else
      cmd+=" | awk -F'\t' -v col=$column '{count[\$col]++} END {for (k in count) print count[k], k}'"
    fi
  elif [ $unique_mode -eq 1 ]; then
    if [ $column -eq 0 ]; then
      cmd+=" | awk '!seen[\$0]++'"
    else
      cmd+=" | awk -F'\t' -v col=$column '!seen[\$col]++'"  # 关键修正
    fi
  fi

  # Step 4: 排序（sort）
  if [ -n "$sort_opt" ]; then
    local sort_cmd="sort"
    [[ "$sort_opt" == *"n"* ]] && sort_cmd+=" -n"
    [[ "$sort_opt" == *"r"* ]] && sort_cmd+=" -r"
    [[ "$sort_opt" == *"k"* ]] && sort_cmd+=" -k${sort_opt//[^0-9]/}"
    cmd+=" | $sort_cmd"
  fi

  # Step 5: 恢复分隔符（tr）
  [ "$delimiter" != " " ] && cmd+=" | tr '\t' '$delimiter'"

  # 执行并输出
  if [ -n "$output" ]; then
    eval "$cmd > \"$output\""
  else
    eval "$cmd"
  fi
}

# 执行主流程
process
