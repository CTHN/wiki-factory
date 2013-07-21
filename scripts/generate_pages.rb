#!/usr/bin/env ruby

require 'rubygems'
require 'kramdown'
require 'fileutils'

basepath = $1 || File.expand_path(File.join(File.absolute_path(__FILE__), '../..'))

FileUtils.rm_rf("#{basepath}/content")
FileUtils.mkdir_p("#{basepath}/content/pages")
FileUtils.cp_r("#{basepath}/git_repository/images", "#{basepath}/content/images")

Dir.glob('git_repository/pages/**/*').each do |file|
  next unless File.file?(file)
  file_relative = file[("git_repository/pages/".size)..-1]
  puts file_relative

  # We need to create that directory
  if file_relative.split('/').size > 1
    dir = file_relative.split('/').first
    FileUtils.mkdir_p("#{basepath}/content/pages/#{dir}")
  end

  # Copy all dynamic pages directly
  if %(.html .html.php .php).include?(File.extname(file))
    FileUtils.cp(file, "#{basepath}/content/pages/#{file_relative}")
    next
  end

  # Markdown files gets converted to HTML
  next unless File.extname(file) == '.mkd'
  document = Kramdown::Document.new(File.read(file), :input => 'markdown')
  File.open("#{basepath}/content/pages/#{file_relative[0..-5]}.html", 'w') do |f|
    f.write(document.to_html)
  end
end
