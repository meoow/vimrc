if exists("b:current_syntax")
  finish
endif

" Keyword generator
" ruby -na -e 'puts $F[0] if $_ =~ /^\w+/' */*/circos.conf */*/ideogram.conf */*/ticks.conf | sort | uniq
syn keyword circosOpts ideogram karyotype radius
syn match circosOpts "\v(^\s*)(chromosomes|chromosomes_(display_default|breaks|display_default|order|radius|reverse|scale|units))(\s*\=)@="
syn match circosOpts "\v(^\s*)@<=image_(map_missing_parameter|map_name|map_overlay|map_overlay_stroke_color|map_overlay_stroke_thickness|map_strict|map_use)(\s*\=)@="
syn match circosOpts "\v(^\s*)@<=snuggle_(link_overlap_(test|tolerance)|refine|sampling|tolerance)(\s*\=)@="
syn match circosOpts "\v(^\s*)@<=(label|label_(case|center|color|font|multiplier|offset|parallel|radius|relative|rotate|separation|size|snuggle|with_tag))(\s*\=)@="
syn match circosOpts "\v(^\s*)@<=(fill|fill_(bands|color|under))(\s*\=)@="
syn match circosOpts "\v(^\s*)@<=(axis|axis_(break|break_at_edge|break_style|color|spacing|thickness))(\s*\=)@="
syn match circosOpts "\v(^\s*)@<=(show|show_(bands|grid|label|links|tick_labels|ticks))(\s*\=)@="
syn match circosOpts "\v(^\s*)@<=(grid|grid_(color|end|start|thickness))(\s*\=)@="
syn match circosOpts "\v(^\s*)@<=link_(color|dims|thickness)(\s*\=)@="
syn match circosOpts "\v(^\s*)@<=(background|background_(color|stroke_color|stroke_thickness))(\s*\=)@="
syn match circosOpts "\v(^\s*)@<=(max|max_(gap|snuggle_distance))(\s*\=)@="
syn match circosOpts "\v(^\s*)@<=band_(stroke_thickness|transparency)(\s*\=)@="
syn match circosOpts "\v(^\s*)@<=bezier_(radius|radius_purity)(\s*\=)@="
syn match circosOpts "\v(^\s*)@<=skip_(first_label|last_label)(\s*\=)@="
syn match circosOpts "\v(^\s*)@<=smooth_(distance|steps)(\s*\=)@="
syn match circosOpts "\v(^\s*)@<=stroke_(color|thickness)(\s*\=)@="
syn match circosOpts "\v(^\s*)@<=tick_(label_font|separation)(\s*\=)@="
syn match circosOpts "\v(^\s*)@<=units_(nounit|ok)(\s*\=)@="
syn match circosOpts "\v(^\s*)@<=auto_(alpha_(colors|steps))(\s*\=)@="
syn match circosOpts "\v(^\s*)@<=(perturb|perturb_(bezier_(radius|radius_purity)|crest))(\s*\=)@="
syn match circosOpts "\v(^\s*)@<=(24bit|angle_offset|anglestep|beziersamples|blackweak|break|chr|color|condition|connector_dims|crest|debug|default|dir|end|extend_bin|file|flat|flow|force_display|format|glyph|glyph_size|ideogram_url|imagemap|importance|layers|layers_(overflow|overflow_color)|margin|min|min_label_distance_to_edge|minslicestep|mod|multiplier|offset|orientation|padding|png|position|prefix|r[01]|radius[12]|record_limit|ribbon|rmultiplier|rpadding|rposition|rspacing|scale|scale_log_base|size|sort_bin_values|spacing|spacing_type|start|suffix|svg|svg_font_scale|thickness|type|url|value|warnings|z)(\s*\=)@="
" syn keyword circosOpts 
" \ 24bit angle_offset anglestep auto_alpha_colors
" \ auto_alpha_steps axis axis_break
" \ axis_break_at_edge axis_break_style axis_color axis_spacing axis_thickness
" \ background background_color background_stroke_color background_stroke_thickness
" \ band_stroke_thickness band_transparency bezier_radius bezier_radius_purity
" \ beziersamples blackweak break chr chromosoemes_display_default chromosomes
" \ chromosomes_breaks chromosomes_display_default chromosomes_order
" \ chromosomes_radius chromosomes_reverse chromosomes_scale chromosomes_units
" \ color condition connector_dims crest debug default dir end extend_bin file fill
" \ fill_bands fill_color fill_under flat flow force_display format glyph
" \ glyph_size grid grid_color grid_end grid_start grid_thickness ideogram
" \ ideogram_url imagemap image_map_missing_parameter image_map_name
" \ image_map_overlay image_map_overlay_stroke_color
" \ image_map_overlay_stroke_thickness image_map_strict image_map_use importance
" \ karyotype label label_center label_color label_font label_multiplier
" \ label_offset label_radius label_relative label_rotate label_separation
" \ label_size label_snuggle label_with_tag layers layers_overflow label_case
" \ layers_overflow_color link_color link_dims link_thickness margin max max_gap
" \ max_snuggle_distance min min_label_distance_to_edge minslicestep mod multiplier
" \ offset orientation padding perturb perturb_bezier_radius
" \ perturb_bezier_radius_purity perturb_crest png position prefix r0 r1 radius
" \ radius1 radius2 record_limit ribbon rmultiplier rpadding rposition rspacing
" \ scale scale_log_base show show_bands show_grid show_label show_links
" \ show_tick_labels show_ticks size skip_first_label skip_last_label
" \ smooth_distance smooth_steps snuggle_link_overlap_test
" \ snuggle_link_overlap_tolerance snuggle_refine snuggle_sampling
" \ snuggle_tolerance sort_bin_values spacing spacing_type start stroke_color
" \ stroke_thickness suffix svg svg_font_scale thickness tick_label_font
" \ tick_separation type units_nounit units_ok url value warnings z label_parallel

