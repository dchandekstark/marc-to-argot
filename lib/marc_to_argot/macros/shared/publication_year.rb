module MarcToArgot
  module Macros
    module Shared
      module PublicationYear

        def self.usable_date?(str, min, max)
          date = str.to_i
          return true if date == 9999
          return false unless date >= min
          return false unless date <= max
          true
        end

        def self.is_range?(str, type)
          case type
          when 'fixed_field'
            return true if str =~ /\d+u+/
            false
          when 'var_field'
            return true if str =~ /\d+-+/
            false
          end
        end
        
        def publication_year(options = {})
          min_year            = options[:min_year] || 500
          max_year            = options[:max_year] || (Time.new.year + 6)
          
          lambda do |rec, acc|
            date = set_publication_year(rec, min_year, max_year)
            acc << date if date
          end
        end

        class PublicationYearFinder
          attr_reader :year_found
          attr_reader :ff_date_type
          attr_reader :ff_date1
          attr_reader :ff_date2
          attr_reader :var_date
          attr_reader :min
          attr_reader :max

          def initialize(rec, min, max)
            @year_found = nil
            @min = min
            @max = max
            @ff_date_type = rec.date_type
            @ff_date1 = rec.date1
            @ff_date2 = rec.date2            
            return @year_found
          end
        end

        class FixedFieldDate
          attr_reader :orig
          attr_reader :is_range
          attr_reader :startdate
          attr_reader :enddate
          attr_reader :usedate

          def initialize(string, min, max)
            @orig = string.strip
            @is_range = MarcToArgot::Macros::Shared::PublicationYear.is_range?(@orig, 'fixed_field')
            if @is_range
              @startdate = @orig.gsub('u', '0').to_i
              @enddate = @orig.gsub('u', '9').to_i
              @usedate = (@startdate + @enddate)/2
            else
              @usedate = @orig.to_i
            end
          end


        end



          


      end

      
    end
  end
end


