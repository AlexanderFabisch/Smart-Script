#!/usr/bin/ruby

require "smartscript/smartscript.rb"

SScript = SmartScript.name "sscript"
SScript.no_debug

SScript.usage_hint "Add some hints to the usage message..."

SScript.register "hello_world", "Prints \"Hello world!\"." do
  puts "Hello world!"
end

SScript.register "cmd command", "Executes command in shell." do |command|
  execute command
end

SScript.register "some_cd", "Changes and prints working directories." do
  execute "pwd", "Current directory"
  cd ".."
  execute "pwd", "Current directory"
  restore_dir
  execute "pwd", "Current directory"
  cd ".."
  execute "pwd", "Current directory"
  store_dir
  cd ".."
  execute "pwd", "Current directory"
  restore_dir
  execute "pwd", "Current directory"
end

SScript.execute
