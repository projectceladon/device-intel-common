/*
 ****************************************************************
 *
 *  Copyright (C) 2011-2014 Intel Mobile Communications GmbH
 *
 *    This program is free software: you can redistribute it and/or modify
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
 *
 ****************************************************************
 */

#ifndef __DCC_IOCTL_H__
#define __DCC_IOCTL_H__
#include <linux/ioctl.h>


#define DCCDRV_VERSION_STR "1.5"
#define DCCDRV_VERSION_INT (15)

#define	DCC_DRIVER_NAME	"dcc"
#define	DCC_DEVICE_NAME	"/dev/"DCC_DRIVER_NAME

#define DCC_TV_DISPLAY		(1<<1)	/**< ramless Tv display type	*/
#define DCC_LCDPAR_DISPLAY	(1<<2)	/**< ram LCD display type	*/
#define DCC_LCDRGB_DISPLAY	(1<<3)	/**< ramless LCD display type	*/

/* Rotate options */
#define DCC_ROTATE90	0x1
#define DCC_ROTATE180	0x2
#define DCC_ROTATE270	0x3

#define DCC_MIRROR_SHIFT  2
#define DCC_SET_MIRROR(_a_ , _sw_) \
	(_a_ | ((!!_sw_) << DCC_MIRROR_SHIFT))
#define DCC_GET_MIRROR(_a_)       ((_a_>>DCC_MIRROR_SHIFT)&0x1)

/* Pixel Format */
enum {
	DCC_FMT_YUV422PACKED	= 1,
	DCC_FMT_YUV420PLANAR	= 2,
	DCC_FMT_YVU420PLANAR	= 3,
	DCC_FMT_YUV422PLANAR	= 4,
	DCC_FMT_RGB565		= 5,
	DCC_FMT_RGB888		= 6,
	DCC_FMT_RGB4444		= 7,
	DCC_FMT_RGB1555		= 8,
	DCC_FMT_ARGB8888	= 9,
	DCC_FMT_BGR565		= 10,
	DCC_FMT_BGR888		= 11,
	DCC_FMT_ABGR8888	= 12,
	DCC_FMT_YUV444PACKED	= 13,
	DCC_FMT_YUV444PLANAR	= 14,
	DCC_FMT_YUV444SP	= 15,
	DCC_FMT_YUV422SP	= 16,
	DCC_FMT_YUV420SP	= 17,
};

/* DCC update flags */
#define	DCC_UPDATE_MODE_BITS		(3)
#define	DCC_UPDATE_MODE_MASK		((1<<DCC_UPDATE_MODE_BITS)-1)
#define	DCC_UPDATE_MODE_GET(_f_)	(_f_ & DCC_UPDATE_MODE_MASK)
#define	DCC_UPDATE_MODE_SET(_f_, _m_) \
	(_f_ = (_f_ & ~DCC_UPDATE_MODE_MASK) | _m_)
enum {
	DCC_UPDATE_ONESHOT_SYNC = 0,
	DCC_UPDATE_ONESHOT_ASYNC,
	DCC_UPDATE_CONTINOUS,
};

#define DCC_UPDATE_NOBG_MASK		(1<<DCC_UPDATE_MODE_BITS)
#define DCC_UPDATE_NOBG_GET(_f_)	((_f_>>DCC_UPDATE_MODE_BITS)&0x1)
#define DCC_UPDATE_NOBG_SET(_f_, _v_)	\
	(_f_ = (_f_ & ~DCC_UPDATE_NOBG_MASK) | (_v_<<DCC_UPDATE_MODE_BITS))

/* DCC update flags for write back*/
#define DCC_UPDATE_WB_BITPOS		(DCC_UPDATE_MODE_BITS + 1)
#define DCC_UPDATE_WB_MASK		(1 << DCC_UPDATE_WB_BITPOS)
#define DCC_UPDATE_WB_GET(_f_)		((_f_ >> DCC_UPDATE_WB_BITPOS) & 0x1)
#define DCC_UPDATE_WB_SET(_f_, _v_)	\
	(_f_ = (_f_ & ~DCC_UPDATE_WB_MASK) | (_v_ << DCC_UPDATE_WB_BITPOS))


