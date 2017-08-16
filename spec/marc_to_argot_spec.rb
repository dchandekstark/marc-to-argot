require 'spec_helper'
require 'util'
require 'marc_to_argot'
require 'json'

describe MarcToArgot do
  class TrajectRunTest 
    def self.run_traject(collection, file, extension = 'xml')
      indexer = Util::TrajectLoader.load(collection)
      test_file = Util.find_marc(collection, file, extension)
      Util.capture_stdout do |_|
        indexer.process(File.open(test_file))
      end
    end
  end

  it 'has a version number' do
    expect(MarcToArgot::VERSION).not_to be nil
  end

  it 'loads base spec successfully' do
    spec = MarcToArgot::SpecGenerator.new('argot')
    result = spec.generate_spec
    expect(result).to be_kind_of(Hash)
    expect(result).not_to be_empty
    expect(result['id']).to eq('001')
  end

  it 'loads NCSU spec without a problem' do
    spec = MarcToArgot::SpecGenerator.new('ncsu')
    result = spec.generate_spec
    expect(result['id']).to eq('918a')
  end

  it 'generates base results for NCSU' do
    result = TrajectRunTest.run_traject('ncsu', 'base')
    expect(result).not_to be_empty
  end

  it 'generates base results for DUke' do
    expect(true).to be(false)
  end

  it 'generates base results for UNC' do
    expect(true).to be(false)
  end
end
