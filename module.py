#!/usr/bin/env python3
#-*- coding: utf-8 -*-
 
# File Name: module.py
# Author: Feng
# Created Time: 2019-03-11 18:21
# Content:

import vim

def delete_inner_obj(symbol):
    for buf in vim.buffers:
        print(buf)

    for content in vim.current.buffer:
        print(content)
    
if __name__ == '__main__':
    delete_inner_obj(None)
