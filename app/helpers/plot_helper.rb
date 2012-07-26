module PlotHelper

def activitad_chart(vaca)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('datetime', 'Date')
    data_table.new_column('number', vaca.nombre)
    
    data_table.add_rows(vaca.actividades.count)
    n = 0

    vaca.actividades.each do |actividad|
      data_table.set_cell(n, 0, actividad.registrada_en)
      data_table.set_cell(n, 1, actividad.valor)
      n = n+1
    end

    opts   = {:title => 'Actividad', :vAxis => { :title => 'Eventos'}, :hAxis => { :title => 'Tiempo'},:series => {'0' => {:color => 'green'}} }
    @chart = GoogleVisualr::Interactive::AreaChart.new(data_table, opts)
    
    return @chart
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

end