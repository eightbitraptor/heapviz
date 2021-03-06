require 'heapviz/config'

module Heapviz
  class Heap
    include Heapviz::Config

    def initialize
      @pages = {}
    end

    def get_or_build_page_for(slot)
      @pages[slot.page_body_address] ||= build_page(slot.page_body_address, slot.size)
    end

    def pages
      @pages.values
    end

    def page_count
      @pages.length
    end

    def max_page_size
      HEAP_PAGE_OBJ_LIMIT
    end

    private

    def build_page(page_body_address, slot_size)
      # Pages have a header with information, so we have to take that in to account
      start = page_body_address + SIZEOF_PAGE_HEADER

      # If the object start address isn't evenly divisible by the size of a
      # Ruby object, we need to calculate the padding required to find the first
      # address that is divisible by SIZEOF_RVALUE
      if start % slot_size != 0
        delta = SIZEOF_RVALUE - (start % SIZEOF_RVALUE)
        start += delta # Move forward to first address

        if num_in_page(start) == 1
          start += slot_size - SIZEOF_RVALUE
        end
      end
      limit = (HEAP_PAGE_SIZE - (start - page_body_address)) / slot_size

      Page.new(page_body_address, start, limit, slot_size)
    end

    def num_in_page(obj)
      (obj & HEAP_PAGE_ALIGN_MASK) / SIZEOF_RVALUE 
    end
  end
end
