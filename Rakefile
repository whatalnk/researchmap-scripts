require 'rake/clean'

targets = ["paper", "conference", "competitiveFund"]
targets.each do |target|
  desc "csv => tex"
  task :"#{target}-csv2tex" do |t|
    Rake::Task["#{target}.yaml"].invoke
    if target != "competitiveFund"
      Rake::Task[:"#{target}-yaml2yaml"].invoke
    end
    Rake::Task["#{target}.tex"].invoke  
  end

  desc "csv => yaml"
  file "#{target}.yaml" => ["#{target}.csv"] do |t|
    system(*["ruby", "csv2yaml.rb", target])
  end

  desc "yaml => yaml"
  task :"#{target}-yaml2yaml" do |t|
    system(*["ruby", "yaml2yaml.rb", target])
  end

  desc "yaml => tex"
  file "#{target}.tex" => ["#{target}.yaml", "#{target}.tex.erb"] do |t|
    system(*(["ruby", "yaml2tex.rb", target]))
  end
end

desc "tex => pdf"
file "works.pdf" => ["works.tex"] do |t|
  system("platex works.tex")
  system("dvipdfmx works.dvi")
end

CLEAN.include ["aux", "bbl", "blg", "dvi", "log"].map{|ext| "works.#{ext}"}
CLOBBER.include "works.pdf"