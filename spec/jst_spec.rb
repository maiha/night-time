# -*- coding: utf-8 -*-

require File.join(File.dirname(__FILE__), 'spec_helper.rb')

describe NightTime::Jst do
  describe ".parse" do
    it "should return a time object" do
      NightTime::Jst.parse("2012/7/3 11:30").should == Time.mktime(2012,7,3,11,30)
    end
  end

  describe ".parsedate" do
    it "should return an Array" do
      NightTime::Jst.parsedate("2012/7/3 11:30").should == [2012, 7, 3, 11, 30, nil]
    end
  end
end

describe NightTime::Jst do
  let(:year ) { Time.now.year  }
  let(:month) { Time.now.month }
  let(:day  ) { Time.now.day   }
  subject { NightTime::Jst.new(text) }

  context "(YYYY-MM-DD)" do
    let(:text ) { "1994-04-12" }
    its(:parse) { should == [1994,4,12,nil,nil,nil] }
    its(:time ) { should == Time.mktime(1994,4,12) }
  end

  context "(XXXX/X/X)" do
    let(:text ) { "2012/7/3" }
    its(:parse) { should == [2012,7,3,nil,nil,nil] }
    its(:time ) { should == Time.mktime(2012,7,3) }
  end

  context "(X/X)" do
    let(:text ) { "7/3" }
    its(:parse) { should == [nil,7,3,nil,nil,nil] }
    its(:time ) { should == Time.mktime(2012,7,3) }
  end

  context "(XX月XX日)[半角]" do
    let(:text ) { "テレビ7月8日(土)24:30～25:00" }
    its(:parse) { should == [nil,7,8,24,30,nil] }
    its(:time ) { should == Time.mktime(year,7,9,0,30) }
  end

  context "(XX月XX日)[全角]" do
    let(:text ) { "テレビ ７月８日（土）２４：３０～２５：００" }
    its(:parse) { should == [nil,7,8,24,30,nil] }
    its(:time ) { should == Time.mktime(year,7,9,0,30) }
  end

  context "(XX年XX月XX日XX時XX分)" do
    let(:text ) { "日テレ　2012年7月8日（日）12時45分～13時55分(1)水中を走る車" }
    its(:parse) { should == [2012,7,8,12,45,nil] }
    its(:time ) { should == Time.mktime(2012,7,8,12,45) }
  end

  context "(XX年XX月XX日26時XX分)" do
    let(:text ) { "TBSチャンネルHD 2012年7月6日（金）  26時55分～27時25分" }
    its(:parse) { should == [2012,7,6,26,55,nil] }
    its(:time ) { should == Time.mktime(2012,7,7,2,55) }
  end

  context "(X月X日X時夜XX分XX秒)" do
    let(:text ) { "【#65】7月2日(月)深夜3時33分22秒～【#66】7月3日(火)" }
    its(:parse) { should == [nil, 7, 2, 27, 33, 22] }
    its(:time ) { should == Time.mktime(year,7,3,3,33,22) }
  end

  context "(XX年XX月XX日XX:XX)" do
    let(:text ) { "日テレ7月9日(月)19:00～20:54ＭＣ" }
    its(:parse) { should == [nil, 7, 9, 19, 0, nil] }
    its(:time ) { should == Time.mktime(year,7,9,19) }
  end

  context "(XX年XX月XX日 夜XX:XX)" do
    let(:text ) { "XXX7/14(土)夜0:15-1:45 NHK" }
    its(:parse) { should == [nil, 7, 14, 24, 15, nil] }
    its(:time ) { should == Time.mktime(year,7,15,0,15) }
  end

  context "(XX:XX)" do
    let(:text ) { "隔週木曜23:30-24:00" }
    its(:parse) { should == [nil, nil, nil, 23, 30, nil] }
    its(:time ) { should == Time.mktime(year,month,day,23,30) }
  end

  ######################################################################
  ### ignore range error

  context "(13/X)" do
    let(:text ) { "13/3" }
    its(:parse) { should == [nil,nil,nil,nil,nil,nil] }
  end

  context "(X/32)" do
    let(:text ) { "1/32" }
    its(:parse) { should == [nil,nil,nil,nil,nil,nil] }
  end

  context "(0/X)" do
    let(:text ) { "0/1" }
    its(:parse) { should == [nil,nil,nil,nil,nil,nil] }
  end

  context "(X/0)" do
    let(:text ) { "1/0" }
    its(:parse) { should == [nil,nil,nil,nil,nil,nil] }
  end

  context "(XXXX/0/X)" do
    let(:text ) { "2012/0/3" }
    its(:parse) { should == [nil,nil,nil,nil,nil,nil] }
  end

  context "(XXXX/X/0)" do
    let(:text ) { "2012/1/0" }
    its(:parse) { should == [nil,nil,nil,nil,nil,nil] }
  end

  context "(XXXX/13/X)" do
    let(:text ) { "2012/13/1" }
    its(:parse) { should == [nil,nil,nil,nil,nil,nil] }
  end

  context "(XXXX/X/32)" do
    let(:text ) { "2012/1/32" }
    its(:parse) { should == [nil,nil,nil,nil,nil,nil] }
  end

  context "(YYYYY/MM/DD)" do
    let(:text ) { "11994-04-12" }
    its(:parse) { should == [nil,nil,nil,nil,nil,nil] }
  end

  ######################################################################
  ### ambiguous value

  context "(2012/1/1/1)" do
    let(:text ) { "2012/1/1/1" }
    its(:parse) { should == [nil,nil,nil,nil,nil,nil] }
  end

  context "(1/1/1)" do
    let(:text ) { "1/1/1" }
    its(:parse) { should == [nil,nil,nil,nil,nil,nil] }
  end

end
