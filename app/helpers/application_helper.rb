module ApplicationHelper
  ALERT_CLASSES = {
    "success" => "border-green-200 text-green-900 bg-green-50",
    "error" => "border-red-200 text-red-900 bg-red-50",
    "alert" => "border-yellow-200 text-yellow-900 bg-yellow-50",
    "notice" => "border-blue-200 text-blue-800 bg-blue-50",
  }.freeze

  def alert_classes_for(flash_type)
    ALERT_CLASSES.fetch(flash_type)
  end

  def buildless_module(name)
    url = BuildlessCache.modules[name]

    raise "module '#{name}' not found" unless url

    %(<script type="module-shim" src="#{url}"></script>).html_safe
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

  def link_back(title, options = {if: true, else: nil})
    url = options.delete(:if) ? url_for(:back) : options.delete(:else)

    link_to title, url, options
  end

  LONG_RATINGS = {
    "G" => "General audiences",
    "PG" => "Parental guidance suggested",
    "PG-13" => "Parents strongly cautioned",
    "R" => "Restricted",
    "NC-17" => "No one 17 and under admitted",
  }.freeze

  def long_rating(rating)
    LONG_RATINGS[rating]
  end

  def tab(path, label)
    activeClasses =
      if current_page?(path)
        'border-b-2 text-gray-800 font-medium border-gray-800 pointer-events-none'
      else
        'text-gray-500 hover:text-gray-800'
      end

      %(<a href="#{path}" class="py-4 px-6 focus:outline-none #{activeClasses}">#{label}</a>).html_safe
  end

  def h1(content)
    %(<h1 class="text-4xl font-medium mb-5">#{content}</h1>).html_safe
  end

  def link_button(label, path, options)
    link_to label, path, options.merge(class: "rounded p-3 text-white bg-red-600 hover:bg-red-700 hover:text-white hover:no-underline")
  end
end
