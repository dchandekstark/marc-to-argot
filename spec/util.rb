require 'yaml'
require 'traject'
require 'marc_to_argot'
require 'yajl'

# Utilities for specs
module Util
  # utility method for loading MARC data for testing
  def find_marc(collection, file, extension = 'xml')
    data = File.expand_path('data', File.dirname(__FILE__))
    File.join(data, collection, "#{file}.#{extension}")
  end

  def load_json_multiple(json_data)
    records = []
    p = Yajl::Parser.new
    p.on_object_complete { |x| records << x}
    p.parse(data)
    records
  end

  # Loads a traject configuration
  module TrajectLoader
    def create_settings(collection, data_dir, extension)
      spec = MarcToArgot::SpecGenerator.new(collection)
      marc_source_type = extension == 'mrc' ? 'binary' : 'xml'
      flatten_attributes = YAML.load_file("#{data_dir}/flatten_attributes.yml")
      override = File.exist?("#{data_dir}/#{collection}/overrides.yml") ? YAML.load_file("#{data_dir}/#{collection}/overrides.yml") : []

      {
        'argot_writer.flatten_attributes' => flatten_attributes,
        'argot_writer.pretty_print' => false,
        'writer_class_name' => 'Traject::ArgotWriter',
        'specs' => spec.generate_spec,
        'processing_thread_pool' => 1,
        'marc_source.type' => marc_source_type,
        'marc_source.encoding' => 'utf-8',
        'override' => override
      }
    end

    def load_indexer(collection = 'argot', extension = 'xml')
      data_dir = File.expand_path('../lib/data',File.dirname(__FILE__))     
      conf_files = ["#{data_dir}/extensions.rb", "#{data_dir}/argot/traject_config.rb", "#{data_dir}/#{collection}/traject_config.rb"]
      indexer_class = MarcToArgot::Indexers.find(collection.to_sym)
      traject_indexer = indexer_class.new create_settings(collection, data_dir, extension)
      conf_files.each do |conf_path|
        begin
          traject_indexer.load_config_file(conf_path)
        rescue Errno::ENOENT, Errno::EACCES => e
          raise "Could not read configuration file '#{conf_path}', exiting..."
        rescue Traject::Indexer::ConfigLoadError => e
          raise e
        rescue StandardError => e
          raise e
        end
      end
      traject_indexer
    end
  end

  module TrajectRunTest
    include Util
    include Util::TrajectLoader

    # resets stdout and executes a block, returning
    # all output as a string
    def capture_stdout
      io = StringIO.new
      err_io = StringIO.new
      old_stdout = $stdout
      old_stderr = $stderr
      $stdout = io
      $stderr = err_io
      begin
        yield io
      ensure
        $stdout = old_stdout
        $stderr = old_stderr
      end
      io.string
    end

    def run_traject(collection, file, extension = 'xml')
      indexer = load_indexer(collection, extension)
      test_file = find_marc(collection, file, extension)
      capture_stdout do |_|
        indexer.process(File.open(test_file))
      end
    end

    # Runs traject and parses the results as JSON.
    def run_traject_json(collection, file, extension = 'xml')
      JSON.parse(run_traject(collection, file, extension))
    end
  end

  
end