#define DCC_FMT_VIDEO_SPRITE	0xFF /* specific format for sprites */

/* Blit flags */
#define DCC_FLAG_NONE		0
#define DCC_FLAG_DRAW2DISP	(1<<0)
#define DCC_FLAG_COLORKEY	(1<<1)
#define DCC_BLEND_ALPHA_PLANE	(1<<2)
#define DCC_BLEND_ALPHA_PIXEL	(1<<3)

static inline const char *dcc_format_name(int fmt)
{
	switch (fmt) {
	case DCC_FMT_YUV422PACKED:
		return "YUV422Packed";
	case DCC_FMT_YUV444PACKED:
		return "YUV444Packed";
	case DCC_FMT_YUV420PLANAR:
		return "YUV420Planar";
	case DCC_FMT_YVU420PLANAR:
		return "YVU420Planar";
	case DCC_FMT_YUV422PLANAR:
		return "YUV422Planar";
	case DCC_FMT_RGB565:
		return "RGB565";
	case DCC_FMT_RGB888:
		return "RGB888";
	case DCC_FMT_RGB4444:
		return "RGB4444";
	case DCC_FMT_RGB1555:
		return "RGB1555";
	case DCC_FMT_ARGB8888:
		return "ARGB8888";
	case DCC_FMT_BGR565:
		return "BGR565";
	case DCC_FMT_BGR888:
		return "BGR888";
	case DCC_FMT_ABGR8888:
		return "ABGR8888";
	case DCC_FMT_YUV444PLANAR:
		return "YUV444PLANAR";
	case DCC_FMT_YUV444SP:
		return "YUV444SP";
	case DCC_FMT_YUV422SP:
		return "YUV422SP";
	case DCC_FMT_YUV420SP:
		return "YUV420SP";
	default:
		return "unknown";
	}
}

struct dcc_bounds_t {
	int x;
	int y;
	int w;
	int h;
};

struct dcc_display_cfg_t {
	int width;
	int height;
	int xdpi; /* pixel density per inch in x direction */
	int ydpi; /* pixel density per inch in y direction */
	int refresh_rate; /* in Hz */
	unsigned int mem_base;
	unsigned int mem_size;
	unsigned int format;	/* bytes per pixel */
	unsigned int hwid;	/* hardware ID */
	unsigned int drvid;	/* driver ID */
	unsigned int overlay_nbr; /* number of overlays */
};


struct dcc_rq_t {
	unsigned int fbwidth;	/* frame buffer width */
	/* source */
	unsigned int sphys;
	unsigned int sfmt;
	int sx;			/* x offset */
	int sy;			/* y offset */
	int sw;
	int sh;
	/* destination */
	unsigned int dphys;
	int dx;
	int dy;
	unsigned int dfmt;
	int dw;
	int dh;
	/* optional params */
	int angle;		/* DCC_IOW_ROTATE */
	int alpha;
	unsigned int flags;
};

#define DCC_RQ_SRC(_rq_, _p_, _x_, _y_, _w_, _h_, _f_) \
		_rq_.sphys = _p_; \
		_rq_.sx    = _x_; \
		_rq_.sy    = _y_; \
		_rq_.sw    = _w_; \
		_rq_.sh    = _h_; \
		_rq_.sfmt  = _f_;

#define DCC_RQ_DST(_rq_, _fbw_, _p_, _x_, _y_, _w_, _h_, _f_) \
		_rq_.dphys = _p_; \
		_rq_.dx    = _x_; \
		_rq_.dy    = _y_; \
		_rq_.dw    = _w_; \
		_rq_.dh    = _h_; \
		_rq_.dfmt  = _f_; \
		_rq_.fbwidth = _fbw_;

#define DCC_RQ_DECL(_rq_) \
	struct dcc_rq_t _rq_; \
	DCC_RQ_SRC(_rq_, 0, 0, 0, 0, 0, 0) \
	DCC_RQ_DST(_rq_, 0, 0, 0, 0, 0, 0, 0) \
	_rq_.angle = 0; \
	_rq_.alpha = 0xFF; \
	_rq_.flags = 0;

