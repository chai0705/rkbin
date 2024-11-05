#!/bin/bash

# 定义芯片型号及对应的参数文件
declare -A chips=(
    ["rk3568"]="rk3568_ddr_1560MHz_v1.23.bin"
    ["rk3588"]="rk3588_ddr_lp4_2112MHz_lp5_2400MHz_v1.18.bin"
    ["rk3562"]="rk3562_ddr_1332MHz_v1.06.bin"
    ["rk3576"]="rk3576_ddr_lp4_2112MHz_lp5_2736MHz_v1.08.bin"
)

# 颜色代码
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# 显示选择菜单
echo -e "${GREEN}请选择要处理的芯片型号：${NC}"
echo -e "${GREEN}0: rk3568${NC}"
echo -e "${GREEN}1: rk3588${NC}"
echo -e "${GREEN}2: rk3562${NC}"
echo -e "${GREEN}3: rk3576${NC}"
echo -e "${GREEN}4: 全部处理${NC}"
read -p "请输入你的选择（0-4）: " choice

# 定义选择对应的芯片名称数组
selected_chips=()
case $choice in
    0) selected_chips=("rk3568");;
    1) selected_chips=("rk3588");;
    2) selected_chips=("rk3562");;
    3) selected_chips=("rk3576");;
    4) selected_chips=("rk3568" "rk3588" "rk3562" "rk3576");;
    *) echo "无效选择！请重新运行脚本并输入有效选项。"; exit 1;;
esac

# 遍历选择的芯片型号，执行相应的操作
for chip in "${selected_chips[@]}"; do
    param_file="${chip}_gen_param.txt"
    ddr_file="${chips[$chip]}"

    echo "处理 $chip ..."

    # 读取 DDR 配置到参数文件
    ../../tools/ddrbin_tool $chip -g $param_file $ddr_file

    # 修改波特率
    sed -i 's/uart baudrate=1500000/uart baudrate=115200/' $param_file

    # 写回修改后的参数
    ../../tools/ddrbin_tool $chip $param_file $ddr_file

    # 删除参数文件
    rm -rf $param_file

    echo "$chip 处理完成！"
done

echo "处理完毕！"
