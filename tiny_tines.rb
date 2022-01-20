# frozen_string_literal: true

require_relative 'story'
require 'json'

ACCEPTED_FORMATS = ['.json'].freeze

@story_file = ARGV[0]

private

def execute
  json = read_file(@story_file)
  story = Story.new(json)
  story.execute
end

def read_file(filename)
  unless ACCEPTED_FORMATS.include? File.extname(filename)
    abort("Please only select files with the extensions #{ACCEPTED_FORMATS}")
  end

  File.open(filename) do |file|
    JSON.parse(file.read)
  end
end

execute
