class CustomField < ApplicationRecord
  validates :data_type, acceptance: {accept: %w(text link image username)}

  def self.add_field(params)
    custom_field = CustomField.new
    custom_field.data_type = params[:data_type][:status_id]
    custom_field.size = (params['size'] == '1')
    custom_field.name = params[:name][:text]
    custom_field.description = params[:description][:text]
    custom_field.default = params[:default][:text]
    custom_field.save
  end
end
