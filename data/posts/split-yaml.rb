require 'yaml'
require 'optparse'

op = OptionParser.new
opts = Hash.new

op.on("-i", "--input VALUE", "input file (.yaml)"){|v| opts[:input] = v}
op.on("-o", "--output VALUE", "output directory"){|v| opts[:output] = v}
op.on("", "--dry-run"){|v| opts[:dryrun] = v}
op.parse(ARGV)

File.open(opts[:input], "r") do |f|
  @data = YAML.load(f.read())
end

def generate_post(category, entry)
  if category == "paper"
    generate_post_paper(entry)
  elsif category == "conference"
    generate_post_conference(entry)
  elsif category == "competitiveFund"
    generate_post_competitiveFund(entry)
  end
end

def normalize_author(authors)
  return authors.gsub(Regexp.union("，", "、"), ",")
end

@journal_abb = YAML.load(File.read("journal-abb.yaml"))

def normalize_journal(journal)
  return @journal_abb[journal]
end

def generate_post_paper(entry)
  year = entry["date"][0..3]
  mon = entry["date"][4..5]
  day = entry["date"][6..7]
  author = normalize_author(entry["author_en"]).split(",")[0].split(" ").join("")
  journal = normalize_journal(entry["journal_en"])
  ret = "#{year}-#{mon}-#{day}-#{author}-#{journal}.yaml"
  return ret
end

@jp2en_author = YAML.load(File.read("jp2en-author.yaml"))

def jp_to_en_author(author)
  if @jp2en_author.has_key?(author)
    return @jp2en_author[author]
  else
    return author
  end
end

@conf_abb = YAML.load(File.read("conf-abb.yaml"))

def normalize_conf(conf)
  re = Regexp.union(/第(\d+)回/, /The (\d+)nd/)
  matched = re.match(conf)
  if matched.nil?
    no = ""
    conf_name = conf
  else
    no = matched.to_a[1]
    conf_name = matched.post_match.strip
  end
  return "#{@conf_abb[conf_name]}#{no}"
end

def generate_post_conference(entry)
  year = entry["date"][0..3]
  mon = entry["date"][4..5]
  day = entry["date"][6..7]
  author = normalize_author(entry["author_ja"]).split(",")[0]
  author =  jp_to_en_author(author).split(" ").join("")
  conf = normalize_conf(entry["conf_ja"])
  ret = "#{year}-#{mon}-#{day}-#{author}-#{conf}.yaml"
  return ret
end

def generate_post_competitiveFund(entry)

end


category = File.basename(opts[:input], ".yaml")
@data.each do |entry|
  post = File.join(opts[:output], generate_post(category, entry))
  entry["author_ja"] = normalize_author(entry["author_ja"])
  if opts[:dryrun]
    puts post
    puts YAML.dump(entry)
    puts
  else
    File.open(post, "w:utf-8") do |f|
      f.puts YAML.dump(entry)
    end  
  end
end