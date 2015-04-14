RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  # config.before(:suite) do
  #   begin
  #     DatabaseCleaner.start
  #     FactoryGirl.lint
  #   ensure
  #     DatabaseCleaner.clean
  #   end
  # end


  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    FactoryGirl.lint
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
    DatabaseCleaner.clean
  end
end