require 'raven'
require 'et_ccd_client'
class CcdClientSentryErrorMiddleware
  def call(ex, context)
    Raven.context.extra.merge! ccd_response: ex.response.body if ex.is_a?(EtCcdClient::Exceptions::Base)
    yield
  end
end
