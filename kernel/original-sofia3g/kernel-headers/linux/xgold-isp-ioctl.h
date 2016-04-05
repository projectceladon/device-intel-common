/*
 ****************************************************************
 *
 *  Component: CIF driver
 *
 *  Copyright (C) 2011 Intel Mobile Communications GmbH
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License Version 2
 *  as published by the Free Software Foundation.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 *  You should have received a copy of the GNU General Public License Version 2
 *  along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 ****************************************************************
 */
#ifndef _XGOLD_ISP_IOCTL_H
#define _XGOLD_ISP_IOCTL_H

#include <linux/v4l2-controls.h>

struct cifisp_bpc_config;
struct cifisp_bls_config;
struct cifisp_sdg_config;
struct cifisp_lsc_config;
struct cifisp_awb_meas_config;
struct cifisp_flt_config;
struct cifisp_bdm_config;
struct cifisp_ctk_config;
struct cifisp_goc_config;
struct cifisp_hst_config;
struct cifisp_aec_config;
struct cifisp_awb_gain_config;
struct cifisp_cproc_config;
struct cifisp_macc_config;
struct cifisp_tmap_config;
struct cifisp_ycflt_config;
struct cifisp_afc_config;
struct cifisp_ie_config;
struct cifisp_last_capture_config;

/*Private IOCTLs for Marvin ISP */
/* Bad Pixel detection & Correction*/
#define CIFISP_IOC_G_BPC \
	_IOR('v', BASE_VIDIOC_PRIVATE + 0, struct cifisp_bpc_config)
#define CIFISP_IOC_S_BPC \
	_IOW('v', BASE_VIDIOC_PRIVATE + 1, struct cifisp_bpc_config)
/* Black Level Subtraction */
#define CIFISP_IOC_G_BLS \
	_IOR('v', BASE_VIDIOC_PRIVATE + 2, struct cifisp_bls_config)
#define CIFISP_IOC_S_BLS \
	_IOW('v', BASE_VIDIOC_PRIVATE + 3, struct cifisp_bls_config)
/* Sensor DeGamma */
#define CIFISP_IOC_G_SDG \
	_IOR('v', BASE_VIDIOC_PRIVATE + 4, struct cifisp_sdg_config)
#define CIFISP_IOC_S_SDG \
	_IOW('v', BASE_VIDIOC_PRIVATE + 5, struct cifisp_sdg_config)
/* Lens Shading Correction */
#define CIFISP_IOC_G_LSC \
	_IOR('v', BASE_VIDIOC_PRIVATE + 6, struct cifisp_lsc_config)
#define CIFISP_IOC_S_LSC \
	_IOW('v', BASE_VIDIOC_PRIVATE + 7, struct cifisp_lsc_config)
/* Auto White Balance */
#define CIFISP_IOC_G_AWB_MEAS \
	_IOR('v', BASE_VIDIOC_PRIVATE + 8, struct cifisp_awb_meas_config)
#define CIFISP_IOC_S_AWB_MEAS \
	_IOW('v', BASE_VIDIOC_PRIVATE + 9, struct cifisp_awb_meas_config)
/* ISP Filtering( Sharpening & Noise reduction */
#define CIFISP_IOC_G_FLT \
	_IOR('v', BASE_VIDIOC_PRIVATE + 10, struct cifisp_flt_config)
#define CIFISP_IOC_S_FLT \
	_IOW('v', BASE_VIDIOC_PRIVATE + 11, struct cifisp_flt_config)
/* Bayer Demosaic */
#define CIFISP_IOC_G_BDM \
	_IOR('v', BASE_VIDIOC_PRIVATE + 12, struct cifisp_bdm_config)
#define CIFISP_IOC_S_BDM \
	_IOW('v', BASE_VIDIOC_PRIVATE + 13, struct cifisp_bdm_config)
/* Cross Talk correction */
#define CIFISP_IOC_G_CTK \
	_IOR('v', BASE_VIDIOC_PRIVATE + 14, struct cifisp_ctk_config)
#define CIFISP_IOC_S_CTK \
	_IOW('v', BASE_VIDIOC_PRIVATE + 15, struct cifisp_ctk_config)
/* Gamma Out Correction */
#define CIFISP_IOC_G_GOC \
	_IOR('v', BASE_VIDIOC_PRIVATE + 16, struct cifisp_goc_config)
#define CIFISP_IOC_S_GOC \
	_IOW('v', BASE_VIDIOC_PRIVATE + 17, struct cifisp_goc_config)
/* Histogram Measurement */
#define CIFISP_IOC_G_HST \
	_IOR('v', BASE_VIDIOC_PRIVATE + 18, struct cifisp_hst_config)
#define CIFISP_IOC_S_HST \
	_IOW('v', BASE_VIDIOC_PRIVATE + 19, struct cifisp_hst_config)
/* Auto Exposure Measurements */
#define CIFISP_IOC_G_AEC \
	_IOR('v', BASE_VIDIOC_PRIVATE + 20, struct cifisp_aec_config)
