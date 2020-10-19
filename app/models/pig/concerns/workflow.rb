require 'active_support/concern'

module Pig
  module Concerns
    module Workflow
      extend ActiveSupport::Concern

      included do
        before_save :execute_transitions
      end

      class_methods do
        def statuses(user)
          statuses_for(user, self)
        end

        def check_ability(ability, instance, user)
          (ability || user).can? :manage, instance
        end

        def statuses_for(user, instance, ability = nil)
          statuses = {}
          statuses[:draft] = 'Draft' if check_ability(ability, instance, user)
          statuses[:pending] = 'Ready to review'
          if (instance.try(:status) == 'published' ||
              instance.try(:status) == 'update' ||
              instance.try(:status) == 'pending') &&
             check_ability(ability, instance, user)
            statuses[:update] = 'Needs updating'
          end
          statuses[:published] = 'Published' if check_ability(ability, instance, user)
          statuses[:expiring] = 'Getting old' if check_ability(ability, instance, user)
          statuses
        end

      end

      def statuses(user, ability)
        self.class.statuses_for(user, self, ability)
      end

      def execute_transitions
        execute_status_transition if saved_change_to_status?
        execute_author_transition if saved_change_to_author_id?
      end

      def execute_status_transition
        transitions = {
          draft: {
            pending: :ready_to_review,
            published: :notify_author_of_publish
          },
          pending: {
            draft: :assign_to_author,
            published: :notify_author_of_publish
          },
          published: {
            draft: :assign_to_author,
            published: :notify_author_of_publish,
            update: :notify_author_of_amends
          },
          update: {
            published: :notify_author_of_publish,
            pending: :ready_to_review
          },
          expiring: {}
        }
        event = transitions[status_before_last_save.to_sym][status.to_sym]
        send(event) if event
      end

      def execute_author_transition
        return if author.nil?
        assign_to_author
      end

      def notify_author_of_publish
        return if editing_user == last_edited_by
        return if last_edited_by.nil?
        ContentPackageMailer.published(self, last_edited_by).deliver_now
      end

      def ready_to_review
        self.last_edited_by_id = author_id
        self.author_id = nil
        return if requested_by.nil?
        ContentPackageMailer.assigned_for_review(self, requested_by).deliver_now
      end

      def assign_to_author
        return if @author_already_notified
        return if author.nil?
        ContentPackageMailer.assigned_for_writing(self, author).deliver_now
        @author_already_notified = true
      end

      def notify_author_of_amends
        return if @author_already_notified
        return if author.nil?
        ContentPackageMailer.assigned_for_updating(self, author).deliver_now
        @author_already_notified = true
      end
    end
  end
end
