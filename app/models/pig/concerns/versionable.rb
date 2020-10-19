# When using versionable the live version published on the site
# is always the last paper_trail version. The preview version
# is the canonical non-versioned instance of the model.

module Pig
  module Concerns
    module Versionable
      extend ActiveSupport::Concern

      included do
        has_paper_trail class_name: 'Pig::Version',
                        if: proc { |t| t.status_before_last_save == 'published' }
      end

      def live_version
        return self if published?
        return versions.last.reify if versions.any?
        self
      end

      def preview_version
        # get the non-versioned model
        @preview_version ||= self.class.find(id)
      end

    end
  end
end
