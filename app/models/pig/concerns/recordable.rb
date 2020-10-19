require 'active_support/concern'

module Pig
  module Concerns
    module Recordable
      extend ActiveSupport::Concern

      included do
        has_many :activity_items, :as => :resource, :class_name => "ActivityItem"
        attr_accessor :editing_user
        validates :editing_user, presence: true
        after_create { record_activity!(self.editing_user, "#{self.name} was created") }
        after_update :record_update_activity
        before_destroy { record_activity!(self.editing_user, "#{self.name} was permanently deleted") }
      end

      def record_update_activity
        if self.saved_change_to_archived_at?
          if archived_at_before_last_save.nil?
            record_activity!(self.editing_user,  "#{self.name} was #{I18n.t('actions.archived').downcase}")
          else
            record_activity!(self.editing_user,  "#{self.name} was restored")
          end
        else
          record_activity!(self.editing_user,  "#{self.name} was updated")
        end
      end

      def record_activity!(user, text)
        return unless user
        self.activity_items.create(user_id: user.id, text: text)
      end
    end
  end
end
