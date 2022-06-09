require 'json'
require 'heapviz/heap'

module Heapviz
  class Slot
    include Comparable

    attr_reader :type, :address, :flags, :size, :page_body_address

    def initialize(json)
      attrs = JSON.parse(json)

      @type = attrs.fetch("type")
      if !gc_root?
          @address  = attrs.fetch("address").to_i(16)
          @size     = attrs.fetch("slot_size")
      end
      @flags    = attrs.fetch("flags", {})

      @page_body_address = @address & ~Heap::HEAP_PAGE_ALIGN_MASK
    end

    def gc_root?
      @type == "ROOT"
    end

    def pinned?
      @flags.fetch('pinned', false)
    end

    def has_flags?
      !gc_root?
    end

    def <=>(o)
      address <=> o.address
    end

    def to_s
      "{address: 0x#{address.to_s(16)}, type: #{type}, flags: #{flags}}"
    end
  end
end
