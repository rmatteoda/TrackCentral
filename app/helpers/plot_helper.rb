module PlotHelper

include StatsHelper

def activitad_total_chart(vaca)

    date_actividad = 24.hours.ago.localtime
    actividades_total = vaca.actividades.where("registrada >= ? and tipo = ?", date_actividad,'recorrido')    
    n=0
    data_total = [[]]
    data_prom = [[]]
    
    actividades_total.each do |actividad|
      data_total[n] = [actividad.registrada.localtime,actividad.valor]
      act_prom = actividad_promedio_en(actividad.registrada)
      data_prom[n] = [actividad.registrada.localtime,act_prom]
      n = n+1
    end 

    #startPoint = data_total[0][0].localtime
    startPoint = 26.hours.ago.localtime
    
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
     f.options[:chart][:defaultSeriesType] = "spline"
     f.options[:chart][:zoomType] = "x"
     f.options[:legend][:align] = "right"
     f.options[:legend][:verticalAlign] = "top"
     f.options[:legend][:floating] = "true"
     f.global(:useUTC => 'false')

     f.series(:name=>'Actividad Vaca ' + vaca.caravana.to_s, :data => data_total, 
      :pointInterval => 3600000,:pointStart => (startPoint.to_i * 1000))
     f.series(:name=>'Actividad Promedio', :data => data_prom, 
      :pointInterval => 3600000,:pointStart => (startPoint.to_i * 1000))
     
     f.options[:yAxis][:title] = {text: "Eventos"}
     f.options[:xAxis][:maxZoom] = "14 * 24 * 3600000"
     f.options[:xAxis][:type] = "datetime"
     f.options[:tooltip][:xDateFormat] = '%Y-%b-%e %H:%M' 
     f.options[:tooltip][:shared] = 'true'
     
     f.title(text: 'Actividad Vaca ' + vaca.caravana.to_s+ ' ultimas 24 horas') 
    end

    return @chart
end

#muestra grafica de celos detectados por mes
#agregar casos para todos los meses del año
def estadistica_celo_chart_high   
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
     f.options[:chart][:defaultSeriesType] = "column"
     f.options[:yAxis][:title] = {text: "Numero de Vacas"}
     f.options[:xAxis][:title] = {text: "Mes"}
     f.title(text: 'Estadistica Mensual') 
     f.options[:plotOptions][:column] = {dataLabels: {enabled: true}}
          
     mydate = Date.new(2013, 1, 1)
     @celos_enero = Celo.where("comienzo between ? and ?" , mydate,mydate.at_end_of_month)
    
     mydate = Date.new(2013, 2, 1)
     @celos_feb = Celo.where("comienzo between ? and ?" , mydate,mydate.at_end_of_month)
    
     mydate = Date.new(2013, 3, 1)
     @celos_marz = Celo.where("comienzo between ? and ?" , mydate,mydate.at_end_of_month)
    
     mydate = Date.new(2013, 4, 1)
     @celos_apr = Celo.where("comienzo between ? and ?" , mydate,mydate.at_end_of_month)
    
     mydate = Date.new(2013, 5, 1)
     @celos_may = Celo.where("comienzo between ? and ?" , mydate,mydate.at_end_of_month)
     
     mydate = Date.new(2013, 6, 1)
     @celos_jun = Celo.where("comienzo between ? and ?" , mydate,mydate.at_end_of_month)
    
     f.options[:xAxis][:categories] = ['Enero','Febrero','Marzo', 'Abril', 'Mayo', 'Junio']

     f.series(:name=>'Celos Detectados', :data => [@celos_enero.size,@celos_feb.size,@celos_marz.size,@celos_apr.size,@celos_may.size,@celos_jun.size])
    end
    
    return @chart
end

end