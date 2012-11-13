#!/usr/bin/env ruby

basepath = $1 || File.expand_path(File.join(File.absolute_path(__FILE__), "../.."))
import_folder = File.join(basepath, "import_results")

# Clean up for a clean start
Dir.unlink(import_folder) if Dir.exists?(import_folder)
Dir.mkdir(import_folder)

Dir.glob("#{basepath}/git_repo/**/*").each do |file|
  relative_path = File.dirname(file[basepath.size+"git_repo".size+2..-1])

  # Files in the _att folders need to be stripped down
  if relative_path[-4..-1] == "_att"
    #Dir.mkdir(File.join(import_folder, relative_path)) -p
  end

  # Regular files are Raki style pages and need to convert to a markdown file
  if File.file?(file) and File.extname(file).empty?
    content = File.read(file).force_encoding("ISO-8859-1").encode("UTF-8", :replace => nil)

    # Headings
    content.gsub!(/^!([^!].+)$/, "#\\1")
    content.gsub!(/^!!([^!].+)$/, "##\\1")
    content.gsub!(/^!!!([^!].+)$/, "###\\1")
    content.gsub!(/^!!!!([^!].+)$/, "####\\1")
    content.gsub!(/^!!!!!([^!].+)$/, "#####\\1")

    # Links
    content.gsub!(/\[([^|\]]+)\]/, "[\\1][\\1]")
    content.gsub!(/\[([^|]+)\|([^\]]+)\]/, "[\\2][\\1]")

    # Images
    content.gsub!(/\\img .* ([^ \\]+) ?\\/, "![Embedded image][\\1]")
    
    # Other Plugins
    content.gsub!(/\\red (.+) ?\\/, "**\\1**")
    content.gsub!(/\\youtube (.*) ?\\/, "[Youtube link][\\1]")
    content.gsub!(/\\osm ([^ ]+) ([^ ]+) ?\\/, "[Open Street Map link][http://www.openstreetmap.org/?lat=\\1&lon=\\2&zoom=18&layers=M]")

    # Delete the useless stuff
    content.gsub!(/\\index.+\\/, "")
    content.gsub!(/\\recentchanges.+\\/, "")


    File.write
  end

end

