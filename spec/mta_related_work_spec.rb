# coding: utf-8
require 'spec_helper'

describe MarcToArgot do
  include Util::TrajectRunTest
  let(:related_work_mirror_included) { run_traject_json('unc', 'related_work_mirror_included', 'mrc') }
  let(:related_work_addtl_7XX) { run_traject_json('unc', 'related_work_addtl_7XX', 'mrc') }
  let(:related_work_linking_fields) { run_traject_json('unc', 'related_work_linking_fields', 'mrc') }
    let(:related_work_vern1) { run_traject_json('unc', 'related_work_vern1', 'mrc') }  

  it '(MTA) sets related_work_from_700_710_711_730_740' do
    result = related_work_mirror_included['related_work']
    expect(result).to eq(
                        [{'type'=>'related',
                          'author'=>'Saint-SaÃ«ns, Camille, 1835-1921.',
                          'title'=>['Quartets,', 'violins (2), viola, cello,', 'no. 2, op. 153,', 'G major']},
                         {'type'=>'related',
                          'author'=>'Schwenkel, Christina.',
                          'title'=>['Architecture and dwelling in the \'war of destruction\' in Vietnam.']},
                         {'type'=>'related',
                          'label'=>'Facsimile of',
                          'author'=>'Ferrini, Vincent, 1913-2007.',
                          'title'=>['Tidal wave : poems of the great strikes.', '1945', '(New York : Great-Concord Publishers)']},
                         {'type'=>'related',
                          'label'=>'Tome 1, volume 1: Contains',
                          'author'=>'Plotinus.',
                          'title'=>['Peri tou kalou.', 'French', '(Achard and Narbonne)']},
                         {'type'=>'related',
                          'author'=>'Name, Author, (Test name), 1944-.',
                          'title'=>['Test title.']},
                         {'type'=>'related',
                          'author'=>'Kungliga Biblioteket (Sweden).',
                          'title'=>['Manuscript.', 'KB787a.', 'Church Slavic.', '1966.']},
                         {'type'=>'related',
                          'author'=>'United States. Congress (94th, 2nd session : 1976).',
                          'title'=>['Memorial services held in the House of Representatives and Senate of the United States, together with remarks presented in eulogy of Jerry L. Litton, late a Representative from Missouri.', '197.']},
                         {'type'=>'related',
                          'author'=>'North Carolina. Building Code Council.',
                          'title'=>['North Carolina state building code.', '1,', 'General construction.', '11X,', 'Making buildings and facilities accessible to and usable by the physically handicapped.']},
                         {'type'=>'related',
                          'author'=>'Germany (East).',
                          'title'=>['Treaties, etc.', 'Germany (West),', '1990 May 18.', '1990.']},
                         {'type'=>'related',
                          'author'=>'CafÃ© Tacuba (Musical group)',
                          'title'=>['12/12']},
                         {'type'=>'related',
                          'author'=>'Great Central Fair for the U.S. Sanitary Commission (1864 : Philadelphia, Pa.). Committee on Public Charities and Benevolent Institutions.',
                          'title'=>['Philadelphia [blank] 1864. 619 Walnut Street. To [blank] ...']},
                         {'type'=>'related',
                          'author'=>'Deutsch Foundation Conference (1930 : University of Chicago).',
                          'title'=>['Care of the aged.', '2000,', '1972.', 'Reprint.'],
                          'issn'=>'1234-1234'},
                         {'type'=>'related',
                          'title'=>['Cahiers de civilisation mÃ©diÃ©vale.', 'Bibliographie.'],
                          'issn'=>'0240-8678'},
                         {'type'=>'related',
                          'title'=>['Jane Pickering\'s lute book.', 'arr.'],
                          'title_variation'=>'Drewries Accord\'s;'},
                         {'type'=>'related',
                          'label'=>'Contains',
                          'title'=>['Magnificent Ambersons (Motion picture).', 'Spanish.']},
                         {'type'=>'related',
                          'label'=>'Contains',
                          'title'=>['Magnificent Ambersons (Motion picture).', 'English.'],
                          'title_nonfiling'=>'The magnificent Ambersons (Motion picture). English.'},
                         {'type'=>'related',
                          'label'=>'Guide: Based on',
                          'title'=>['Deutsche Geschichte.', 'Band 6.']},
                         {'type'=>'related',
                          'title'=>['English pilot.', 'The fourth book : describing the West India navigation, from Hudson\'s-Bay to the river Amazones ...'],
                          'title_nonfiling'=>'The English pilot. The fourth book : describing the West India navigation, from Hudson\'s-Bay to the river Amazones ...'},
                         {'type'=>'related',
                          'title'=>['Industrial sales management game', '5.']}
                        ]
                      )
  end

  it '(MTA) sets related_work_from_700_710_711_730_740 additional' do
    result = related_work_addtl_7XX['related_work']
    expect(result).to eq(
                        [{'type'=>'related',
                          'label'=>'Facsimile of',
                          'author'=>'Mozart, Wolfgang Amadeus, 1756-1791.',
                          'title'=>['Concertos,', 'violin, orchestra,', 'K. 219,', 'A major.', 'Library of Congress. Music Division : ML30.8b .M8 K. 219 Case.']},
                         {'type'=>'related',
                          'label'=>'Facsimilie of',
                          'author'=>'Conservatoire royal de musique de Bruxelles. BibliothÃ¨que.',
                          'title'=>['Manuscript.', '16.662.']},
                         {'type'=>'related',
                          'label'=>'Facsimilie of',
                          'author'=>'Conservatoire royal de musique de Bruxelles. BibliothÃ¨que.',
                          'title'=>['Manuscript.', '16.663.']},
                         {'type'=>'related',
                          'author'=>'Westminster Assembly (1643-1652).',
                          'title'=>['Shorter catechism.', '1809.']}
                        ]
                      )
  end

  it '(MTA) sets related_work from 76X-78X linking fields' do
    result = related_work_linking_fields['related_work']
    expect(result).to eq(
                        [{'type'=>'translation_of',
                          'author'=>'China.',
                          'title'=>['Laws, etc.', '(Zhonghua Renmin Gongheguo fa lÃ¼ hui bian).'],
                          'title_variation'=>'Zhonghua Renmin Gongheguo fa lÃ¼ hui bian',
                          'other_ids'=>['90645849']},
                         {'type'=>'translation_of',
                          'label'=>'Originally published in France as',
                          'title'=>['Innovations mÃ©dicales en situations humanitaires.'],
                          'details'=>'Paris : Harmattan, c2009',
                          'isbn'=>['9782296100466'],
                          'other_ids'=>['465089061']},
                         {'type'=>'translation_of',
                          'title'=>['Itogi nauki i tekhniki. Seriï¸ iï¸¡a Sovremennye problemy matematiki. FundamentalÊ¹nye napravleniï¸ iï¸¡a'],
                          'issn'=>'0233-6723',
                          'other_ids'=>['87645715', '14198545'],
                          'display'=>'false'},
                         {'type'=>'translated_as',
                          'label'=>'German version',
                          'title'=>['Wissenschaftliche Mitteilungen des Bosnisch-Herzegowinischen Landesmuseums.', 'Heft A, ArchÃ¤ologie'],
                           'issn'=>'0352-1990',
                           'other_ids'=>['2010223203', '4818533']},
                         {'type'=>'has_supplement',
                          'label'=>'Supplement',
                          'title'=>['Insect pest survey.', 'Special supplement'],
                          'other_ids'=>['1032826279']},
                         {'type'=>'has_supplement',
                          'title'=>['Baking equipment'],
                          'details'=>'1979-Dec. 1987',
                          'other_ids'=>['15639544']},
                         {'type'=>'has_supplement',
                          'title'=>['French review. Special issue'],
                          'issn'=>'0271-3349',
                          'display'=>'false'},
                         {'type'=>'supplement_to',
                          'title'=>['Furnace-type lumber dry-kiln'],
                          'details'=>'Report number: Report R1474',
                          'other_ids' => ["Report R1474"]},
                         {'type'=>'supplement_to',
                          'title'=>['Bunka jinruigaku'],
                          'other_ids'=>['2005222403', '55991441'],
                          'display'=>'false'},
                         {'type'=>'supplement_to',
                          'label'=>'Parent item',
                          'author'=>'Knowlton, Frank Hall, 1860-1926.',
                          'title'=>['Catalogue of the Mesozoic and Cenozoic plants of North America'],
                          'other_ids'=>['670360522']},
                         {'type'=>'host_item',
                          'label'=>'Detached from',
                          'title'=>['Gentleman\'s magazine', '(London, England :', '1868)'],
                          'title_variation'=>'Gentleman\'s magazine.',
                          'details'=>'Vol. 12 (Apr. 1874)',
                          'other_ids'=>['7898234']},
                         {'type'=>'host_item',
                          'label'=>'Pt 1: Detached from',
                          'title'=>['Gentleman\'s magazine', '(London, England :', '1868)'],
                          'title_variation'=>'Gentleman\'s magazine.',
                          'details'=>'Vol. 12 (Apr. 1874)',
                          'other_ids'=>['7898234']},
                         {'type'=>'host_item',
                          'label'=>'Pt. 1',
                          'title'=>['Gentleman\'s magazine', '(London, England :', '1868)'],
                          'title_variation'=>'Gentleman\'s magazine.',
                          'details'=>'Vol. 12 (Apr. 1874)',
                          'other_ids'=>['7898234']},
                         {'type'=>'host_item',
                          'author'=>'National Academy of Sciences (U.S.).',
                          'title'=>['Biographical memoirs.'],
                          'title_nonfiling'=>'Biogr. mem.',
                          'details'=>'Washington, National Academy of Sciences, 1938. 23 cm. vol. XVIII, 7th memoir, 1 p. l., p. 157-174. front. (port) CODEN: BMNSAC',
                          'issn'=>'0077-2933',
                          'other_ids'=>['BMNSAC', '1759017']},
                         {'type'=>'host_item',
                          'title'=>['Department of Health Behavior and Health Education Master\'s Papers and Community Diagnosis Projects, 1947-2015.'],
                          'other_ids'=>['989732850'],
                          'display'=>'false'},
                         {'type'=>'alt_edition',
                          'label'=>'Spanish version',
                          'title'=>['Identity theft and your social security number.', 'Spanish', '(Online)'],
                          'title_variation'=>'Robo de identidad y su nÃºmero de seguro social',
                          'other_ids'=>['2005230022', '57614487']},
                         {'type'=>'alt_edition',
                          'label'=>'Translation of',
                          'title'=>['Redes femeninas'],
                          'details'=>'Roma : Viella, 2013 (IRCUM-Medieval cultures ; 1)',
                          'other_ids'=>['830363122']},
                         {'type'=>'alt_edition',
                          'label'=>'English language edition',
                          'title'=>['Highlights of the International Transport Forum'],
                          'issn'=>'2218-9750'},
                         {'type'=>'alt_edition',
                          'label'=>'German language edition',
                          'title'=>['Weltverkehrsforum : Forum HÃ¶hepunkte'],
                          'issn'=>'2218-9777'},
                         {'type'=>'alt_edition',
                          'label'=>'Russian language edition',
                          'title'=>['Fighting Corruption in Transition Economies', '(Russian version)'],
                          'issn'=>'1990-5076'},
                         {'type'=>'issued_with',
                          'title'=>['Cosmetic bench reference'],
                          'issn'=>'1069-1448',
                          'other_ids'=>['sn 93007310', '9883467']},
                         {'type'=>'issued_with',
                          'label'=>'Companion to',
                          'author'=>'University of North Carolina at Chapel Hill. Graduate School.',
                          'title'=>['Graduate school handbook.'],
                          'other_ids'=>['45129829']},
                         {'type'=>'issued_with',
                          'title'=>['Bakers digest'],
                          'other_ids'=>['4974418'],
                          'display'=>'false'},
                         {'type'=>'earlier',
                          'label'=>'Replacement of',
                          'author'=>'Ludwig, F. L.',
                          'title'=>['Site selection for the monitoring of photochemical air pollutants.'],
                          'details'=>'Research Triangle Park, N.C. : U.S. Environmental Protection Agency ; Springfield, Va. : National Technical Information Service [distributor], 1978. Report number: EPA-450/3-78-013',
                          'other_ids'=>['EPA-450/3-78-013', '4454556']},
                         {'type'=>'earlier',
                          'label'=>'Supersedes',
                          'author'=>'Vancouver Art Gallery Association.',
                          'title'=>['Vancouver Art Gallery Association annual report.'],
                          'issn'=>'0315-4424',
                          'other_ids'=>['cn 77318987', '3113301']},
                         {'type'=>'earlier',
                          'label'=>'Formed by the union of',
                          'title'=>['Alberta English.'],
                          'details'=>'Edmonton, English Language Arts Council of the Alberta Teachers\' Association.',
                          'issn'=>'0382-5191',
                          'other_ids'=>['cn 76301138', '2297987']},
                         {'type'=>'earlier',
                          'label'=>'Formed by the union of',
                          'title'=>['Voices', '(Edmonton, Alta.).'],
                          'details'=>'[Edmonton] : English Language Arts Council of the Alberta Teachers\' Association, Â©1986-2002',
                          'issn'=>'0832-8315',
                          'other_ids'=>['870315102', 'cn 87031510']},
                         {'type'=>'later',
                          'label'=>'Continued by',
                          'author'=>'United States.',
                          'title'=>['Union County ASCS ... annual report'],
                          'details'=>'Agricultural Stabilization and Conservation Service. Warren County ASCS Office.',
                          'other_ids'=>['1028240203']},
                         {'type'=>'later',
                          'title'=>['Acta pathologica, microbiologica et immunologica Scandinavica. Section B, Microbiology'],
                          'issn'=>'0108-0180',
                          'other_ids'=>['sc 82005096', '8246434'],
                          'display'=>'false'},
                         {'type'=>'later',
                          'title'=>['Acta pathologica, microbiologica et immunologica Scandinavica. Section C, Immunology'],
                          'issn'=>'0108-0202',
                          'other_ids'=>['sc 82005097', '8276661'],
                          'display'=>'false'},
                         {'type'=>'later',
                          'title'=>['APMIS'],
                          'issn'=>'0903-4641',
                          'other_ids'=>['sn 88026537', '17476618'],
                          'display'=>'false'},
                         {'type'=>'data_source',
                          'title'=>['Australian plant name index.'],
                          'details'=>'[Canberra, A.C.T.] : Australian National Botanic Gardens : Australian National Herbarium Contributed: Data for inclusion in initial database at launch',
                          'other_ids'=>['2009252503', '64343431']},
                         {'type'=>'related',
                          'author'=>'Rush, James E.',
                          'title'=>['Technical report on development of non-roman alphabet capability for library processes'],
                          'details'=>'Technical report number: OCLC/DD/TR-80/4 February 29, 1980',
                          'other_ids'=>['OCLC/DD/TR-80/4', '6081468']},
                         {'type'=>'related',
                          'title'=>['Journal of chemical research. Synopses'],
                          'issn'=>'0308-2342',
                          'other_ids'=>['JRPSDC'],
                          'display'=>'false'},
                         {'type'=>'related',
                          'author'=>'Rosenau, William.',
                          'title'=>['Subversion and insurgency : RAND counterinsurgency study--paper 2'],
                          'other_ids'=>['RAND/OP-172-OSD'],
                          'display'=>'false'}
                        ]
                      )
  end

    it '(MTA) sets related_work_from 880s' do
    result = related_work_vern1['related_work']
    expect(result).to include(
                        {'type'=>'related',
                          'author'=>'郭湛波.',
                          'title'=>['近五十年中國思想史.']},
                      )
  end

end


