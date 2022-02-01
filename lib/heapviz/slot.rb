require 'json'

module Heapviz
  class Slot
    include Comparable

    attr_reader :type, :address, :flags, :size, :page_body_address

    def initialize(json)
      attrs = JSON.parse(json)

      @type = attrs.fetch("type")

      if !gc_root?
        begin
          @address  = attrs.fetch("address").to_i(16)
          @size     = attrs.fetch("slot_size")
          @flags    = attrs.fetch("flags")
        rescue 
          p attrs
          p "we got here"
        end
      end

      @page_body_address = @address & ~Heapviz::Heap::HEAP_PAGE_ALIGN_MASK
    end

    def gc_root?
      @type == "ROOT"
    end

    def <=>(o)
      addr_i <=> o.addr_i
    end
  end
end
