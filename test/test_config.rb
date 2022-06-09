require 'test_helper'
require 'heapviz/config'

module Heapviz
  class TestConfig < Minitest::Test
    def test_sizeof_page_header
      assert_equal(Fiddle::SIZEOF_VOIDP, Config::SIZEOF_PAGE_HEADER)
    end

    def test_sizeof_rvalue
      assert(GC::INTERNAL_CONSTANTS[:RVALUE_SIZE], Config::SIZEOF_RVALUE)
    end

    def test_heap_page_align_log
      assert_equal(16, Config::HEAP_PAGE_ALIGN_LOG)
    end

    def test_heap_page_align
      assert_equal(65536, Config::HEAP_PAGE_ALIGN)
    end

    def test_heap_page_size
      # previous versions of CRuby accounted for malloc padding here, now all
      # heap pages are aligned we no longer need to do this. This constant
      # alias is kept in place mostly to match the names used in the C source
      # code.
      assert_equal(Config::HEAP_PAGE_ALIGN, Config::HEAP_PAGE_SIZE)
    end

    def test_heap_page_obj_limit
      assert_equal(1638, Config::HEAP_PAGE_OBJ_LIMIT)
    end
  end
end
