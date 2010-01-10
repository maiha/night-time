
require File.join(File.dirname(__FILE__), 'spec_helper.rb')

describe Time do
  describe ".mktime" do
    it "should treat late night time" do
      Time.mktime(2010,1,10,26,40).should == Time.mktime(2010,1,11,2,40)
    end

    it "should treat valid time too" do
      Time.mktime(2010,1,10, 2,40).should == Time.mktime(2010,1,10,2,40)
    end
  end

  it "should provide .parse" do
    Time.should respond_to(:parse)
  end

  describe ".parse" do
    it "should parse late night time" do
      Time.parse('2010-01-10 26:40').should == Time.mktime(2010,1,11,2,40)
    end

    it "should treat valid time too" do
      Time.parse('2010-01-10 02:40').should == Time.mktime(2010,1,10,2,40)
    end
  end
end
