require 'rubygems'
require 'pry'
require 'rest-client'
require 'nokogiri'
require 'open-uri'

#Sélectionne le nom des villes

def mairie_names
  mairie_names = []

  page = Nokogiri::HTML(RestClient.get("http://annuaire-des-mairies.com/val-d-oise"))

  page.css('td > p > a.lientxt').each do |node|
    mairie_names << node.text.capitalize
  end

  return mairie_names
end

#Créer une liste des sites des villes

def mairie_links
  page = Nokogiri::HTML(RestClient.get("http://annuaire-des-mairies.com/val-d-oise"))

  mairie_end_links = page.css('td > p > a.lientxt').map { |link| link['href'].delete_prefix(".") }

  mairie_links = []

  mairie_end_links.each do |n|
    mairie_links << "http://annuaire-des-mairies.com" + n
  end
  return mairie_links
end

#Créer la liste des mails

def mairie_mail
  mairie_mail = []

  mairie_links.each do |n|

    page = Nokogiri::HTML(RestClient.get("#{n}"))
    if (page.xpath('/html/body/div[1]/main/section[2]/div/table/tbody/tr[4]/td[2]').text) == ""
      mairie_mail << "Pas de mail!"
    else
      mairie_mail << page.xpath('/html/body/div[1]/main/section[2]/div/table/tbody/tr[4]/td[2]').text
    end

  end
  return mairie_mail
end

#Créer l'annuaire des mails

def annuaire_des_mails
  annuaire_des_mails = Hash[mairie_names.zip(mairie_mail)].map{|k, v| {k => v}}
  return annuaire_des_mails
end

p annuaire_des_mails