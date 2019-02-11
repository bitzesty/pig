module Pig
  class ContentAttribute < ActiveRecord::Base

    belongs_to :content_type
    belongs_to :default_attribute, :class_name => 'ContentAttribute'
    after_validation :set_meta_title, :if => :meta?
    before_validation :set_slug
    validates :slug, :name, :field_type, :presence => true
    begin
      validates :slug, :name,
        uniqueness: { scope: :content_type_id },
        exclusion: {
          in: Pig::ContentPackage.methods + Pig::ContentPackage.column_names,
          message: "%{value} is a reserved word."
        }
    rescue ActiveRecord::StatementInvalid
      # Migrations not yet carried out, but need to be able to precompile
    end
    belongs_to :resource_content_type, :class_name => 'ContentType'


    class << self

      def field_types
        {
          string: 'Single line of text',
          text: 'Block of text',
          link: 'Link',
          image: 'Image',
          file: 'File',
          embeddable: 'Embeddable content - Flickr, Instagram, Scribd, Slideshare, SoundCloud, Vimeo, YouTube',
          tags: 'Tag list',
          boolean: 'Check box',
          user: 'User',
          location: 'Location',
          resource: 'Link to content',
          rich_content: 'Rich Content',
          date: 'Date',
          time: 'Time'
        }.merge(Pig.configuration.content_types)
      end

      def fields_to_duplicate
        column_names - %w{id content_type_id slug position}
      end

    end

    META_TAG_TYPES = ["title", "description", "image", "keywords"]

    def field_type
      ActiveSupport::StringInquirer.new(read_attribute(:field_type).to_s)
    end

    def input_type
      case field_type
      when 'file' then 'file_with_preview'
      when 'text' then 'redactor'
      when 'boolean' then 'content_boolean'
      when 'user' then 'select'
      when 'resource' then 'autocomplete_select'
      when 'rich' then 'text'
      when 'rich_content' then 'rich_redactor'
      when 'date' then 'date_picker'
      when 'time' then 'ym_time_picker'
      else field_type
      end
    end

    def input_method
      case field_type
      when 'embeddable' then slug + "_url"
      when 'tags' then slug.singularize + "_list"
      when 'user' then slug + "_id"
      else slug
      end
    end

    def input_options
      case field_type
      when 'user'
        {
          :collection => Pig::User.all,
          :prompt => "None selected"
        }
      when 'resource'
        {
          :collection => resource_collection,
          :prompt => "None selected",
        }
      else {}
      end
    end

    def resource_collection
      # ContentPackage collection for atrributes of type resource
      scope = Pig::ContentPackage.unscoped.published.order(:name).where(archived_at: nil)
      scope = scope.where(content_type: resource_content_type) if resource_content_type.present?

      scope
    end

    def limitable?
      %w{string text}.include?(field_type.to_s)
    end

    def removable?
      new_record? || content_type.missing_view?
    end

    def to_s
      name
    end

    private

    def set_meta_title
      unless name.start_with?('Meta ')
        self.name = 'Meta ' << name
        valid?
      end
    end

    def set_slug
      return unless slug.blank? && name.present? && errors['name'].blank?
      if Rails.version.to_f >= 5.0
        slug_name = name.gsub('-', ' ').parameterize(separator: '_').sub(/^\d+/, 'n')
      else
        slug_name = name.gsub('-', ' ').parameterize('_').sub(/^\d+/, 'n')
      end
      if Pig::ContentPackage.new.respond_to?(slug_name)
        slug_name = 'content_package_' + slug_name
      end
      self.slug = slug_name
      valid?
    end

  end
end
