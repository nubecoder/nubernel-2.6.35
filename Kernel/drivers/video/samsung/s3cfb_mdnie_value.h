#if defined(CONFIG_ARIES_LATONA)

mDNIe_data_type mDNIe_Video[]= 
{
	0x0084,0x0060, //algorithm selection+pcc + mcm
	0x0090,0x0000, //decontour th.
	0x0094,0x0fff, //directional th.
	0x0098,0x005c, //simplicity th.
	0x009c,0x0ff0, //de 127, ce off
	0x00ac,0x0200, //skin detect off, cs 512
	0x00b4,0x0001, //de th.
	0x00c0,0x0400, //PCC skin
	0x00c4,0x7200, //    cb
	0x00c8,0x008d, //    cr
	0x00d0,0x00c0, //    strength. 3
	0x0120,0x0064, //MCM 10000K
	0x0140,0x8d00, //cb
	0x0148,0x0073, //cr
	0x0134,0xFFF8, //LSF 248 
	END_SEQ, 0x0000,
};

mDNIe_data_type mDNIe_Camera[]= 
{
	0x0084,0x0020, //algorithm selection + mcm
	0x0090,0x0000, //decontour th.
	0x0094,0x0fff, //directional th.
	0x0098,0x005c, //simplicity th.
	0x009c,0x0010, //de 0, ce off
	0x00ac,0x0000, //skin detect off, cs off
	0x00b4,0x03ff, //de th.
	0x0120,0x0064, //MCM 10000K
	0x0140,0x8d00, //cb
	0x0148,0x0073, //cr
	0x0134,0xFFF8, //LSF 248
	END_SEQ, 0x0000,
};

mDNIe_data_type mDNIe_Camera_Outdoor_Mode[]= 
{
	0x0084,0x00a0, //algorithm selection + ove
	0x0090,0x0000, //decontour th.
	0x0094,0x0fff, //directional th.
	0x0098,0x005c, //simplicity th.
	0x009c,0x0010, //de 127, ce off
	0x00ac,0x0000, //skin detect off, cs 128
	0x00b4,0x03ff, //de th.
	0x0100,0x5040, //ove
	0x0120,0x0064, //MCM 10000K
	0x0140,0x8d00, //cb
	0x0148,0x0073, //cr
	0x0134,0xFFF8, //LSF 248
	END_SEQ, 0x0000,
};

mDNIe_data_type mDNIe_UI[]= 
{
	0x0084,0x0020, //algorithm selection + mcm
	0x0090,0x0000, //decontour th.
	0x0094,0x0fff, //directional th.
	0x0098,0x005c, //simplicity th.
	0x009c,0x0ff0, //de 127, ce off
	0x00ac,0x0200, //skin detect off, cs 512
	0x00b4,0x0100, //de th.
	0x0120,0x0064, //MCM 10000K
	0x0140,0x8d00, //cb
	0x0148,0x0073, //cr
	0x0134,0xFFF8, //LSF 248
	END_SEQ, 0x0000,
};

mDNIe_data_type mDNIe_Video_Warm[]= 
{
	0x0084,0x0060, //algorithm selection+pcc + mcm
	0x0090,0x0000, //decontour th.
	0x0094,0x0fff, //directional th.
	0x0098,0x005c, //simplicity th.
	0x009c,0x0ff0, //de 127, ce off
	0x00ac,0x0200, //skin detect off, cs 512
	0x00b4,0x0001, //de th.
	0x00c0,0x0400, //PCC skin
	0x00c4,0x7200, //    cb
	0x00c8,0x008d, //    cr
	0x00d0,0x00c0, //    strength. 3
	0x0120,0x0064, //MCM 10000K
	0x0140,0x8000, //cb 0
	0x0148,0x0080, //cr 0
	0x0134,0xFFF8, //LSF 248
	END_SEQ, 0x0000,
};

mDNIe_data_type mDNIe_Video_WO_Mode[]= 
{
	0x0084,0x00a0, //algorithm selection+pcc + mcm
	0x0090,0x0000, //decontour th.
	0x0094,0x0fff, //directional th.
	0x0098,0x005c, //simplicity th.
	0x009c,0x0ff0, //de 127, ce off
	0x00ac,0x0200, //skin detect off, cs 512
	0x00b4,0x0001, //de th.
	0x00c0,0x0400, //PCC skin
	0x00c4,0x7200, //    cb
	0x00c8,0x008d, //    cr
	0x00d0,0x00c0, //    strength. 3
	0x0100,0x5050, //ove
	0x0120,0x0064, //MCM 10000K
	0x0140,0x8000, //cb 0
	0x0148,0x0080, //cr 0
	0x0134,0xFFF8, //LSF 248
	END_SEQ, 0x0000,
};

