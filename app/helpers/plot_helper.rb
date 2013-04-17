module PlotHelper

def activitad_chart(vaca)

    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('datetime', 'Date')
    data_table.new_column('number', "Vaca " + vaca.caravana.to_s)
    data_table.new_column('number', "Promedio")
    
    data_table.add_rows(vaca.actividades.count)
    n = 0
    actividades_celo = vaca.actividades.where("registrada >= ? ", 36.hours.ago)
 
    actividades_celo.each do |actividad|
      data_table.set_cell(n, 0, actividad.registrada)
      data_table.set_cell(n, 1, actividad.valor)
      promedio = actividad_promedio(actividad.registrada)    
      data_table.set_cell(n, 2, promedio)
      n = n+1
    end

    opts   = {:pointSize => 3,:legend => {:position => 'top'},:title => 'Actividad vaca '+ vaca.caravana.to_s + ' ultimas 36 horas', :vAxis => {:title => 'Eventos', :minValue => 0,:maxValue => 200}, :hAxis => {:title => 'Tiempo'}, :seriesType => 'area', :series => {'1' => {:type => 'line',:color => 'green'}} }
    @chart = GoogleVisualr::Interactive::ComboChart.new(data_table, opts)

    return @chart
end

def activitad_total_chart(vaca)

    actividades_total = vaca.actividades.where("registrada >= ? and tipo = ?", 36.hours.ago,'recorrido_total')
    
    n=0
    data_total = [[]]
    data_prom = [[]]
    
    startPoint = Time.now

    actividades_total.each do |actividad|
      data_total[n] = [actividad.registrada,actividad.valor]
      act_prom = actividad_promedio_total(actividad.registrada)
      data_prom[n] = [actividad.registrada,act_prom]
      n = n+1
    end 
    startPoint = data_total[0][0]

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
     f.options[:chart][:defaultSeriesType] = "spline"
     f.options[:chart][:zoomType] = "x"
     f.options[:legend][:align] = "right"
     f.options[:legend][:verticalAlign] = "top"
     f.options[:legend][:floating] = "true"
     
     f.series(:name=>'Actividad Total', :data => data_total, 
      :pointInterval => 3600000,:pointStart => (startPoint.to_i * 1000))
     f.series(:name=>'Actividad Promedio', :data => data_prom, 
      :pointInterval => 3600000,:pointStart => (startPoint.to_i * 1000))
     
     f.options[:yAxis][:title] = {text: "Eventos"}
     f.options[:xAxis][:maxZoom] = "14 * 24 * 3600000"
     f.options[:xAxis][:type] = "datetime"
     f.title(text: 'Actividad vaca ultimas 36 horas') 
    end

    return @chart
end

def actividad_promedio_total(momento)
 from = momento.advance(:minutes => -10) 
 to   = momento.advance(:minutes => 10) 
 actividades = Actividad.where("registrada between ? and ? and tipo = ?", from,to,'recorrido_total')
 actividad_promedio = 0
 actividades.each { |actividad| actividad_promedio = actividad_promedio + actividad.valor}
 
 if actividades.count > 0
  actividad_promedio = (actividad_promedio/actividades.count)
 end
 
 return actividad_promedio
end

def actividad_promedio(momento)
  
 actividades = Actividad.where("registrada between ? and ?", momento,momento+1.hour)
 actividad_promedio = 0
 actividades.each { |actividad| actividad_promedio = actividad_promedio + actividad.valor}
 
 if actividades.count > 0
  actividad_promedio = (actividad_promedio/actividades.count)
 end
 
 return actividad_promedio
end

# http://code.google.com/apis/chart/interactive/docs/gallery/annotatedtimeline.html#Example
def vaca_time_line(vaca)

  data_table = GoogleVisualr::DataTable.new
  data_table.new_column('date'  , 'Date')
  data_table.new_column('number', 'Servicios')
  data_table.new_column('string', 'title1')
  data_table.new_column('number', 'Partos'   )
  data_table.new_column('string', 'title2')

  data_table.add_rows(vaca.sucesos.count)
  index = 0
  
  vaca.sucesos.each do |suceso|

    data_table.set_cell(index,0,suceso.momento);
    data_table.set_cell(index,1,100);
    data_table.set_cell(index,2,'');
    data_table.set_cell(index,3,200);
    data_table.set_cell(index,4,'');
    
    if suceso.tipo == "parto"
      data_table.set_cell(index,4,'Parto');
    else
      data_table.set_cell(index,2,'Servicio');
    end 

    index = index + 1
  end

  opts   = {:title => 'Historial de Partos y Servicios', :displayAnnotations => true, 
    :displayRangeSelector => true, :displayZoomButtons => false, :scaleColumns => [], 
    :displayLegendValues => false, :displayLegendDots => false}
  @chart = GoogleVisualr::Interactive::AnnotatedTimeLine.new(data_table, opts)
  return @chart
end

def estadistica_celo_chart_google
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Mes'       )
    data_table.new_column('number', 'Celos Detectados')
    data_table.new_column('number', 'Servicios')
    data_table.add_rows( [
    ['enero', 21, 21],
    ['febrero', 18, 18],
    ['marzo', 25, 23],
    ['abril', 28, 26],
    ['mayo', 30, 29]] )

    opts   = { :width => 700, :height => 400, :title => 'Estadistica mensual', 
    :vAxis => {:title => 'Numero de Vacas'}, :hAxis => {:title => 'Mes'}, :seriesType => 'bars' }
    @chart = GoogleVisualr::Interactive::ColumnChart.new(data_table, opts)
    return @chart
end

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
    
     f.options[:xAxis][:categories] = ['Enero','Febrero','Marzo', 'Abril', 'Mayo']

     f.series(:name=>'Celos Detectados', :data => [@celos_enero.size,@celos_feb.size,@celos_marz.size,@celos_apr.size,@celos_may.size])
     #f.series(:name=>'Servicios', :data => [21,18,23,26,29])
     
    end
    
    return @chart
end

end