#define CIFISP_IOC_S_AEC \
	_IOW('v', BASE_VIDIOC_PRIVATE + 21, struct cifisp_aec_config)
#define CIFISP_IOC_G_BPL \
	_IOR('v', BASE_VIDIOC_PRIVATE + 22, struct cifisp_aec_config)
#define CIFISP_IOC_G_AWB_GAIN \
	_IOR('v', BASE_VIDIOC_PRIVATE + 23, struct cifisp_awb_gain_config)
#define CIFISP_IOC_S_AWB_GAIN \
	_IOW('v', BASE_VIDIOC_PRIVATE + 24, struct cifisp_awb_gain_config)
#define CIFISP_IOC_G_CPROC \
	_IOR('v', BASE_VIDIOC_PRIVATE + 25, struct cifisp_cproc_config)
#define CIFISP_IOC_S_CPROC \
	_IOW('v', BASE_VIDIOC_PRIVATE + 26, struct cifisp_cproc_config)
#define CIFISP_IOC_G_MACC \
	_IOR('v', BASE_VIDIOC_PRIVATE + 27, struct cifisp_macc_config)
#define CIFISP_IOC_S_MACC \
	_IOW('v', BASE_VIDIOC_PRIVATE + 28, struct cifisp_macc_config)
#define CIFISP_IOC_G_TMAP \
	_IOR('v', BASE_VIDIOC_PRIVATE + 29, struct cifisp_tmap_config)
#define CIFISP_IOC_S_TMAP \
	_IOW('v', BASE_VIDIOC_PRIVATE + 30, struct cifisp_tmap_config)
#define CIFISP_IOC_G_YCFLT \
	_IOR('v', BASE_VIDIOC_PRIVATE + 31, struct cifisp_ycflt_config)
#define CIFISP_IOC_S_YCFLT \
	_IOW('v', BASE_VIDIOC_PRIVATE + 32, struct cifisp_ycflt_config)
#define CIFISP_IOC_G_AFC \
	_IOR('v', BASE_VIDIOC_PRIVATE + 33, struct cifisp_afc_config)
#define CIFISP_IOC_S_AFC \
	_IOW('v', BASE_VIDIOC_PRIVATE + 34, struct cifisp_afc_config)
#define CIFISP_IOC_G_IE \
	_IOR('v', BASE_VIDIOC_PRIVATE + 35, struct cifisp_ie_config)
#define CIFISP_IOC_S_IE \
	_IOW('v', BASE_VIDIOC_PRIVATE + 36, struct cifisp_ie_config)
#define CIFISP_IOC_G_LAST_CONFIG \
	_IOR('v', BASE_VIDIOC_PRIVATE + 37, struct cifisp_last_capture_config)

/*  CIF-ISP Private control IDs */
#define V4L2_CID_CIFISP_BPC    (V4L2_CID_PRIVATE_BASE + 0)
#define V4L2_CID_CIFISP_BLS    (V4L2_CID_PRIVATE_BASE + 1)
#define V4L2_CID_CIFISP_SDG    (V4L2_CID_PRIVATE_BASE + 2)
#define V4L2_CID_CIFISP_LSC    (V4L2_CID_PRIVATE_BASE + 3)
#define V4L2_CID_CIFISP_AWB_MEAS    (V4L2_CID_PRIVATE_BASE + 4)
#define V4L2_CID_CIFISP_FLT    (V4L2_CID_PRIVATE_BASE + 5)
#define V4L2_CID_CIFISP_BDM    (V4L2_CID_PRIVATE_BASE + 6)
#define V4L2_CID_CIFISP_CTK    (V4L2_CID_PRIVATE_BASE + 7)
#define V4L2_CID_CIFISP_GOC    (V4L2_CID_PRIVATE_BASE + 8)
#define V4L2_CID_CIFISP_HST    (V4L2_CID_PRIVATE_BASE + 9)
#define V4L2_CID_CIFISP_AEC    (V4L2_CID_PRIVATE_BASE + 10)
#define V4L2_CID_CIFISP_AWB_GAIN    (V4L2_CID_PRIVATE_BASE + 11)
#define V4L2_CID_CIFISP_CPROC    (V4L2_CID_PRIVATE_BASE + 12)
#define V4L2_CID_CIFISP_MACC    (V4L2_CID_PRIVATE_BASE + 13)
#define V4L2_CID_CIFISP_TMAP    (V4L2_CID_PRIVATE_BASE + 14)
#define V4L2_CID_CIFISP_YCFLT    (V4L2_CID_PRIVATE_BASE + 15)
#define V4L2_CID_CIFISP_AFC    (V4L2_CID_PRIVATE_BASE + 16)
#define V4L2_CID_CIFISP_IE    (V4L2_CID_PRIVATE_BASE + 17)

/* Camera Sensors' running modes */
#define CI_MODE_PREVIEW	0x8000
#define CI_MODE_VIDEO	0x4000
#define CI_MODE_STILL_CAPTURE	0x2000
#define CI_MODE_CONTINUOUS	0x1000
#define CI_MODE_NONE	0x0000

#endif
