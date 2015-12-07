module ApplicationHelper

  def placeholder(args={})  # used for prototyping and putting image-like blocks on the screen
    defaults = {width: 300, height: 200, text: "Placeholder"}  # D = defaults
    defaults.merge!(args) 
    x = defaults
    url = image_path "placeholder.gif"
    render inline: %Q{<div style="width:#{x[:width]}px;height:#{x[:height]}px;position:relative;border:1px solid #000;text-align:center">
    <img src="#{url}" style="width:100%;height:100%">
    <span style="position:absolute;left:0;bottom:0;width:100%">#{x[:text]}</span>
   </div>}.html_safe
  end

  def m(string)  # <%= m post.content %>  When using content that has lightweight markup
    if string.is_a?(String)
      string.gsub!("\\r","\r") # normalize on \r
      string.gsub!("\r","\r\n\r\n") # replace single spacing with double spacing because that is expected by RDiscount
      RDiscount.new(string,:filter_html).to_html.html_safe
    else
      ""
    end
  end

  def c(a_string)  # counts the spaces (words) in a string.  Approx
    a_string.is_a?(String) ? a_string.count(' ') : 0
  end

  def back_button
    link_to '< Back', :back 
  end

  def show_instance(instance)
    url = url_for controller: params[:controller], action: :show_admin, id: instance.id 
    "window.location='" + url + "'"
  end

end

