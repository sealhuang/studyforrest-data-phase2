##segment: 0
##frames: 22550.0
##TRs: 451.0
##Duration: 902.0
melt -profile dv_pal_wide forrest_gump_dvd_orig.VOB force_fps=25.000 in=35 out=22585 -consumer avformat:fg_av_seg0.mov f=mov acodec=ac3 ab=256k vcodec=libx264 b=5000k sample_aspect_num=1 sample_aspect_den=1


##segment: 1
##frames: 22050.0
##TRs: 441.0
##Duration: 882.0
melt -profile dv_pal_wide forrest_gump_dvd_orig.VOB force_fps=25.000 in=22185 out=32348 -mix 25 -mixer luma forrest_gump_dvd_orig.VOB force_fps=25.000 in=36385 out=48273 -consumer avformat:fg_av_seg1.mov f=mov acodec=ac3 ab=256k vcodec=libx264 b=5000k sample_aspect_num=1 sample_aspect_den=1


##segment: 2
##frames: 21900.0
##TRs: 438.0
##Duration: 876.0
melt -profile dv_pal_wide forrest_gump_dvd_orig.VOB force_fps=25.000 in=47873 out=57835 -mix 25 -mixer luma forrest_gump_dvd_orig.VOB force_fps=25.000 in=58507 out=70446 -consumer avformat:fg_av_seg2.mov f=mov acodec=ac3 ab=256k vcodec=libx264 b=5000k sample_aspect_num=1 sample_aspect_den=1


#segment: 3
#frames: 24400.0
#TRs: 488.0
#Duration: 976.0
melt -profile dv_pal_wide forrest_gump_dvd_orig.VOB force_fps=25.000 in=70046 out=86036 -mix 25 -mixer luma forrest_gump_dvd_orig.VOB force_fps=25.000 in=89332 out=97742 -consumer avformat:fg_av_seg3.mov f=mov acodec=ac3 ab=256k vcodec=libx264 b=5000k sample_aspect_num=1 sample_aspect_den=1


#segment: 4
#frames: 23100.0
#TRs: 462.0
#Duration: 924.0
melt -profile dv_pal_wide forrest_gump_dvd_orig.VOB force_fps=25.000 in=97342 out=117391 -mix 25 -mixer luma forrest_gump_dvd_orig.VOB force_fps=25.000 in=120656 out=123708 -consumer avformat:fg_av_seg4.mov f=mov acodec=ac3 ab=256k vcodec=libx264 b=5000k sample_aspect_num=1 sample_aspect_den=1


#segment: 5
#frames: 21950.0
#TRs: 439.0
#Duration: 878.0
melt -profile dv_pal_wide forrest_gump_dvd_orig.VOB force_fps=25.000 in=123308 out=141496 -mix 25 -mixer luma forrest_gump_dvd_orig.VOB force_fps=25.000 in=145908 out=149671 -consumer avformat:fg_av_seg5.mov f=mov acodec=ac3 ab=256k vcodec=libx264 b=5000k sample_aspect_num=1 sample_aspect_den=1


#segment: 6
#frames: 27100.0
#TRs: 542.0
#Duration: 1084.0
melt -profile dv_pal_wide forrest_gump_dvd_orig.VOB force_fps=25.000 in=149271 out=152304 -mix 25 -mixer luma forrest_gump_dvd_orig.VOB force_fps=25.000 in=154288 out=178356 -consumer avformat:fg_av_seg6.mov f=mov acodec=ac3 ab=256k vcodec=libx264 b=5000k sample_aspect_num=1 sample_aspect_den=1


#segment: 7
#frames: 16876.0
#TRs: 337.52
#Duration: 675.04
melt -profile dv_pal_wide forrest_gump_dvd_orig.VOB force_fps=25.000 in=177956 out=194832 -consumer avformat:fg_av_seg7.mov f=mov acodec=ac3 ab=256k vcodec=libx264 b=5000k sample_aspect_num=1 sample_aspect_den=1


#entire movie cut: english
melt -profile dv_pal_wide forrest_gump_dvd_orig.VOB force_fps=25.000 in=35 out=32348 forrest_gump_dvd_orig.VOB force_fps=25.000 in=36385 out=57835 forrest_gump_dvd_orig.VOB force_fps=25.000 in=58507 out=86036 forrest_gump_dvd_orig.VOB force_fps=25.000 in=89332 out=117391 forrest_gump_dvd_orig.VOB force_fps=25.000 in=120656 out=141496 forrest_gump_dvd_orig.VOB force_fps=25.000 in=145908 out=152304 forrest_gump_dvd_orig.VOB force_fps=25.000 in=154288 out=194832 -consumer avformat:forrestgump_researchcut_eng.mov f=mov acodec=ac3 ab=256k vcodec=libx264 b=5000k sample_aspect_num=1 sample_aspect_den=1


