module Heapviz
  class Page
    attr_reader :live_objects, :slot_size, :address

    def initialize(address, obj_start_address, capacity, slot_size)
      @address = address
      @obj_start_address = obj_start_address
      @capacity = capacity
      @slot_size = slot_size

      @live_objects = []
    end

    def fill_slot(slot)
      fail "slot size mismatch" if slot.size != @slot_size
      @live_objects << slot
    end

    def each_slot
      return enum_for(:each_slot) unless block_given?

      objs = sorted_objects

      @capacity.times do |i|
        expected = @obj_start_address + (i * slot_size)
        if objs.any? && objs.first.address == expected
          yield objs.shift
        else
          yield nil
        end
      end
    end

    def sorted_objects
      @live_objects.sort
    end

    def full?
      @live_objects.count == @capacity
    end

    def pinned_count
      @pinned_count ||= live_objects.find_all { |lo| lo.dig("flags", "pinned") }.count
    end

    def live_object_count
      @live_objects.count
    end

    def fragmented?
      !full?
    end

    def to_s
      "{page: #{address.to_s(16)}, slot_size: #{slot_size}, full: #{full?}}"
    end
  end
end
