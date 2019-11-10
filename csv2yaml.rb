require 'yaml'
require 'csv'

target = ARGV[0]
csv = "#{target}.csv"
yaml = "#{target}.yaml"

header_paper = [
  "title_ja", 
  "title_en", 
  "author_ja", 
  "author_en", 
  "journal_ja", 
  "journal_en", 
  "volume", 
  "issue", 
  "page_start", 
  "page_end", 
  "date", 
  "reviewed", 
  "invited", 
  "language", 
  "type", 
  "ISSN", 
  "DOI", 
  "JGlobalID", 
  "NAID", 
  "PMID", 
  "Permalink", 
  "URL", 
  "Abstract_ja", 
  "Abstract_en"
]

header_conf = [
  "title_ja", 
  "title_en", 
  "author_ja", 
  "author_en", 
  "conf_ja", 
  "conf_en", 
  "date", 
  "invited", 
  "language", 
  "confType1",
  "confType2",  
  "host_ja", 
  "host_en", 
  "place_ja", 
  "place_en", 
  "URL", 
  "Abstract_ja", 
  "Abstract_en"
]

header_fund = [
  "owner_ja", 
  "owner_en", 
  "grant_ja", 
  "grant_en", 
  "title_ja", 
  "title_en", 
  "period_from", 
  "period_to", 
  "author_ja", 
  "author_en", 
  "amount_total", 
  "amount_direct", 
  "amount_indirect", 
  "Permalink", 
  "Abstract_ja", 
  "Abstract_en"
]

headers = {
  "paper" => header_paper, 
  "conference" => header_conf, 
  "competitiveFund" => header_fund
}

data = CSV.read(csv)
data.shift

data_yaml = YAML.dump(data.map{|x| Hash[headers[target].zip(x)]})

File.open(yaml, "w:utf-8") do |f|
  f.write(data_yaml)
end