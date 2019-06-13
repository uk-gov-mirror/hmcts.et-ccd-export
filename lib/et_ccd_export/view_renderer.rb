require 'active_support/json'
require 'active_support/core_ext/module'
require 'action_view'
require 'jbuilder'
require 'et_ccd_export/jbuilder_template'
ActiveSupport.on_load :action_view do
  ActionView::Template.register_template_handler :jbuilder, EtCcdExport::JbuilderHandler
  require 'jbuilder/dependency_tracker'
end
module EtCcdExport
  module ViewRenderer
    def self.render(options = {})
      view_paths = [File.absolute_path('../../app/views', __dir__)]
      lookup_context = ActionView::LookupContext.new(view_paths, {}, [])
      view_renderer =  ActionView::Renderer.new(lookup_context)
      view_context =  ActionView::Base.new(view_renderer, {}, self)
      view_renderer.render(view_context, options)
    end
  end
end
