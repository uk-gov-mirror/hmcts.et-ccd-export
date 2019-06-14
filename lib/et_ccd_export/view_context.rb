module EtCcdExport
  class ViewContext < ActionView::Base
      helpers_path = File.absolute_path('../../app/helpers', __dir__)
      Dir.glob(File.absolute_path(File.join(helpers_path, '**', '*_helper.rb'), __dir__)).each do |file|
        require file
        relative_path = file.gsub("#{helpers_path}/", '').gsub(/\.rb$/, '')
        mod = relative_path.camelize.safe_constantize
        include mod unless mod.nil?
      end
  end
end
