module Pig
  module Concerns
    module Models
      module Core

        extend ::ActiveSupport::Concern

        included do
          scope :with_out, (lambda do |ids_or_records|
            array = [*ids_or_records].collect{|i| i.is_a?(Integer) ? i : i.try(:id)}.reject(&:nil?)
            array.empty? ? scoped : where(["#{table_name}.id NOT IN (?)", array])
            end)
        end

        def all_present?(*attrs)
          attrs.all? {|attr| send(attr).present?}
        end

        def any_present?(*attrs)
          attrs.any? {|attr| send(attr).present?}
        end

      end
    end
  end
end
