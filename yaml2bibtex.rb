require 'erb'
require 'yaml'

yaml = ARGV[0]
erb = ARGV[1]
bibtex = ARGV[2]

data = YAML.load(File.read(yaml))

File.open(erb, "r") do |c|
  template = ERB.new(c.read(), nil, "-")
  File.open(bibtex, "w:utf-8") do |f|
    f.write(template.result(binding))
  end
end