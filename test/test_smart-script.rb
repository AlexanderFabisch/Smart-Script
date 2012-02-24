require 'helper'

class TestSmartScript < Test::Unit::TestCase
  context "smart-script" do
    setup do
      @my_script_class = SmartScript.name "correct_name"
      @my_script_class.register "known_option", "description" do "found_known_option" end
      @my_script = @my_script_class.new
      ARGV.clear
    end

    should "have the correct name" do
      assert_equal "correct_name", @my_script.name
    end

    should "complain about missing option" do
      assert_raise Exception do
        @my_script_class.execute
      end
    end

    should "complain about unknown option" do
      ARGV << "unkown_option"
      assert_raise Exception do
        @my_script_class.execute
      end
    end

    should "invoke known method" do
      ARGV << "known_option"
      assert_equal "found_known_option", @my_script_class.execute
    end
  end
end
