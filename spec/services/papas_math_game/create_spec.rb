require 'rails_helper'

describe PapasMathGame::Create do
  describe '#initialize' do
    it 'should initialize defaults' do
      service = PapasMathGame::Create.new

      expect(service.number_count).to eq(5)
      expect(service.max_range).to eq(101)
      expect(service.random_numbers).to eq([])
      expect(service.operation).to eq(:addition)
    end

    it 'should initialize with correct values' do
      service = PapasMathGame::Create.new(15, 10, :multiplication)

      expect(service.number_count).to eq(15)
      expect(service.max_range).to eq(11)
      expect(service.random_numbers).to eq([])
      expect(service.operation).to eq(:multiplication)
    end

    it 'should set number_count correctly with number_count over 15' do
      service = PapasMathGame::Create.new(51, 15, :multiplication)

      expect(service.number_count).to eq(15)
      expect(service.max_range).to eq(16)
      expect(service.random_numbers).to eq([])
      expect(service.operation).to eq(:multiplication)
    end
  end

  describe '#execute' do
    it 'should set random numbers correctly' do
      expect_any_instance_of(PapasMathGame::Create).to receive(:rand).and_return(2, 9, 6)
      allow_any_instance_of(PapasMath::Calculator).to receive(:rand).and_return(5)

      service = PapasMathGame::Create.new(3, 12)

      expect(service.execute).to eq(true)
      expect(service.number_count).to eq(3)
      expect(service.random_numbers.size).to eq(3)
      expect(service.random_numbers).to eq([2, 9, 6])
      expect(service.max_range).to eq(13)
    end

    it'should set calculator values correctly' do
      expect_any_instance_of(PapasMathGame::Create).to receive(:rand).and_return(2, 9, 6, 7, 53, 12)
      allow_any_instance_of(PapasMath::Calculator).to receive(:rand).and_return(5)

      service = PapasMathGame::Create.new(6, 132)

      expect(service.execute).to eq(true)
      expect(service.random_numbers.size).to eq(6)
      expect(service.random_numbers).to eq([2, 9, 6, 7, 53, 12])
      expect(service.calculator.array_of_numbers).to eq([2, 9, 6, 7, 53, 12])
      expect(service.calculator.flattened_collection).to eq([2, 6, 7, 9, 12, 53])
      expect(service.calculator.numbers_to_choose_from).to eq((1..58).to_a)
    end
  end
end
