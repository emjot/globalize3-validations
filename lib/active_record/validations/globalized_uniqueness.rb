module ActiveRecord
  module Validations

      class GlobalizedUniquenessValidator < ActiveModel::EachValidator

        def initialize(options)
          super(options.reverse_merge(:case_sensitive => true))
        end

        # Unfortunately, we have to tie Uniqueness validators to a class.
        def setup(klass)
          @klass = klass
        end

        def validate_each(record, attribute, value)
          finder_class = find_finder_class_for(record)
          table = finder_class.arel_table

          coder = record.class.serialized_attributes[attribute.to_s] # FIXME add/test support for serialized attributes with globalize3

          # determine table / attr_column_class respecting globalize3 translations
          globalized_column_class = find_globalized_column_class_for(record, attribute)
          globalized = globalized_column_class.present?
          if globalized
            attr_column_class = globalized_column_class
            table = attr_column_class.arel_table
          else
            attr_column_class = finder_class
          end

          if value && coder
            value = coder.dump value
          end

          # build relation respecting globalize3 translations
          relation = build_relation(attr_column_class, table, attribute, value)
          relation = relation.and(finder_class.arel_table[finder_class.primary_key.to_sym].not_eq(record.send(:id))) if record.persisted?

          Array.wrap(options[:scope]).each do |scope_item|
            if globalized && ([:locale] | record.class.translated_attribute_names).include?(scope_item)
              # handle globalize3 translated attribute scopes and :locale scope
              scope_value = if scope_item == :locale
                              Globalize.locale.to_s
                            else
                              record.read_attribute(scope_item)
                            end
              relation = relation.and(table[scope_item].eq(scope_value))
            else
              scope_value = record.read_attribute(scope_item)
              relation = relation.and(finder_class.arel_table[scope_item].eq(scope_value))
            end
          end

          # finalize building & execute query (respecting globalize3 translations)
          scoped = finder_class.unscoped
          scoped = scoped.joins(:translations) if globalized
          if scoped.where(relation).exists?
            record.errors.add(attribute, :taken, options.except(:case_sensitive, :scope).merge(:value => value))
          end
        end

      protected

        # The check for an existing value should be run from a class that
        # isn't abstract. This means working down from the current class
        # (self), to the first non-abstract class. Since classes don't know
        # their subclasses, we have to build the hierarchy between self and
        # the record's class.
        def find_finder_class_for(record) #:nodoc:
          class_hierarchy = [record.class]

          while class_hierarchy.first != @klass
            class_hierarchy.insert(0, class_hierarchy.first.superclass)
          end

          class_hierarchy.detect { |klass| !klass.abstract_class? }
        end

        # If the attribute of the record is globalized, returns the translation class; otherwise, returns nil.
        def find_globalized_column_class_for(record, attribute)
          class_hierarchy = [record.class]

          while class_hierarchy.first != @klass
            class_hierarchy.insert(0, class_hierarchy.first.superclass)
          end

          klass = class_hierarchy.detect { |klass| !klass.abstract_class? && klass.respond_to?(:translation_class) }

          if klass && record.class.translated_attribute_names.include?(attribute)
            klass.translation_class
          else
            nil
          end
        end

        def build_relation(klass, table, attribute, value) #:nodoc:
          column = klass.columns_hash[attribute.to_s]
          value = column.limit ? value.to_s.mb_chars[0, column.limit] : value.to_s if value && column.text?

          if !options[:case_sensitive] && value && column.text?
            # will use SQL LOWER function before comparison
            relation = table[attribute].lower.eq(table.lower(value))
          else
            value    = klass.connection.case_sensitive_modifier(value)
            relation = table[attribute].eq(value)
          end

          relation
        end
      end

      module ClassMethods
        # Validates whether the value of the specified attributes are unique across the system.
        # Useful for making sure that only one user
        # can be named "davidhh".
        #
        # See validates_uniqueness_of in ActiveRecord::Validations::ClassMethods for further explanation.
        #
        # This validator works the same, but additionally respects globalize3 model translations.
        # Also, you can use :locale as value for :scope.
        #
        # For instance, if you want to validate that a product title is unique in each locale:
        #
        #   class Product < ActiveRecord::Base
        #     translates :title
        #
        #     validates_globalized_uniqueness_of :title, :scope => :locale
        #   end
        def validates_globalized_uniqueness_of(*attr_names)
          validates_with GlobalizedUniquenessValidator, _merge_attributes(attr_names)
        end
      end

  end
end