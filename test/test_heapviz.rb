# frozen_string_literal: true

require "test_helper"
require "heapviz"

class TestHeapviz < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Heapviz::VERSION
  end
end
