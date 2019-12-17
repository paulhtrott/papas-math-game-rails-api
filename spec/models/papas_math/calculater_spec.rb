require 'rails_helper'

describe PapasMath::Calculator, type: :model do
  describe '#initialize' do
    it 'should initialize correctly, wioth empty array' do
      calculator = PapasMath::Calculator.new([])

      expect(calculator.numbers_to_choose_from).to eq([])
      expect(calculator.array_of_numbers).to eq([])
      expect(calculator.flattened_collection).to eq([])
      expect(calculator.combinations_used).to eq([])
      expect(calculator.calculated_values).to eq([])
      expect(calculator.operation).to be_nil
      expect(calculator.errors).to be_nil
    end

    it 'should initialize correctly with array of ints' do
      calculator = PapasMath::Calculator.new([1,2,3])

      expect(calculator.array_of_numbers).to eq([1,2,3])
      expect(calculator.flattened_collection).to eq([])
      expect(calculator.combinations_used).to eq([])
      expect(calculator.calculated_values).to eq([])
    end

  end

  describe '#execute' do
    it 'should set error and return false when not an array for array of numbers' do
      calculator = PapasMath::Calculator.new(12)

      expect(calculator.execute).to eq(false)
      expect(calculator.errors).to eq(['Calculator only works with arrays'])
    end

    it 'should return false and set errors when array of numbers empty' do
      calculator = PapasMath::Calculator.new([])

      expect(calculator.execute).to eq(false)
      expect(calculator.errors).to eq(['Calculator does not have any values to work on'])
    end

    it 'should set errors and return false when array of numbers empty after flatten, compact, map and removing zeros is empty' do
      calculator = PapasMath::Calculator.new(['house', 0, nil])

      expect(calculator.execute).to eq(false)
      expect(calculator.errors).to eq(['Calculator does not have any values to work on'])
    end

    it 'should return true and set operation to addition by default' do
      calculator = PapasMath::Calculator.new([1,2,3])

      expect(calculator.execute).to eq(true)
      expect(calculator.operation).to eq(:addition)
      expect(calculator.errors).to be_nil
    end

    it 'should set operation to addition by default, and set calculated values to correct values' do
      calculator = PapasMath::Calculator.new([1,2,3])

      expect(calculator.execute).to eq(true)
      expect(calculator.operation).to eq(:addition)
      expect(calculator.errors).to be_nil
      expect(calculator.calculated_values).to eq([3, 4, 5, 6])
    end

    it 'should return true and not remove duplicates' do
      calculator = PapasMath::Calculator.new([1, 2, 3, 3])

      expect(calculator.execute).to eq(true)
      expect(calculator.operation).to eq(:addition)
      expect(calculator.errors).to be_nil
      expect(calculator.calculated_values).to eq([3, 4, 4, 5, 5, 6, 6, 6, 7, 8, 9])
    end

    it 'should return true, and remove duplicates when set to true' do
      calculator = PapasMath::Calculator.new([1, 2, 3, 3])

      expect(calculator.execute(remove_duplicates: true)).to eq(true)
      expect(calculator.operation).to eq(:addition)
      expect(calculator.errors).to be_nil
      expect(calculator.calculated_values).to eq([3, 4, 5, 6, 7, 8, 9])
    end

    it 'should return true and set operation to multiplication when set' do
      calculator = PapasMath::Calculator.new([1, 2, 3])

      expect(calculator.execute(operation: :multiplication)).to eq(true)
      expect(calculator.operation).to eq(:multiplication)
      expect(calculator.errors).to be_nil
      expect(calculator.calculated_values).to eq([2, 3, 6, 6])
    end

    it 'should return true, does not sort calculated_values if sort set to false' do
      calculator = PapasMath::Calculator.new([1, 2, 3])

      expect(calculator.execute(operation: :multiplication, sort: false)).to eq(true)
      expect(calculator.operation).to eq(:multiplication)
      expect(calculator.errors).to be_nil
      expect(calculator.calculated_values).to eq([6, 2, 3, 6])
    end

    it 'should return true and strings set to 0 and removed' do
      calculator = PapasMath::Calculator.new([1, 2, 3, 'papa', 'game'])

      expect(calculator.execute).to eq(true)
      expect(calculator.errors).to be_nil
      expect(calculator.flattened_collection).to eq([1, 2, 3])
      expect(calculator.calculated_values).to eq([3, 4, 5, 6])
    end

    it 'should return true, and set how answers calculated (addition)' do
      calculator = PapasMath::Calculator.new([1, 2, 3, 'papa', 'game'])

      expect(calculator.execute).to eq(true)
      expect(calculator.errors).to be_nil
      expect(calculator.flattened_collection).to eq([1, 2, 3])
      expect(calculator.calculated_values).to eq([3, 4, 5, 6])
      expect(calculator.combinations_used).to eq(['1+2+3=6', '1+2=3', '1+3=4', '2+3=5'])
    end

    it 'should return true and set how answers calculated (multiplication)' do
      calculator = PapasMath::Calculator.new([1, 2, 3, 'papa', 'game'])

      expect(calculator.execute(operation: 'multiplication')).to eq(true)
      expect(calculator.errors).to be_nil
      expect(calculator.flattened_collection).to eq([1, 2, 3])
      expect(calculator.calculated_values).to eq([2, 3, 6, 6])
      expect(calculator.combinations_used).to eq(['1*2*3=6', '1*2=2', '1*3=3', '2*3=6'])
    end

    it 'should return true and set user message correctly' do
      allow_any_instance_of(PapasMath::Calculator).to receive(:rand).and_return(6)

      calculator = PapasMath::Calculator.new([5, 2, 3, 7])

      expect(calculator.execute).to eq(true)
      expect(calculator.errors).to be_nil
      expect(calculator.user_message).to eq("Figure out which 4 numbers were used to get the following answers. Options are from 1 to 13.")
    end

    it 'should return true and set numbers_to_choose_from correctly' do
      allow_any_instance_of(PapasMath::Calculator).to receive(:rand).and_return(5)

      calculator = PapasMath::Calculator.new([5, 2, 3, 7])

      expect(calculator.execute).to eq(true)
      expect(calculator.errors).to be_nil
      expect(calculator.numbers_to_choose_from).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
    end

    it 'should calculate as addition if operation requested does not exist' do
      calculator = PapasMath::Calculator.new([1, 2, 3])

      expect(calculator.execute(operation: :none_existent)).to eq(true)
      expect(calculator.errors).to be_nil
      expect(calculator.operation).to eq(:addition)
      expect(calculator.flattened_collection).to eq([1, 2, 3])
      expect(calculator.calculated_values).to eq([3, 4, 5, 6])
      expect(calculator.combinations_used).to eq(['1+2+3=6', '1+2=3', '1+3=4', '2+3=5'])
    end
  end
end
