module ApplicationHelper

  def pretty_date(time)
    time.strftime "%e %b %A"
  end

end
