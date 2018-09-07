module MarcToArgot
  module Macros
    module UNC
      module ResourceType
        include MarcToArgot::Macros::Shared::ResourceType

        def resource_type
          lambda do |rec, acc|
            acc.concat UncResourceTypeClassifier.new(rec).unc_formats
          end
        end

        class UncResourceTypeClassifier < ResourceTypeClassifier
          attr_reader :record
          
          def get_general_formats
            UncResourceTypeClassifier.new(record).formats
          end
          
          def unc_formats
            formats = get_general_formats
            if unc_archival?
              formats << 'Archival and manuscript material'
            end
            if unc_manuscript?
              formats = []
              formats << 'Archival and manuscript material'
            end
            if unc_text_corpus?
              formats.delete('Book')
              formats << 'Text corpus'
            end
            if unc_thesis_dissertation?
              formats.delete('Archival and manuscript material')
              formats.delete('Book')
              formats << 'Thesis/Dissertation'
              formats << 'Book' unless record.has_field?('502')
            end
            if unc_geospatial?
              formats << 'Dataset -- Geospatial'
            end
            if unc_statistical_data?
              formats << 'Dataset -- Statistical'
            end
            formats.uniq
          end

          def unc_archival?
            record.under_archival_control? && record.has_archival_bib_level?
          end

          def unc_manuscript?
            return true if record.manuscript_lang_rec_type? unless record.has_field?('502')
          end

          def unc_geospatial?
            true if has_iii_mattype_code?('7')
          end

          def unc_statistical_data?
            true if has_iii_mattype_code?('8')
          end

          def has_iii_mattype_code?(value)
            bib_meta = record.select{ |field| field.tag == '999' && field.indicator2 == '0' }.first
            if bib_meta
              if bib_meta['m'] == value
                true
              elsif bib_meta['m'].nil?
                nil
              else
                false
              end
            end
          end

          # Text corpus
          # LDR/06 = m AND 008/26 = d AND 006/00 = a AND 336 contains dataset or cod
          def unc_text_corpus?
            return true if (record.computer_rec_type? &&
                            record.has_008_position_value?(26, 'd') &&
                            record.has_lang_006? &&
                            record.has_336_matching?('dataset|cod')
                           )
          end
          
          # Thesis/Dissertation
          # LDR/06 = a AND 008/24-27(any) = m
          # OR
          # LDR/06 = t AND 008/24-27(any) = m
          # OR
          # 006/00 = a AND 006/07-10(any) = m
          def unc_thesis_dissertation?
            rec_type_match = record.manuscript_lang_rec_type? || record.lang_rec_type?
            nature_contents_match = record.fields('008').find do |field|
              (field.value.byteslice(24..27) || '').split('').include?('m')
            end

            marc_006_match_results = record.fields('006').collect do |field|
              %w[a].include?(field.value.byteslice(0)) &&
                (field.value.byteslice(7..10) || '').split('').include?('m')
            end

            return true if (rec_type_match && nature_contents_match) ||
                           marc_006_match_results.include?(true) ||
                           rec_type_match && record.has_field?('502')
          end


        end
      end
    end
  end
end
