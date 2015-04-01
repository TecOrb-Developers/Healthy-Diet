module InterventionsHelper
  def intervention_image intervention
    image = (intervention.image.url == "/intervention_images/placeholder_name") ? (image_path "intervention/#{intervention.name}.png") : intervention.image.url
    return image
  end
end
