# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform     = Gem::Platform::RUBY
  s.name         = 'spree_promo_users_codes'
  s.version      = '3.3.0'
  s.summary      = 'Adds multiple coupon code for a promotion with
    respect to users functionality to the application'
  s.description  = "It's an extension that provides a functionality
    to create multiple coupons for a promotion with respect to a
    user and these codes can only be used once"
  s.author       = 'Vinsol Team'
  s.email        = 'info@vinsol.com'
  s.homepage     = 'http://vinsol.com'
  s.license      = 'BSD-3'
  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.required_ruby_version = '>= 2.2.7'

  spree_version = '>= 3.2.0', '< 4.0.0'

  s.add_dependency 'spree_core',                        spree_version
  s.add_dependency 'spree_extension',                   '~> 0.0.5'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-activemodel-mocks'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
