require 'yaml'

target = ARGV[0]
yaml = "#{target}.yaml"

File.open(yaml, "r") do |f|
  @data = YAML.load(f.read())
end
config = YAML.load(File.read("config.yaml"))

patterns1 = config["patterns1"]
patterns2 = config["patterns2"]
re1 = Regexp.union(patterns1.keys)
re2 = Regexp.union(patterns2.keys)
out = []


@data.each do |entry|
  if entry["conf_ja"] == config["s"] || entry["language"] != "ja"
    entry["author_ja"] = entry["author_ja"].split(",").map{|x| x.split(" ").map{|y| y.capitalize}.join(" ")}.join(",")
    entry["author_en"] = entry["author_en"].split(",").map{|x| x.split(" ").map{|y| y.capitalize}.join(" ")}.join(",")
  end
  bibkey = entry["author_ja"].split(",")[0].split(" ")[0] + entry["date"][0..3] + entry["title_ja"].split(" ")[0]
  entry["bibkey"] = bibkey
  entry["title_ja"] = entry["title_ja"].gsub(re1, patterns1)
  entry["title_en"] = entry["title_en"].gsub(re1, patterns1)
  entry["author_ja"] = entry["author_ja"].gsub(re2, patterns2)
  entry["author_en"] = entry["author_en"].gsub(re2, patterns2)
  
  out << entry
end

File.open(yaml, "w:utf-8") do |f|
  f.write(YAML.dump(out))
end