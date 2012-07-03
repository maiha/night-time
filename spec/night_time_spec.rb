
require File.join(File.dirname(__FILE__), 'spec_helper.rb')

describe NightTime do
  describe ".mktime" do
    it "should treat late night time" do
      NightTime.mktime(2010,1,10,26,40).should == Time.mktime(2010,1,11,2,40)
    end

    it "should treat date overflow" do
      NightTime.mktime(2010,2,33).should == Time.mktime(2010,3,5)
    end

    it "should treat valid time too" do
      NightTime.mktime(2010,1,10, 2,40).should == Time.mktime(2010,1,10,2,40)
    end
  end

  it "should provide .parse" do
    NightTime.should respond_to(:parse)
  end

  describe ".parse" do
    it "should parse late night time" do
      NightTime.parse('2010-01-10 26:40').should == Time.mktime(2010,1,11,2,40)
    end

    it "should treat valid time too" do
      NightTime.parse('2010-01-10 02:40').should == Time.mktime(2010,1,10,2,40)
    end
  end
end
