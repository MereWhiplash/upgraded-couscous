# frozen_string_literal: true

require 'active_model'
require_relative 'action'
# This is a queue that will process a definition which is a collection of Actions, it maintains a
# data bank of past params it required to complete the story, the bank is continually update as the actions progress.
class Story
  include ActiveModel::Validations

  validates_presence_of :actions, :queue, :story_params
  attr_accessor :actions, :queue, :story_params

  def initialize(data)
    @actions = parse_actions(data)

    @queue = Queue.new
    @story_params = []

    @actions.each do |action|
      @story_params << action.required_params if action.requires_params?

      @queue << action
    end
  end

  def execute
    return if @queue.empty? || @actions.empty?

    data_bank = {}

    until @queue.empty?
      action = queue.pop

      new_data = action.execute(@story_params.flatten, data_bank)
      data_bank = data_bank.merge(new_data) unless @queue.empty? || new_data.blank?
    end
  end

  private

  def parse_actions(data)
    return [] if data.blank?

    actions = data['actions'].map { |action| Action.new(action['name'], action['type'], action['options']) }
    actions.delete_if { |action| !action.valid? }
  end
end
