require 'rubygems'
require 'pry'
require 'rest-client'
require 'nokogiri'
require 'open-uri'

def find_mail(arr)
  i = []
  arr.each do |n|
    if [] == n.scan(/(#{"assemblee-nationale.fr"})/).flatten
      i
    else
      i << n
    end
  end
  return i.uniq
end
depute_first_name = []
depute_last_name = []

def depute_names (depute_first_name, depute_last_name)
  page = Nokogiri::HTML(URI.open("https://www2.assemblee-nationale.fr/deputes/liste/alphabetique"))

  depute = []

  page.xpath('//*[@id="deputes-list"]/div/ul/li/a').each do |node|
    depute << node.text
  end

  depute.each do |n|
    depute_first_name << n.split[1]
    depute_last_name << n.split[2..6].join(" ")
  end

  return depute_last_name
  return depute_first_name
end

def depute_sites
  page = Nokogiri::HTML(URI.open("https://www2.assemblee-nationale.fr/deputes/liste/alphabetique"))
  depute_sites = []

  depute_sites_without = page.xpath('//*[@id="deputes-list"]/div/ul/li/a').map { |link| link['href']}

  depute_sites_without.each do |n|
    depute_sites << "https://www2.assemblee-nationale.fr" + n
  end
  return depute_sites
end


def depute_mail
  depute_mail = []

  depute_sites.each do |n|
    h = []

    page = Nokogiri::HTML(URI.open("#{n}"))
    page.css('#haut-contenu-page > article > div.contenu-principal.en-direct-commission.clearfix > div > dl > dd a[href]').each do |node|
      h << node.text
    end

    depute_mail << find_mail(h)

  end
  return depute_mail
end

depute_names(depute_first_name, depute_last_name)

depute_mail_final = depute_mail

all_merged = []

(depute_first_name.length).times do |i|
  all = {}
  all["Prénom"] = depute_first_name[i]
  all["Nom"] = depute_last_name[i]
  all["Email"] = depute_mail_final[i][0]
  all_merged << all
end

p all_merged
puts all_merged.length