ActiveSupport.on_load(:active_record) do

  # backport 'case_sensitive_modifier' for AR 3.0.x connection adapters
  if ActiveRecord::VERSION::STRING.start_with?("3.0.")

    method_name = 'case_sensitive_modifier'

    if defined?(ActiveRecord::ConnectionAdapters::AbstractAdapter)

      abstract_adapter = ActiveRecord::ConnectionAdapters::AbstractAdapter
      unless abstract_adapter.instance_methods.collect(&:to_s).include?(method_name)
        abstract_adapter.class_eval do
          def case_sensitive_modifier(node)
            node
          end
        end
      end

      if defined?(ActiveRecord::ConnectionAdapters::MysqlAdapter)
        adapter = ActiveRecord::ConnectionAdapters::MysqlAdapter
        unless adapter.instance_methods.collect(&:to_s).include?(method_name)
          adapter.class_eval do
            def case_sensitive_modifier(node)
              Arel::Nodes::Bin.new(node)
            end
          end
        end
      end

      if defined?(ActiveRecord::ConnectionAdapters::Mysql2Adapter)
        adapter = ActiveRecord::ConnectionAdapters::Mysql2Adapter
        unless adapter.instance_methods.collect(&:to_s).include?(method_name)
          adapter.class_eval do
            def case_sensitive_modifier(node)
              Arel::Nodes::Bin.new(node)
            end
          end
        end
      end

    end

  end

end
