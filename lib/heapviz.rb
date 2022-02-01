require 'fiddle'
require 'debug'

module Heapviz
  def self.shiftcount(n)
    x = 0
    while n > 1
      x += 1
      n >>= 1
    end
    x
  end
end

require 'heapviz/heap'
require 'heapviz/page'
require 'heapviz/slot'
require 'heapviz/renderer'
