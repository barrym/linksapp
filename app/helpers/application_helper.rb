module ApplicationHelper

  def error_on(model, attribute)
    !model.errors[attribute].blank?
  end

  def errors_for(model, attribute)
    model.errors[attribute].join(", ").capitalize
  end

end
