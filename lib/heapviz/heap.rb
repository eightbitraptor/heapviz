module Heapviz
  class Heap
    SIZEOF_HEAP_PAGE_HEADER_STRUCT = Fiddle::SIZEOF_VOIDP
    SIZEOF_RVALUE           = 40
    HEAP_PAGE_ALIGN_LOG     = Heapviz::shiftcount(GC::INTERNAL_CONSTANTS[:HEAP_PAGE_SIZE])
    HEAP_PAGE_ALIGN         = 1 << HEAP_PAGE_ALIGN_LOG      # 2 ^ 14 (or 16 on MacOS)
    HEAP_PAGE_ALIGN_MASK    = ~(~0 << HEAP_PAGE_ALIGN_LOG)  # Mask for getting page address
    HEAP_PAGE_SIZE          = HEAP_PAGE_ALIGN               # Actual page size
    HEAP_PAGE_OBJ_LIMIT     = (HEAP_PAGE_SIZE - SIZEOF_HEAP_PAGE_HEADER_STRUCT) / SIZEOF_RVALUE

    def initialize
      @pages = []
    end

    def get_or_build_page_for(slot)
      p "getting page #{slot.page_body_address}"
      @pages[slot.page_body_address] ||= build_page(slot.page_body_address, slot.size)     
    end

    private

    def build_page(page_body_address, slot_size)
      # Pages have a header with information, so we have to take that in to account
      start = page_body_address + SIZEOF_HEAP_PAGE_HEADER_STRUCT

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

      p "\tcreating page #{page_body_address}"
      page = Page.new(page_body_address, start, limit, slot_size)
    end

    def num_in_page(obj)
      (obj & HEAP_PAGE_ALIGN_MASK) / SIZEOF_RVALUE 
    end

  end
end
