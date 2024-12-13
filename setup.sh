#!/bin/sh
basepath=$(
	cd $(dirname $0)
	pwd
)

home_dir=$(eval echo ~)

configPath="${home_dir}/.config/nvim"
if [ -d "$configPath" ]; then
	read -p "已存在配置目录，是否要删除?(y/n): " response

	case "$response" in 
		[Yy])
			rm -rf "$configPath"
			;;
		*)
			exit 0
			;;
	esac
fi

ln -sf ${basepath} ~/.config/nvim
#test
