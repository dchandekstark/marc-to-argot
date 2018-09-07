# coding: utf-8

require 'marc'

def get_record(file)
  case file
  when /\.xml/
    return MARC::XMLReader.new(file).first
  when/\.mrc/
    return MARC::Reader.new(file).first
  end
end

describe MARC::Record do
  describe 'has_008_position_value' do
    rec = get_record('spec/data/unc/access_type01.xml')
    it 'returns true if match' do
      result = rec.has_008_position_value?(23, 'o')
      expect(result).to be true
    end
    it 'returns false if no match' do
      result = rec.has_008_position_value?(23, 's')
      expect(result).to be false
    end

    rec3 = get_record('spec/data/unc/access_type03.xml')
    it 'returns nil if no 008' do
      result = rec3.has_008_position_value?(23, 'o')
      expect(result).to be nil
    end
  end

  
end
