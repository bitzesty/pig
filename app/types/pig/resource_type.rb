# the "resource" type is for linking to internal pig content,
# call the _path appended version of attribute for the link

module Pig
  class ResourceType < Type
    def decorate(content_package)
      this = self
      content_package.define_singleton_method(@slug) { this.get(self) }
      content_package.define_singleton_method("#{@slug}=") do |value|
        this.set(self, value)
      end
      content_package.define_singleton_method("#{@slug}_valid?") do |content_package|
        this.valid?(content_package)
      end
      content_package.define_singleton_method("#{@slug}_content_package") do
        if this.content_value(self).present?
          Pig::ContentPackage.find_by_id(this.content_value(self))
        end
      end
      content_package.define_singleton_method("#{@slug}_path") do
        if this.content_value(self).present?
          package = self.send("#{this.slug}_content_package")

          if package
            cp_path = self.send("#{this.slug}_content_package").to_param
            "/#{cp_path}".squeeze "/"
          else
            "#"
          end
        end
      end
    end
  end
end
