# config valid only for Capistrano 3.1
lock '3.4.0'

set :application, 'menu'
set :repo_url, 'git@github.com:nulib/menu.git'

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/menu'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/secrets.yml config/ldap.yml config/browse_everything_providers.yml}

# cap-passenger gem allows for deploy:restart hook, requires this to be set to also
# allow touch tmp/restart.txt to work

set :passenger_restart_with_touch, true
# Default value for linked_dirs is []

#we want to enable this, use public/system for sure for default paperclip storage
set :linked_dirs, %w{public/system public/assets}


set :rbenv_ruby, '2.2.2'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 2

set :delayed_job_workers, 2

set :delayed_job_queues, ["image_importing"]


# Run all rspec tests before deploying
set :tests, []
set :bundle_flags, "--deployment"

namespace :deploy do

  before :deploy, "deploy:run_tests"


  desc "Runs test before deploying, can't deploy unless they pass"
  task :run_tests do
    test_log = "log/capistrano.test.log"
    tests = fetch(:tests)
    tests.each do |test|
      puts "--> Running tests: '#{test}', please wait ..."
      unless system "bundle exec rspec #{test} > #{test_log} 2>&1"
        puts "--> Tests: '#{test}' failed. Results in: #{test_log} and below:"
        system "cat #{test_log}"
        exit;
      end
      puts "--> '#{test}' passed"
    end
    puts "--> All tests passed"
    system "rm #{test_log}"
  end


  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        with RAILS_ENV: fetch(:rails_env) do
          execute :rake, "delayed_job:kill_the_djs"
          execute :touch, release_path.join('tmp/restart.txt')
          invoke "delayed_job:start"
        end
      end
    end
  end

  after :publishing, :restart


end
