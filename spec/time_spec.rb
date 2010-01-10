
require File.join(File.dirname(__FILE__), 'spec_helper.rb')

describe Time do
  describe ".mktime" do
    it do
      Time.mktime(2010,1,10,26,40).should == Time.mktime(2010,1,11,2,40)
    end
  end

  it do
    Time.should respond_to(:parse)
  end

  describe ".parse" do
    Time.parse('2010-01-10 26:40').should == Time.mktime(2010,1,11,2,40)
  end
end
