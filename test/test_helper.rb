$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'bundler/setup'
require 'simplestate'
require 'dummys/button'
require 'dummys/dummy_state_holder'
require 'dummys/dummy_master'

require 'minitest/autorun'

#require 'coveralls'
#Coveralls.wear!

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

# Uncomment these to make pry available
# Also make necessary changes in simplestate.gemspec
#require 'pry'
#require 'pry-byebug'
