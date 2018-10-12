require 'spec_helper'

describe MARC::Record do

  def create_rec
    rec = MARC::Record.new
    cf008val = ''
    40.times { cf008val << ' ' }
    rec << MARC::ControlField.new('008', cf008val)
    rec
  end

  describe '.date_type' do
    it 'returns DateType from 008' do
      rec = create_rec
      rec['008'].value[6] = 's'

      result = rec.date_type
      expect(result).to eq('s')
    end

    it 'fails gracefully if no 008' do
      rec = MARC::Record.new

      result = rec.date_type
      expect(result).to be_nil
    end

    it 'fails gracefully if 008 has no byte 06' do
      rec = MARC::Record.new
      rec << MARC::ControlField.new('008', '   ')
      result = rec.date_type
      expect(result).to be_nil
    end

  end

  describe '.date1' do
    it 'returns Date1 (bytes 7-10) from 008' do
      rec = create_rec
      rec['008'].value[7..10] = '2018'

      result = rec.date1
      expect(result).to eq('2018')
    end
  end

  describe '.date2' do
    it 'returns Date1 (bytes 11-14) from 008' do
      rec = create_rec
      rec['008'].value[11..14] = '2007'

      result = rec.date2
      expect(result).to eq('2007')
    end
  end

  describe '.publication_statement_fields' do
    it 'returns all 260s and any 264s with ind2 = 1' do
      rec = create_rec
      rec << (MARC::DataField.new( '260', '2', ' ', ['a', 'Paris :'], ['b', 'Larousse,'], ['c', '1972.']))
      rec << (MARC::DataField.new( '264', '3', '1', ['a', 'New York :'], ['b', 'Dover,'], ['c', '1987.']))
      rec << (MARC::DataField.new( '264', ' ', '2', ['a', 'New York :'], ['b', 'Distrib,'], ['c', '1999.']))
      pubfields = rec.publication_statement_fields
      dates = pubfields.map{ |f| f['c'] }
      expect(pubfields.length).to eq(2)
      expect(dates).to eq(['1972.', '1987.'])
    end
  end

end
