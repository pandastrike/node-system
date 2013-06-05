# Node System

Analog to Ruby's `system` method. Put another way, a sync version of `spawn`. Adapted from `[exec-sync][0]`.

[0]:https://github.com/jeremyfa/node-exec-sync

## Installation

    npm install node-system
    
## Usage

    system = require "node-system"
    readdir = -> system( "ls" ).split("\n")
    
## License

MIT

