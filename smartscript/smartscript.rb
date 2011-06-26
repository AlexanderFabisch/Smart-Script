require "smartscript/shell_helper.rb"

# Smart Script enables fast script programming without any overhead.
class SmartScript
  include ShellHelper

  # Creats a new program with the given name. The name should equal the script
  # file name.
  def self.name name
    @@name = name
    @@debug = true
    @@dry = false
    @@usage = "usage: #{name} option\n\npossible options are:\n"
    @@hints = ""
    @@auto_completion = []
    @@auto_completion_arguments = {}
    Class.new self
  end

  # Turns detailed debug messages off, i. e. the trace and line is not visible.
  def self.no_debug
    @@debug = false
  end

  # Deactivates the execution of external commands.
  def self.dry_run
    @@dry = true
  end

  # Registers an option, i. e. the method will be added to this class, the usage
  # message will be updated and the auto completion tables will be updated.
  #
  # * A method_name should look like this: name argtype1 argtype2 ... argtypeN.
  # * The description can be any kind of text.
  # * The block will be executed when the user chooses this option.
  def self.register method_name, description, &block
    @@usage += "  #{method_name.ljust 30, "."}#{description}\n"
    command_with_args = method_name.split
    command = command_with_args[0]
    @@auto_completion << command_with_args[0]
    @@auto_completion_arguments[command_with_args[0]] = command_with_args[1..-1]
    define_method command_with_args[0], block
  end

  # Adds a hint to the usage message.
  def self.usage_hint hint
    @@hints += hint + "\n"
  end

  # Runs the script after all initializations were successful.
  def self.execute
    unless @@hints == ""
      @@usage += "\nhints:\n" + @@hints
    end
    begin
      program = self.new
      method = ARGV.delete_at(0)
      raise Exception.new("unknown option") unless program.public_methods.include? method
      program.store_dir
      option = program.method(method)
      if option.arity > 0 and ARGV.length != option.arity
        raise Exception.new("wrong number of arguments (#{ARGV.length} for #{option.arity})")
      end
      option.call(*ARGV)
    rescue Exception
      handle_exception program, $!
    end
  end

  # Returns the name of the script. This can be used in blocks.
  def name
    @@name
  end

  # Prints the usage message. This can be used in blocks.
  def print_usage
    puts @@usage
  end

  # A string of all possible options. Use split to get an array of all options.
  # This can be used in blocks.
  def options
    @@auto_completion.inject do |opts,opt|
      opts + " " + opt
    end
  end

  # An array of the argument types of a given option. This can be used in
  # blocks.
  def arguments command
    @@auto_completion_arguments[command]
  end

  # Remembers the current directory. It can be restored with restore_dir. This
  # can be used in blocks.
  def store_dir
    @dir = Dir.pwd
  end

  # Sets the working directory to the previously remembered directory.  This can
  # be used in blocks.
  def restore_dir
    cd @dir
  end

private

  def self.handle_exception instance, e
    instance.print_usage
    puts ""
    puts "error:"
    if @@debug
      raise e
    else
      puts "  " + e.message
    end
  end
end
