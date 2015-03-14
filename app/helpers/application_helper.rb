module ApplicationHelper
  ALERT_CLASSES = ActiveSupport::HashWithIndifferentAccess.new(
    success: "alert-success",
    error: "alert-danger",
    alert: "alert-warning",
    notice: "alert-info",
  ).freeze

  def alert_class_for(flash_type)
    ALERT_CLASSES[flash_type] || flash_type
  end
end
