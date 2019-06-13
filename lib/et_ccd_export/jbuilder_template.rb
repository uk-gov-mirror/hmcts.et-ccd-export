require 'jbuilder/jbuilder'
require 'active_support/cache'
module EtCcdExport
  class JbuilderTemplate < Jbuilder
    class << self
      attr_accessor :template_lookup_options
    end

    self.template_lookup_options = { handlers: [:jbuilder] }

    def initialize(context, *args)
      @context = context
      @cached_root = nil
      super(*args)
    end

    def partial!(*args)
      _render_explicit_partial(*args)
    end

    def target!
      @cached_root || super
    end

    def array!(collection = [], *args)
      options = args.first

      if args.one? && _partial_options?(options)
        partial! options.merge(collection: collection)
      else
        super
      end
    end

    def set!(name, object = ::Jbuilder::BLANK, *args)
      options = args.first

      if args.one? && _partial_options?(options)
        _set_inline_partial name, object, options
      else
        super
      end
    end

    private

    def _render_partial_with_options(options)
      options.reverse_merge! locals: {}
      options.reverse_merge! ::JbuilderTemplate.template_lookup_options
      as = options[:as]

      if as && options.key?(:collection)
        as = as.to_sym
        collection = options.delete(:collection)
        locals = options.delete(:locals)
        array! collection do |member|
          member_locals = locals.clone
          member_locals.merge! collection: collection
          member_locals.merge! as => member
          _render_partial options.merge(locals: member_locals)
        end
      else
        _render_partial options
      end
    end

    def _render_partial(options)
      options[:locals].merge! json: self
      @context.render options
    end

    def _partial_options?(options)
      ::Hash === options && options.key?(:as) && options.key?(:partial)
    end

    def _set_inline_partial(name, object, options)
      value = if object.nil?
        []
      elsif _is_collection?(object)
        _scope{ _render_partial_with_options options.merge(collection: object) }
      else
        locals = ::Hash[options[:as], object]
        _scope{ _render_partial_with_options options.merge(locals: locals) }
      end

      set! name, value
    end

    def _render_explicit_partial(name_or_options, locals = {})
      case name_or_options
      when ::Hash
        # partial! partial: 'name', foo: 'bar'
        options = name_or_options
      else
        # partial! 'name', locals: {foo: 'bar'}
        if locals.one? && (locals.keys.first == :locals)
          options = locals.merge(partial: name_or_options)
        else
          options = { partial: name_or_options, locals: locals }
        end
        # partial! 'name', foo: 'bar'
        as = locals.delete(:as)
        options[:as] = as if as.present?
        options[:collection] = locals[:collection] if locals.key?(:collection)
      end

      _render_partial_with_options options
    end

  end

  class JbuilderHandler
    cattr_accessor :default_format
    self.default_format = 'application/json'

    def self.call(template)
      # this juggling is required to keep line numbers right in the error
      %{__already_defined = defined?(json); json||=::EtCcdExport::JbuilderTemplate.new(self); #{template.source}
        json.target! unless (__already_defined && __already_defined != "method")}
    end
  end

end
