$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'turbomode'

require 'minitest/autorun'
require 'minitest/reporters'

reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]
