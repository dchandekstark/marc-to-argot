# coding: utf-8
require 'spec_helper'

describe MarcToArgot do
  include Util::TrajectRunTest
  let(:py1) { run_traject_json('unc', 'pub_year1', 'mrc') }
  let(:py2) { run_traject_json('unc', 'pub_year2', 'mrc') }
  
  context 'DateType = q' do
    it '(MTA) halves the date range' do
      result = py1['publication_year']
      expect(result).to eq(
                          [
                            1849
                          ]
                        )
    end
  end
  
  context 'DateType = m' do
    it '(MTA) sets using Date1' do
      result = py2['publication_year']
      expect(result).to eq(
                          [
                            1967
                          ]
                        )
    end
  end
end

