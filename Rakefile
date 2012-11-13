desc "Convert the old wiki into Markdown"
task :convert do
  sh "scripts/importer.rb"
end

desc "Generate HTML stuff from markdown"
task :generate do
  require "kramdown"
  puts Kramdown::Document.new("*test*").to_html # .to_latex
end

