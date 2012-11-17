desc "Convert the old wiki into Markdown"
task :convert do
  sh "scripts/importer.rb"
end

desc "Generate HTML stuff from markdown"
task :generate do
  require "kramdown"
  require "fileutils"

  import_folder = "import_results"
  target_folder = "public_html"

  #Dir.mkdir(target_folder)
  FileUtils.rm_rf(target_folder) if Dir.exists?(target_folder)
  Dir.mkdir(target_folder)
  FileUtils.cp_r(File.join(import_folder, "images"), target_folder)

  Dir.glob("#{import_folder}/*.mkd").each do |file|
    content = Kramdown::Document.new(File.new(file, "r").read).to_html
    File.open(File.join(target_folder, File.basename(file)[0..-4] + "html"), "w") do |fh|
      fh.write(content)
    end
  end
end

