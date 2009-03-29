#!/usr/bin/ruby
require 'rubygems'
require 'open-uri'
require 'hpricot'

install_site = "http://www.turbinado.org/Home/Install"
install_to   = "/Users/justin/dev/haskell"
install_specs = Hpricot(open(install_site)).search("li").collect{|li| {:name=> li.inner_text.strip, :link=> li.search("a")}}.select{|r| r[:name] =~ /\([a-z]+\)$/}
#raise install_specs.inspect

darcs_regex = "\\(darcs\\)$"
git_regex = "\\(git\\)$"

#bash_install = File.read("turbinado")

darcs = install_specs.select{|l| l[:name] =~ Regexp.new(darcs_regex)}
gits =  install_specs.select{|l| l[:name] =~ Regexp.new(git_regex)}

Dir.chdir(install_to) 

darcs.each do |d|
  dir = File.join(install_to, d[:name])
  link = d[:link][0].get_attribute(:href)
  puts "Getting darc from #{link}"
  system "darcs get --lazy #{link}"
  puts "Installing darc"
  #Dir.chdir(dir)
  #system "runhaskell Setup configure;runhaskell Setup build;sudo runhaskell Setup install"
  #Dir.chdir("..")
end

gits.each do |g|
  dir = File.join(install_to, g[:name])
  git_repo = open(d[:link][0].get_attribute(:href)).scan(/^git:\/\/[a-zA-Z\.\/]/)[0]
  puts "Getting git repo #{git_repo}"
  system "git clone #{git_repo}"
end



