# frozen_string_literal: true

require_relative '../action'

RSpec.describe Action, '#Actions' do
  let(:name) { 'ActionName' }
  let(:type) { 'PrintAction' }
  let(:options) { { 'message' => 'Message Option' } }

  let(:action) { Action.new(name, type, options) }

  context 'with required params' do
    it 'is valid' do
      expect(action.valid?).to eq true
    end
  end

  context 'without required params' do
    context 'like name' do
      let(:name) { nil }

      it 'is not valid' do
        expect(action.valid?).to eq false
      end
    end

    context 'like type' do
      let(:type) { nil }

      it 'is not valid' do
        expect(action.valid?).to eq false
      end
    end

    context 'like options' do
      let(:options) { nil }

      it 'is not valid' do
        expect(action.valid?).to eq false
      end
    end
  end
end
