# coding: utf-8
require 'spec_helper'

describe MarcToArgot do
  include Util::TrajectRunTest
  let(:py1) { run_traject_json('unc', 'pub_year1', 'mrc') }
  let(:py2) { run_traject_json('unc', 'pub_year2', 'mrc') }


  def create_rec
    rec = MARC::Record.new
    cf008val = ''
    40.times { cf008val << ' ' }
    rec << MARC::ControlField.new('008', cf008val)
    rec
  end
  
  context 'DateType = b' do
    context 'AND no 260/4 date' do
      it '(MTA) does not set date' do
        rec = create_rec
        val = rec['008'].value
        val[6] = 'b'
        val[7..10] = '1975'
        rec['008'].value = val
        argot = run_traject_on_record('unc', rec)
        expect(argot['publication_year']).to be_nil
      end
    end

    context 'AND 260/4 date' do
      it '(MTA) does not set date' do
        rec = create_rec
        val = rec['008'].value
        val[6] = 'b'
        val[7..10] = '1975'
        rec['008'].value = val
        rec << MARC::DataField.new('260', ' ',  ' ', ['c', '1999'])
        argot = run_traject_on_record('unc', rec)
        expect(argot['publication_year']).to eq([1999])
      end
    end
  end

  context 'DateType = q' do
    it '(MTA) halves the date range' do
      result = py1['publication_year']
      expect(result).to eq([1849])
    end
  end
  
  context 'DateType = m' do
    it '(MTA) sets using Date1' do
      result = py2['publication_year']
      expect(result).to eq([1967])
    end
  end

  it '(MTA) sets using Date1' do
    rec = create_rec
    val = rec['008'].value
    val[6] = 's'
    val[7..10] = '1975'
    rec['008'].value = val
    argot = run_traject_on_record('unc', rec)
    expect(argot['publication_year']).to eq([1975])
  end
end
           

