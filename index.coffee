# Adapted from git://github.com/jeremyfa/node-exec-sync.git
{rm,read} = require "fairmont"
{tmpDir} = require "os"
{join} = require "path"

FFI = require "ffi"
libc = new FFI.Library null, "system": ["int32", ["string"]]

getOutput = (path) ->
  output = read( path ).trim()
  rm( path )
  output

# execSync implementation
module.exports = (cmd) ->
  {pid} = process
  dir = tmpDir()
  stdout = join( dir, "#{pid}.stdout" )
  stderr = join( dir, "#{pid}.stderr" )
  cmd = "#{cmd} > #{stdout} 2> #{stderr}"
  status = libc.system( cmd )
  result = getOutput( stdout )
  error = getOutput( stderr )
  if status != 0
    error ?= "Process exited with status #{status}"
    throw new Error( error )
  else
    result
