# Adapted from git://github.com/jeremyfa/node-exec-sync.git

FFI = require "ffi"
libc = new FFI.Library null, "system": ["int32", ["string"]]
fs = require "fs"

# Generate a pseudo-unique identifier
uniqIdK = 0
uniqId = ->
    prefix = 'tmp'
    prefix + (new Date()).getTime() + '' + (uniqIdK++) + ('' + Math.random()).split('.').join('')

# Retrieve temporary writable directory
tmpDir = ->
    for name in ['TMPDIR', 'TMP', 'TEMP']
        if process.env[name]?
            dir = process.env[name]
            if dir.charAt(dir.length-1) is '/' then return dir.substr(0, dir.length-1)
            return dir
    return '/tmp' # Fallback to the default

getOutput = (path) ->
    output = fs.readFileSync path
    fs.unlinkSync path
    output = "#{output}"
    if output.charAt(output.length-1) is "\n" then output = output.substr(0,output.length-1)
    return output

# execSync implementation
module.exports = (cmd) ->
    id = uniqId()
    stdout = id+'.stdout'
    stderr = id+'.stderr'
    dir = tmpDir()
    cmd = "#{cmd} > #{dir}/#{stdout} 2> #{dir}/#{stderr}"
    status = libc.system cmd
    result = getOutput "#{dir}/#{stdout}"
    error = getOutput "#{dir}/#{stderr}"
    if status is 0
      return result
    else
      error = if error is ""
        "Process exited with status #{status}" 
      else 
        error
      throw new Error error
