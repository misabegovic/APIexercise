# FormObject, implements default behavior for all
# Forms that inherit from the class
class FormObject
  include ActiveModel::Model

  def initialize(args = {})
    args.each do |k, v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end
end
