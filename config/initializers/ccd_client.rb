EtCcdClient.config do |c|
  c.auth_base_url = ENV.fetch('CCD_AUTH_BASE_URL', 'http://localhost:4502')
  c.idam_base_url = ENV.fetch('CCD_IDAM_BASE_URL', 'http://localhost:4501')
  c.data_store_base_url = ENV.fetch('CCD_DATA_STORE_BASE_URL', 'http://localhost:4452')
  c.jurisdiction_id = ENV.fetch('CCD_JURISDICTION_ID', 'EMPLOYMENT')
  c.microservice = ENV.fetch('CCD_MICROSERVICE_ID', 'ccd_gw')
  c.logger = Rails.logger
end
