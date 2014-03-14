module PlotHelper

include StatsHelper

def activitad_total_chart(vaca)

    date_actividad = 1300.hours.ago.localtime
    actividades_total = vaca.actividades.where("registrada >= ? and tipo = ?", date_actividad,'recorrido')    
    n=0
    data_total = [[]]
    data_prom = [[]]
    max_act = 100
    max_act_prom = 50

    actividades_total.each do |actividad|
      data_total[n] = [actividad.registrada.localtime,actividad.valor]
      act_prom = actividad_promedio_en(actividad.registrada)
      data_prom[n] = [actividad.registrada.localtime,act_prom]
      if actividad.valor > max_act
        max_act = actividad.valor + 20
      end
      if act_prom > max_act_prom
        max_act_prom = act_prom * 1.5
      end
      #area_celo[n] = [actividad.registrada.localtime,act_prom*1.5,actividad.valor*1.2]
      n = n+1
    end 

    startPoint = 24.hours.ago.localtime
    if !data_total[0][0].nil? && data_total.size >0 && data_total.size < 24
        startPoint = data_total[0][0].advance(:hours => (-3).to_i).localtime
    end
    startPoint = startPoint.change(:min => 0)

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
     f.options[:chart][:defaultSeriesType] = "spline"
     f.options[:chart][:zoomType] = "x"
     f.options[:legend][:align] = "right"
     f.options[:legend][:verticalAlign] = "top"
     f.options[:legend][:floating] = "true"
     f.global(:useUTC => 'false')

     #f.series(:name=>'Area Celo', :type=>'arearange', :color => '#2f7ed8', :lineWidth=> '0',
     #   :fillOpacity=> '0.2', :data => area_celo, :pointInterval => 3600000,:pointStart => (startPoint.to_i * 1000))
     f.series(:name=>'Actividad Vaca ' + vaca.caravana.to_s, :data => data_total, 
      :pointInterval => 3600000,:pointStart => (startPoint.to_i * 1000))
     f.series(:name=>'Actividad Promedio', :data => data_prom, 
      :pointInterval => 3600000,:pointStart => (startPoint.to_i * 1000))
     
     f.options[:yAxis][:title] = {text: "Eventos"}
     f.options[:xAxis][:maxZoom] = "14 * 24 * 3600000"
     f.options[:xAxis][:type] = "datetime"
     f.yAxis({plotBands: [{ 
                    from: max_act_prom,
                    to: max_act,
                    color: 'rgba(68, 170, 213, .2)'}]
      })
   
     f.tooltip({
        formatter: %|function() { return '<b>'+ this.series.name +':</b> '+ this.y  +'<br/>'+
                                        '<b>'+'Hora de Actividad:</b> ' + Highcharts.dateFormat('%e/%m %H:%M',
                                              new Date(this.x)) +'hrs<br/>';
                         }|.js_code
        })
      
     f.title(text: 'Actividad Vaca ' + vaca.caravana.to_s + ' ultimas 24 horas') 
    end

    return @chart
end

#grafico de actividad de la vaca en los ultimos X dias
def grafico_activitad(vaca,num_dias)

    date_actividad = num_dias.days.ago.localtime

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
      
    startPoint = 24.hours.ago.localtime
    if !data_total[0][0].nil? && data_total.size >0 
        startPoint = data_total[0][0].advance(:hours => (-3).to_i).localtime
    end
    startPoint = startPoint.change(:min => 0)
    
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
     f.options[:tooltip][:shared] = 'true'
     
     f.title(text: 'Actividad Vaca ' + vaca.caravana.to_s + ' ultimos ' + num_dias.to_s + ' dias') 
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
    
     mydate = Date.new(2013, 8, 1)
     @celos_ags = Celo.where("comienzo between ? and ?" , mydate,mydate.at_end_of_month)
    
     mydate = Date.new(2013, 9, 1)
     @celos_sep = Celo.where("comienzo between ? and ?" , mydate,mydate.at_end_of_month)
    
     mydate = Date.new(2013, 10, 1)
     @celos_oct = Celo.where("comienzo between ? and ?" , mydate,mydate.at_end_of_month)
    
     mydate = Date.new(2013, 11, 1)
     @celos_nov = Celo.where("comienzo between ? and ?" , mydate,mydate.at_end_of_month)
    
     mydate = Date.new(2013, 12, 1)
     @celos_dic = Celo.where("comienzo between ? and ?" , mydate,mydate.at_end_of_month)
    
     f.options[:xAxis][:categories] = ['Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']

     f.series(:name=>'Celos Detectados', :data => [0,@celos_ags.size,@celos_sep.size,@celos_oct.size,@celos_nov.size,@celos_dic.size])
    end
    
    return @chart
end

end