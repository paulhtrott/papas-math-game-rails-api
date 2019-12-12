
require 'test_helper'

class Api::V1::PapasMathGameControllerTest < ActionDispatch::IntegrationTest
  test 'should return game results on success' do
    get api_v1_papas_math_game_index_url

    assert_response :success

    game_response = JSON.parse(@response.body).deep_symbolize_keys

    assert_not_nil(game_response[:game])
    assert_not_nil(game_response[:game][:array_of_numbers])
    assert_not_nil(game_response[:game][:flattened_collection])
    assert_not_nil(game_response[:game][:combinations_used])
    assert_not_nil(game_response[:game][:calculated_values])
    assert_equal(game_response[:game][:operation], 'addition')
    assert_equal(game_response[:success], true)
  end
end
