#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'optparse'
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'cache'

DEFAULT_DIR = "./"

opts = {}
ARGV.options do |o|
  o.banner = "ruby #{$0} [OPTION]... CACHEDIR FILETYPE..."
  o.on("-m", "移動による抽出を行う(指定しなければコピー)") {|x| opts[:mv] = x}
  o.on("-d DIRECTORY", "抽出先を指定する(指定しなければ ./)") {|x| opts[:dir] = x}

  begin
    o.parse!
  rescue => err
    puts err.to_s
    exit
  end
end
opts = {dir: DEFAULT_DIR}.merge(opts)

cx = Cache.new(*ARGV)
if opts[:mv]
  cx.mv_cache(opts[:dir])
else
  cx.cp_cache(opts[:dir])
end
