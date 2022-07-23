#!/usr/bin/env ruby

# (c) Copyright 2022 by Niklaus Giger<niklaus.giger@member.fsf.org>
# Small helper file to help keeping the RCPTT translations in sync with
# the ch.elexis.core.l10n messages properties
#

require 'bundler/inline'
puts "It may take some time for bundler/inline to install the dependencies"

gemfile do
source 'https://rubygems.org'
  gem 'pry-byebug'
end

TranslationItem = Struct.new(:translation_id, # id in translation_<lang>.properties elexis-uitest
  :message_id, # id in messages_<lang>.properties elexis
  :de, # value in german
  :fr,
  :it)
Headers = [:translation_id, # id in translation_<lang>.properties elexis-uitest
  :message_id, # id in messages_<lang>.properties elexis
  :de, # value in german
  :fr,
  :it]

Languages = [:de, :fr, :it]
PropertyMatch = /(\w|.*)\s*=\s*(.*)/

dir = Dir.glob("../elexis-3-core")
raise "ElexisCoreBase not found" unless dir.size == 1
ElexisCoreBase = dir.first

L10N_Base = File.join(ElexisCoreBase, "bundles/ch.elexis.core.l10n/src/ch/elexis/core/l10n")
raise "L10N_Base not found" unless File.directory?(L10N_Base)
pp
Billing_Base = File.join(ElexisCoreBase, "bundles/ch.elexis.core/src/ch/elexis/core/model/ch")
raise "Billing_Base not found" unless File.directory?(Billing_Base)
pp Billing_Base

EscapeBackslash = /\\([\\]+)/

# Converts escapces like \u00 to UTF-8 and removes all duplicated backslash.
# Verifiy it using the following SQL scripts
# select * from db_texts where translation like '%\u00%';
# select * from db_texts where translation like '%\\%';
def convert_to_real_utf(string)
  string = string.gsub(EscapeBackslash, '\\')
  return string unless  /\\u00|/.match(string)
  strings = []
  begin
	string.split('"').each do |part|
	  idx = 0
	  while idx <= 5 && /\\u00/.match(part)
		part = eval(String.new('"'+part.chomp('\\')+'"'))
		idx += 1
	  end
	  strings << part
	end
  rescue => error
	puts error
  end
  res = strings.join('"')
  res += '"' if  /"$/.match(string)
  res
end

Elexis_Messages = {}
Languages.each do |lang|
  Elexis_Messages[lang] = {}
  [ L10N_Base, Billing_Base].each do |msgDir|
	file =File.join(msgDir, "messages_#{lang}.properties")
	lines = IO.readlines(file)
	lines.each do |line|
	  if m = PropertyMatch.match(convert_to_real_utf(line))
		Elexis_Messages[lang][m[1].strip] = m[2] 
	  end
	end
	puts "#{lang}: Has #{Elexis_Messages[lang].size} keys from #{file}"
  end
end

def propName(lang)
  file = Dir.glob("./setup/data/translations_#{lang}.properties").first
end

ToTranslate = {}
Languages.each do |lang|
  ToTranslate[lang] = {}
  lines = IO.readlines(propName(lang))
  lines.each do |line|
	str = convert_to_real_utf(line).strip
	m = PropertyMatch.match(str)
	binding.pry if /.*BillingLaw.KVG.*/.match(line)
	ToTranslate[lang][m[1]] = m[2] if m
  end
end

ForCSV = []
def fill_from(lang, file = propName(lang))
  file = propName(lang)
  puts "Filling #{lang} defaults for #{ToTranslate[lang].size} items from #{file}"
  nrFounds = 0
  ToTranslate[lang].each do |pair|
	res = Elexis_Messages[lang].find do |key, value|
	  /#{pair[1]}$/.match(value)
	end
	item = TranslationItem.new
	item.translation_id = pair[0]
	item.de = pair[1]
	if res
	  puts "Found #{pair[1]} via #{res.first}" if $VERBOSE
	  nrFounds+=1
	  item.message_id = res.first.strip
	end
	ForCSV << item
  end
  puts "Found #{nrFounds} of #{ForCSV.size} items"
end
fill_from(:de)

def add_lang(lang)
  file = propName(lang)
  ForCSV.each do |csvItem|
	binding.pry if csvItem.translation_id.eql?('KVG_Gesetz')
	value = Elexis_Messages[lang][csvItem.message_id]
	# To we have already a translation for a not found german 
	value = ToTranslate[lang][csvItem.translation_id] unless value
	if value
#	  puts "Adding #{value} for #{csvItem.message_id} lang #{lang}"
	  begin
		str = "csvItem.#{lang} = '#{value.gsub("'", "\\\\'")}'"
		eval(str)
	  rescue => error
		pp error
	  end
	end
  end
end
add_lang(:fr)
add_lang(:it)

require 'csv'
def write_csv(file)
  CSV.open(file, "w", :write_headers=> true, :headers => Headers ) do |csv|
	ForCSV.each do |item|
	  csv << item
	end
  end
end
write_csv('./setup/data/translations.csv')

def emit_lang(lang)
  File.open(propName(lang), 'w+') do |file|
	ForCSV.each do |csvItem|
	  value = eval("csvItem.#{lang} || csvItem.de")
	  line = "#{csvItem.translation_id}=#{value}"
	  file.puts line
	end
  end
end

emit_lang(:fr)
emit_lang(:it)
