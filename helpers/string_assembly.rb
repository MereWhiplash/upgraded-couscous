# frozen_string_literal: true

# Naming this module broke me
module StringAssembly
  def extract_params(string)
    strings = string.scan(/{{.*?}}/)
    strings.map { |param| param.tr('{}', '') }
  end

  def add_values_to_string(values, string)
    required_values = extract_params(string)
    required_values.each do |required_value|
      string = string.gsub(required_value, values[required_value].to_s)
    end
    string
  end
end
