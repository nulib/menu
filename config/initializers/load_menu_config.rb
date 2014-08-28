require 'yaml'
require 'nokogiri'
require 'open-uri'

MENU_CONFIG = YAML.load_file('config/menu.yml')[Rails.env]
if Rails.env.test? then WebMock.allow_net_connect! end
XSD = Nokogiri::XML::Schema(open("http://www.loc.gov/standards/vracore/vra-strict.xsd").read)
if Rails.env.test? then WebMock.disable_net_connect! end