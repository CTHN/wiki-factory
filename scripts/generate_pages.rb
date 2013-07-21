#!/usr/bin/env ruby

require 'rubygems'
require 'kramdown'
require 'fileutils'

basepath = $1 || File.expand_path(File.join(File.absolute_path(__FILE__), '../..'))

FileUtils.rm_rf("#{basepath}/public_html")
FileUtils.mkdir_p("#{basepath}/public_html/pages")
FileUtils.cp_r("#{basepath}/wiki-data/images", "#{basepath}/public_html/images")

Dir.glob('wiki-data/pages/**/*').each do |file|
  next unless File.file?(file)
  file_relative = file[("wiki-data/pages/".size)..-1]
  puts file_relative

  # We need to create that directory
  if file_relative.split('/').size > 1
    dir = file_relative.split('/').first
    FileUtils.mkdir_p("#{basepath}/public_html/pages/#{dir}")
  end

  # Copy all dynamic pages directly
  if %(.html .html.php .php).include?(File.extname(file))
    FileUtils.cp(file, "#{basepath}/public_html/pages/#{file_relative}")
    next
  end

  # Markdown files gets converted to HTML
  next unless File.extname(file) == '.mkd'
  document = Kramdown::Document.new(File.read(file), :input => 'markdown')
  File.open("#{basepath}/public_html/pages/#{file_relative[0..-5]}.html", 'w') do |f|
    f.write(document.to_html)
  end
end
