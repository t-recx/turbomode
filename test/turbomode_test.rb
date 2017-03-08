require 'test_helper'

class TurbomodeTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Turbomode::VERSION
  end
end
