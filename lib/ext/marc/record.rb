module MARC

  # Extending the Marc Record class to add some helpers
  class Record

    #########################
    # LDR-related checks -- record type
    #########################
    # Returns true if record type = Language Materials
    def lang_rec_type?
      self.leader.byteslice(6) == 'a'
    end

    # Returns true if record type = Manuscript Language Materials
    def manuscript_lang_rec_type?
      self.leader.byteslice(6) == 't'
    end

    # Returns true if record type = Computer file
    def computer_rec_type?
      self.leader.byteslice(6) == 'm'
    end

    #########################
    # LDR-related checks -- other
    #########################
    # returns true if record is coded as being under archival control
    def under_archival_control?
      self.leader.byteslice(8) == 'a'
    end

    #returns true if bib level is Collection or Subunit
    def has_archival_bib_level?
      %w[c d].include?(self.leader.byteslice(7))
    end

    #########################
    # 006-related checks
    #########################
    def has_lang_006?
      match006s = self.fields('006').select{ |f| f.value.byteslice(0) == 'a' }
      return true unless match006s.empty?
    end

    #########################
    # 008 workform type checks
    #########################
    # Does record use 008 definition for books?
    def has_book_008?
      if leader.byteslice(6) =~ /[a]/ && leader.byteslice(7) =~ /[acdm]/
        true
      elsif leader.byteslice(6) == 't'
        true
      else
        false
      end
    end

    #########################
    # 008 general checks
    #########################
    def has_008_position_value?(position, value)
      the008 = self['008']
      if the008 && the008.value.byteslice(position) == value
        true
      elsif the008.nil?
        nil
      else
        false
      end
    end

    #########################
    # other variable field-related checks
    #########################

    # Does record include a 336 that matches this regexp?
    def has_336_matching?(string_regexp)
      regexp = Regexp.new(string_regexp)
      match336s = self.fields('336').map{ |f| f.to_s.downcase }.select{ |f| regexp.match(f) }
      return true unless match336s.empty?
    end

    # Does record include this field?
    def has_field?(tag)
      field_array = self.fields(tag)
      if field_array.empty?
        false
      else
        true
      end
    end
    
  end
end
