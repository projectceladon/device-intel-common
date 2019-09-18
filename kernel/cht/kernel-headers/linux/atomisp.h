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
#ifdef CSS15
#include <linux/atomisp_css15.h>
#else
#ifndef _ATOM_ISP_H
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define _ATOM_ISP_H
#include <linux/types.h>
#include <linux/version.h>
#include <stdbool.h>
#define ATOMISP_CSS_VERSION_MASK 0x00ffffff
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_CSS_VERSION_15 KERNEL_VERSION(1, 5, 0)
#define ATOMISP_CSS_VERSION_20 KERNEL_VERSION(2, 0, 0)
#define ATOMISP_CSS_VERSION_21 KERNEL_VERSION(2, 1, 0)
#define ATOMISP_HW_REVISION_MASK 0x0000ff00
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_HW_REVISION_SHIFT 8
#define ATOMISP_HW_REVISION_ISP2300 0x00
#define ATOMISP_HW_REVISION_ISP2400 0x10
#define ATOMISP_HW_REVISION_ISP2401_LEGACY 0x11
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_HW_REVISION_ISP2401 0x20
#define ATOMISP_HW_STEPPING_MASK 0x000000ff
#define ATOMISP_HW_STEPPING_A0 0x00
#define ATOMISP_HW_STEPPING_B0 0x10
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define CI_MODE_PREVIEW 0x8000
#define CI_MODE_VIDEO 0x4000
#define CI_MODE_STILL_CAPTURE 0x2000
#define CI_MODE_CONTINUOUS 0x1000
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define CI_MODE_NONE 0x0000
#define OUTPUT_MODE_FILE 0x0100
#define OUTPUT_MODE_TEXT 0x0200
#define ATOMISP_BUFFER_HAS_PER_FRAME_SETTING 0x80000000
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define V4L2_PIX_FMT_CUSTOM_M10MO_RAW v4l2_fourcc('M', '1', '0', '1')
#define V4L2_MBUS_FMT_CUSTOM_YUV420 0x8001
#define V4L2_MBUS_FMT_CUSTOM_YVU420 0x8002
#define V4L2_MBUS_FMT_CUSTOM_YUV422P 0x8003
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define V4L2_MBUS_FMT_CUSTOM_YUV444 0x8004
#define V4L2_MBUS_FMT_CUSTOM_NV12 0x8005
#define V4L2_MBUS_FMT_CUSTOM_NV21 0x8006
#define V4L2_MBUS_FMT_CUSTOM_NV16 0x8007
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define V4L2_MBUS_FMT_CUSTOM_YUYV 0x8008
#define V4L2_MBUS_FMT_CUSTOM_SBGGR16 0x8009
#define V4L2_MBUS_FMT_CUSTOM_RGB32 0x800a
#define V4L2_MBUS_FMT_CUSTOM_M10MO_RAW 0x800b
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_nr_config {
 unsigned int bnr_gain;
 unsigned int ynr_gain;
 unsigned int direction;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int threshold_cb;
 unsigned int threshold_cr;
};
struct atomisp_tnr_config {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int gain;
 unsigned int threshold_y;
 unsigned int threshold_uv;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_histogram {
 unsigned int num_elements;
 void __user *data;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
enum atomisp_ob_mode {
 atomisp_ob_mode_none,
 atomisp_ob_mode_fixed,
 atomisp_ob_mode_raster
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct atomisp_ob_config {
 enum atomisp_ob_mode mode;
 unsigned int level_gr;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int level_r;
 unsigned int level_b;
 unsigned int level_gb;
 unsigned short start_position;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned short end_position;
};
struct atomisp_ee_config {
 unsigned int gain;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int threshold;
 unsigned int detail_gain;
};
struct atomisp_3a_output {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 int ae_y;
 int awb_cnt;
 int awb_gr;
 int awb_r;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 int awb_b;
 int awb_gb;
 int af_hpf1;
 int af_hpf2;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
enum atomisp_calibration_type {
 calibration_type1,
 calibration_type2,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 calibration_type3
};
struct atomisp_calibration_group {
 unsigned int size;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int type;
 unsigned short *calb_grp_values;
};
struct atomisp_gc_config {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 __u16 gain_k1;
 __u16 gain_k2;
};
struct atomisp_3a_config {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int ae_y_coef_r;
 unsigned int ae_y_coef_g;
 unsigned int ae_y_coef_b;
 unsigned int awb_lg_high_raw;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int awb_lg_low;
 unsigned int awb_lg_high;
 int af_fir1_coef[7];
 int af_fir2_coef[7];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct atomisp_dvs_grid_info {
 uint32_t enable;
 uint32_t width;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 uint32_t aligned_width;
 uint32_t height;
 uint32_t aligned_height;
 uint32_t bqs_per_grid_cell;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 uint32_t num_hor_coefs;
 uint32_t num_ver_coefs;
};
struct atomisp_dvs_envelop {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int width;
 unsigned int height;
};
struct atomisp_grid_info {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 uint32_t enable;
 uint32_t use_dmem;
 uint32_t has_histogram;
 uint32_t s3a_width;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 uint32_t s3a_height;
 uint32_t aligned_width;
 uint32_t aligned_height;
 uint32_t s3a_bqs_per_grid_cell;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 uint32_t deci_factor_log2;
 uint32_t elem_bit_depth;
};
struct atomisp_dis_vector {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 int x;
 int y;
};
struct atomisp_dvs2_coef_types {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 short __user *odd_real;
 short __user *odd_imag;
 short __user *even_real;
 short __user *even_imag;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct atomisp_dvs2_stat_types {
 int __user *odd_real;
 int __user *odd_imag;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 int __user *even_real;
 int __user *even_imag;
};
struct atomisp_dis_coefficients {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 struct atomisp_dvs_grid_info grid_info;
 struct atomisp_dvs2_coef_types hor_coefs;
 struct atomisp_dvs2_coef_types ver_coefs;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_dvs2_statistics {
 struct atomisp_dvs_grid_info grid_info;
 struct atomisp_dvs2_stat_types hor_prod;
 struct atomisp_dvs2_stat_types ver_prod;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct atomisp_dis_statistics {
 struct atomisp_dvs2_statistics dvs2_stat;
 uint32_t exp_id;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct atomisp_3a_rgby_output {
 uint32_t r;
 uint32_t g;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 uint32_t b;
 uint32_t y;
};
enum atomisp_metadata_type {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 ATOMISP_MAIN_METADATA = 0,
 ATOMISP_SEC_METADATA,
 ATOMISP_METADATA_TYPE_NUM,
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_metadata_with_type {
 enum atomisp_metadata_type type;
 void __user *data;
 uint32_t width;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 uint32_t height;
 uint32_t stride;
 uint32_t exp_id;
 uint32_t *effective_width;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct atomisp_metadata {
 void __user *data;
 uint32_t width;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 uint32_t height;
 uint32_t stride;
 uint32_t exp_id;
 uint32_t *effective_width;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct atomisp_ext_isp_ctrl {
 uint32_t id;
 uint32_t data;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct atomisp_3a_statistics {
 struct atomisp_grid_info grid_info;
 struct atomisp_3a_output __user *data;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 struct atomisp_3a_rgby_output __user *rgby_data;
 uint32_t exp_id;
 uint32_t isp_config_id;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_cont_capture_conf {
 int num_captures;
 unsigned int skip_frames;
 int offset;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 __u32 reserved[5];
};
struct atomisp_ae_window {
 int x_left;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 int x_right;
 int y_top;
 int y_bottom;
 int weight;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct atomisp_wb_config {
 unsigned int integer_bits;
 unsigned int gr;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int r;
 unsigned int b;
 unsigned int gb;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_cc_config {
 unsigned int fraction_bits;
 int matrix[3 * 3];
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_de_config {
 unsigned int pixelnoise;
 unsigned int c1_coring_threshold;
 unsigned int c2_coring_threshold;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct atomisp_ce_config {
 unsigned char uv_level_min;
 unsigned char uv_level_max;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct atomisp_dp_config {
 unsigned int threshold;
 unsigned int gain;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int gr;
 unsigned int r;
 unsigned int b;
 unsigned int gb;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct atomisp_xnr_config {
 __u16 threshold;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_metadata_config {
 uint32_t metadata_height;
 uint32_t metadata_stride;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_resolution {
 uint32_t width;
 uint32_t height;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_zoom_point {
 int32_t x;
 int32_t y;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_zoom_region {
 struct atomisp_zoom_point origin;
 struct atomisp_resolution resolution;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_dz_config {
 uint32_t dx;
 uint32_t dy;
 struct atomisp_zoom_region zoom_region;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct atomisp_parm {
 struct atomisp_grid_info info;
 struct atomisp_dvs_grid_info dvs_grid;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 struct atomisp_dvs_envelop dvs_envelop;
 struct atomisp_wb_config wb_config;
 struct atomisp_cc_config cc_config;
 struct atomisp_ob_config ob_config;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 struct atomisp_de_config de_config;
 struct atomisp_dz_config dz_config;
 struct atomisp_ce_config ce_config;
 struct atomisp_dp_config dp_config;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 struct atomisp_nr_config nr_config;
 struct atomisp_ee_config ee_config;
 struct atomisp_tnr_config tnr_config;
 struct atomisp_metadata_config metadata_config;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct dvs2_bq_resolution {
 int width_bq;
 int height_bq;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct atomisp_dvs2_bq_resolutions {
 struct dvs2_bq_resolution source_bq;
 struct dvs2_bq_resolution output_bq;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 struct dvs2_bq_resolution envelope_bq;
 struct dvs2_bq_resolution ispfilter_bq;
 struct dvs2_bq_resolution gdc_shift_bq;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_dvs_6axis_config {
 uint32_t exp_id;
 uint32_t width_y;
 uint32_t height_y;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 uint32_t width_uv;
 uint32_t height_uv;
 uint32_t *xcoords_y;
 uint32_t *ycoords_y;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 uint32_t *xcoords_uv;
 uint32_t *ycoords_uv;
};
struct atomisp_formats_config {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 uint32_t video_full_range_flag;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_dpc2_config {
 int32_t metric1;
 int32_t metric2;
 int32_t metric3;
 int32_t wb_gain_gr;
 int32_t wb_gain_r;
 int32_t wb_gain_b;
 int32_t wb_gain_gb;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_CSS_NUMBER_OF_DEW_ENHANCE_SEGMENTS 9
struct atomisp_eed1_8_config {
 int32_t rbzp_strength;
 int32_t fcstrength;
 int32_t fcthres_0;
 int32_t fcthres_1;
 int32_t fc_sat_coef;
 int32_t fc_coring_prm;
 int32_t aerel_thres0;
 int32_t aerel_gain0;
 int32_t derel_thres0;
 int32_t derel_gain0;
 int32_t aerel_thres1;
 int32_t aerel_gain1;
 int32_t derel_thres1;
 int32_t derel_gain1;
 int32_t coring_pos0;
 int32_t coring_pos1;
 int32_t coring_neg0;
 int32_t coring_neg1;
 int32_t gain_exp;
 int32_t gain_pos0;
 int32_t gain_pos1;
 int32_t gain_neg0;
 int32_t gain_neg1;
 int32_t pos_margin0;
 int32_t pos_margin1;
 int32_t neg_margin0;
 int32_t neg_margin1;
 int32_t dew_enhance_seg_x[ATOMISP_CSS_NUMBER_OF_DEW_ENHANCE_SEGMENTS];
 int32_t dew_enhance_seg_y[ATOMISP_CSS_NUMBER_OF_DEW_ENHANCE_SEGMENTS];
 int32_t dew_enhance_seg_slope[(ATOMISP_CSS_NUMBER_OF_DEW_ENHANCE_SEGMENTS
         - 1)];
 int32_t dew_enhance_seg_exp[(ATOMISP_CSS_NUMBER_OF_DEW_ENHANCE_SEGMENTS
         - 1)];
 int32_t dedgew_max;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_ob2_config {
 uint32_t level_gr;
 uint32_t level_r;
 uint32_t level_b;
 uint32_t level_gb;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_ctc2_config {
 int32_t y_y0;
 int32_t y_y1;
 int32_t y_y2;
 int32_t y_y3;
 int32_t y_y4;
 int32_t y_y5;
 int32_t y_x1;
 int32_t y_x2;
 int32_t y_x3;
 int32_t y_x4;
 int32_t uv_y0;
 int32_t uv_y1;
 int32_t uv_x0;
 int32_t uv_x1;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_iefd2_6_config {
 int32_t horver_diag_coeff;
 int32_t ed_horver_diag_coeff;
 bool dir_smooth_enable;
 int32_t dir_metric_update;
 int32_t unsharp_c00;
 int32_t unsharp_c01;
 int32_t unsharp_c02;
 int32_t unsharp_c11;
 int32_t unsharp_c12;
 int32_t unsharp_c22;
 int32_t unsharp_weight;
 int32_t unsharp_amount;
 int32_t cu_dir_sharp_pow;
 int32_t cu_dir_sharp_pow_bright;
 int32_t cu_non_dir_sharp_pow;
 int32_t cu_non_dir_sharp_pow_bright;
 int32_t dir_far_sharp_weight;
 int32_t rad_cu_dir_sharp_x1;
 int32_t rad_cu_non_dir_sharp_x1;
 int32_t rad_dir_far_sharp_weight;
 int32_t sharp_nega_lmt_txt;
 int32_t sharp_posi_lmt_txt;
 int32_t sharp_nega_lmt_dir;
 int32_t sharp_posi_lmt_dir;
 int32_t clamp_stitch;
 bool rad_enable;
 int32_t rad_x_origin;
 int32_t rad_y_origin;
 int32_t rad_nf;
 int32_t rad_inv_r2;
 bool vssnlm_enable;
 int32_t vssnlm_x0;
 int32_t vssnlm_x1;
 int32_t vssnlm_x2;
 int32_t vssnlm_y1;
 int32_t vssnlm_y2;
 int32_t vssnlm_y3;
 int32_t cu_ed_points_x[6];
 int32_t cu_ed_slopes_a[5];
 int32_t cu_ed_slopes_b[5];
 int32_t cu_ed2_points_x[2];
 int32_t cu_ed2_slopes_a;
 int32_t cu_ed2_slopes_b;
 int32_t cu_dir_sharp_points_x[4];
 int32_t cu_dir_sharp_slopes_a[3];
 int32_t cu_dir_sharp_slopes_b[3];
 int32_t cu_non_dir_sharp_points_x[4];
 int32_t cu_non_dir_sharp_slopes_a[3];
 int32_t cu_non_dir_sharp_slopes_b[3];
 int32_t cu_radial_points_x[6];
 int32_t cu_radial_slopes_a[5];
 int32_t cu_radial_slopes_b[5];
 int32_t cu_vssnlm_points_x[2];
 int32_t cu_vssnlm_slopes_a;
 int32_t cu_vssnlm_slopes_b;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_macc1_5_config {
 uint8_t exp;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_CSS_MACC_NUM_AXES 16
#define ATOMISP_CSS_MACC_NUM_COEFS 4
struct atomisp_macc1_5_table {
 int16_t data[ATOMISP_CSS_MACC_NUM_COEFS * ATOMISP_CSS_MACC_NUM_AXES];
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_xnr3_0_11_config {
 int32_t weight_y0;
 int32_t weight_y1;
 int32_t weight_u0;
 int32_t weight_u1;
 int32_t weight_v0;
 int32_t weight_v1;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_bnlm_config  {
 bool rad_enable;
 int32_t rad_x_origin;
 int32_t rad_y_origin;
 int32_t mu_root_lut_thr[15];
 int32_t mu_root_lut_val[16];
 int32_t sad_norm_lut_thr[15];
 int32_t sad_norm_lut_val[16];
 int32_t sig_rad_lut_thr[15];
 int32_t sig_rad_lut_val[16];
 int32_t sig_detail_lut_thr[15];
 int32_t sig_detail_lut_val[16];
 int32_t rad_pow_lut_thr[15];
 int32_t rad_pow_lut_val[16];
 int32_t exp_coeff_a;
 uint32_t exp_coeff_b;
 int32_t exp_coeff_c;
 uint32_t exp_exponent;
 int32_t nl_0_lut_thr[15];
 int32_t nl_0_lut_val[16];
 int32_t nl_1_lut_thr[15];
 int32_t nl_1_lut_val[16];
 int32_t nl_2_lut_thr[15];
 int32_t nl_2_lut_val[16];
 int32_t nl_3_lut_thr[15];
 int32_t nl_3_lut_val[16];
 int32_t nl_th[3];
 int32_t match_quality_max_idx[4];
 int32_t avg_min_th;
 int32_t max_min_th;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_tdf_config {
 int32_t thres_flat_table[64];
 int32_t thres_detail_table[64];
 int32_t epsilon_0;
 int32_t epsilon_1;
 int32_t eps_scale_text;
 int32_t eps_scale_edge;
 int32_t sepa_flat;
 int32_t sepa_edge;
 int32_t blend_flat;
 int32_t blend_text;
 int32_t blend_edge;
 int32_t shading_gain;
 int32_t shading_base_gain;
 int32_t local_y_gain;
 int32_t local_y_base_gain;
 int32_t rad_x_origin;
 int32_t rad_y_origin;
 int32_t blend_ratio;
 int32_t min_edge_thres;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_parameters {
 struct atomisp_wb_config *wb_config;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 struct atomisp_cc_config *cc_config;
 struct atomisp_tnr_config *tnr_config;
 struct atomisp_ecd_config *ecd_config;
 struct atomisp_ynr_config *ynr_config;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 struct atomisp_fc_config *fc_config;
 struct atomisp_formats_config *formats_config;
 struct atomisp_cnr_config *cnr_config;
 struct atomisp_macc_config *macc_config;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 struct atomisp_ctc_config *ctc_config;
 struct atomisp_aa_config *aa_config;
 struct atomisp_aa_config *baa_config;
 struct atomisp_ce_config *ce_config;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 struct atomisp_dvs_6axis_config *dvs_6axis_config;
 struct atomisp_ob_config *ob_config;
 struct atomisp_dp_config *dp_config;
 struct atomisp_nr_config *nr_config;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 struct atomisp_ee_config *ee_config;
 struct atomisp_de_config *de_config;
 struct atomisp_gc_config *gc_config;
 struct atomisp_anr_config *anr_config;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 struct atomisp_3a_config *a3a_config;
 struct atomisp_xnr_config *xnr_config;
 struct atomisp_dz_config *dz_config;
 struct atomisp_cc_config *yuv2rgb_cc_config;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 struct atomisp_cc_config *rgb2yuv_cc_config;
 struct atomisp_macc_table *macc_table;
 struct atomisp_gamma_table *gamma_table;
 struct atomisp_ctc_table *ctc_table;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 struct atomisp_xnr_table *xnr_table;
 struct atomisp_rgb_gamma_table *r_gamma_table;
 struct atomisp_rgb_gamma_table *g_gamma_table;
 struct atomisp_rgb_gamma_table *b_gamma_table;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 struct atomisp_vector *motion_vector;
 struct atomisp_shading_table *shading_table;
 struct atomisp_morph_table *morph_table;
 struct atomisp_dvs_coefficients *dvs_coefs;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 struct atomisp_dvs2_coefficients *dvs2_coefs;
 struct atomisp_capture_config *capture_config;
 struct atomisp_anr_thres *anr_thres;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 struct atomisp_dpc2_config *dpc2_config;
 struct atomisp_eed1_8_config *eed1_8_config;
 struct atomisp_ob2_config *ob2_config;
 struct atomisp_ctc2_config *ctc2_config;
 struct atomisp_iefd2_6_config *iefd2_6_config;
 struct atomisp_macc1_5_config *macc1_5_config;
 struct atomisp_macc1_5_table *macc1_5_table;
 struct atomisp_xnr3_0_11_config *xnr3_0_11_config;
 struct atomisp_bnlm_config  *bnlm_config;
 struct atomisp_tdf_config *tdf_config;
 void *lin_2500_config;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 void *obgrid_2500_config;
 void *bnr_2500_config;
 void *shd_2500_config;
 void *dm_2500_config;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 void *rgbpp_2500_config;
 void *dvs_stat_2500_config;
 void *lace_stat_2500_config;
 void *yuvp1_2500_config;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 void *yuvp2_2500_config;
 void *tnr_2500_config;
 void *dpc_2500_config;
 void *awb_2500_config;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 void *awb_fr_2500_config;
 void *anr_2500_config;
 void *af_2500_config;
 void *ae_2500_config;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 void *bds_2500_config;
 void *dvs_2500_config;
 void *res_mgr_2500_config;
 void *output_frame;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 uint32_t isp_config_id;
 uint32_t per_frame_setting;
};
#define ATOMISP_GAMMA_TABLE_SIZE 1024
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_gamma_table {
 unsigned short data[ATOMISP_GAMMA_TABLE_SIZE];
};
#define ATOMISP_MORPH_TABLE_NUM_PLANES 6
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_morph_table {
 unsigned int enabled;
 unsigned int height;
 unsigned int width;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned short __user *coordinates_x[ATOMISP_MORPH_TABLE_NUM_PLANES];
 unsigned short __user *coordinates_y[ATOMISP_MORPH_TABLE_NUM_PLANES];
};
#define ATOMISP_NUM_SC_COLORS 4
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_SC_FLAG_QUERY (1 << 0)
struct atomisp_shading_table {
 __u32 enable;
 __u32 sensor_width;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 __u32 sensor_height;
 __u32 width;
 __u32 height;
 __u32 fraction_bits;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 __u16 *data[ATOMISP_NUM_SC_COLORS];
};
struct atomisp_makernote_info {
 unsigned int focal_length;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int f_number_curr;
 unsigned int f_number_range;
};
#define ATOMISP_NUM_MACC_AXES 16
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_macc_table {
 short data[4 * ATOMISP_NUM_MACC_AXES];
};
struct atomisp_macc_config {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 int color_effect;
 struct atomisp_macc_table table;
};
#define ATOMISP_CTC_TABLE_SIZE 1024
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_ctc_table {
 unsigned short data[ATOMISP_CTC_TABLE_SIZE];
};
struct atomisp_overlay {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 struct v4l2_framebuffer *frame;
 unsigned char bg_y;
 char bg_u;
 char bg_v;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned char blend_input_perc_y;
 unsigned char blend_input_perc_u;
 unsigned char blend_input_perc_v;
 unsigned char blend_overlay_perc_y;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned char blend_overlay_perc_u;
 unsigned char blend_overlay_perc_v;
 unsigned int overlay_start_x;
 unsigned int overlay_start_y;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct atomisp_sensor_mode_data {
 unsigned int coarse_integration_time_min;
 unsigned int coarse_integration_time_max_margin;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int fine_integration_time_min;
 unsigned int fine_integration_time_max_margin;
 unsigned int fine_integration_time_def;
 unsigned int frame_length_lines;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int line_length_pck;
 unsigned int read_mode;
 unsigned int vt_pix_clk_freq_mhz;
 unsigned int crop_horizontal_start;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int crop_vertical_start;
 unsigned int crop_horizontal_end;
 unsigned int crop_vertical_end;
 unsigned int output_width;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int output_height;
 uint8_t binning_factor_x;
 uint8_t binning_factor_y;
 uint16_t hts;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct atomisp_exposure {
 unsigned int integration_time[8];
 unsigned int shutter_speed[8];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int gain[4];
 unsigned int aperture;
};
struct atomisp_bc_video_package {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 int ioctl_cmd;
 int device_id;
 int inputparam;
 int outputparam;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
enum atomisp_focus_hp {
 ATOMISP_FOCUS_HP_IN_PROGRESS = (1U << 2),
 ATOMISP_FOCUS_HP_COMPLETE = (2U << 2),
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 ATOMISP_FOCUS_HP_FAILED = (3U << 2)
};
#define ATOMISP_FOCUS_STATUS_MOVING (1U << 0)
#define ATOMISP_FOCUS_STATUS_ACCEPTS_NEW_MOVE (1U << 1)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_FOCUS_STATUS_HOME_POSITION (3U << 2)
enum atomisp_camera_port {
 ATOMISP_CAMERA_PORT_SECONDARY,
 ATOMISP_CAMERA_PORT_PRIMARY,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 ATOMISP_CAMERA_PORT_TERTIARY,
 ATOMISP_CAMERA_NR_PORTS
};
enum atomisp_flash_mode {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 ATOMISP_FLASH_MODE_OFF,
 ATOMISP_FLASH_MODE_FLASH,
 ATOMISP_FLASH_MODE_TORCH,
 ATOMISP_FLASH_MODE_INDICATOR,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
enum atomisp_flash_status {
 ATOMISP_FLASH_STATUS_OK,
 ATOMISP_FLASH_STATUS_HW_ERROR,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 ATOMISP_FLASH_STATUS_INTERRUPTED,
 ATOMISP_FLASH_STATUS_TIMEOUT,
};
enum atomisp_frame_status {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 ATOMISP_FRAME_STATUS_OK,
 ATOMISP_FRAME_STATUS_CORRUPTED,
 ATOMISP_FRAME_STATUS_FLASH_EXPOSED,
 ATOMISP_FRAME_STATUS_FLASH_PARTIAL,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 ATOMISP_FRAME_STATUS_FLASH_FAILED,
};
enum atomisp_acc_type {
 ATOMISP_ACC_STANDALONE,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 ATOMISP_ACC_OUTPUT,
 ATOMISP_ACC_VIEWFINDER
};
enum atomisp_acc_arg_type {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 ATOMISP_ACC_ARG_SCALAR_IN,
 ATOMISP_ACC_ARG_SCALAR_OUT,
 ATOMISP_ACC_ARG_SCALAR_IO,
 ATOMISP_ACC_ARG_PTR_IN,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 ATOMISP_ACC_ARG_PTR_OUT,
 ATOMISP_ACC_ARG_PTR_IO,
 ATOMISP_ARG_PTR_NOFLUSH,
 ATOMISP_ARG_PTR_STABLE,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 ATOMISP_ACC_ARG_FRAME
};
enum atomisp_acc_memory {
 ATOMISP_ACC_MEMORY_PMEM0 = 0,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 ATOMISP_ACC_MEMORY_DMEM0,
 ATOMISP_ACC_MEMORY_DMEM = ATOMISP_ACC_MEMORY_DMEM0,
 ATOMISP_ACC_MEMORY_VMEM0,
 ATOMISP_ACC_MEMORY_VAMEM0,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 ATOMISP_ACC_MEMORY_VAMEM1,
 ATOMISP_ACC_MEMORY_VAMEM2,
 ATOMISP_ACC_MEMORY_HMEM0,
 ATOMISP_ACC_NR_MEMORY
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
enum atomisp_ext_isp_id {
 EXT_ISP_CID_ISO = 0,
 EXT_ISP_CID_CAPTURE_HDR,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 EXT_ISP_CID_CAPTURE_LLS,
 EXT_ISP_CID_FOCUS_MODE,
 EXT_ISP_CID_FOCUS_EXECUTION,
 EXT_ISP_CID_TOUCH_POSX,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 EXT_ISP_CID_TOUCH_POSY,
 EXT_ISP_CID_CAF_STATUS,
 EXT_ISP_CID_AF_STATUS,
 EXT_ISP_CID_GET_AF_MODE,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 EXT_ISP_CID_CAPTURE_BURST,
 EXT_ISP_CID_FLASH_MODE,
 EXT_ISP_CID_ZOOM,
 EXT_ISP_CID_SHOT_MODE
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
#define EXT_ISP_FOCUS_MODE_NORMAL 0
#define EXT_ISP_FOCUS_MODE_MACRO 1
#define EXT_ISP_FOCUS_MODE_TOUCH_AF 2
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define EXT_ISP_FOCUS_MODE_PREVIEW_CAF 3
#define EXT_ISP_FOCUS_MODE_MOVIE_CAF 4
#define EXT_ISP_FOCUS_MODE_FACE_CAF 5
#define EXT_ISP_FOCUS_MODE_TOUCH_MACRO 6
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define EXT_ISP_FOCUS_MODE_TOUCH_CAF 7
#define EXT_ISP_FOCUS_STOP 0
#define EXT_ISP_FOCUS_SEARCH 1
#define EXT_ISP_PAN_FOCUSING 2
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define EXT_ISP_CAF_RESTART_CHECK 1
#define EXT_ISP_CAF_STATUS_FOCUSING 2
#define EXT_ISP_CAF_STATUS_SUCCESS 3
#define EXT_ISP_CAF_STATUS_FAIL 4
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define EXT_ISP_AF_STATUS_INVALID 1
#define EXT_ISP_AF_STATUS_FOCUSING 2
#define EXT_ISP_AF_STATUS_SUCCESS 3
#define EXT_ISP_AF_STATUS_FAIL 4
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
enum atomisp_burst_capture_options {
 EXT_ISP_BURST_CAPTURE_CTRL_START = 0,
 EXT_ISP_BURST_CAPTURE_CTRL_STOP
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define EXT_ISP_FLASH_MODE_OFF 0
#define EXT_ISP_FLASH_MODE_ON 1
#define EXT_ISP_FLASH_MODE_AUTO 2
#define EXT_ISP_LED_TORCH_OFF 3
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define EXT_ISP_LED_TORCH_ON 4
#define EXT_ISP_SHOT_MODE_AUTO 0
#define EXT_ISP_SHOT_MODE_BEAUTY_FACE 1
#define EXT_ISP_SHOT_MODE_BEST_PHOTO 2
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define EXT_ISP_SHOT_MODE_DRAMA 3
#define EXT_ISP_SHOT_MODE_BEST_FACE 4
#define EXT_ISP_SHOT_MODE_ERASER 5
#define EXT_ISP_SHOT_MODE_PANORAMA 6
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define EXT_ISP_SHOT_MODE_RICH_TONE_HDR 7
#define EXT_ISP_SHOT_MODE_NIGHT 8
#define EXT_ISP_SHOT_MODE_SOUND_SHOT 9
#define EXT_ISP_SHOT_MODE_ANIMATED_PHOTO 10
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define EXT_ISP_SHOT_MODE_SPORTS 11
struct atomisp_sp_arg {
 enum atomisp_acc_arg_type type;
 void *value;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int size;
};
struct atomisp_acc_fw_arg {
 unsigned int fw_handle;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int index;
 void __user *value;
 size_t size;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_acc_s_mapped_arg {
 unsigned int fw_handle;
 __u32 memory;
 size_t length;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned long css_ptr;
};
struct atomisp_acc_fw_abort {
 unsigned int fw_handle;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int timeout;
};
struct atomisp_acc_fw_load {
 unsigned int size;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int fw_handle;
 void __user *data;
};
struct atomisp_acc_fw_load_to_pipe {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 __u32 flags;
 unsigned int fw_handle;
 __u32 size;
 void __user *data;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 __u32 type;
 __u32 reserved[3];
};
struct atomisp_s_runmode {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 __u32 mode;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_record_header {
 uint32_t uuid;
 uint32_t size;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
enum atomisp_config_uuid {
 atomisp_wb_config_uuid = 1,
 atomisp_dp_config_uuid = 2,
 atomisp_dp_config2_uuid = 3,  /*ISP 2.6.1 specific block */
 atomisp_cc_config_yuv2rgb_uuid = 4,
 atomisp_tnr_config_uuid = 5,
 atomisp_ecd_config_uuid = 6,
 atomisp_fc_config_uuid = 7,
 atomisp_ynr_config_uuid = 8,
 atomisp_formats_config_uuid = 9,
 atomisp_cnr_config_uuid = 10,
 atomisp_aa_config1_uuid = 11 ,
 atomisp_aa_config2_uuid = 12,
 atomisp_ee_config_uuid = 13,
 atomisp_macc_table_uuid = 14,
 atomisp_macc_config_uuid = 15,
 atomisp_nr_config_uuid = 16,
 atomisp_ob_config_uuid = 17,
 atomisp_xnr_config_uuid = 18,
 atomisp_cc_config_rgb2yuv_uuid = 19,
 atomisp_3a_config_uuid = 20,
 atomisp_gc_config_uuid = 21,
 atomisp_ce_config_uuid = 22,
 atomisp_de_config_uuid = 23,
 atomisp_config_id_uuid = 24,
 atomisp_rgb1_gamma_table_uuid = 25,
 atomisp_rgb2_gamma_table_uuid = 26,
 atomisp_rgb3_gamma_table_uuid = 27,
 atomisp_shading_table_uuid = 28,
 atomisp_btdf_config_uuid = 29,
 atomisp_bnr2_config_uuid = 30,
 atomisp_bnlm_config_uuid = 31,
 atomisp_eed_config_uuid = 32,
 atomisp_xnr3_0_11_config_uuid = 33,
 atomisp_iefd_config_uuid = 34,
 atomisp_ctc2_config_uuid = 35,
 atomisp_xnr3_0_5_config_uuid = 36, /*end of the AIC runtime config records */
 atomisp_ctc_config_uuid,
 atomisp_dvs_6axis_config_uuid,
 atomisp_anr_config_uuid,
 atomisp_dz_config_uuid,
 atomisp_gamma_table_uuid,
 atomisp_ctc_table_uuid,
 atomisp_xnr_table_uuid,
 atomisp_vector_uuid,
 atomisp_morph_table_uuid,
 atomisp_dvs_coefficients_uuid,
 atomisp_dvs2_coefficients_uuid,
 atomisp_capture_config_uuid,
 atomisp_anr_thres_uuid,
 atomisp_2500_lin_kernel_config_uuid,
 atomisp_2500_obgrid_kernel_config_uuid,
 atomisp_2500_bnr_kernel_config_uuid,
 atomisp_2500_shd_kernel_config_uuid,
 atomisp_2500_dm_kernel_config_uuid,
 atomisp_2500_rgbpp_kernel_config_uuid,
 atomisp_2500_yuvp1_kernel_config_uuid,
 atomisp_2500_yuvp2_kernel_config_uuid,
 atomisp_2500_tnr_kernel_config_uuid,
 atomisp_2500_dpc_kernel_config_uuid,
 atomisp_2500_awb_kernel_config_uuid,
 atomisp_2500_awb_fr_kernel_config_uuid,
 atomisp_2500_anr_kernel_config_uuid,
 atomisp_2500_af_kernel_config_uuid,
 atomisp_2500_ae_kernel_config_uuid,
 atomisp_2500_bds_kernel_config_uuid,
 atomisp_2500_dvs_kernel_config_uuid,
 atomisp_frame_uuid
};
#define ATOMISP_ACC_FW_LOAD_FL_PREVIEW (1 << 0)
#define ATOMISP_ACC_FW_LOAD_FL_COPY (1 << 1)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_ACC_FW_LOAD_FL_VIDEO (1 << 2)
#define ATOMISP_ACC_FW_LOAD_FL_CAPTURE (1 << 3)
#define ATOMISP_ACC_FW_LOAD_FL_ACC (1 << 4)
#define ATOMISP_ACC_FW_LOAD_FL_ENABLE (1 << 16)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_ACC_FW_LOAD_TYPE_NONE 0
#define ATOMISP_ACC_FW_LOAD_TYPE_OUTPUT 1
#define ATOMISP_ACC_FW_LOAD_TYPE_VIEWFINDER 2
#define ATOMISP_ACC_FW_LOAD_TYPE_STANDALONE 3
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_acc_map {
 __u32 flags;
 __u32 length;
 void __user *user_ptr;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned long css_ptr;
 __u32 reserved[4];
};
#define ATOMISP_MAP_FLAG_NOFLUSH 0x0001
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_MAP_FLAG_CACHED 0x0002
struct atomisp_acc_state {
 __u32 flags;
#define ATOMISP_STATE_FLAG_ENABLE ATOMISP_ACC_FW_LOAD_FL_ENABLE
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int fw_handle;
};
struct atomisp_update_exposure {
	unsigned int gain;
	unsigned int digi_gain;
	unsigned int update_gain;
	unsigned int update_digi_gain;
};
struct v4l2_private_int_data {
 __u32 size;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 void __user *data;
 __u32 reserved[2];
};
enum atomisp_sensor_ae_bracketing_mode {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 SENSOR_AE_BRACKETING_MODE_OFF = 0,
 SENSOR_AE_BRACKETING_MODE_SINGLE,
 SENSOR_AE_BRACKETING_MODE_SINGLE_TO_STREAMING,
 SENSOR_AE_BRACKETING_MODE_LOOP,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct atomisp_sensor_ae_bracketing_info {
 unsigned int modes;
 unsigned int lut_depth;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct atomisp_sensor_ae_bracketing_lut_entry {
 __u16 coarse_integration_time;
 __u16 analog_gain;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 __u16 digital_gain;
};
struct atomisp_sensor_ae_bracketing_lut {
 struct atomisp_sensor_ae_bracketing_lut_entry *lut;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 unsigned int lut_size;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct atomisp_isp_frame_params{
 __u16 isp_horizontal_crop_offset;
 __u16 isp_vertical_crop_offset;
 __u16 isp_crop_image_width;
 __u16 isp_crop_image_height;
};
#define ATOMISP_IOC_G_XNR   _IOR('v', BASE_VIDIOC_PRIVATE + 0, int)
#define ATOMISP_IOC_S_XNR   _IOW('v', BASE_VIDIOC_PRIVATE + 0, int)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_IOC_G_NR   _IOR('v', BASE_VIDIOC_PRIVATE + 1, struct atomisp_nr_config)
#define ATOMISP_IOC_S_NR   _IOW('v', BASE_VIDIOC_PRIVATE + 1, struct atomisp_nr_config)
#define ATOMISP_IOC_G_TNR   _IOR('v', BASE_VIDIOC_PRIVATE + 2, struct atomisp_tnr_config)
#define ATOMISP_IOC_S_TNR   _IOW('v', BASE_VIDIOC_PRIVATE + 2, struct atomisp_tnr_config)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_IOC_G_HISTOGRAM   _IOWR('v', BASE_VIDIOC_PRIVATE + 3, struct atomisp_histogram)
#define ATOMISP_IOC_S_HISTOGRAM   _IOW('v', BASE_VIDIOC_PRIVATE + 3, struct atomisp_histogram)
#define ATOMISP_IOC_G_BLACK_LEVEL_COMP   _IOR('v', BASE_VIDIOC_PRIVATE + 4, struct atomisp_ob_config)
#define ATOMISP_IOC_S_BLACK_LEVEL_COMP   _IOW('v', BASE_VIDIOC_PRIVATE + 4, struct atomisp_ob_config)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_IOC_G_EE   _IOR('v', BASE_VIDIOC_PRIVATE + 5, struct atomisp_ee_config)
#define ATOMISP_IOC_S_EE   _IOW('v', BASE_VIDIOC_PRIVATE + 5, struct atomisp_ee_config)
#define ATOMISP_IOC_G_DIS_STAT   _IOWR('v', BASE_VIDIOC_PRIVATE + 6, struct atomisp_dis_statistics)
#define ATOMISP_IOC_G_DVS2_BQ_RESOLUTIONS   _IOR('v', BASE_VIDIOC_PRIVATE + 6, struct atomisp_dvs2_bq_resolutions)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_IOC_S_DIS_COEFS   _IOW('v', BASE_VIDIOC_PRIVATE + 6, struct atomisp_dis_coefficients)
#define ATOMISP_IOC_S_DIS_VECTOR   _IOW('v', BASE_VIDIOC_PRIVATE + 6, struct atomisp_dvs_6axis_config)
#define ATOMISP_IOC_G_3A_STAT   _IOWR('v', BASE_VIDIOC_PRIVATE + 7, struct atomisp_3a_statistics)
#define ATOMISP_IOC_G_ISP_PARM   _IOR('v', BASE_VIDIOC_PRIVATE + 8, struct atomisp_parm)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_IOC_S_ISP_PARM   _IOW('v', BASE_VIDIOC_PRIVATE + 8, struct atomisp_parm)
#define ATOMISP_IOC_G_ISP_GAMMA   _IOR('v', BASE_VIDIOC_PRIVATE + 9, struct atomisp_gamma_table)
#define ATOMISP_IOC_S_ISP_GAMMA   _IOW('v', BASE_VIDIOC_PRIVATE + 9, struct atomisp_gamma_table)
#define ATOMISP_IOC_G_ISP_GDC_TAB   _IOR('v', BASE_VIDIOC_PRIVATE + 10, struct atomisp_morph_table)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_IOC_S_ISP_GDC_TAB   _IOW('v', BASE_VIDIOC_PRIVATE + 10, struct atomisp_morph_table)
#define ATOMISP_IOC_ISP_MAKERNOTE   _IOWR('v', BASE_VIDIOC_PRIVATE + 11, struct atomisp_makernote_info)
#define ATOMISP_IOC_G_ISP_MACC   _IOR('v', BASE_VIDIOC_PRIVATE + 12, struct atomisp_macc_config)
#define ATOMISP_IOC_S_ISP_MACC   _IOW('v', BASE_VIDIOC_PRIVATE + 12, struct atomisp_macc_config)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_IOC_G_ISP_BAD_PIXEL_DETECTION   _IOR('v', BASE_VIDIOC_PRIVATE + 13, struct atomisp_dp_config)
#define ATOMISP_IOC_S_ISP_BAD_PIXEL_DETECTION   _IOW('v', BASE_VIDIOC_PRIVATE + 13, struct atomisp_dp_config)
#define ATOMISP_IOC_G_ISP_FALSE_COLOR_CORRECTION   _IOR('v', BASE_VIDIOC_PRIVATE + 14, struct atomisp_de_config)
#define ATOMISP_IOC_S_ISP_FALSE_COLOR_CORRECTION   _IOW('v', BASE_VIDIOC_PRIVATE + 14, struct atomisp_de_config)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_IOC_G_ISP_CTC   _IOR('v', BASE_VIDIOC_PRIVATE + 15, struct atomisp_ctc_table)
#define ATOMISP_IOC_S_ISP_CTC   _IOW('v', BASE_VIDIOC_PRIVATE + 15, struct atomisp_ctc_table)
#define ATOMISP_IOC_G_ISP_WHITE_BALANCE   _IOR('v', BASE_VIDIOC_PRIVATE + 16, struct atomisp_wb_config)
#define ATOMISP_IOC_S_ISP_WHITE_BALANCE   _IOW('v', BASE_VIDIOC_PRIVATE + 16, struct atomisp_wb_config)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_IOC_S_ISP_FPN_TABLE   _IOW('v', BASE_VIDIOC_PRIVATE + 17, struct v4l2_framebuffer)
#define ATOMISP_IOC_G_ISP_OVERLAY   _IOWR('v', BASE_VIDIOC_PRIVATE + 18, struct atomisp_overlay)
#define ATOMISP_IOC_S_ISP_OVERLAY   _IOW('v', BASE_VIDIOC_PRIVATE + 18, struct atomisp_overlay)
#define ATOMISP_IOC_CAMERA_BRIDGE   _IOWR('v', BASE_VIDIOC_PRIVATE + 19, struct atomisp_bc_video_package)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_IOC_G_SENSOR_MODE_DATA   _IOR('v', BASE_VIDIOC_PRIVATE + 20, struct atomisp_sensor_mode_data)
#define ATOMISP_IOC_S_EXPOSURE   _IOW('v', BASE_VIDIOC_PRIVATE + 21, struct atomisp_exposure)
#define ATOMISP_IOC_G_SENSOR_CALIBRATION_GROUP   _IOWR('v', BASE_VIDIOC_PRIVATE + 22, struct atomisp_calibration_group)
#define ATOMISP_IOC_G_3A_CONFIG   _IOR('v', BASE_VIDIOC_PRIVATE + 23, struct atomisp_3a_config)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_IOC_S_3A_CONFIG   _IOW('v', BASE_VIDIOC_PRIVATE + 23, struct atomisp_3a_config)
#define ATOMISP_IOC_ACC_LOAD   _IOWR('v', BASE_VIDIOC_PRIVATE + 24, struct atomisp_acc_fw_load)
#define ATOMISP_IOC_ACC_UNLOAD   _IOWR('v', BASE_VIDIOC_PRIVATE + 24, unsigned int)
#define ATOMISP_IOC_ACC_S_ARG   _IOW('v', BASE_VIDIOC_PRIVATE + 24, struct atomisp_acc_fw_arg)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_IOC_ACC_START   _IOW('v', BASE_VIDIOC_PRIVATE + 24, unsigned int)
#define ATOMISP_IOC_ACC_WAIT   _IOW('v', BASE_VIDIOC_PRIVATE + 25, unsigned int)
#define ATOMISP_IOC_ACC_ABORT   _IOW('v', BASE_VIDIOC_PRIVATE + 25, struct atomisp_acc_fw_abort)
#define ATOMISP_IOC_ACC_DESTAB   _IOW('v', BASE_VIDIOC_PRIVATE + 25, struct atomisp_acc_fw_arg)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_IOC_G_SENSOR_PRIV_INT_DATA   _IOWR('v', BASE_VIDIOC_PRIVATE + 26, struct v4l2_private_int_data)
#define ATOMISP_IOC_S_ISP_SHD_TAB   _IOWR('v', BASE_VIDIOC_PRIVATE + 27, struct atomisp_shading_table)
#define ATOMISP_IOC_G_ISP_GAMMA_CORRECTION   _IOR('v', BASE_VIDIOC_PRIVATE + 28, struct atomisp_gc_config)
#define ATOMISP_IOC_S_ISP_GAMMA_CORRECTION   _IOW('v', BASE_VIDIOC_PRIVATE + 28, struct atomisp_gc_config)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_IOC_G_MOTOR_PRIV_INT_DATA   _IOWR('v', BASE_VIDIOC_PRIVATE + 29, struct v4l2_private_int_data)
#define ATOMISP_IOC_ACC_MAP   _IOWR('v', BASE_VIDIOC_PRIVATE + 30, struct atomisp_acc_map)
#define ATOMISP_IOC_ACC_UNMAP   _IOW('v', BASE_VIDIOC_PRIVATE + 30, struct atomisp_acc_map)
#define ATOMISP_IOC_ACC_S_MAPPED_ARG   _IOW('v', BASE_VIDIOC_PRIVATE + 30, struct atomisp_acc_s_mapped_arg)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_IOC_ACC_LOAD_TO_PIPE   _IOWR('v', BASE_VIDIOC_PRIVATE + 31, struct atomisp_acc_fw_load_to_pipe)
#define ATOMISP_IOC_S_PARAMETERS   _IOW('v', BASE_VIDIOC_PRIVATE + 32, struct atomisp_parameters)
#define ATOMISP_IOC_S_CONT_CAPTURE_CONFIG   _IOWR('v', BASE_VIDIOC_PRIVATE + 33, struct atomisp_cont_capture_conf)
#define ATOMISP_IOC_G_METADATA   _IOWR('v', BASE_VIDIOC_PRIVATE + 34, struct atomisp_metadata)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_IOC_G_METADATA_BY_TYPE   _IOWR('v', BASE_VIDIOC_PRIVATE + 34, struct atomisp_metadata_with_type)
#define ATOMISP_IOC_EXT_ISP_CTRL   _IOWR('v', BASE_VIDIOC_PRIVATE + 35, struct atomisp_ext_isp_ctrl)
#define ATOMISP_IOC_EXP_ID_UNLOCK   _IOW('v', BASE_VIDIOC_PRIVATE + 36, int)
#define ATOMISP_IOC_EXP_ID_CAPTURE   _IOW('v', BASE_VIDIOC_PRIVATE + 37, int)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_IOC_S_ENABLE_DZ_CAPT_PIPE   _IOWR('v', BASE_VIDIOC_PRIVATE + 38, unsigned int)
#define ATOMISP_IOC_G_FORMATS_CONFIG   _IOR('v', BASE_VIDIOC_PRIVATE + 39, struct atomisp_formats_config)
#define ATOMISP_IOC_S_FORMATS_CONFIG   _IOW('v', BASE_VIDIOC_PRIVATE + 39, struct atomisp_formats_config)
#define ATOMISP_IOC_S_EXPOSURE_WINDOW   _IOW('v', BASE_VIDIOC_PRIVATE + 40, struct atomisp_ae_window)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_IOC_S_ACC_STATE   _IOW('v', BASE_VIDIOC_PRIVATE + 41, struct atomisp_acc_state)
#define ATOMISP_IOC_G_ACC_STATE   _IOR('v', BASE_VIDIOC_PRIVATE + 41, struct atomisp_acc_state)
#define ATOMISP_IOC_INJECT_A_FAKE_EVENT   _IOW('v', BASE_VIDIOC_PRIVATE + 42, int)
#define ATOMISP_IOC_G_SENSOR_AE_BRACKETING_INFO   _IOR('v', BASE_VIDIOC_PRIVATE + 43, struct atomisp_sensor_ae_bracketing_info)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_IOC_S_SENSOR_AE_BRACKETING_MODE   _IOW('v', BASE_VIDIOC_PRIVATE + 43, unsigned int)
#define ATOMISP_IOC_G_SENSOR_AE_BRACKETING_MODE   _IOR('v', BASE_VIDIOC_PRIVATE + 43, unsigned int)
#define ATOMISP_IOC_S_SENSOR_AE_BRACKETING_LUT   _IOW('v', BASE_VIDIOC_PRIVATE + 43, struct atomisp_sensor_ae_bracketing_lut)
#define ATOMISP_IOC_G_INVALID_FRAME_NUM   _IOR('v', BASE_VIDIOC_PRIVATE + 44, unsigned int)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_IOC_S_ARRAY_RESOLUTION   _IOW('v', BASE_VIDIOC_PRIVATE + 45, struct atomisp_resolution)
#define ATOMISP_IOC_G_DEPTH_SYNC_COMP   _IOR('v', BASE_VIDIOC_PRIVATE + 46, unsigned int)
#define ATOMISP_IOC_S_SENSOR_EE_CONFIG   _IOW('v', BASE_VIDIOC_PRIVATE + 47, unsigned int)
#define ATOMISP_IOC_S_SENSOR_RUNMODE   _IOW('v', BASE_VIDIOC_PRIVATE + 48, struct atomisp_s_runmode)
#define ATOMISP_IOC_G_UPDATE_EXPOSURE  _IOWR('v', BASE_VIDIOC_PRIVATE + 49, struct atomisp_update_exposure)
#define ATOMISP_IOC_G_ISP_FRAME_PARAMS _IOWR('v', BASE_VIDIOC_PRIVATE + 50, struct atomisp_isp_frame_params)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define V4L2_CID_ATOMISP_BAD_PIXEL_DETECTION   (V4L2_CID_PRIVATE_BASE + 0)
#define V4L2_CID_ATOMISP_POSTPROCESS_GDC_CAC   (V4L2_CID_PRIVATE_BASE + 1)
#define V4L2_CID_ATOMISP_VIDEO_STABLIZATION   (V4L2_CID_PRIVATE_BASE + 2)
#define V4L2_CID_ATOMISP_FIXED_PATTERN_NR   (V4L2_CID_PRIVATE_BASE + 3)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define V4L2_CID_ATOMISP_FALSE_COLOR_CORRECTION   (V4L2_CID_PRIVATE_BASE + 4)
#define V4L2_CID_ATOMISP_LOW_LIGHT   (V4L2_CID_PRIVATE_BASE + 5)
#define V4L2_CID_CAMERA_LASTP1 (V4L2_CID_CAMERA_CLASS_BASE + 1024)
#define V4L2_CID_FOCAL_ABSOLUTE (V4L2_CID_CAMERA_LASTP1 + 0)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define V4L2_CID_FNUMBER_ABSOLUTE (V4L2_CID_CAMERA_LASTP1 + 1)
#define V4L2_CID_FNUMBER_RANGE (V4L2_CID_CAMERA_LASTP1 + 2)
#define V4L2_CID_REQUEST_FLASH (V4L2_CID_CAMERA_LASTP1 + 3)
#define V4L2_CID_FLASH_STATUS (V4L2_CID_CAMERA_LASTP1 + 5)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define V4L2_CID_FLASH_MODE (V4L2_CID_CAMERA_LASTP1 + 10)
#define V4L2_CID_VCM_SLEW (V4L2_CID_CAMERA_LASTP1 + 11)
#define V4L2_CID_VCM_TIMEING (V4L2_CID_CAMERA_LASTP1 + 12)
#define V4L2_CID_FOCUS_STATUS (V4L2_CID_CAMERA_LASTP1 + 14)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define V4L2_CID_BIN_FACTOR_HORZ (V4L2_CID_CAMERA_LASTP1 + 15)
#define V4L2_CID_BIN_FACTOR_VERT (V4L2_CID_CAMERA_LASTP1 + 16)
#define V4L2_CID_G_SKIP_FRAMES (V4L2_CID_CAMERA_LASTP1 + 17)
#define V4L2_CID_2A_STATUS (V4L2_CID_CAMERA_LASTP1 + 18)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define V4L2_2A_STATUS_AE_READY (1 << 0)
#define V4L2_2A_STATUS_AWB_READY (1 << 1)
#define V4L2_CID_FMT_AUTO (V4L2_CID_CAMERA_LASTP1 + 19)
#define V4L2_CID_RUN_MODE (V4L2_CID_CAMERA_LASTP1 + 20)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_RUN_MODE_VIDEO 1
#define ATOMISP_RUN_MODE_STILL_CAPTURE 2
#define ATOMISP_RUN_MODE_CONTINUOUS_CAPTURE 3
#define ATOMISP_RUN_MODE_PREVIEW 4
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_RUN_MODE_SDV 5
#define V4L2_CID_ENABLE_VFPP (V4L2_CID_CAMERA_LASTP1 + 21)
#define V4L2_CID_ATOMISP_CONTINUOUS_MODE (V4L2_CID_CAMERA_LASTP1 + 22)
#define V4L2_CID_ATOMISP_CONTINUOUS_RAW_BUFFER_SIZE   (V4L2_CID_CAMERA_LASTP1 + 23)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define V4L2_CID_ATOMISP_CONTINUOUS_VIEWFINDER   (V4L2_CID_CAMERA_LASTP1 + 24)
#define V4L2_CID_VFPP (V4L2_CID_CAMERA_LASTP1 + 25)
#define ATOMISP_VFPP_ENABLE 0
#define ATOMISP_VFPP_DISABLE_SCALER 1
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ATOMISP_VFPP_DISABLE_LOWLAT 2
#define V4L2_CID_FLASH_STATUS_REGISTER (V4L2_CID_CAMERA_LASTP1 + 26)
#define V4L2_CID_START_ZSL_CAPTURE (V4L2_CID_CAMERA_LASTP1 + 28)
#define V4L2_CID_ENABLE_RAW_BUFFER_LOCK (V4L2_CID_CAMERA_LASTP1 + 29)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define V4L2_CID_DEPTH_MODE (V4L2_CID_CAMERA_LASTP1 + 30)
#define V4L2_CID_EXPOSURE_ZONE_NUM (V4L2_CID_CAMERA_LASTP1 + 31)
#define V4L2_CID_DISABLE_DZ (V4L2_CID_CAMERA_LASTP1 + 32)
#define V4L2_CID_TEST_PATTERN_COLOR_R (V4L2_CID_CAMERA_LASTP1 + 33)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define V4L2_CID_TEST_PATTERN_COLOR_GR (V4L2_CID_CAMERA_LASTP1 + 34)
#define V4L2_CID_TEST_PATTERN_COLOR_GB (V4L2_CID_CAMERA_LASTP1 + 35)
#define V4L2_CID_TEST_PATTERN_COLOR_B (V4L2_CID_CAMERA_LASTP1 + 36)
#define V4L2_CID_ATOMISP_SELECT_ISP_VERSION    (V4L2_CID_CAMERA_LASTP1 + 38)
#define V4L2_BUF_FLAG_BUFFER_INVALID 0x0400
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define V4L2_BUF_FLAG_BUFFER_VALID 0x0800
#define V4L2_BUF_TYPE_VIDEO_CAPTURE_ION (V4L2_BUF_TYPE_PRIVATE + 1024)
#define V4L2_EVENT_ATOMISP_3A_STATS_READY (V4L2_EVENT_PRIVATE_START + 1)
#define V4L2_EVENT_ATOMISP_METADATA_READY (V4L2_EVENT_PRIVATE_START + 2)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define V4L2_EVENT_ATOMISP_RAW_BUFFERS_ALLOC_DONE (V4L2_EVENT_PRIVATE_START + 3)
#define V4L2_EVENT_ATOMISP_ACC_COMPLETE (V4L2_EVENT_PRIVATE_START + 4)
#define V4L2_EVENT_ATOMISP_PAUSE_BUFFER (V4L2_EVENT_PRIVATE_START + 5)
#define V4L2_EVENT_ATOMISP_CSS_RESET (V4L2_EVENT_PRIVATE_START + 6)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
enum {
 V4L2_COLORFX_SKIN_WHITEN_LOW = 1001,
 V4L2_COLORFX_SKIN_WHITEN_HIGH = 1002,
 V4L2_COLORFX_WARM = 1003,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 V4L2_COLORFX_COLD = 1004,
 V4L2_COLORFX_WASHED = 1005,
 V4L2_COLORFX_RED = 1006,
 V4L2_COLORFX_GREEN = 1007,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
 V4L2_COLORFX_BLUE = 1008,
 V4L2_COLORFX_PINK = 1009,
 V4L2_COLORFX_YELLOW = 1010,
 V4L2_COLORFX_PURPLE = 1011,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
#endif
#endif
