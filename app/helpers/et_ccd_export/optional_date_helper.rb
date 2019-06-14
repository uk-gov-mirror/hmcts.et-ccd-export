module EtCcdExport
  module OptionalDateHelper
    def optional_date(date)
      return nil if date.nil?
      Date.parse(date).strftime('%Y-%m-%d')
    end
  end
end
