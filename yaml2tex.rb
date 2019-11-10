require 'erb'
require 'yaml'

target = ARGV[0]
data = []
config = YAML.load(File.read("config.yaml"))

YAML.load(File.read("#{target}.yaml")).each do |entry|
  if entry["conf_ja"] == config["s"] || entry["language"] != "ja"
    authors = entry['author_ja'].split(",")
    n = authors.size
    authors_ = ""
    n.times do |i|
      if i == 0
        authors_ += authors[i]
      elsif i == n - 1
        authors_ += ", and #{authors[i]}"
      else
        authors_ += ", #{authors[i]}"
      end
    end
    entry['author_ja'] = authors_
  end
  data << entry
end
data.sort_by!{|x| x['date']}.reverse!

File.open("#{target}.tex.erb", "r:utf-8") do |c|
  template = ERB.new(c.read(), nil, "-")
  File.open("#{target}.tex", "w") do |f|
    f.puts template.result(binding)
  end
end