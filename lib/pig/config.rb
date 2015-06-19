module Pig
  class Config
    attr_accessor :nested_permalinks,
                  :tags_feature,
                  :basic_redactor_plugins,
                  :redactor_plugins,
                  :cms_roles,
                  :unpublished,
                  :additional_stylesheets,
                  :additional_javascripts

    def initialize(options = {})
      self.nested_permalinks = options[:nested_permalinks] || true
      self.tags_feature = options[:tags_feature] || true
      self.basic_redactor_plugins = options[:basic_redactor_plugins] || []
      self.redactor_plugins = options[:redactor_plugins] || []
      self.on_unpublished { redirect_to sign_in_path }
      self.additional_stylesheets = options[:additional_stylesheets] || []
      self.additional_javascripts = options[:additional_javascripts] || []
    end

    def on_unpublished(&block)
      self.instance_variable_set(:@unpublished, block)
    end

  end
end