"syn keyword circosColor 
"\ optblue optgreen optyellow optorange optred optviolet optpurple white vvvvlgrey
"\ vvvlgrey vvlgrey vlgrey lgrey grey dgrey vdgrey vvdgrey vvvdgrey vvvvdgrey
"\ black vlred lred red dred vlgreen lgreen green dgreen vlblue lblue blue dblue
"\ vlpurple lpurple purple dpurple vlyellow lyellow yellow dyellow lime vlorange
"\ lorange orange dorange gpos100 gpos gpos75 gpos66 gpos50 gpos33 gpos25 gvar
"\ gneg acen stalk select nyt_blue nyt_green nyt_yellow nyt_orange nyt_red chr1
"\ chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15
"\ chr16 chr17 chr18 chr19 chr20 chr21 chr22 chr23 chrX chr24 chrY chrM chr0 chrUn
"\ chrNA meth0 meth1 meth2 meth3 meth4 meth5 meth6 meth7 meth8 meth9 meth10 meth11
"\ meth12 meth13 meth14 meth15 meth16 meth17 meth18 meth19 meth20 meth21 meth22
"\ meth23 meth24 meth25 meth26 meth27 meth28 meth29 meth30 meth31 meth32 meth33
"\ meth34 meth35 meth36 meth37 meth38 meth39 meth40 meth41 meth42 meth43 meth44
"\ meth45 meth46 meth47 meth48 meth49 meth50 meth51 meth52 meth53 meth54 meth55
"\ meth56 meth57 meth58 meth59 meth60 meth61 meth62 meth63 meth64 meth65 meth66
"\ meth67 meth68 meth69 meth70 meth71 meth72 meth73 meth74 meth75 meth76 meth77
"\ meth78 meth79 meth80 meth81 meth82 meth83 meth84 meth85 meth86 meth87 meth88
"\ meth89 meth90 meth91 meth92 meth93 meth94 meth95 meth96 meth97 meth98 meth99 meth100

syn match   circosUnits '-\?[^A-Za-z]\d*\.\?\d\+[upr]\?'
syn keyword   circosUnits yes upper lower no out in
syn match   circosComment "#.*$" 
syn region  circosTag start=+<+   end=+>+
syn region  circosInclude start=+<<include+   end=+>>+
syn match circosColor '\v<(v{0,4}[ld])?(grey|green|black|red|blue|purple|yellow|orange)(_a[1-5])?>'
syn match circosColor '\v<opt(grey|green|black|red|blue|purple|yellow|orange)(_a[1-5])?>'
syn match circosColor '\v<nyt_(blue|green|yellow|orrange|red)(_a[1-5])?>'
syn match circosColor '\v<chr(2[0-4]|1[0-9]|[0-9]|X|Y|M|Un|NA)(_a[1-5])?>'
syn match circosColor '\v<gpos(100|75|66|50|33|25|)(_a[1-5])?>'
syn match circosColor '\v<meth(100|[1-9][0-9]|[0-9])(_a[1-5])?>'
syn keyword circosColor lime gvar gneg acen stalk select white

"syn keyword circosFunction  var dims
syn match circosFunction '\v<(var|dims|mod|on|from|to|between|fromto|tofrom|within|max|min|eval|abs|int)\(@='

let b:current_syntax = "circos"

hi def link circosOpts           Statement
hi def link circosComment        Comment 
hi def link circosTag	         Tag
hi def link circosInclude        Include
hi def link circosUnits          Number
hi def link circosColor          Constant
hi def link circosFunction       Function
