# -*- coding: utf-8 -*-
require 'nkf'

module NightTime
  class Jst
    class Build < RuntimeError
      attr_accessor :year,:month,:day,:hour,:min,:sec
      def date?; month and day; end
      def time?; hour and min; end
      def full?; date? and time?; end
      def to_array; [year, month, day, hour, min, sec]; end
      def to_time; NightTime.mktime(year, month, day, hour||0, min||0, sec||0); end
      def inspect; "<Build: %s>" % [year,month,day,hour,min,sec].inspect; end
    end

    def initialize(text)
      @text  = NKF.nkf('-Wwxm0Z0', text).gsub(/\s+/m,'').strip
      @build = Build.new
    end

    def parsedate
      build!
      @build.to_array
    end

    def parse
      parsedate
    end

    def time(now = nil)
      unless now
        now = Time.now
        now = Time.mktime(now.year, now.month, now.day)
      end

      build!
      b = @build.dup
      b.year  ||= now.year
      b.month ||= now.month
      b.day   ||= now.day
      b.hour  ||= now.hour
      b.min   ||= now.min
      b.sec   ||= now.sec
      return b.to_time
    end
    
    def parse!
      build!
      
      if @build.full?
        return @build.to_time
      elsif @build.date?
        build = @build.dup
        build.year ||= Time.now.year
        return build.to_time
      else
        return nil
      end
    end

    private
      def build!
        catch(:completed) {
          parse_nengappi
          parse_gappi
          parse_jifunbyou
          parse_jifun
          parse_month_slash_day
          parse_hour_colon_min
        }
      end

      def parse_nengappi
        @text.scan(/(\d{4})年(\d{1,2})月(\d{1,2})日/) {
          @build.year  ||= $1.to_i
          @build.month ||= $2.to_i
          @build.day   ||= $3.to_i
          return validate!
        }
      end

      def parse_gappi
        @text.scan(/(\d{1,2})月(\d{1,2})日/) {
          @build.month ||= $1.to_i
          @build.day   ||= $2.to_i
          return validate!
        }
      end

      def parse_month_slash_day
        @text.scan(/(\d{1,2})\/(\d{1,2})/) {
          @build.month ||= $1.to_i
          @build.day   ||= $2.to_i
          return validate!
        }
      end

      def parse_jifunbyou
        @text.scan(/(夜)?(\d{1,2})時(\d{1,2})分(\d{1,2})秒/) {
          hour_margin = ($1 and $2.to_i < 5) ? 24 : 0
          @build.hour ||= hour_margin + $2.to_i
          @build.min  ||= $3.to_i
          @build.sec  ||= $4.to_i
          return validate!
        }
      end

      def parse_jifun
        @text.scan(/(夜)?(\d{1,2})時(\d{1,2})分/) {
          hour_margin = ($1 and $2.to_i < 5) ? 24 : 0
          @build.hour ||= hour_margin + $2.to_i
          @build.min  ||= $3.to_i
          return validate!
        }
      end

      def parse_hour_colon_min
        @text.scan(/(夜)?(\d{1,2}):(\d{1,2})/) {
          hour_margin = ($1 and $2.to_i < 5) ? 24 : 0
          @build.hour ||= hour_margin + $2.to_i
          @build.min  ||= $3.to_i
          return validate!
        }
      end

      def validate!
        throw(:completed) if @build.full?
      end
    end
end
  
