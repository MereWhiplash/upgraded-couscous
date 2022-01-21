# frozen_string_literal: true

require_relative '../action'

RSpec.describe Action, '#Actions' do
  let(:name) { 'ActionName' }
  let(:type) { 'PrintAction' }
  let(:options) { { 'message' => 'Message Option' } }

  let(:action) { Action.new(name, type, options) }

  context '#validate' do
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

  context '#execute' do
    let(:params_with_values) do
      {
        'location.country' => 'Ireland',
        'location.city' => 'Naas',
        'location.latitude' => 53.2205654,
        'location.longitude' => -6.6593079,
        'sunset.results.sunset' => '6:15:42 PM'
      }
    end

    let(:options) do
      { 'message' => 'Sunset in {{location.city}}, {{location.country}} is at {{sunset.results.sunset}}.' }
    end

    context 'with params to with values for' do
      it 'should return the formatted message' do
        action.for_spec = true
        # output was not working here for some reason.
        expect(action.execute(params_with_values)).to eq('Sunset in Naas, Ireland is at 6:15:42 PM.')
      end
    end

    context 'with one missing param for value' do
      let(:params_with_values) do
        {
          'location.country' => 'Ireland',
          'location.latitude' => 53.2205654,
          'location.longitude' => -6.6593079,
          'sunset.results.sunset' => '6:15:42 PM'
        }
      end

      it 'should return the formatted message' do
        action.for_spec = true
        expect(action.execute(params_with_values)).to eq('Sunset in , Ireland is at 6:15:42 PM.')
      end
    end
  end
end
