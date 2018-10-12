module MarcToArgot
  module Macros
    module Shared
      module PublicationYear

        def usable_date?(str, min, max)
          date = str.to_i
          return true if date == 9999
          return false unless date >= min
          return false unless date <= max
          true
        end

        def is_range?(str, type)
          case type
          when 'fixed_field'
            return true if str =~ /\d+u+/
            false
          when 'var_field'
            return true if str =~ /\d+-+/
            false
          end
        end

        # valid_9999 = true if 9999 is an acceptable/desired date to assign
        # otherwise, valid_9999 = false
        def choose_ff_date(preferred_date, fallback_date, valid_9999)
          chosen_year = preferred_date
          chosen_year = nil if chosen_year == 9999 && valid_9999 == false
          chosen_year = fallback_date if chosen_year == nil
          chosen_year = nil if chosen_year == 9999 && valid_9999 == false
          return chosen_year
        end

        # if both dates are usable as a range, returns midpoint between them
        # if both dates are usable, but not usable as range, return date1
        # if one but not both of the dates is usable, return it
        def midpoint_or_usable(date1, date2)
          return date1 if date2 == 9999
          return (date1 + date2)/2 if date1 && date2 && date2 > date1
          return date1 if date1 && date2 && date2 <= date1
          return date1 if date1
          return date2 if date2
          return nil
        end

        def get_fixed_field_date(string, min, max)
          orig = string.strip
          if is_range?(orig, 'fixed_field')
            startdate = orig.gsub('u', '0').to_i
            enddate = orig.gsub('u', '9').to_i
            usedate = (startdate + enddate)/2
          else
            usedate = orig.to_i
          end
          usedate = nil unless usable_date?(usedate, min, max)
          return usedate
        end
        
        def publication_year(options = {})
          min_year            = options[:min_year] || 500
          max_year            = options[:max_year] || (Time.new.year + 6)
          
          lambda do |rec, acc|
            date = set_year_from_008(rec, min_year, max_year)
            acc << date if date
          end
        end

          def set_year_from_008(rec, min, max)
            min = min
            max = max
            ff_date_type = rec.date_type
            ff_date1 = get_fixed_field_date(rec.date1, min, max)
            ff_date2 = get_fixed_field_date(rec.date2, min, max)

            case ff_date_type
            when 'b'
              year_found = nil
            when 'c'
              year_found = ff_date2
            when 'e'
              year_found = ff_date1
            when 'i'
              year_found = ff_date1
            when 'k'
              year_found = ff_date1
            when 'm'
              year_found = choose_ff_date(ff_date2, ff_date1, false)
            when 'n'
              year_found = midpoint_or_usable(ff_date1, ff_date2)
            when 'p'
              year_found = choose_ff_date(ff_date2, ff_date1, false)
            when 'q'
              year_found = midpoint_or_usable(ff_date1, ff_date2)
            when 'r'
              year_found = choose_ff_date(ff_date2, ff_date1, false)
            when 's'
              year_found = ff_date1
            when 't'
              year_found = ff_date1
            when 'u'
              year_found = choose_ff_date(ff_date2, ff_date1, true)
            end
            return year_found
          end
      end
    end
  end
end


