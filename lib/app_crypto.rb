require 'rubygems'
require 'pry'
require 'rest-client'
require 'nokogiri'
require 'open-uri'

#Prends tout les cours de crypto et les attributs a leur symbole

def get_all_page_names
  crypto_names_array = []
  crypto_values_array = []

  57.times do |i|
    page = Nokogiri::HTML(RestClient.get("https://coinmarketcap.com/?page=#{i+1}"))
    
    page.xpath('//*[@id="__next"]/div[1]/div[1]/div[2]/div/div[1]/div[2]/table/tbody/tr/td[3]/div/a/div/div/div/p').each do |node|
      crypto_names_array << node.text
    end
  
    page.xpath('//*[@id="__next"]/div[1]/div[1]/div[2]/div/div[1]/div[2]/table/tbody/tr/td[3]/a/span[3]').each do |node|
      crypto_names_array << node.text
    end

    page.xpath('//*[@id="__next"]/div[1]/div[1]/div[2]/div/div[1]/div[2]/table/tbody/tr/td[4]/div/a').each do |node|
      crypto_values_array << node.text.delete_prefix("$").gsub(/([,])/, "").to_f
    end
  
    page.xpath('//*[@id="__next"]/div[1]/div[1]/div[2]/div/div[1]/div[2]/table/tbody/tr/td[4]/span').each do |node|
      crypto_values_array << node.text.delete_prefix("$").gsub(/([,])/, "").to_f
    end
  end
  combined = Hash[crypto_names_array.zip(crypto_values_array)].map{|k, v| {k => v}}
  return combined
end

p get_all_page_names