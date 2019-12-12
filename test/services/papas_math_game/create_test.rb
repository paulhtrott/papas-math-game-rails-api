require 'test_helper'

class PapasMathGame::CreateTest < ActiveSupport::TestCase
  test 'initialize defaults' do
    service = PapasMathGame::Create.new

    assert_equal(service.number_count, 5)
    assert_equal(service.max_range, 101)
    assert_equal(service.random_numbers, [])
    assert_equal(service.operation, :addition)
  end

  test 'initialize' do
    service = PapasMathGame::Create.new(15, 10, :multiplication)

    assert_equal(service.number_count, 15)
    assert_equal(service.max_range, 11)
    assert_equal(service.random_numbers, [])
    assert_equal(service.operation, :multiplication)
  end

  test 'initialize, with number_count over 15' do
    service = PapasMathGame::Create.new(51, 15, :multiplication)

    assert_equal(service.number_count, 15)
    assert_equal(service.max_range, 16)
    assert_equal(service.random_numbers, [])
    assert_equal(service.operation, :multiplication)
  end

  test 'execute sets random numbers correctly' do
    service = PapasMathGame::Create.new(3, 12)

    assert_equal(service.execute, true)
    assert_equal(service.random_numbers.size, 3)
  end

  test 'execute sets calculator values correctly' do
    service = PapasMathGame::Create.new(6, 132)

    assert_equal(service.execute, true)
    assert_equal(service.random_numbers.size, 6)
    assert_not_nil(service.calculator)
    assert_equal(service.calculator.array_of_numbers, service.random_numbers)
  end
end
