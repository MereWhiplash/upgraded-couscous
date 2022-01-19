# frozen_string_literal: true

require 'active_model'

class Action
  include ActiveModel::Validations

  VALID_OPTIONS = %w[url message].freeze
  VALID_TYPES = %w[HTTPRequestAction PrintAction].freeze

  validates_presence_of :type, :name, :options
  validate :validate_options, :validate_types
  attr_accessor :type, :name, :options

  def initialize(name, type, options)
    @name = name
    @type = type
    @options = options
  end

  private

  def validate_options
    errors.add(:base,  "Must have valid options of #{VALID_OPTIONS}") unless has_valid_options?
  end

  def validate_types
    errors.add(:base,  "Must have valid types of #{VALID_TYPES}") unless has_valid_type?
  end

  def has_valid_options?
    return false if @options.nil?

    (@options.keys - VALID_OPTIONS).empty?
  end

  def has_valid_type?
    VALID_TYPES.include?(@type)
  end
end
