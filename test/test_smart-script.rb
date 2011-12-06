require 'helper'

class TestSmartScript < Test::Unit::TestCase
  should "have the correct name" do
    MyScript = SmartScript.name "correct_name"
    my_script = MyScript.new
    assert_equal "correct_name", my_script.name
  end
end
