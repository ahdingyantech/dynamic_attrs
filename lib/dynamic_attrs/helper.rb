class DynamicAttr
  module Owner
    module Helper
      class << self
        def _to_string(str)
          str.to_s
        end

        def _to_datetime(str)
          str.to_datetime
        end

        def _to_boolean(str)
          {true: true, false: false}[str.to_sym]
        end

        def _to_integer(str)
          str.to_i
        end
      end
    end
  end
end
