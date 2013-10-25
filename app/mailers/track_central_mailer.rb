class TrackCentralMailer < ActionMailer::Base
  default :from => "noreply@argtrack.com"
  default :to => "rmatteoda@gmail.com"
  default :content_type => 'multipart/alternative'
  default :parts_order => [ "text/html", "text/enriched", "text/plain", "application/pdf" ]

  def mail_report
    #attachments['development.sqlite3'] = File.read('./db/development.sqlite3')
    attachments['development.sqlite3'] =  File.read('./db/development.sqlite3', :encoding => 'BINARY')
    #SpecialEncode(File.read('./db/development.sqlite3'))
	#attachments['development.sqlite3'] = {mime_type: 'application/x-gzip',
    #                           encoding: 'SpecialEncoding',
    #                           content: encoded_content }

    mail(:subject => "[TrackCentral] reporte desde La Mariana", body: "")
  end
end
