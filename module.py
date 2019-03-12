#!/usr/bin/env python3
#-*- coding: utf-8 -*-
 
# File Name: module.py
# Author: Feng
# Created Time: 2019-03-11 18:21
# Content:

import vim
import urllib.request
import json

def print_python_version():
    python_version = vim.eval('g:python_version')
    print("Python version %s" % python_version)

def _get(url):
    return urllib.request.urlopen(url, None, 5).read().strip().decode()

def _get_country():
    try:
        ip = _get("http://ipinfo.io/ip")
        json_location_data = _get("http://api.ip2country.info/ip?%s" % ip)
        location_data = json.loads(json_location_data)
        print(location_data['countryName'])
        return location_data['countryName']
    except Exception as e:
        print(e)

def print_country():
    print("You seem to be in %s" % _get_country())

def insert():
    row, col = vim.current.window.cursor
    # print(row, col)
    current_line = vim.current.buffer[row - 1] #vim first line is 1, so current line is row - 1
    # print(current_line)
    new_line = current_line[:col] + _get_country() + current_line[col:]
    vim.current.buffer[row - 1] = new_line

def delete_inner_obj(symbol):
    for buf in vim.buffers:
        print(buf)

    for content in vim.current.buffer:
        print(content)
    
if __name__ == '__main__':
    # delete_inner_obj(None)
    # insert()
    print_python_version()
