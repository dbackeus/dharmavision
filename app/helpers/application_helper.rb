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

  def gravatar_url(email)
    hash = Digest::MD5.hexdigest(email)
    "https://www.gravatar.com/avatar/#{hash}"
  end

  def admin?
    user_signed_in? && current_user.admin?
  end

  def page_title(page_title = nil)
    @page_title = page_title if page_title

    @page_title || "Dharmavision"
  end

  def link_back_or(title, default_path, options = {})
    url = request.referer.to_s.include?(ENV.fetch("HOST")) ? url_for(:back) : default_path

    link_to title, url, options
  end
end
