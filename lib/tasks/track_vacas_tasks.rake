namespace :track_vacas do
  desc "Task de control de vacas"
      
  task detectar_alarmas: :environment do
  	#eliminar alarmas con mas de 10 dias de antiguedad
   #Alarma.destroy_all(["registrada <= ?", 9.days.ago])
   Alarma.destroy_all(["registrada > ?", 9.days.ago])
   
   #genera las alarmas del sistema para problemas en vacas:
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
  	sucesos_serv_pp = vaca.sucesos.where("momento > ? and tipo = 'servicio'",ultimo_parto)
   	if sucesos_serv_pp.count >= 4
		crear_alarma(vaca.id,"servicios","vaca con " + sucesos_serv_pp.count.to_s + " servicios post-parto")
	end
	
	if !vaca.nodo.nil? && vaca.nodo.bateria < 20
		crear_alarma(vaca.id,"bateria_collar","collar en vaca con bateria baja, contacte a TrackTambo")
	end
	
   end
  end

  def crear_alarma(vaca,tipo,mensaje)
    registro = 1.hours.ago
    Alarma.create!(vaca_id: vaca,
                  tipo: tipo,
                  vista: false,
                  registrada: registro,
                  mensaje: mensaje) 
  end
end