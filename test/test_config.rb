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
      heap_page_size = GC::INTERNAL_CONSTANTS[:HEAP_PAGE_SIZE]

      #  macOS uses 64kb page sizes, all other systems use 16kb
      if heap_page_size > 16384
        assert_equal(16, Config::HEAP_PAGE_ALIGN_LOG)
      else
        assert_equal(14, Config::HEAP_PAGE_ALIGN_LOG)
      end
    end

    def test_heap_page_align
      heap_page_size = GC::INTERNAL_CONSTANTS[:HEAP_PAGE_SIZE]

      if heap_page_size > 16384
        assert_equal(65536, Config::HEAP_PAGE_ALIGN)
      else
        assert_equal(16384, Config::HEAP_PAGE_ALIGN)
      end
    end

    def test_heap_page_size
      # previous versions of CRuby accounted for malloc padding here, now all
      # heap pages are aligned we no longer need to do this. This constant
      # alias is kept in place mostly to match the names used in the C source
      # code.
      assert_equal(Config::HEAP_PAGE_ALIGN, Config::HEAP_PAGE_SIZE)
    end

    def test_heap_page_obj_limit
      heap_page_size = GC::INTERNAL_CONSTANTS[:HEAP_PAGE_SIZE]

      if heap_page_size > 16384
        assert_equal(1638, Config::HEAP_PAGE_OBJ_LIMIT)
      else
        assert_equal(409, Config::HEAP_PAGE_OBJ_LIMIT)
      end
    end
  end
end
