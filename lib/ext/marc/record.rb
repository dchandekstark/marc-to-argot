module MARC

  # Extending the Marc Record class to add some helpers
  class Record

    def uses_book_configuration_in_008?
      if leader.byteslice(6) =~ /[a]/ && leader.byteslice(7) =~ /[acdm]/
        true
      elsif leader.byteslice(6) == 't'
        true
      else
        false
      end
    end

    # returns 008/06 as string
    def date_type
      self['008'].value[6] if self['008']
    end

    # returns 008/7-10 as string
    def date1
      self['008'].value[7..10] if self['008']
    end

    # returns 008/7-10 as string
    def date2
      self['008'].value[11..14] if self['008']
    end

    # returns array of DataFields including all 260s and any 264s with i2 = 1
    def publication_statement_fields
      pub_fields = []
      each_by_tag('260') { |f| pub_fields << f }
      each_by_tag('264') { |f| pub_fields << f if f.indicator2 == '1'}
      return pub_fields
    end
  end
end
