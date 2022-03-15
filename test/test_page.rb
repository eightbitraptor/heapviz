require 'test_helper'
require 'heapviz/page'

module Heapviz
  class TestPage < Minitest::Test
    attr_accessor :page, :address, :obj_start_address, :capacity, :slot_size

    def setup
      self.address = 123
      self.obj_start_address = 234
      self.capacity = 5
      self.slot_size = 40

      self.page = Page.new(address, obj_start_address, capacity, slot_size)
    end

    def test_slot_size_mismatch
      slot = stub("slot", size: 160)

      err = assert_raises(StandardError) do
        self.page.fill_slot(slot)
      end
      assert_equal("slot size mismatch", err.message)
    end

    def test_full
      5.times do 
        self.page.fill_slot(stub("slot", size: self.page.slot_size))
      end

      assert(self.page.full?)
    end

    def test_iterating_slots
      slot1 = stub("slot", size: self.page.slot_size, address: 234)
      slot2 = stub("slot", size: self.page.slot_size, address: 274)
      slot3 = stub("slot", size: self.page.slot_size, address: 394)

      page.stubs(:sorted_objects).returns([slot1, slot2, slot3])
      address_ordered_slots = self.page.each_slot.to_a 

      assert_equal([slot1, slot2, nil, nil, slot3], address_ordered_slots)
    end
  end
end