mDNIe_data_type mDNIe_Video_Cold[]= 
{
	0x0084,0x0060, //algorithm selection+pcc + mcm
	0x0090,0x0000, //decontour th.
	0x0094,0x0fff, //directional th.
	0x0098,0x005c, //simplicity th.
	0x009c,0x0ff0, //de 127, ce off
	0x00ac,0x0200, //skin detect off, cs 512
	0x00b4,0x0001, //de th.
	0x00c0,0x0400, //PCC skin
	0x00c4,0x7200, //    cb
	0x00c8,0x008d, //    cr
	0x00d0,0x00c0, //    strength. 3
	0x0120,0x0064, //MCM 10000K
	0x0140,0x9300, //cb +19
	0x0148,0x006d, //cr -19
	0x0134,0xFFF8, //LSF 248
	END_SEQ, 0x0000,
};

mDNIe_data_type mDNIe_Video_CO_Mode[]= 
{
	0x0084,0x00a0, //algorithm selection + mcm
	0x0090,0x0000, //decontour th.
	0x0094,0x0fff, //directional th.
	0x0098,0x005c, //simplicity th.
	0x009c,0x0ff0, //de 127, ce off
	0x00ac,0x0200, //skin detect off, cs 512
	0x00b4,0x0001, //de th.
	0x00c0,0x0400, //PCC skin
	0x00c4,0x7200, //    cb
	0x00c8,0x008d, //    cr
	0x00d0,0x00c0, //    strength. 3
	0x0100,0x5050, //ove
	0x0120,0x0064, //MCM 10000K
	0x0140,0x9300, //cb +19
	0x0148,0x006d, //cr -19
	0x0134,0xFFF8, //LSF 248
	END_SEQ, 0x0000,

};

mDNIe_data_type mDNIe_Outdoor_Mode[]= 
{
	0x0084,0x00a0, //algorithm selection + ove
	0x0090,0x0000, //decontour th.
	0x0094,0x0fff, //directional th.
	0x0098,0x005c, //simplicity th.
	0x009c,0x0ff0, //de 127, ce off
	0x00ac,0x0200, //skin detect off, cs 512
	0x00b4,0x0100, //de th.
	0x0100,0x5050, //ove
	0x0120,0x0064, //MCM 10000K
	0x0140,0x8d00, //cb
	0x0148,0x0073, //cr
	0x0134,0xFFF8, //LSF 248
	END_SEQ, 0x0000,

};

mDNIe_data_type mDNIe_Gallery[]= 
{
	0x0084,0x0020, //algorithm selection + mcm
	0x0090,0x0000, //decontour th.
	0x0094,0x0fff, //directional th.
	0x0098,0x005c, //simplicity th.
	0x009c,0x0ff0, //de 127, ce off
	0x00ac,0x0200, //skin detect off, cs 512
	0x00b4,0x0100, //de th.
	0x0120,0x0064, //MCM 10000K
	0x0140,0x8d00, //cb
	0x0148,0x0073, //cr
	0x0134,0xFFF8, //LSF 248
	END_SEQ,0x0000,
};

#else   ///////////////////////////////////////////////////////////////

mDNIe_data_type mDNIe_Video[]= 
{
#ifdef CONFIG_VOODOO_MDNIE
	// Voodoo color: mDNIe settings optimized for most video
	// standard response curve
	// nice sharpness filter and very light color saturation boost
	0x0084, 0x0040,
	0x0090, 0x0000,
	0x0094, 0x0FFF,
	0x0098, 0x005C,
	0x009C, 0x0FF5,
	0x00AC, 0x0007,
	0x00B4, 0x0500,
	0x00C0, 0x0400,
	0x00C4, 0x7200,
	0x00C8, 0x008D,
	0x00D0, 0x00C0,
	END_SEQ, 0x0000,
#else
	0x0084, 0x0040,
	0x0090, 0x0000,
	0x0094, 0x0fff,
	0x0098, 0x005c,
	0x009C, 0x0ff0,
	0x00AC, 0x00E0, 
	0x00B4, 0x0001, 
	0x00C0, 0x0400,
	0x00C4, 0x7200, 
	0x00C8, 0x008d, 
	0x00D0, 0x0100, 
	END_SEQ, 0x0000,
#endif
};

mDNIe_data_type mDNIe_Camera[]= 
{
#ifdef CONFIG_VOODOO_MDNIE
	// Voodoo color: optimized UI mode
	// reduce the sharpness filter radius to make it much closer
	// to the real fuzzyness introduced by the SAMOLED Pentile pattern
	// color saturation boost on everything is also disabled because
	// it causes harm on stock settings (exaggerated colors)
	0x0084, 0x0040,
	0x0090, 0x0000,
	0x0094, 0x0FFF,
	0x0098, 0x005C,
	0x009C, 0x0613,
	0x00AC, 0x0000,
	0x00B4, 0x0A00,
	0x00C0, 0x0400,
	0x00C4, 0x7200,
	0x00C8, 0x008D,
	0x00D0, 0x00C0,
	END_SEQ, 0x0000,
#else
	0x0084, 0x0040,
	0x0090, 0x0000,
	0x0094, 0x0FFF,
	0x0098, 0x005C,
	0x009C, 0x0010,
	0x00AC, 0x0000,
	0x00B4, 0x03FF,
	0x00C0, 0x0400,
	0x00C4, 0x7200,
	0x00C8, 0x008D,
	0x00D0, 0x00C0,
	END_SEQ, 0x0000,
#endif
};

