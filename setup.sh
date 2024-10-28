#!/bin/sh
basepath=$(
	cd $(dirname $0)
	pwd
)
ln -sf ${basepath} ~/.config/nvim
#test
