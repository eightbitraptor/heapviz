require 'test_helper'
require 'heapviz/renderer'

module Heapviz
  class TestRenderer < Minitest::Test
    attr_accessor :renderer, :heap

    def setup
      self.heap = stub("heap", page_count: 1, max_page_size: 4)
      self.renderer = Renderer.new('output.png', heap)
    end

    def test_renders_pinned_slots_black
      slot = stub("slot", pinned?: true)

      assert(Renderer::BLACK, renderer.slot_colour(slot))
    end

    def test_renders_none_slots_white
      slot = stub("slot", pinned?: false, type: "NONE")

      assert(Renderer::WHITE, renderer.slot_colour(slot))
    end

    def test_renders_nil_white
      slot = nil

      assert(Renderer::WHITE, renderer.slot_colour(slot))
    end

    def test_renders_40_byte_slots
      slot = stub("slot", pinned?: false, type: "STRING", size: 40)

      assert(Renderer::COLORS[40], renderer.slot_colour(slot))
    end

    def test_renders_80_byte_slots
      slot = stub("slot", pinned?: false, type: "STRING", size: 80)

      assert(Renderer::COLORS[80], renderer.slot_colour(slot))
    end

    def test_renders_160_byte_slots
      slot = stub("slot", pinned?: false, type: "STRING", size: 160)

      assert(Renderer::COLORS[160], renderer.slot_colour(slot))
    end

    def test_renders_320_byte_slots
      slot = stub("slot", pinned?: false, type: "STRING", size: 320)

      assert(Renderer::COLORS[320], renderer.slot_colour(slot))
    end
  end
end
