require 'test_helper'
require 'heapviz/slot'

module Heapviz
  class SlotTest < Minitest::Test
    def setup
      self.slot = Slot.new(slot_json)
    end

    def test_address
      assert_equal("0x106b2fd20".to_i(16), self.slot.address)
    end

    def test_type
      assert_equal("ICLASS", self.slot.type)
    end

    def test_flags
      assert_equal(true, self.slot.flags["wb_protected"])
      assert_equal(true, self.slot.flags["old"])
      assert_equal(true, self.slot.flags["uncollectible"])
      assert_equal(true, self.slot.flags["marked"])
    end

    def test_size
      assert_equal(160, self.slot.size)
    end

    def test_page_body_address
      assert_equal(4407296000, self.slot.page_body_address)
    end

    def test_gc_root
      refute(self.slot.gc_root?)

      root = Slot.new({type: "ROOT", address: "0x001", slot_size: 40}.to_json)
      assert(root.gc_root?)
    end

    def test_pinned
      refute(self.slot.pinned?)

      slot1 = Slot.new({type: "ROOT", address: "0x001", 
                        slot_size: 40, flags: {pinned: true}}.to_json)
      assert(slot1.pinned?)
    end

    def has_flags?
      assert(self.slot.has_flags?)

      root = Slot.new({type: "ROOT", address: "0x001", slot_size: 40}.to_json)
      refute(root.has_flags?)
    end

    def test_comparable
      slot1 = Slot.new({type: "STRING", address: "0x001", slot_size: 40}.to_json)
      slot2 = Slot.new({type: "STRING", address: "0x002", slot_size: 40}.to_json)
      slot3 = Slot.new({type: "STRING", address: "0xfff", slot_size: 40}.to_json)

      assert(slot1 < slot2 && slot2 < slot3)
    end

    private
    attr_accessor :slot

    def slot_json
      '{"address":"0x106b2fd20", "type":"ICLASS", "slot_size":160, "class":"0x106b2ff00", "superclass":"0x106b0fa20", "references":["0x106b0fa20"], "memsize":160, "flags":{"wb_protected":true, "old":true, "uncollectible":true, "marked":true}}'
    end
  end
end
