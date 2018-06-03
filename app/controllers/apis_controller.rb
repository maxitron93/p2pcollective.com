class ApisController < ApplicationController
  def get_chart
    chart = Chart.where(chart: params[:chart]).first
    if chart == nil
      chart = Chart.find(2)
    end
    render json: chart
  end

  def save_chart
    Chart.create!(
      chart: params[:chart],
      project_name: params[:project_name],
      start_date: params[:start_date],
      end_date: params[:end_date],
      show_main_gridlines: params[:show_main_gridlines],
      show_sub_gridlines: params[:show_sub_gridlines],
      row_spacing: params[:row_spacing],
      rows: params[:rows]
      )
  end
end