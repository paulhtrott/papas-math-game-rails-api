require 'rails_helper'

describe Api::V1::PapasMathGameController, type: :controller do
  describe '#index' do
    context 'success' do
      it 'should return game results on success' do
        get :index

        expect(response.status).to eq(200)

        game_response = JSON.parse(response.body).deep_symbolize_keys

        expect(game_response[:game]).to_not be_nil
        expect(game_response[:game][:array_of_numbers]).to_not be_nil
        expect(game_response[:game][:flattened_collection]).to_not be_nil
        expect(game_response[:game][:combinations_used]).to_not be_nil
        expect(game_response[:game][:calculated_values]).to_not be_nil
        expect(game_response[:game][:operation]).to eq('addition')
        expect(game_response[:success]).to eq(true)
      end
    end

    context 'false returned by service' do
      before do
        expect_any_instance_of(PapasMathGame::Create).to receive(:execute).and_return(false)
      end

      it 'should return 400' do
        get :index

        expect(response.status).to eq(400)
      end
    end
  end
end
