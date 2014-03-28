namespace :track_alert do
  desc "Task de control de vacas"
      
  #genera las alarmas del sistema para problemas en vacas:
  task detectar_alarmas: :environment do
   #eliminar alarmas con mas de 10 dias de antiguedad
   Alarma.destroy_all(["registrada < ?", 9.days.ago.to_date])
   #Alarma.destroy_all()
   
   #vacas_alerts = Vaca.joins(:sucesos).where("sucesos.tipo = 'parto'")
   vacas_alerts = Vaca.all
   limite_parto = 120.days.ago.to_date
   
   vacas_alerts.each do |vaca| 

   	sucesos_parto = vaca.sucesos.where("tipo = 'parto'").order("momento DESC")
   	ultimo_parto = 100.days.ago.to_date
 	  ultimo_parto = sucesos_parto.first.momento if sucesos_parto.any?
 	
   	#vacas con mas de 120 dias sin estar preñadas
    if ultimo_parto.to_date <= limite_parto.to_date
		crear_alarma(vaca.id,"post-parto","vaca con mas de 120 dias sin estar preniada")
	  end
	
   	#detecto vacas con mas de 4 servicios sin estar preñadas
    sucesos_serv_pp = vaca.sucesos(true).where("momento > ? and tipo = 'servicio'",ultimo_parto)
    if sucesos_serv_pp.count >= 4
  		crear_alarma(vaca.id,"servicios","vaca con " + sucesos_serv_pp.count.to_s + " servicios post-parto")
  	end
  	
  	if !vaca.nodo.nil? && vaca.nodo.bateria < 20
  		crear_alarma(vaca.id,"bateria_collar","collar en vaca con bateria baja, contacte a TrackTambo")
  	end
	
   end

  end

  #detecta posible perdida de collares
  task detectar_perdida: :environment do
   Alarma.destroy_all(["tipo = 'collar_sin_datos'"])
   
   vacas_alerts = Vaca.all
   ultimo_registro = 26.hours.ago
   
   vacas_alerts.each do |vaca| 
   		actividades = vaca.actividades.where("registrada > ?",ultimo_registro)

   		if actividades.count < 4
   		  puts vaca.id.to_s + " - collar_sin_datos"
       	#crear_alarma(vaca.id,"collar_sin_datos","no se detectaron datos en collar, posible perdida de collar")
		  end
   end
  end

  #crea una alarma en la DB
  def crear_alarma(vaca,tipo,mensaje)
    registro = 1.hours.ago
    Alarma.create!(vaca_id: vaca,
                  tipo: tipo,
                  vista: false,
                  registrada: registro,
                  mensaje: mensaje) 
  end
end