# -*- coding: utf-8 -*-
# 指定したキャッシュディレクトリから
# 特定の種類のファイルを抽出する
# browser.cache.disk.max_entry_size = 1048576(=1GB)

require 'pathname'
require 'fileutils'
require 'thread'

class Cache
  FILENUM_IN_A_THREAD = 1000
  MINIMUM_SIZE = 1000000

  def initialize(dir, *types)
    @cache_path = create_path(dir)
    @type_list = types
  end

  def cp_cache(dir)
    cp_path = create_path(dir)
    extraction_files.each do |file|
      cp(file, cp_path)
    end
    puts "copy files to #{cp_path.to_s}"
  end

  def mv_cache(dir)
    mv_path = create_path(dir)
    extraction_files.each do |file|
      mv(file, mv_path)
    end
    puts "move files to #{mv_path.to_s}"
  end

  private
  def create_path(dir)
    path = Pathname.new(dir)
    raise "wrong path \"#{dir}\"" unless path.exist?
    path
  end

  def extraction_files()
    files = []
    @cache_path.find do |path|
      next if path.directory?
      next if path.size < MINIMUM_SIZE
      type_str = `file -bi #{path.to_s}`
      if @type_list.any? {|t| type_str =~ /#{t}/}
        puts "#{path.to_s}: #{type_str.split(';')[0]}"
        files << path
      end
    end
    files
  end

  def cp(f, to)
    FileUtils.cp(f, to)
  end

  def mv(f, to)
    FileUtils.mv(f, to)
  end
end
