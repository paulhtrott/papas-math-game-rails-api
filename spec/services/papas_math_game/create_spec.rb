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
      service = PapasMathGame::Create.new(3, 12)

      expect(service.execute).to eq(true)
      expect(service.random_numbers.size).to eq(3)
    end

    it'should set calculator values correctly' do
      service = PapasMathGame::Create.new(6, 132)

      expect(service.execute).to eq(true)
      expect(service.random_numbers.size).to eq(6)
      expect(service.calculator).to_not be_nil
      expect(service.calculator.array_of_numbers).to eq(service.random_numbers)
    end
  end
end
