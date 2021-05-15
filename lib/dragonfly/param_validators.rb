module Dragonfly
  module ParamValidators
    class InvalidParameter < RuntimeError; end

    module_function

    IS_NUMBER = ->(param) {
      param.is_a?(Numeric) || /\A[\d\.]+\z/ === param
    }

    def is_number; IS_NUMBER; end

    def validate!(parameter, &validator)
      return if parameter.nil?
      raise InvalidParameter unless validator.(parameter)
    end

    def validate_all!(parameters, &validator)
      parameters.each { |p| validate!(p, &validator) }
    end
  end
end
