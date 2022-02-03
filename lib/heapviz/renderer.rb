require 'chunky_png'

module Heapviz
  class Renderer
    SLOT_BASE_SIZE = 4
    COLORS = [
      ChunkyPNG::Color.rgba(104, 195, 163, 255),
      ChunkyPNG::Color.rgba(27, 163, 156, 255),
      ChunkyPNG::Color.rgba(200, 247, 197, 255),
      ChunkyPNG::Color.rgba(22, 160, 133, 255),
    ]
    WHITE = ChunkyPNG::Color.rgba(255, 255, 255, 255);

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
        COLORS[(slot.size / Heap::SIZEOF_RVALUE) - 1]
      else
        WHITE
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
