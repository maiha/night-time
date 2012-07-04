# -*- coding: utf-8 -*-
require 'nkf'

module NightTime
  class Jst
    def self.parse(text, now = nil)
      new(text).time(now)
    end

    class Build < RuntimeError
      attr_accessor :year,:month,:day,:hour,:min,:sec
      def date?; month and day; end
      def time?; hour and min; end
      def full?; date? and time?; end
      def to_a; [year, month, day, hour, min, sec]; end
      def to_time; NightTime.mktime(year, month, day, hour||0, min||0, sec||0); end
      def inspect; "<Build: %s>" % [year,month,day,hour,min,sec].inspect; end
    end

    class Changed   < RuntimeError; end
    class Completed < RuntimeError; end

    def initialize(text)
      @text  = NKF.nkf('-Wwxm0Z0', text).gsub(/\s+/m,' ').strip
      @build = Build.new
      @trace = []
    end

    def trace
      build!
      return @trace
    end

    def parse
      build!
      @build.to_a
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
        try :parse_nengappi
        try :parse_gappi
        try :parse_iso8601
        try :parse_jifunbyou
        try :parse_jifun
        try :parse_month_slash_day
        try :parse_hour_colon_min
      rescue Completed
      end

      def parse_nengappi
        @text.scan(/(\d{4})\s*年\s*(\d{1,2})\s*月\s*(\d{1,2})\s*日/) {
          return observe {
            @build.year  ||= $1.to_i
            @build.month ||= $2.to_i
            @build.day   ||= $3.to_i
          }
        }
      end

      def parse_gappi
        @text.scan(/(\d{1,2})\s*月\s*(\d{1,2})\s*日/) {
          return observe {
            @build.month ||= $1.to_i
            @build.day   ||= $2.to_i
          }
        }
      end

      def parse_iso8601
        @text.scan(/(?:^|[^\d\/])(\d{4})[-\/](\d{1,2})[-\/](\d{1,2})($|[^\d\/])/) {
          (1..12).include?($2.to_i) or return false
          (1..31).include?($3.to_i) or return false
          return observe {
            @build.year  ||= $1.to_i
            @build.month ||= $2.to_i
            @build.day   ||= $3.to_i
          }
        }
      end

      def parse_month_slash_day
        @text.scan(/(?:^|[^\d\/])(\d{1,2})\/(\d{1,2})($|[^\d\/])/) {
          (1..12).include?($1.to_i) or return false
          (1..31).include?($2.to_i) or return false
          return observe {
            @build.month ||= $1.to_i
            @build.day   ||= $2.to_i
          }
        }
      end

      def parse_jifunbyou
        @text.scan(/(夜)?\s*(\d{1,2})\s*時\s*(\d{1,2})\s*分\s*(\d{1,2})秒/) {
          return observe {
            hour_margin = ($1 and $2.to_i < 5) ? 24 : 0
            @build.hour ||= hour_margin + $2.to_i
            @build.min  ||= $3.to_i
            @build.sec  ||= $4.to_i
          }
        }
      end

      def parse_jifun
        @text.scan(/(夜)?\s*(\d{1,2})\s*時\s*(\d{1,2})\s*分/) {
          return observe {
            hour_margin = ($1 and $2.to_i < 5) ? 24 : 0
            @build.hour ||= hour_margin + $2.to_i
            @build.min  ||= $3.to_i
          }
        }
      end

      def parse_hour_colon_min
        @text.scan(/(夜)?\s*(\d{1,2}):(\d{1,2})/) {
          return observe {
            hour_margin = ($1 and $2.to_i < 5) ? 24 : 0
            @build.hour ||= hour_margin + $2.to_i
            @build.min  ||= $3.to_i
          }
        }
      end

      def try(method)
        __send__(method)
      rescue Changed
        @trace << method
        validate!
      end

      def observe(&block)
        a1 = @build.to_a
        block.call
        a2 = @build.to_a        
        raise Changed if a1 != a2
      end

      def validate!
        raise Completed if @build.full?
      end
    end
end
  
