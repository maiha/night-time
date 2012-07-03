require 'parsedate'

module NightTime
  module Calculate
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

    def mktime(*args)
      year, mon, day, hour, min, sec, usec = args
      extra = 0
      if hour.to_i >= 24 or min.to_i >= 60 or sec.to_i > 60
        hour, min, sec, extra = mod_midnight(hour, min, sec)
      end

      begin
        Time.mktime(year, mon, day, hour, min, sec, usec) + extra
      rescue ArgumentError
        if day < 28
          raise
        else
          extra += (day - 28) * 86400
          day = 28
          Time.mktime(year, mon, day, hour, min, sec, usec) + extra
        end
      end
    end

    def parse(text)
      mktime(*ParseDate.parsedate(text)[0,7])
    end
  end

  extend Calculate
end
