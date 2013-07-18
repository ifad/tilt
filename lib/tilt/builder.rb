require 'tilt/template'

module Tilt
   # Builder template implementation. See:
  # http://builder.rubyforge.org/
  class BuilderTemplate < Template
    self.default_mime_type = 'text/xml'

    def self.engine_initialized?
      defined? ::Builder
    end

    def initialize_engine
      require_template_library 'builder'
    end

    def prepare
      options[:indent] ||= 2
    end

    def evaluate(scope, locals, &block)
      xml = (locals[:xml] ||= ::Builder::XmlMarkup.new(options))
      return super(scope, locals, &block) if data.respond_to?(:to_str)
      data.call(xml)
      xml.target!
    end

    def precompiled_postamble(locals)
      "xml.target!"
    end

    def precompiled_template(locals)
      data.to_str
    end
  end
end

