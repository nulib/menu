require 'yaml'
require 'nokogiri'
require 'open-uri'

MENU_CONFIG = YAML.load_file('config/menu.yml')[Rails.env]

XSD = Nokogiri::XML::Schema(open("http://www.loc.gov/standards/vracore/vra-strict.xsd").read)