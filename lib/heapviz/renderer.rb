require 'chunky_png'

module Heapviz
  class Renderer
    SLOT_BASE_SIZE = 4
    GREEN = ChunkyPNG::Color.rgba(0, 255, 0, 255);
    RED   = ChunkyPNG::Color.rgba(255, 0, 0, 255);
    BLACK = ChunkyPNG::Color.rgba(0, 0, 0, 255);

    def initialize(op_path, heap)
      @op_path = op_path
      @heap = heap
      @img = ChunkyPNG::Image.new(
        heap.page_count * SLOT_BASE_SIZE,
        heap.max_page_size * SLOT_BASE_SIZE
      )
    end

    def render
      @heap.pages.each_with_index do |page, i|
        start_i = i * SLOT_BASE_SIZE
        render_page(page, start_i)
      end

      @img.save(@op_path, interlace: true)
    end

    def slot_colour(slot)
      if slot
        slot.pinned? ? RED : GREEN
      else
        BLACK
      end
    end

    def render_page(page, x)
      # The height of each slot will be scaled up depending on the
      # slot size of the page. Slot size is a multiple of rvalue size
      # right now
      adjusted_height = SLOT_BASE_SIZE * (page.slot_size / Heap::SIZEOF_RVALUE)

      page.each_slot.with_index do |slot, y|
        y = y * adjusted_height

        adjusted_height.times do |y_offset|
          SLOT_BASE_SIZE.times do |x_offset|
            @img[x + x_offset, y + y_offset] = slot_colour(slot)
          end
        end
      end
    end
  end
end
