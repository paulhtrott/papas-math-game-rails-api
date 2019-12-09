require 'test_helper'

class PapasMath::CalculatorTest < ActiveSupport::TestCase
  test 'empty initialize' do
    calculator = PapasMath::Calculator.new([])

    assert_equal(calculator.array_of_numbers, [])
    assert_equal(calculator.flattened_collection, [])
    assert_equal(calculator.combinations_used, [])
    assert_equal(calculator.calculated_values, [])
    assert_nil(calculator.operation)
    assert_nil(calculator.errors)
  end

  test 'set initialize' do
    calculator = PapasMath::Calculator.new([1,2,3])

    assert_equal(calculator.array_of_numbers, [1,2,3])
    assert_equal(calculator.flattened_collection, [])
    assert_equal(calculator.combinations_used, [])
    assert_equal(calculator.calculated_values, [])
  end

  test 'execute not an array for array of numbers, returns false, sets errors' do
    calculator = PapasMath::Calculator.new(12)

    assert_equal(calculator.execute, false)
    assert_equal(calculator.errors, ['Calculator only works with arrays'])
  end

  test 'execute, array of numbers empty, returns false, sets errors' do
    calculator = PapasMath::Calculator.new([])

    assert_equal(calculator.execute, false)
    assert_equal(calculator.errors, ['Calculator does not have any values to work on'])
  end

  test 'execute, array of numbers empty after flatten, compact, map and removing zeros' do
    calculator = PapasMath::Calculator.new(['house', 0, nil])

    assert_equal(calculator.execute, false)
    assert_equal(calculator.errors, ['Calculator does not have any values to work on'])
  end

  test 'execute, success, sets operation to addition by default' do
    calculator = PapasMath::Calculator.new([1,2,3])

    assert_equal(calculator.execute, true)
    assert_equal(calculator.operation, :addition)
    assert_nil(calculator.errors)
  end

  test 'execute, success, sets operation to addition by default, sets calculated values to correct values' do
    calculator = PapasMath::Calculator.new([1,2,3])

    assert_equal(calculator.execute, true)
    assert_equal(calculator.operation, :addition)
    assert_nil(calculator.errors)
    assert_equal(calculator.calculated_values, [3, 4, 5, 6])
  end

  test 'execute, success, does not remove duplicates' do
    calculator = PapasMath::Calculator.new([1, 2, 3, 3])

    assert_equal(calculator.execute, true)
    assert_equal(calculator.operation, :addition)
    assert_nil(calculator.errors)
    assert_equal(calculator.calculated_values, [3, 4, 4, 5, 5, 6, 6, 6, 7, 8, 9])
  end

  test 'execute, success, removes duplicates when set' do
    calculator = PapasMath::Calculator.new([1, 2, 3, 3])

    assert_equal(calculator.execute(remove_duplicates: true), true)
    assert_equal(calculator.operation, :addition)
    assert_nil(calculator.errors)
    assert_equal(calculator.calculated_values, [3, 4, 5, 6, 7, 8, 9])
  end

  test 'execute, success, set operation to multiplication when set' do
    calculator = PapasMath::Calculator.new([1, 2, 3])

    assert_equal(calculator.execute(operation: :multiplication), true)
    assert_equal(calculator.operation, :multiplication)
    assert_nil(calculator.errors)
    assert_equal(calculator.calculated_values, [2, 3, 6, 6])
  end

  test 'execute, success, does not sort calculated_values if sort set to false' do
    calculator = PapasMath::Calculator.new([1, 2, 3])

    assert_equal(calculator.execute(operation: :multiplication, sort: false), true)
    assert_equal(calculator.operation, :multiplication)
    assert_nil(calculator.errors)
    assert_equal(calculator.calculated_values, [6, 2, 3, 6])
  end

  test 'execute, success, names set to 0 and removed' do
    calculator = PapasMath::Calculator.new([1, 2, 3, 'papa', 'game'])

    assert_equal(calculator.execute, true)
    assert_nil(calculator.errors)
    assert_equal(calculator.flattened_collection, [1, 2, 3])
    assert_equal(calculator.calculated_values, [3, 4, 5, 6])
  end

  test 'execute, success, sets how answers calculated (addition)' do
    calculator = PapasMath::Calculator.new([1, 2, 3, 'papa', 'game'])

    assert_equal(calculator.execute, true)
    assert_nil(calculator.errors)
    assert_equal(calculator.flattened_collection, [1, 2, 3])
    assert_equal(calculator.calculated_values, [3, 4, 5, 6])
    assert_equal(calculator.combinations_used, ['1+2+3=6', '1+2=3', '1+3=4', '2+3=5'])
  end

  test 'execute, success, sets how answers calculated (multiplication)' do
    calculator = PapasMath::Calculator.new([1, 2, 3, 'papa', 'game'])

    assert_equal(calculator.execute(operation: 'multiplication'), true)
    assert_nil(calculator.errors)
    assert_equal(calculator.flattened_collection, [1, 2, 3])
    assert_equal(calculator.calculated_values, [2, 3, 6, 6])
    assert_equal(calculator.combinations_used, ['1*2*3=6', '1*2=2', '1*3=3', '2*3=6'])
  end
end
