#!/usr/bin/env ruby

require 'fileutils'

abort("We don't need this any more")

basepath = $1 || File.expand_path(File.join(File.absolute_path(__FILE__), "../.."))

puts basepath
Dir.glob("#{basepath}/raki_import/**/*").each do |file|
  puts file
  relative_path = File.dirname(file[basepath.size+"git_repository".size+2..-1])

  # Files in the _att folders need to be stripped down
  if relative_path[-4..-1] == "_att"
    #Dir.mkdir(File.join(import_folder, relative_path)) -p
  end

  if ['.jpg', '.jpeg', '.png'].include?(File.extname(file).strip)
    FileUtils.cp(file, "#{basepath}/git_repository/images/#{File.basename(file)}")
  end

  # Regular files are Raki style pages and need to convert to a markdown file
  if File.file?(file) and File.extname(file).empty?
    content = File.read(file) #.force_encoding("ISO-8859-1").encode("UTF-8", :replace => nil)

    # Headings
    content.gsub!(/^!([^!].+)$/, "#\\1")
    content.gsub!(/^!!([^!].+)$/, "##\\1")
    content.gsub!(/^!!!([^!].+)$/, "###\\1")
    content.gsub!(/^!!!!([^!].+)$/, "####\\1")
    content.gsub!(/^!!!!!([^!].+)$/, "#####\\1")

    # Links
    content.gsub!(/\[([^|\]]+)\]/, "[\\1](/\\1)")
    content.gsub!(/\[([^|]+)\|([^\]]+)\]/, "[\\2](/\\1)")

    # Images
    content.gsub!(/\\img .* ([^ \\]+) ?\\/, "![Embedded image](/images/\\1)")
    
    # Other Plugins
    content.gsub!(/\\red (.+) ?\\/, "**\\1**")
    content.gsub!(/\\youtube (.*) ?\\/, "[Youtube link](\\1)")
    content.gsub!(/\\osm ([^ ]+) ([^ ]+) ?\\/, "[Open Street Map link](http://www.openstreetmap.org/?lat=\\1&lon=\\2&zoom=18&layers=M)")

    # Delete the useless stuff
    content.gsub!(/\\index.+\\/, "")
    content.gsub!(/\\recentchanges.+\\/, "")

    new_filename = file[(basepath.size+"raki_import".size+1)..-1]
    FileUtils.mkdir_p("#{basepath}/git_repository/pages/#{new_filename.split('/')[1]}")
    File.open("#{basepath}/git_repository/pages#{new_filename}.mkd", 'w') do |f|
      f.write(content)
    end
  end

end

