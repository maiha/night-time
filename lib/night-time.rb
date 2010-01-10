require 'parsedate'

class Time
  class << self
    def mod_midnight(hour, min, sec)
      extra = 0

      squeeze = lambda{|val, max, unit, extra|
        num, new_val = val.divmod(max)
        [new_val, extra + max*num*unit]
      }
      sec , extra = squeeze.call(sec.to_i , 60, 1    , extra)
      min , extra = squeeze.call(min.to_i , 60, 60   , extra)
      hour, extra = squeeze.call(hour.to_i, 24, 60*60, extra)

      return [hour, min, sec, extra]
    end


    alias mktime_without_night_time mktime

    def mktime(*args)
      year, mon, day, hour, min, sec, usec = args
      extra = 0
      if hour.to_i >= 24 or min.to_i >= 60 or sec.to_i > 60
        hour, min, sec, extra = mod_midnight(hour, min, sec)
      end
      mktime_without_night_time(year, mon, day, hour, min, sec, usec) + extra
    end

    unless respond_to?(:parse)
      def parse(text)
        Time.mktime(*ParseDate.parsedate(text)[0,7])
      end
    end
  end
end
