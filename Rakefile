require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

require 'engine_cart/rake_task'

Dir.glob('./tasks/*.rake').each { |f| load f }
Dir.glob('./lib/tasks/*.rake').each { |f| load f }

task default: %i[rubocop ci]
