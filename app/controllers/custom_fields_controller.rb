class CustomFieldsController < ApplicationController
  def index
    # @custom_fields = CustomField.get_like_json.to_json
    render 'settings/custom_fields'
  end

  def create
    # TOTO: add notify to show message about save error if it is exist
    CustomField.add_field(params)
    render 'settings/custom_fields'
  end
end