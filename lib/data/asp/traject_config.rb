################################################
# Primary ID
######
to_field "id", extract_marc(settings["specs"][:id], :first => true) do |rec, acc|
  acc.collect! {|s| "ASP#{s.delete("b.")}"}
end

################################################
# Local ID
######
to_field "local_id" do |rec, acc|
  primary = Traject::MarcExtractor.cached("907a").extract(rec).first
  primary = primary.delete(".") if primary

  local_id = {
    :value => primary,
    :other => []
  }

  # do things here for "Other"

  acc << local_id
end

################################################
# Catalog Date
######

to_field "cataloged_date", extract_marc("909")

################################################
# Items
# https://github.com/trln/extract_marcxml_for_argot_unc/blob/master/attached_record_data_mapping.csv
######
item_map = {
  :b => {
    :key => "item_id"
  },
  :c => {
    :key => "copy_no",
  },
  :d => {
    :key => "due_date",
  },
  :i => {
    :key => "ils_id",
  },
  :l => {
    :key => "loc_b",
    #:translation_map => "unc/locations_map",
  },
  :n => {
    :key => "notes",
  },
  :o => {
    :key => "checkouts",
  },
  :p => {
    :key => "cn_scheme",
  },
  :q => {
    :key => "call_no",
  },
  :s => {
    :key => "status",
    :translation_map => "unc/status_map"
  },
  :t => {
    :key => "type",
  },
  :v => {
    :key => "vol",
  }
}

to_field "items" do |rec, acc|

  Traject::MarcExtractor.cached("999", :alternate_script => false).each_matching_line(rec) do |field, spec, extractor|
    if field.indicator2 == "1"
      item = {}

      field.subfields.each do |subfield|
        code = subfield.code.to_sym
        if item_map.key?(code)
          if !item.key?(code)
              item[item_map[code][:key]] = []
          end
          # Translation map can't use a dash as a key, so change to string 'dash'
          if code == :s && subfield.value == "-"
            subfield.value = "dash"
          end
          #change dates to ISO8601
          if code == :d 
            subfield.value = Time.parse(subfield.value).utc.iso8601
          end
          #change checkouts to int
          if code == :o
            subfield.value = subfield.value.to_i
          end
          #remove vertical pipe-codes in call number
          if code == :q
            subfield.value = subfield.value.gsub(/\|[a-z]/,' ')
            subfield.value = subfield.value.strip
          end
          
          item[item_map[code][:key]] << subfield.value

          if item_map[code][:translation_map]
            translation_map = Traject::TranslationMap.new(item_map[code][:translation_map])
            translation_map.translate_array!(item[item_map[code][:key]])
          end
        end
      end

      if item["call_number_scheme"] and item["call_number_scheme"].first == "090"
        item["lcc_top"] = [item["call_number"].first[0,1]]
      end

    end

    acc << item.each_key {|x| item[x] = item[x].join(';')  } if item

  end
end
