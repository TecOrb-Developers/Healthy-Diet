class ApplicationModel < ActiveRecord::Base
  self.abstract_class = true
  include ApplicationHelper
  include ApplicationValidators

  def self.id_for(name)  # used for seeds.  
  	self.where(name: name).first.id
  end
  def self.find_one(name)  # used for seeds.  
    self.where(name: name).first
  end

  def display_name
       name || id
  end

end
