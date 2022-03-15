require 'fiddle'

module Heapviz
  module Config
    class << self
      private

      def shiftcount(n)
        x = 0
        while n > 1
          x += 1
          n >>= 1
        end
        x
      end
    end

    SIZEOF_PAGE_HEADER   = Fiddle::SIZEOF_VOIDP
    SIZEOF_RVALUE        = GC::INTERNAL_CONSTANTS[:RVALUE_SIZE]
    HEAP_PAGE_ALIGN_LOG  = shiftcount(GC::INTERNAL_CONSTANTS[:HEAP_PAGE_SIZE])
    HEAP_PAGE_ALIGN      = 1 << HEAP_PAGE_ALIGN_LOG      # 2 ^ 14 (or 16 on MacOS)
    HEAP_PAGE_ALIGN_MASK = ~(~0 << HEAP_PAGE_ALIGN_LOG)  # Mask for getting page address
    HEAP_PAGE_SIZE       = HEAP_PAGE_ALIGN               # Actual page size
    HEAP_PAGE_OBJ_LIMIT  = (HEAP_PAGE_SIZE - SIZEOF_PAGE_HEADER) / SIZEOF_RVALUE

  end
end
