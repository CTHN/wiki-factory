#!/usr/bin/env ruby

require "fileutils"

basepath = $1 || File.expand_path(File.join(File.absolute_path(__FILE__), "../.."))
import_folder = File.join(basepath, "import_results")

# Clean up for a clean start
FileUtils.rm_rf(import_folder) if Dir.exists?(import_folder)
Dir.mkdir(import_folder)
Dir.mkdir(File.join(import_folder, "images"))

Dir.glob("#{basepath}/git_repo/**/*").each do |file|
  relative_path = File.dirname(file[basepath.size+"git_repo".size+2..-1])

  # Determine the subfolder
  f = file["#{basepath}/gitrepo?".size..-1].split("/")
  subfolder = f.size > 1 ? f.first : "."

  # Regular files are Raki style pages and need to convert to a markdown file
  if File.file?(file) and File.extname(file).empty?
    content = File.read(file)
    
    # Headings
    content.gsub!(/^!([^!].+)$/, "#\\1")
    content.gsub!(/^!!([^!].+)$/, "##\\1")
    content.gsub!(/^!!!([^!].+)$/, "###\\1")
    content.gsub!(/^!!!!([^!].+)$/, "####\\1")
    content.gsub!(/^!!!!!([^!].+)$/, "#####\\1")

    # Links
    content.gsub!(/\[([^|\]]+)\]/, "[\\1](\\1)")
    content.gsub!(/\[([^|]+)\|([^\]]+)\]/, "[\\2](\\1)")

    # Images
    content.gsub!(/\\img .* ([^ \\]+) ?\\/, "![Embedded image](images/\\1)")
    
    # Other Plugins
    content.gsub!(/\\red (.+) ?\\/, "**\\1**")
    content.gsub!(/\\youtube (.*) ?\\/, "[Youtube link](\\1)")
    content.gsub!(/\\osm ([^ ]+) ([^ ]+) ?\\/, "[Open Street Map link](http://www.openstreetmap.org/?lat=\\1&lon=\\2&zoom=18&layers=M)")

    # Delete the useless stuff
    content.gsub!(/\\index.+\\/, "")
    content.gsub!(/\\recentchanges.+\\/, "")

    file = File.new(File.join("import_results", File.basename(file+".mkd")), "w")
    file.write(content)
    file.close

  # files
  elsif File.file?(file) and File.extname(file) =~ /(jpg|jpeg|png)/
    new_file = File.join(import_folder, "images", File.basename(file))
    p file if File.exists?(new_file)
    FileUtils.cp(file, new_file)
  end
end