struct dcc_rq_resize_t {
	unsigned int fbwidth;	/* frame buffer width */
	/* source */
	unsigned int sphys;
	unsigned int sfmt;
	int sx;			/* x offset */
	int sy;			/* y offset */
	int sw;
	int sh;
	/* window */
	int wx;
	int wy;
	int ww;
	int wh;
	/* destination */
	unsigned int dphys;
	int dx;
	int dy;
	unsigned int dfmt;
	int dw;
	int dh;
	/* optional params */
	int angle;		/* DCC_IOW_ROTATE */
	int alpha;
	unsigned int colorkey;
	unsigned int flags;
};

#define DCC_RQRESIZE_SRC(_rq_, _p_, _x_, _y_, _w_, _h_, _f_) \
		_rq_.sphys = _p_; \
		_rq_.sx    = _x_; \
		_rq_.sy    = _y_; \
		_rq_.sw    = _w_; \
		_rq_.sh    = _h_; \
		_rq_.sfmt  = _f_;

#define DCC_RQRESIZE_WIN(_rq_, _x_, _y_, _w_, _h_) \
		_rq_.wx    = _x_; \
		_rq_.wy    = _y_; \
		_rq_.ww    = _w_; \
		_rq_.wh    = _h_;

#define DCC_RQRESIZE_DST(_rq_, _fbw_, _p_, _x_, _y_, _w_, _h_, _f_) \
		_rq_.dphys = _p_; \
		_rq_.dx    = _x_; \
		_rq_.dy    = _y_; \
		_rq_.dw    = _w_; \
		_rq_.dh    = _h_; \
		_rq_.dfmt  = _f_; \
		_rq_.fbwidth = _fbw_;

#define DCC_RQRESIZE_DECL(_rq_) \
	struct dcc_rq_resize_t _rq_; \
	DCC_RQRESIZE_SRC(_rq_, 0, 0, 0, 0, 0, 0) \
	DCC_RQRESIZE_WIN(_rq_, 0, 0, 0, 0) \
	DCC_RQRESIZE_DST(_rq_, 0, 0, 0, 0, 0, 0, 0) \
	_rq_.angle = 0; \
	_rq_.alpha = 0xFF; \
	_rq_.flags = 0;

struct dcc_rect_t {
	unsigned int phys;	/* frame buffer base */
	unsigned int fbwidth;	/* frame buffer width */
	unsigned int x;		/* top left x */
	unsigned int y;		/* top left y */
	unsigned int w;
	unsigned int h;
	unsigned int fmt;
	unsigned int color;	/* optional */
	unsigned int flags;	/* optional */
};

#define DCC_INIT_RECT(_r_, _p_, _fbw_, _x_, _y_, _w_, _h_, _f_, _c_, _g_) \
		_r_.phys = _p_; \
		_r_.fbwidth = _fbw_; \
		_r_.x    = _x_; \
		_r_.y    = _y_; \
		_r_.w    = _w_; \
		_r_.h    = _h_; \
		_r_.fmt  = _f_; \
		_r_.color = _c_; \
		_r_.flags = _g_;


struct dcc_point_t {
	unsigned int phys;	/* base adress */
	unsigned int fbwidth;	/* frame buffer width */
	unsigned int x;		/* relative x pos from base adress */
	unsigned int y;		/* relative y pos from base adress */
	unsigned int color;
};

#define DCC_POINT_INIT(_p_, _ph_, _fbw_, _x_, _y_, _c_) \
		_p_.phys = _ph_; \
		_p_.fbwidth = _fbw_; \
		_p_.x    = _x_; \
		_p_.y    = _y_; \
		_p_.color = _c_;


struct dcc_layer_back {
	unsigned int phys;	/* frame buffer base */
	unsigned int stride;	/* frame buffer width */
	struct dcc_bounds_t src;
	unsigned int fmt;
	unsigned int alpha;	/* optional */
	int fence_acquire;
	int fence_release;
	int fd;
};

