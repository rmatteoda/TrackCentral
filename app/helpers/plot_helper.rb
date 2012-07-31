module PlotHelper

def activitad_chart(vaca)

    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('datetime', 'Date')
    data_table.new_column('number', "Vaca " + vaca.caravana.to_s)
    data_table.new_column('number', "Promedio")
    
    data_table.add_rows(vaca.actividades.count)
    n = 0

    vaca.actividades.each do |actividad|
      data_table.set_cell(n, 0, actividad.registrada)
      data_table.set_cell(n, 1, actividad.valor)
      promedio = actividad_promedio(actividad.registrada)    
      data_table.set_cell(n, 2, promedio)
      n = n+1
    end

    #opts   = {:title => 'Actividad', :vAxis => { :title => 'Eventos'}, :hAxis => { :title => 'Tiempo'},:series => {'0' => {:color => 'green'}} }
    #@chart = GoogleVisualr::Interactive::AreaChart.new(data_table, opts)
    opts   = {:title => 'Actividad', :vAxis => {:title => 'Eventos'}, :hAxis => {:title => 'Tiempo'}, :seriesType => 'area', :series => {'1' => {:type => 'line',:color => 'green'}} }
    @chart = GoogleVisualr::Interactive::ComboChart.new(data_table, opts)

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
  data_table.add_rows( [
    [ Date.parse("2010-9-1"), 100, '', 200, ''],
    [ Date.parse("2010-10-1"), 100, '', 200, 'Parto'],
    [ Date.parse("2011-1-20"), 100, 'Servicio 1', 200, ''],
    [ Date.parse("2011-2-3"), 100, 'Servicio 2', 200, ''],
    [ Date.parse("2011-11-25"), 100, '', 200, 'Parto'],
    [ Date.parse("2012-2-25"), 100, 'Servicio 1', 200, ''],
    [ Date.parse("2012-3-16"), 100, 'Servicio 2', 200, ''],
    [ Date.parse("2012-4-7"), 100, 'Servicio 3', 200, ''],
    [ Date.parse("2012-4-29"), 100, 'Servicio 4', 200, ''],
    [ Date.parse("2012-6-20"), 100, '', 200, '']
    ] )

  opts   = {:title => 'Historial de Partos y Servicios', :displayAnnotations => true, 
    :displayRangeSelector => true, :displayZoomButtons => false, :scaleColumns => [], 
    :displayLegendValues => false, :displayLegendDots => false}
  @chart = GoogleVisualr::Interactive::AnnotatedTimeLine.new(data_table, opts)
  return @chart
end

def estadistica_celo_chart
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Mes'       )
    data_table.new_column('number', 'Celos Detectados')
    data_table.new_column('number', 'Servicios')
    data_table.new_column('number', 'Vacas Preniadas')
    data_table.add_rows( [
    ['enero', 21, 21, 10],
    ['febrero', 18, 18, 9],
    ['marzo', 25, 23, 11],
    ['abril', 28, 26, 15],
    ['mayo', 30, 29, 20]] )

    opts   = { :width => 700, :height => 400, :title => 'Analisis de Celo', 
    :vAxis => {:title => 'Numero de Vacas'}, :hAxis => {:title => 'Mes'}, :seriesType => 'bars' }
    @chart = GoogleVisualr::Interactive::ColumnChart.new(data_table, opts)
    return @chart
end

end