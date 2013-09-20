class SucesosController < ApplicationController
  
  def new
    @suceso = Suceso.new
    @suceso.momento = Date.today
    @vacas = Vaca.all
  end

  def create
    @vaca = Vaca.find(params[:suceso][:vaca_id])
    @suceso = @vaca.sucesos.build(params[:suceso])
    
    #date_aux = DateTime.strptime(params[:suceso][:momento],"%m/%d/%Y")
    date_aux = (params[:suceso][:momento]).split("/")
    if date_aux.size < 3
      date_aux = (params[:suceso][:momento]).split("-")
      date_mont = date_aux[1]
      date_day = date_aux[2]
      date_year = date_aux[0]
    else
      date_mont = date_aux[0]
      date_day = date_aux[1]
      date_year = date_aux[2]
    end
    
    #temporal, revisar datepicker format
    temp_time = Time.new(date_year,date_mont,date_day,12, 0, 0, 0)
    @suceso.momento = temp_time
      
    if @suceso.tipo == "celo"
      @vaca.celos.create!(comienzo: @suceso.momento.to_datetime,
                          probabilidad: "alta",
                          caravana: @vaca.caravana,
                          causa: "agregado por registro")
    end

    if @suceso.save
       flash[:success] = "Registro Agregado con exito"
       redirect_to root_path
    else
        render 'new'
    end

  end

end
