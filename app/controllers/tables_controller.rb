class TablesController < ApplicationController
  
  def all_tables
    Rails.application.eager_load!
    dummy_count = 0
    model_array = []    
    ActiveRecord::Base.descendants.each do |model|
      if model == ApplicationRecord || model == ActiveRecord::SchemaMigration
        dummy_count += 1 # This doesn't do anything. I just don't know how else to skip the first two objects in ActiveRecord::Base.descendants
      else
        model_array.push(model.to_s)
      end
    end
    model_array.sort!
    @all_models = model_array
    render layout: false    
  end

  def table
    @model = params.permit(:table_name)[:table_name]

    render layout: false
  end

end