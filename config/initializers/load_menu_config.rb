require 'yaml'

MENU_CONFIG = YAML.load_file('config/menu.yml')[Rails.env]
