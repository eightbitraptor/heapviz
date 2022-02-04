# Heapviz

**Warning: This probably shouldn't be used for anything important. It
requires patching and building a custom Ruby**

Produces a png of a json dump of the Ruby objspace. Heap dump images
are organised in rows and columns:

* A heap page is a vertical column 4 pixels wide
* A slot is a vertical chunk that is 4 pixels wide and
  (4*slot_size/sizeof(RVALUE)) tall. so 40 byte slots are 4x4 pixels,
  80 bytes slots are 4x8 pixels, 160 bytes are 4x16 pixels and so on.

## Running

This script requires a commit that recently landed on Ruby master to
add a `slot_size` field to the output of `ObjectSpace.dump_all`. Use
your Ruby version manager of choice to install the development release
of Ruby and then write a script that dumps the heap to a file.

```
require 'objspace'
ObjectSpace.dump_all(output: File.new("output.json", "w"))
```

Run it with Ruby

```
./ruby test.rb
```

Then run this script with your json output, and a filename of a png
to write to (the png doesn't need to exist)

```
../heapviz/exe/heapviz output.json output.png
open output.png
```