mDNIe_data_type mDNIe_Camera_Outdoor_Mode[]= 
{
	0x0084, 0x0090,
	0x0090, 0x0000,
	0x0094, 0x0FFF,
	0x0098, 0x005C,
	0x009C, 0x0010,
	0x00AC, 0x0000,
	0x00B4, 0x03FF,
	0x0100, 0x6050,
	0x0198, 0x0001,
	0x0194, 0x0011,
	END_SEQ, 0x0000,
};

mDNIe_data_type mDNIe_UI[]= 
{
#if 0
	0x0084, 0x0000,
	0x0090, 0x0000,
	0x0094, 0x0fff,
	0x0098, 0x005c,
	0x009C, 0x0010,
	0x00AC, 0x0000,
	0x00B4, 0x03ff,
	END_SEQ, 0x0000,
#else
	0x0084, 0x0040,
	0x0090, 0x0000,
	0x0094, 0x0fff,
	0x0098, 0x005C,
	0x009C, 0x0ff0,
	0x00AC, 0x0080,
	0x00B4, 0x0180,
	0x00C0, 0x0400,
	0x00C4, 0x7200,
	0x00C8, 0x008D,
	0x00D0, 0x00C0,
	0x0100, 0x0000,
	END_SEQ, 0x0000,
#endif
};

mDNIe_data_type mDNIe_Video_Warm[]= 
{
#ifdef CONFIG_VOODOO_MDNIE_VIDEOS_ALT_PRESETS
	// Voodoo color: high vibrance/saturation and sharpening
	// Boost mode for videos
	0x0084, 0x0040,
	0x0090, 0x0000,
	0x0094, 0x0FFF,
	0x0098, 0x005C,
	0x009C, 0x0FFF,
	0x00AC, 0x0200,
	0x00B4, 0x0800,
	0x00C0, 0x0400,
	0x00C4, 0x7200,
	0x00C8, 0x008D,
	0x00D0, 0x00C0,
	END_SEQ, 0x0000,
#else
	0x0084, 0x0020,
	0x0090, 0x0000,
	0x0094, 0x0fff,
	0x0098, 0x005C,
	0x009C, 0x0FF0,
	0x00AC, 0x0000,
	0x00B4, 0x0001,
	0x0120, 0x0028,
	0x0138, 0x7600,
	0x0140, 0x0090,
	END_SEQ, 0x0000,
#endif
};

mDNIe_data_type mDNIe_Video_WO_Mode[]= 
{
	0x0084, 0x0090,
	0x0090, 0x0000,
	0x0094, 0x0fff,
	0x0098, 0x005C,
	0x009C, 0x0ff0,
	0x00AC, 0x0000,
	0x00B4, 0x0001,
	0x0100, 0x6050,
	0x0198, 0x0001,
	0x0194, 0x0011,
	END_SEQ, 0x0000,
};

mDNIe_data_type mDNIe_Video_Cold[]= 
{
#ifdef CONFIG_VOODOO_MDNIE_VIDEOS_ALT_PRESETS
	// Voodoo color : sharpness filter at minimum, unmodified color
	// Soft mode. Useful to counter artifacts on bad or noisy videos
	0x0084, 0x0040,
	0x0090, 0x0000,
	0x0094, 0x0FFF,
	0x0098, 0x005C,
	0x009C, 0x0010,
	0x00AC, 0x0000,
	0x00B4, 0x0000,
	0x00C0, 0x0400,
	0x00C4, 0x7200,
	0x00C8, 0x008D,
	0x00D0, 0x00C0,
	END_SEQ, 0x0000,
#else
	0x0084, 0x0020,
	0x0090, 0x0000,
	0x0094, 0x0fff,
	0x0098, 0x005c,
	0x009C, 0x0ff0,
	0x00AC, 0x0000,
	0x00B4, 0x0001,
	0x0120, 0x0064,
	0x0140, 0x9400,
	0x0148, 0x006D,
	END_SEQ, 0x0000,
#endif
};

mDNIe_data_type mDNIe_Video_CO_Mode[]= 
{
	0x0084, 0x0090,
	0x0090, 0x0000,
	0x0094, 0x0fff,
	0x0098, 0x005C,
	0x009C, 0x0ff0,
	0x00AC, 0x0000,
	0x00B4, 0x0001,
	0x0100, 0x6050,
	0x0198, 0x0001,
	0x0194, 0x0011,
	END_SEQ, 0x0000,

};

mDNIe_data_type mDNIe_Outdoor_Mode[]= 
{
	0x0084, 0x0090,
	0x0090, 0x0000,
	0x0094, 0x0fff,
	0x0098, 0x005C,
	0x009C, 0x0ff0,
	0x00AC, 0x0000,
	0x00B4, 0x0001,
	0x0100, 0x6050,
	0x0198, 0x0001,
	0x0194, 0x0011,
	END_SEQ, 0x0000,

};

#endif
