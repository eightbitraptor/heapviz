require 'chunky_png'

module Heapviz
  class Renderer
    SLOT_BASE_SIZE = 4
    COLORS = {
      40 => ChunkyPNG::Color.rgba(104, 195, 163, 255),
      80 => ChunkyPNG::Color.rgba(27, 163, 156, 255),
      160 => ChunkyPNG::Color.rgba(200, 247, 197, 255),
      320 => ChunkyPNG::Color.rgba(22, 160, 133, 255),
    }
    WHITE = ChunkyPNG::Color.rgba(255, 255, 255, 255);
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
      return WHITE unless slot

      if slot.pinned?
        BLACK
      elsif slot.type == "NONE"
        WHITE
      else
        COLORS[slot.size]
      end
    end

    def render_page(page, x)
      # The height of each slot will be scaled up depending on the
      # slot size of the page. Slot size is a multiple of rvalue size
      # right now
      adjusted_height = SLOT_BASE_SIZE * (page.slot_size / Heap::SIZEOF_RVALUE)

      $stderr.puts "#{page}"
      page.each_slot.with_index do |slot, y|
        $stderr.puts "\t=> #{slot}"
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
