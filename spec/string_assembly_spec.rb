# frozen_string_literal: true

require_relative '../helpers/string_assembly'

RSpec.describe StringAssembly do
  include StringAssembly

  context 'with balanced brackets' do
    let(:string) { 'Sunset in {{location.city}}, {{location.country}} is at {{sunset.results.sunset}}.' }
    let(:result) { %w[location.city location.country sunset.results.sunset] }

    it 'should return 3 params' do
      expect(extract_params(string)).to eq(result)
    end
  end

  context 'with unbalanced brackets' do
    let(:string) { 'Sunset in {{location.city}, {{location.country}} is at {{sunset.results.sunset}}.' }
    let(:result) { %w[location.country sunset.results.sunset] }

    it 'should return 2 params' do
      expect(extract_params(string)).to eq(result)
    end
  end
end
