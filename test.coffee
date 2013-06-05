system = require "./index"

console.log system "ls -l ."

try
  console.log system "ls -l foo"
catch e
  console.log e.message
  
readdir = -> system( "ls" ).split("\n")

console.log readdir()