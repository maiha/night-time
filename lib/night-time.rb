require 'parsedate'

module NightTime
  def parse(text)
    raise NotImplementedError
  end
end

Time.extend NightTime
