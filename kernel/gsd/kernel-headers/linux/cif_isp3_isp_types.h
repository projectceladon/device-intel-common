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
#ifndef _CIF_ISP_TYPES_H
#define _CIF_ISP_TYPES_H
#ifdef __cplusplus
#endif
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define CIFISP_AWB_MAX_GRID 4800
#define CIFISP_HIST_BIN_N_MAX 512
#define CIFISP_AFM_MAX_GRID 1200
#define CIFISP_AE_MEAN_MAX 25
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define CIFISP_GAMMA_OUT_TBL_SIZE 259
#define CIFISP_DEGAMMA_TBL_SIZE 257
#define CIFISP_TONE_MAP_TABLE_SIZE 257
#define CIFISP_BNR_LUT_SIZE 33
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define CIFISP_AFM_FILTER_SIZE 9
#define CIFISP_AFM_COEFFS_SIZE 3
#define CIFISP_COLOR_TONE_TABLE_SIZE 33
#define CIFISP_BNR_TABLE_SIZE 33
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define CIFISP_CORR_DATA_TBL_SIZE 561
#define CIFISP_MACC_SEGMENTS 16
#define CIFISP_CTK_TBL_SIZE 9
#define CIFISP_IE_TBL_SIZE 3
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
enum cifisp_histogram_mode {
  CIFISP_HISTOGRAM_MODE_RGB_COMBINED_LEGACY = 1,
  CIFISP_HISTOGRAM_MODE_R_HISTOGRAM = 2,
  CIFISP_HISTOGRAM_MODE_G_HISTOGRAM = 3,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  CIFISP_HISTOGRAM_MODE_B_HISTOGRAM = 4,
  CIFISP_HISTOGRAM_MODE_Y_HISTOGRAM = 5,
  CIFISP_HISTOGRAM_MODE_RGBY_HISTOGRAM = 6,
  CIFISP_HISTOGRAM_MODE_RGB_COMBINED = 7
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct cifisp_window {
  uint16_t h_offs;
  uint16_t v_offs;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint16_t h_size;
  uint16_t v_size;
};
enum cifisp_awb_mode_type {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  CIFISP_AWB_MODE_MANUAL = 0,
  CIFISP_AWB_MODE_RGB = 1,
  CIFISP_AWB_MODE_YCBCR = 2
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
enum cifisp_bls_mode {
  CIF_ISP_BLS_FIXED,
  CIF_ISP_BLS_AUTO,
  CIF_ISP_BLS_LOCAL,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  CIF_ISP_BLS_MIXED
};
enum cifisp_stat_type {
  CIFISP_STAT_AWB,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  CIFISP_STAT_EXP,
  CIFISP_STAT_AFM,
  CIFISP_STAT_HIST
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
enum cifisp_colorfx {
  CIFISP_COLORFX_BW = 1,
  CIFISP_COLORFX_SEPIA = 2,
  CIFISP_COLORFX_NEGATIVE = 3,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  CIFISP_COLORFX_EMBOSS = 4,
  CIFISP_COLORFX_SKETCH = 5,
  CIFISP_COLORFX_SKY_BLUE = 6,
  CIFISP_COLORFX_GRASS_GREEN = 7,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  CIFISP_COLORFX_SKIN_WHITEN = 8,
  CIFISP_COLORFX_VIVID = 9,
  CIFISP_COLORFX_AQUA = 10,
  CIFISP_COLORFX_ART_FREEZE = 11,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  CIFISP_COLORFX_SILHOUETTE = 12,
  CIFISP_COLORFX_SOLARIZATION = 13,
  CIFISP_COLORFX_ANTIQUE = 14,
  CIFISP_COLORFX_SET_CBCR = 15,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  CIFISP_COLORFX_SELECTION = 16
};
struct cifisp_ie_config {
  uint8_t on;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  int32_t effect;
  uint16_t effect_cfg[CIFISP_IE_TBL_SIZE];
};
struct cifisp_awb_meas_yc {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t cnt;
  uint8_t mean_y;
  uint8_t mean_cb;
  uint8_t mean_cr;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct cifisp_awb_meas_bayer {
  uint32_t cnt;
  uint16_t mean_r;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint16_t mean_b;
  uint16_t mean_gr;
  uint16_t mean_gb;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct cifisp_awb_stat {
  union {
    struct cifisp_awb_meas_bayer bayer[CIFISP_AWB_MAX_GRID];
    struct cifisp_awb_meas_yc yc[CIFISP_AWB_MAX_GRID];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  } awb_mean;
};
struct cifisp_hist_stat {
  uint16_t bin[CIFISP_HIST_BIN_N_MAX];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct cifisp_ae_stat {
  uint8_t exp_mean[CIFISP_AE_MEAN_MAX];
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct cifisp_af_meas_val {
  uint32_t afm_result1;
  uint32_t afm_result2;
  uint32_t afm_lum;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct cifisp_af_stat {
  struct cifisp_af_meas_val af[CIFISP_AFM_MAX_GRID];
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
union cifisp_stat {
  struct cifisp_awb_stat awb;
  struct cifisp_ae_stat ae;
  struct cifisp_af_stat af;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  struct cifisp_hist_stat hist;
};
struct cifisp_meas_grid {
  uint16_t h_coverage;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint16_t v_coverage;
  uint16_t h_dim;
  uint16_t v_dim;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct cifisp_stat_buffer {
  int32_t meas_type;
  union cifisp_stat params;
  struct cifisp_meas_grid grid;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct cifisp_corr_grid {
  uint32_t r_data_tbl[CIFISP_CORR_DATA_TBL_SIZE];
  uint32_t gr_data_tbl[CIFISP_CORR_DATA_TBL_SIZE];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t gb_data_tbl[CIFISP_CORR_DATA_TBL_SIZE];
  uint32_t b_data_tbl[CIFISP_CORR_DATA_TBL_SIZE];
  uint16_t width;
  uint16_t height;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct cifisp_bp_detection_config {
  uint8_t bp_hot_turbulence_adj_en;
  uint8_t bp_dead_turbulence_adj_en;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint8_t bp_dev_hot_sign_sens;
  uint8_t bp_dev_dead_sign_sens;
  uint8_t bp_hot_turbulence_shift;
  uint8_t bp_dead_turbulence_shift;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint8_t bp_dev_hot_grad_trig_lvl;
  uint8_t bp_dev_dead_grad_trig_lvl;
};
struct cifisp_bp_direct {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint16_t abs_hot_thres;
  uint16_t abs_dead_thres;
  uint16_t dev_hot_thres;
  uint16_t dev_dead_thres;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint8_t w0;
  uint8_t w1;
  uint16_t th0;
  uint32_t offset;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct cifisp_bp_correction_config {
  uint8_t corr_type;
  uint8_t corr_rep;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint8_t corr_mode;
  struct cifisp_bp_direct bp_corr_direct;
};
struct cifisp_bpc_config {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint8_t on;
  struct cifisp_bp_correction_config corr_config;
  struct cifisp_bp_detection_config det_config;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct cifisp_bls_fixed_config {
  uint16_t fixed_a;
  uint16_t fixed_b;
  uint16_t fixed_c;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint16_t fixed_d;
};
struct cifisp_bls_meas_config {
  struct cifisp_window bls_window1;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  struct cifisp_window bls_window2;
  uint8_t bls_samples;
  uint8_t window_enable;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct cifisp_bls_local_config {
  struct cifisp_corr_grid corr;
};
struct cifisp_bls_mixed_config {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  struct cifisp_bls_local_config local;
  struct cifisp_bls_fixed_config fixed;
};
struct cifisp_bls_config {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint8_t on;
  int32_t mode;
  union {
    struct cifisp_bls_fixed_config fixed;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
    struct cifisp_bls_meas_config meas;
    struct cifisp_bls_local_config local;
    struct cifisp_bls_mixed_config mixed;
  } config;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct cifisp_sdg_config {
  uint8_t on;
  uint16_t gamma_gr[CIFISP_DEGAMMA_TBL_SIZE];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint16_t gamma_gb[CIFISP_DEGAMMA_TBL_SIZE];
  uint16_t gamma_b[CIFISP_DEGAMMA_TBL_SIZE];
  uint16_t gamma_r[CIFISP_DEGAMMA_TBL_SIZE];
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct cifisp_lsc_config {
  uint8_t on;
  struct cifisp_corr_grid corr;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct cifisp_awb_yc_meas_config {
  uint8_t max_y;
  uint8_t min_y;
  uint8_t max_csum;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint8_t min_c;
  uint8_t awb_ref_cr;
  uint8_t awb_ref_cb;
  uint8_t enable_ymax_cmp;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct cifisp_awb_bayer_meas_config {
  uint16_t gb_sat;
  uint16_t gr_sat;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint16_t b_sat;
  uint16_t r_sat;
  uint8_t rgb_meas_pnt;
  uint8_t awbm_before_lsc;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint8_t rgb_include_sat_pix;
};
struct cifisp_awb_meas_config {
  uint8_t on;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  int32_t awb_mode;
  union {
    struct cifisp_awb_yc_meas_config yc;
    struct cifisp_awb_bayer_meas_config bayer;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  } config;
  uint8_t frames;
  struct cifisp_meas_grid grid;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct cifisp_awb_gain_config {
  uint8_t on;
  uint16_t gain_red;
  uint16_t gain_green_r;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint16_t gain_blue;
  uint16_t gain_green_b;
};
struct cifisp_gd_config {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint8_t on;
  uint8_t clip;
  uint32_t rgbd_coeffs;
  uint32_t config;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct cifisp_bnr_config {
  uint8_t on;
  uint32_t weight;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t antishading;
  uint32_t coeffs;
  uint32_t wb_gain;
  uint16_t lut[CIFISP_BNR_TABLE_SIZE];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  struct cifisp_gd_config gd;
};
struct cifisp_flt_config {
  uint8_t on;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t flt_mask_sharp0;
  uint32_t flt_mask_sharp1;
  uint32_t flt_mask_diag;
  uint32_t flt_mask_blur_max;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t flt_mask_blur;
  uint32_t flt_mask_lin;
  uint32_t flt_mask_orth;
  uint32_t flt_mask_v_diag;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t flt_mask_h_diag;
  uint32_t flt_lum_weight;
  uint16_t flt_blur_th0;
  uint16_t flt_blur_th1;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint16_t flt_sharp0_th;
  uint16_t flt_sharp1_th;
  uint16_t flt_cas_enable;
  uint16_t flt_cas_lowlevel;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint16_t flt_cas_th0;
  uint16_t flt_cas_th1;
  uint16_t flt_cas_inverse;
  uint8_t demosaic_th;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint8_t chrom_h_mode;
  uint8_t chrom_v_mode;
  uint8_t diag_sharp_mode;
  uint8_t flt_mode;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct cifisp_ctk_config {
  uint8_t on;
  uint16_t coeff[CIFISP_CTK_TBL_SIZE];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint16_t ct_offset_r;
  uint16_t ct_offset_g;
  uint16_t ct_offset_b;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct cifisp_goc_config {
  uint8_t on;
  uint32_t gamma_rgb[CIFISP_GAMMA_OUT_TBL_SIZE];
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct cifisp_macc_coeff {
  uint32_t coeff0;
  uint32_t coeff1;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct cifisp_macc_config {
  uint8_t on;
  struct cifisp_macc_coeff seg[CIFISP_MACC_SEGMENTS];
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct cifisp_cproc_config {
  uint8_t on;
  uint8_t contrast;
  uint8_t brightness;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint8_t sat;
  uint8_t hue;
};
struct cifisp_tmap_config {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint8_t on;
  uint16_t tmap_y[CIFISP_TONE_MAP_TABLE_SIZE];
  uint16_t tmap_c[CIFISP_TONE_MAP_TABLE_SIZE];
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct cifisp_hist_config {
  uint8_t on;
  uint8_t predivider;
  int32_t mode;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  struct cifisp_meas_grid grid;
};
struct cifisp_aem_config {
  uint8_t on;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint8_t autostop;
  struct cifisp_meas_grid grid;
};
struct cifisp_ycflt_config {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint8_t on;
  uint32_t ctrl;
  uint32_t ss_ctrl;
  uint32_t ss_fac;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t ss_offs;
  uint32_t chr_nr_ctrl;
  uint32_t lum_eenr_edge_gain;
  uint32_t lum_eenr_corner_gain;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t lum_eenr_fc_crop_pos;
  uint32_t lum_eenr_fc_crop_neg;
  uint32_t lum_eenr_fc_gain_pos;
  uint32_t lum_eenr_fc_gain_neg;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t lum_nr_ctrl;
  uint32_t lum_eenr_fc_coring_pos;
  uint32_t lum_eenr_fc_coring_neg;
  uint32_t color_tone_y_lut[CIFISP_COLOR_TONE_TABLE_SIZE];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t color_tone_cb_lut[CIFISP_COLOR_TONE_TABLE_SIZE];
  uint32_t color_tone_cr_lut[CIFISP_COLOR_TONE_TABLE_SIZE];
  uint32_t color_tone_s_lut[CIFISP_COLOR_TONE_TABLE_SIZE];
  uint32_t color_tone_norm_offs;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct cifisp_afm_config {
  uint8_t on;
  struct cifisp_meas_grid grid;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t afm_result1_thres;
  uint32_t afm_result2_thres;
  uint8_t afm_result1_rshift;
  uint8_t afm_result2_rshift;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint8_t afm_lum_rshift;
  uint32_t afm_filter_coeffs_matx[CIFISP_AFM_FILTER_SIZE];
  uint32_t afm_filter_coeffs_maty[CIFISP_AFM_FILTER_SIZE];
  uint32_t afm_bayer2y_coeffs[CIFISP_AFM_COEFFS_SIZE];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct cifisp_crop_config {
  int32_t left;
  int32_t top;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  uint32_t width;
  uint32_t height;
};
#ifdef __cplusplus
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#endif
#endif
