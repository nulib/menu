# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Menu::Application.initialize!

Rails.logger = Logger.new( 'log/staging.log' )

