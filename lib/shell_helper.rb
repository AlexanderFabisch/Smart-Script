module ShellHelper
  @@dry = false

  # The text will be printed in this color, if you print it in the shell.
  { "black"       => "0;30",
    "red"         => "0;31",
    "green"       => "0;32",
    "brown"       => "0;33",
    "blue"        => "0;34",
    "purple"      => "0;35",
    "cyan"        => "0;36",
    "lightgray"   => "0;37",
    "darkgray"    => "1;30",
    "lightred"    => "1;31",
    "lightgreen"  => "1;32",
    "yellow"      => "1;33",
    "lightblue"   => "1;34",
    "lightpurple" => "1;35",
    "lightcyan"   => "1;36",
    "white"       => "1;37"
  }.each do |color, code|
    define_method color do |text|
      "\033[#{code}m#{text}\033[00m"
    end
  end

  # Prints red "FAILED" in verbose mode and returns false.
  def failed verbose = true
    puts "[" + red("FAILED") + "]" if verbose
    false
  end

  # Prints green "DONE" in verbose mode and returns true.
  def done verbose = true
    puts "[ " + green("DONE") + " ]" if verbose
    true
  end

  # Prints a description in verbose mode.
  def describe description, verbose = true
    puts blue(description) if verbose
  end

  # Make a command start as background process.
  def background cmd
    cmd + " &"
  end

  # Suppress the standard output of a command.
  def suppress_stdout cmd
    cmd + " > /dev/null"
  end

  # Executes a command in a shell. If there is no description, everything will
  # be done in non-verbose mode. The standard description is "Executing". If
  # this is a dry run, nothing will be executed. The command will be printed on
  # stdout.
  def execute cmd, description = "Executing"
    verbose = description != ""
    describe description, verbose
    if @@dry
      puts cmd
      true
    else
      if system cmd
        done verbose
      else
        failed verbose
      end
    end
  end

  # Changes the working directory.
  def cd dir
    Dir.chdir dir
  end

end

