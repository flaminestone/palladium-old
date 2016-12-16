class CustomFieldsController < ApplicationController
  def index
    @custom_fields = CustomField.all
    render 'settings/custom_fields'
  end

  def create
    # TOTO: add notify to show message about save error if it is exist
    CustomField.add_field(params)
    render 'settings/custom_fields'
  end
end
