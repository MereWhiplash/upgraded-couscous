# frozen_string_literal: true

require_relative '../story'
require 'json'

RSpec.describe Story, '#Story' do
  let(:file) { File.open('test.json') }
  let(:json) { JSON.parse(file.read) }

  context 'with a few json values' do
    let(:story) { Story.new(json) }

    it 'should have 3 actions in the queue' do
      expect(story.actions.count).to eq(3)
      expect(story.queue.length).to eq(3)
    end
  end

  context 'with no actions' do
    let(:json) { '' }
    let(:story) { Story.new(json) }

    it 'should have no actions and the queue is empty' do
      expect(story.actions.count).to eq(0)
      expect(story.queue.length).to eq(0)
    end
  end
end