#define dcc_layer_back_conf(_r_, _p_, _s_, _x_, _y_, \
			_w_, _h_, _f_, _a_, _c_, _g_) \
		_r_.phys    = _p_; \
		_r_.stride  = _s_; \
		_r_.src.x   = _x_; \
		_r_.src.y   = _y_; \
		_r_.src.w   = _w_; \
		_r_.src.h   = _h_; \
		_r_.fmt     = _f_; \
		_r_.alpha   = _a_;

#define dcc_layer_back_disable(_b_) _b_.phys = 0

struct dcc_layer_ovl {
	unsigned int phys;
	struct dcc_bounds_t src;
	struct dcc_bounds_t dst;
	unsigned int fmt;
	unsigned int alpha;
	int fence_acquire;
	int fence_release;
	int fd;

	unsigned int global;	/* use global alpha value or update cmd */
	unsigned int chromakey;	/* chromakey for overlay only */
};

#define dcc_layer_ovl_conf(_o_, _p_, \
		_x_, _y_, _w_, _h_, _f_, _fd_, _a_, _g_, _c_) \
		_o_.phys   = _p_; \
		_o_.dst.x  = _x_; \
		_o_.dst.y  = _y_; \
		_o_.dst.w  = _w_; \
		_o_.dst.h  = _h_; \
		_o_.fmt    = _f_; \
		_o_.fence_acquire = _fd_; \
		_o_.alpha  = _a_; \
		_o_.global = _g_; \
		_o_.chromakey = _c_;

#define dcc_layer_ovl_disable(_o_) _o_.phys = 0

#define DCC_OVERLAY_NUM 4

struct dcc_layer_writeback {
	unsigned int phys;
	int fence_release;
};

#define dcc_layer_writeback_conf(_o_, _p_) \
			_o_.phys = _p_;

#define dcc_layer_writeback_disable(_o_) _o_.phys = 0

struct dcc_update_layers {
	struct dcc_layer_back back;
	struct dcc_layer_ovl ovls[DCC_OVERLAY_NUM];
	int fence_retire;
	unsigned int flags;
};

struct dcc_update_layers_wb {
	struct dcc_update_layers updt;
	struct dcc_layer_writeback wb;
};

/* IO CONTROL DEFINES */

#define DCC_IOC_MAGIC 'x' /* ioctl: Magic number */

#define DCC_IOW_POWER_ON		_IOWR('x', 0, unsigned int)
#define DCC_IOW_POWER_OFF		_IOWR('x', 1, unsigned int)
#define DCC_IOW_FILLRECTANGLE		_IOWR('x', 2, struct dcc_rect_t)
#define DCC_IOW_DRAWLINE		_IOWR('x', 3, struct dcc_rect_t)
#define DCC_IOW_BLIT			_IOWR('x', 4, struct dcc_rq_t)
#define DCC_IOW_ROTATE			_IOWR('x', 5, struct dcc_rq_t)
#define DCC_IOW_RESIZE			_IOWR('x', 6, struct dcc_rq_resize_t)
#define DCC_IOW_COMPOSE			_IOWR('x', 7, struct dcc_update_layers)
#define DCC_IOW_DRAWLINEREL		_IOWR('x', 13, struct dcc_rect_t)
#define DCC_IOW_MIRROR			_IOWR('x', 14, struct dcc_rq_t)
#define DCC_IOR_DISPLAY_INFO		_IOWR('x', 15, struct dcc_display_cfg_t)
#define DCC_IOW_SCROLLMOVE		_IOWR('x', 16, struct dcc_rq_t)
#define DCC_IOW_SETPIXEL		_IOWR('x', 20, struct dcc_point_t)
#define DCC_IOW_CONVERT			_IOWR('x', 21, struct dcc_rq_t)
#define DCC_IOW_UPDATE			_IOWR('x', 22, struct dcc_rect_t)
#define DCC_IOW_COMPOSE_WITH_WB		_IOWR('x', 23, \
						struct dcc_update_layers_wb)

#define DCC_IOC_MAXNR (27)

#endif /*__DCC_IOCTL_H__ */
