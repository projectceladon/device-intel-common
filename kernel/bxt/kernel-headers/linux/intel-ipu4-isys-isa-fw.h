/****************************************************************************
 ****************************************************************************
 ***
 ***   This header was automatically generated from a Linux kernel header
 ***   of the same name, to make information necessary for userspace to
 ***   call into the kernel available to libc.  It contains only constants,
 ***   structures, and macros generated from the original header, and thus,
 ***   contains no copyrightable information.
 ***
 ***   To edit the content of this header, modify the corresponding
 ***   source file (e.g. under external/kernel-headers/original/) then
 ***   run bionic/libc/kernel/tools/update_all.py
 ***
 ***   Any manual change here will be lost the next time this script will
 ***   be run. You've been warned!
 ***
 ****************************************************************************
 ****************************************************************************/
#ifndef INTEL_IPU4_ISYS_ISA_FW_H
#define INTEL_IPU4_ISYS_ISA_FW_H
#define ia_css_terminal_offsets(pg) ((uint16_t *) ((void *) (pg) + (pg)->terminals_offset_offset))
#define to_ia_css_terminal(pg,i) ((struct ia_css_terminal *) ((void *) (pg) + ia_css_terminal_offsets(pg)[i]))
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ia_css_terminal_offset(pg,i) (! (i) ? sizeof * (pg) + ((((pg)->terminal_count - 1) | 3) + 1) * sizeof(uint16_t) : ia_css_terminal_offsets(pg)[(i) - 1] + to_ia_css_terminal(pg, (i) - 1)->size)
#define N_IA_CSS_ISYS_KERNEL_ID 20
struct ia_css_process_group_light {
  uint32_t size;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint16_t terminals_offset_offset;
  uint16_t terminal_count;
};
enum ia_css_terminal_type {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  IA_CSS_TERMINAL_TYPE_DATA_IN = 0,
  IA_CSS_TERMINAL_TYPE_DATA_OUT,
  IA_CSS_TERMINAL_TYPE_PARAM_STREAM,
  IA_CSS_TERMINAL_TYPE_PARAM_CACHED_IN,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  IA_CSS_TERMINAL_TYPE_PARAM_CACHED_OUT,
  IA_CSS_TERMINAL_TYPE_PARAM_SPATIAL_IN,
  IA_CSS_TERMINAL_TYPE_PARAM_SPATIAL_OUT,
  IA_CSS_TERMINAL_TYPE_PARAM_SLICED_IN,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  IA_CSS_TERMINAL_TYPE_PARAM_SLICED_OUT,
  IA_CSS_TERMINAL_TYPE_STATE_IN,
  IA_CSS_TERMINAL_TYPE_STATE_OUT,
  IA_CSS_TERMINAL_TYPE_PROGRAM,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  IA_CSS_N_TERMINAL_TYPES
};
struct ia_css_terminal {
  enum ia_css_terminal_type terminal_type;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  int16_t parent_offset;
  uint16_t size;
  uint16_t tm_index;
  uint8_t id;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint8_t padding[5];
};
struct ia_css_param_payload {
  uint64_t host_buffer;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t buffer;
  uint8_t padding[4];
};
struct ia_css_param_section_desc {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t mem_offset;
  uint32_t mem_size;
};
struct ia_css_param_terminal {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  struct ia_css_terminal base;
  struct ia_css_param_payload param_payload;
  uint16_t param_section_desc_offset;
  uint8_t padding[6];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct ia_css_program_terminal {
  struct ia_css_terminal base;
  struct ia_css_param_payload param_payload;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint16_t fragment_param_section_desc_offset;
  uint16_t kernel_fragment_sequencer_info_desc_offset;
  uint8_t padding[4];
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct ia_css_sliced_param_terminal {
  struct ia_css_terminal base;
  struct ia_css_param_payload param_payload;
  uint32_t kernel_id;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint16_t fragment_slice_desc_offset;
  uint8_t padding[2];
};
enum ia_css_dimension {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  IA_CSS_COL_DIMENSION = 0,
  IA_CSS_ROW_DIMENSION = 1,
  IA_CSS_N_DATA_DIMENSION = 2
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct ia_css_frame_grid_desc {
  uint16_t frame_grid_dimension[IA_CSS_N_DATA_DIMENSION];
  uint8_t padding[4];
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct ia_css_spatial_param_terminal {
  struct ia_css_terminal base;
  struct ia_css_param_payload param_payload;
  struct ia_css_frame_grid_desc frame_grid_desc;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t kernel_id;
  uint16_t frame_grid_param_section_desc_offset;
  uint16_t fragment_grid_desc_offset;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#endif

