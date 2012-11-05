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

def activitad_accelerometer_chart(vaca)

    #data_table.new_column('datetime', 'Date')
    #data_table.new_column('number', "Actividad Suave")
    #data_table.new_column('number', "Actividad Media")
    #data_table.new_column('number', "Actividad Fuerte")
    #data_table.new_column('number', "Actividad Continua")
    
    #data_table.add_rows(vaca.actividades.count)

    #actividades_suave = vaca.actividades.where("registrada >= ? and tipo = ?", 36.hours.ago,'recorrido_lento')
    #actividades_media = vaca.actividades.where("registrada >= ? and tipo = ?", 36.hours.ago,'recorrido_medio')
    #actividades_fuerte = vaca.actividades.where("registrada >= ? and tipo = ?", 36.hours.ago,'recorrido_rapido')
    #actividades_continua = vaca.actividades.where("registrada >= ? and tipo = ?", 36.hours.ago,'recorrido_continuo')
 
    #data_table.add_rows(actividades_suave.count)

    #n = 0
    #actividades_suave.each do |actividad|
    #  data_table.set_cell(n, 0, actividad.registrada)
    #  data_table.set_cell(n, 1, actividad.valor)
    #  data_table.set_cell(n, 2, actividades_media[n].valor)
    #  data_table.set_cell(n, 3, actividades_fuerte[n].valor)
    #  data_table.set_cell(n, 4, actividades_continua[n].valor)
    #  n = n+1
    #end

    #opts   = {:pointSize => 3,:legend => {:position => 'top'},:title => 'Actividad vaca '+ vaca.caravana.to_s + ' ultimas 36 horas', 
    #          :vAxis => {:title => 'Eventos', :minValue => -10,:maxValue => 200}, 
    #          :hAxis => {:title => 'Tiempo'}}
    #@chart = GoogleVisualr::Interactive::LineChart.new(data_table, opts)

    actividades_celo = vaca.actividades.where("registrada >= ? and tipo = ?", 36.hours.ago,'recorrido_lento')
    n=0
    data_table = []
    actividades_celo.each do |actividad|
      data_table[n] = actividad.valor
      n = n+1
    end 
    xStart = 36.hours.ago
    xStartUTC = Time.now.utc

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
     f.options[:chart][:defaultSeriesType] = "spline"
     f.options[:chart][:zoomType] = "x"
     f.series(:name=>'Actividad', :data => data_table, :pointInterval => 3600000)
     f.xAxis(type: :datetime)
     f.options[:yAxis][:title] = {text: "Eventos"}
     f.options[:xAxis][:maxZoom] = "14 * 24 * 3600000"
     f.title(text: 'Actividad vaca ultimas 36 horas') 
    end

    return @chart
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
     
     f.options[:xAxis][:categories] = ['Julio','Agosto','Septiembre','Octubre','Noviembre']
     
     f.series(:name=>'Celos Detectados', :data => [21,18,25,28,30])
     f.series(:name=>'Servicios', :data => [21,18,23,26,29])
     
    end
    
    return @chart
end

end