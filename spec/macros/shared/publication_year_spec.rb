# coding: utf-8
require 'spec_helper'

describe MarcToArgot::Macros::Shared::PublicationYear do
  #  describe PublicationYearFinder do
  #  end

  def make_rec
    rec = MARC::Record.new
    rec << MARC::ControlField.new('008', ' ' * 40)
  end

  describe 'usable_date?' do
    it 'returns true if 4 digits and in range' do
      v = MarcToArgot::Macros::Shared::PublicationYear.usable_date?('1997', 500, 2024)
      expect(v).to eq(true)
    end

    it 'returns true if fewer than 4 digits, but in range' do
      v = MarcToArgot::Macros::Shared::PublicationYear.usable_date?('666 ', 500, 2024)
      expect(v).to eq(true)
    end

    it 'returns false if 4 digits and out of range' do
      v = MarcToArgot::Macros::Shared::PublicationYear.usable_date?('6754', 500, 2024)
      expect(v).to eq(false)
    end

    it 'returns false if uuuu' do
      v = MarcToArgot::Macros::Shared::PublicationYear.usable_date?('uuuu', 500, 2024)
      expect(v).to eq(false)
    end

    it 'returns true if 9999' do
      v = MarcToArgot::Macros::Shared::PublicationYear.usable_date?('9999', 500, 2024)
      expect(v).to eq(true)
    end
  end

  describe 'is_range?' do
    it 'works for fixed field u dates' do
      v1 = MarcToArgot::Macros::Shared::PublicationYear.is_range?('1997', 'fixed_field')
      v2 = MarcToArgot::Macros::Shared::PublicationYear.is_range?('199u', 'fixed_field')
      v3 = MarcToArgot::Macros::Shared::PublicationYear.is_range?('19uu', 'fixed_field')
      v4 = MarcToArgot::Macros::Shared::PublicationYear.is_range?('uuuu', 'fixed_field')
      v5 = MarcToArgot::Macros::Shared::PublicationYear.is_range?('198|', 'fixed_field')
      v6 = MarcToArgot::Macros::Shared::PublicationYear.is_range?('66u|', 'fixed_field')
      expect(v1).to eq(false)
      expect(v2).to eq(true)
      expect(v3).to eq(true)
      expect(v4).to eq(false)
      expect(v5).to eq(false)
      expect(v6).to eq(true)
    end
    
    it 'works for variable field u dates' do
      v1 = MarcToArgot::Macros::Shared::PublicationYear.is_range?('1997', 'var_field')
      v2 = MarcToArgot::Macros::Shared::PublicationYear.is_range?('199-', 'var_field')
      v3 = MarcToArgot::Macros::Shared::PublicationYear.is_range?('19--', 'var_field')
      v4 = MarcToArgot::Macros::Shared::PublicationYear.is_range?('1---', 'var_field')
      v5 = MarcToArgot::Macros::Shared::PublicationYear.is_range?('198?', 'var_field')
      expect(v1).to eq(false)
      expect(v2).to eq(true)
      expect(v3).to eq(true)
      expect(v4).to eq(true)
      expect(v5).to eq(false)
    end
  end

  describe 'FixedFieldDate' do
    describe '.new' do
      it 'retains stripped original value in orig' do
        ffd = MarcToArgot::Macros::Shared::PublicationYear::FixedFieldDate.new('123 ', 500, 2024)
        expect(ffd.orig).to eq('123')
      end

      it 'sets is_range to true or false' do
        r1 = MarcToArgot::Macros::Shared::PublicationYear::FixedFieldDate.new('1997', 500, 2024)
        expect(r1.is_range).to eq(true).or eq(false)
      end

      it 'populates range start and end values' do
        r1 = MarcToArgot::Macros::Shared::PublicationYear::FixedFieldDate.new('19uu', 500, 2024)
        expect(r1.startdate).to eq(1900)
        expect(r1.enddate).to eq(1999)
        r2 = MarcToArgot::Macros::Shared::PublicationYear::FixedFieldDate.new('6uu|', 500, 2024)
        expect(r2.startdate).to eq(600)
        expect(r2.enddate).to eq(699)
      end

      it 'populates usedate for range' do
        r1 = MarcToArgot::Macros::Shared::PublicationYear::FixedFieldDate.new('19uu', 500, 2024)
        expect(r1.usedate).to eq(1949)
      end

      it 'populates usedate for non-range' do
        r1 = MarcToArgot::Macros::Shared::PublicationYear::FixedFieldDate.new('666', 500, 2024)
        expect(r1.usedate).to eq(666)
      end
    end
  end
end
