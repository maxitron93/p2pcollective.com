class ApisController < ApplicationController
  require 'securerandom'

  def get_chart
    chart = Chart.where(chart: params[:chart]).first
    if chart == nil
      chart = Chart.where(chart: "febb1bcf023e1f68").first
    end
    render json: chart
  end

  def save_chart
    if params[:module] == '*(V5*69)c5I&$Coo#$^vb*Vb7o*7'
      chart_key = SecureRandom.hex(8)
      
      Chart.create!(
        chart: chart_key,
        container_width: params[:containerWidth],
        project_name: params[:projectName],
        start_date: params[:startDate],
        end_date: params[:endDate],
        row_spacing: params[:rowSpacing],
        rows: params[:rows]
        )
      
      render json: {
         message: "Chart saved",
         chart_key: chart_key
        }
    end
  end

end