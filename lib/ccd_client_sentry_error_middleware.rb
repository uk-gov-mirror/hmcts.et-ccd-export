require 'raven'
class CcdClientSentryErrorMiddleware
  def call(ex, context)
    Raven.context.extra.merge! ccd_response: ex.response.body if ex.is_a?(EtCcdClient::Exception::Base)
    yield
  end
end
