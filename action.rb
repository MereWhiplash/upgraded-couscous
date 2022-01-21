# frozen_string_literal: true

require 'active_model'
require_relative 'helpers/network'
require_relative 'helpers/string_assembly'
# Actions are the core executable and model behaviours defined in the inputs.
class Action
  include ActiveModel::Validations
  include Network
  include StringAssembly

  VALID_OPTIONS = %w[url message].freeze
  VALID_TYPES = %w[HTTPRequestAction PrintAction].freeze

  validates_presence_of :type, :name, :options
  validate :validate_options, :validate_types
  attr_accessor :type, :name, :options, :for_spec

  # nasty workaround for spec bug with output(see readme.md)
  @for_spec = false

  def initialize(name, type, options)
    @name = name
    @type = type
    @options = options
  end

  def execute(params_with_values = [])
    run_action(params_with_values)
  end

  def requires_params?
    @options.each_value do |option|
      return true if option.include?('{{') || option.include?('}}')
    end

    false
  end

  def required_params
    params = []
    @options.each_value do |option|
      params << extract_params(option)
    end
    params
  end

  private

  def run_action(params_with_values)
    add_params_to_options(params_with_values) unless params_with_values.empty?

    case @type
    when 'HTTPRequestAction'
      response_data = http_request_action
      simple_dig(response_data)
    when 'PrintAction'
      message = options['message'].tr('{}', '')
      puts message

      return message if @for_spec

      []
    else
      p "Action not allowed, please use actions of types #{VALID_TYPES}"
    end
  end

  def add_params_to_options(params_with_values)
    @options.each { |key, value| @options[key] = add_values_to_string(params_with_values, value) }
  end

  def print_action; end

  def http_request_action
    JSON.parse(http_request(options['url']))
  end

  def validate_options
    errors.add(:base,  "Must have valid options of #{VALID_OPTIONS}") unless valid_options?
  end

  def validate_types
    errors.add(:base,  "Must have valid types of #{VALID_TYPES}") unless valid_type?
  end

  def valid_options?
    return false if @options.nil?

    (@options.keys - VALID_OPTIONS).empty?
  end

  def valid_type?
    VALID_TYPES.include?(@type)
  end

  # This was the failed attempts, I was trying to be cute by only looking for params that I know the story needs,
  # you can see other methods showing this approach in the class Im leaving it here because it should give an idea of
  # my thought process.
  # The REASON to go this way was I could short circuit once the params are filled since perhaps the data returned
  # could be bigger than the params the story needs. Finding the right approach was then a case of going
  # back to the requirements and internalising "(that must itself be a valid JSON key)", then it found home.
  # I normally dont comment this much IRL
  def dig_for_params(params_to_search_for, data)
    data_with_values = {}

    data.each_key do |data_key|
      next if params_for_key(data_key, params_to_search_for).blank?

      if data[data_key].is_a? Hash
        nested_hash = dig_for_params(params_to_search_for, data[data_key])
        data_with_values = nested_hash.merge(data_with_values) unless nested_hash.blank?
        next
      end

      candidate = params_for_key(data_key, params_to_search_for)
      data_with_values[candidate[0]] = data[candidate[1]] unless candidate.nil?
    end

    data_with_values
  end

  def simple_dig(data, keys = [])
    data_with_values = {}

    data.each do |key, value|
      if value.is_a? Hash
        keys << key
        data_with_values = data_with_values.merge(simple_dig(value, keys))
        keys = []
      elsif keys.blank?
        data_with_values[action_key + key] = value
      else
        data_with_values["#{action_key}#{keys.join('.')}.#{key}"] = value
      end
    end

    data_with_values
  end

  def params_for_key(key, params_to_search_for)
    params_to_search_for.each do |param|
      return [param, key] if param.include?(key)
    end
    nil
  end

  def action_key
    "#{@name}."
  end
end
