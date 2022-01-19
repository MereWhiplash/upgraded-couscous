# frozen_string_literal: true

require_relative 'Action'
require 'json'

@story_file = ARGV[0]

ACCEPTED_FORMATS = ['.json'].freeze

private

def execute
  return puts 'Not a valid file format please use JSON' unless is_valid_format?

  json_file = File.open(@story_file)
  unparsed_actions = JSON.parse(json_file)
  actions = parse_actions(unparsed_actions)

  actions.each { |action| puts action.valid? }
end

def parse_actions(data)
  actions = data['actions'].map { |action| Action.new(action['name'], action['type'], action['options']) }
  actions.delete_if { |action| !action.valid? }
end

def is_valid_format?
  ACCEPTED_FORMATS.include? File.extname(@story_file)
end

execute
