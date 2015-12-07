module ApplicationValidators

 class EmailValidator < ActiveModel::EachValidator  # used in models as:  validates :useremail, email: true
  def validate_each(record, attribute, value)
    if value && value =~ /\A([^@\s])@((?:[-a-z0-9]\.)[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
 end

 class FloatValidator < ActiveModel::EachValidator  # used in models as:  validates :useremail, email: true
  def validate_each(record, attribute, value)
   # TBD
  end
 end 

 class IntegerValidator < ActiveModel::EachValidator  # used in models as:  validates :useremail, email: true
  def validate_each(record, attribute, value)
   # TBD
  end
 end 

 class PhoneValidator < ActiveModel::EachValidator  # used in models as:  validates :useremail, email: true
  def validate_each(record, attribute, value)
  end
 end

 class DatetimeValidator < ActiveModel::EachValidator  # used in models as:  validates :useremail, datetime: true
  def validate_each(record, attribute, value)
    # TypeError: no implicit conversion of ActiveSupport::TimeWithZone into String
    #if value && !DateTime.parse(value) 
    #  record.errors[attribute] << "must be a valid datetime" 
    #end 
  end
 end

 class DateValidator < ActiveModel::EachValidator  # used in models as:  validates :on_date, date: true
  def validate_each(record, attribute, value)
    #if value && !DateTime.parse(value) 
    # record.errors[attribute] << "must be a valid date"
    #end
  end
 end

 class TimeValidator < ActiveModel::EachValidator
   def validate_each(record, attribute, value)
     #if value && !value.kind_of?(Time)
     #  record.errors[attribute] << (options[:message] || "don't recognize time")
     #end
   end
 end

 class NameValidator < ActiveModel::EachValidator
   def validate_each(record, attribute, value)
     # 2 to 8 characters, all ASCII letters
     # format: { with: /\A[a-zA-Z]\z/, message: "only allows letters" }, length: { in: 2..8 } 
   end
 end

 class TextValidator < ActiveModel::EachValidator
   def validate_each(record, attribute, value)
     # 2 to 8 characters, all ASCII letters
     # format: { with: /\A[a-zA-Z]\z/, message: "only allows letters" }, length: { in: 8..100 }
   end
 end

 class IpAddressValidator < ActiveModel::EachValidator
   def validate_each(record, attribute, value)
     # IP address such as 192.0.0.1
   end
 end

 class BooleanValidator < ActiveModel::EachValidator
   def validate_each(record, attribute, value)
     if value && !%w[true false].include?(value.to_s)
       record.errors[attribute] << (options[:message] || "don't recognize boolean value")
     end
   end
 end

 class CantWantWouldValidator < ActiveModel::EachValidator
   def validate_each(record, attribute, value)
     if value && !%w[cant want would].include?(value.to_s)
       record.errors[attribute] << (options[:message] || "valid values are: cant, want, would")
     end
   end
 end

 class DefaultValidator < ActiveModel::EachValidator
   def validate_each(record, attribute, value)
     #if !value
       #record[attribute] = value  
     #end
     # this means field is optional, and it gets its default from the validations instance. 
   end
 end

end
