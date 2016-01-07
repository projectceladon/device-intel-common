/*
 * include/linux/xgold_ion.h
 *
 * Copyright (C) 2014 Intel Mobile Communications GmbH
 *
 * Copyright (C) 2011 Google, Inc.
 * Copyright (C) 2012 Intel Corp.
 *
 * This software is licensed under the terms of the GNU General Public
 * License version 2, as published by the Free Software Foundation, and
 * may be copied, distributed, and modified under those terms.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
 * GNU General Public License for more details.
 *
 */

#ifndef _LINUX_XGOLD_ION_H
#define _LINUX_XGOLD_ION_H

#ifndef __KERNEL__
#include <linux/ion.h>
#endif
#include <linux/compat.h>


#ifdef __KERNEL__
extern struct ion_handle *ion_handle_get_by_id(struct ion_client *client,
						int id);
extern int xgold_ion_handler_init(struct device_node *node,
	struct ion_device *idev, struct ion_platform_data *pdata);
extern void xgold_ion_handler_exit(void);
#endif

struct xgold_ion_get_params_data {
	int handle;
	size_t size;
	unsigned long addr;
};

enum {
	XGOLD_ION_GET_PARAM = 0,
	XGOLD_ION_ALLOC_SECURE,
	XGOLD_ION_FREE_SECURE,
};

enum {
	ION_HEAP_TYPE_SECURE = ION_HEAP_TYPE_CUSTOM,
};

/* struct ion_flush_data - data passed to ion for flushing caches
 *
 * @handle:	handle with data to flush
 * @fd:		fd to flush
 * @vaddr:	userspace virtual address mapped with mmap
 * @offset:	offset into the handle to flush
 * @length:	length of handle to flush
 *
 * Performs cache operations on the handle. If p is the start address
 * of the handle, p + offset through p + offset + length will have
 * the cache operations performed
 */
struct ion_flush_data {
	ion_user_handle_t handle;
	int fd;
	void *vaddr;
	unsigned int offset;
	unsigned int length;
};

struct ion_phys_data {
	ion_user_handle_t handle;
	unsigned long phys;
	unsigned long size;
};

struct ion_share_id_data {
	int fd;
	unsigned int id;
};

#define ION_HEAP_TYPE_SECURE_MASK	(1 << ION_HEAP_TYPE_SECURE)

#ifdef __KERNEL__
#ifdef CONFIG_COMPAT
struct compat_xgold_ion_get_params_data {
	compat_int_t handle;
	compat_size_t size;
	compat_long_t addr;
};

extern int compat_put_xgold_ion_custom_data(unsigned int arg, struct
		xgold_ion_get_params_data __user *data);
extern int compat_get_xgold_ion_custom_data(
			struct compat_xgold_ion_get_params_data __user *data32,
			struct xgold_ion_get_params_data __user *data);
extern struct xgold_ion_get_params_data __user
		*compat_xgold_ion_get_param(unsigned int arg);
#else
struct compat_xgold_ion_get_params_data;

static inline int compat_put_xgold_ion_custom_data(unsigned int arg, struct
		xgold_ion_get_params_data __user *data)
{
	return 0;
}

static inline struct xgold_ion_get_params_data __user
		*compat_xgold_ion_get_param(unsigned int arg)
{
	return NULL;
}
#endif
#endif

#define ION_IOC_SOFIA_MAGIC 'R'

/* Clean the caches of the handle specified. */
#define ION_IOC_CLEAN_CACHES	_IOWR(ION_IOC_SOFIA_MAGIC, 0, \
						struct ion_flush_data)
/* Invalidate the caches of the handle specified. */
#define ION_IOC_INV_CACHES	_IOWR(ION_IOC_SOFIA_MAGIC, 1, \
						struct ion_flush_data)
/* Clean and invalidate the caches of the handle specified. */
#define ION_IOC_CLEAN_INV_CACHES	_IOWR(ION_IOC_SOFIA_MAGIC, 2, \
						struct ion_flush_data)
/* Get phys addr of the handle specified. */
#define ION_IOC_GET_PHYS	_IOWR(ION_IOC_SOFIA_MAGIC, 3, \
						struct ion_phys_data)
/* Get share object of the fd specified. */
#define ION_IOC_GET_SHARE_ID	_IOWR(ION_IOC_SOFIA_MAGIC, 4, \
						struct ion_share_id_data)
/* Set share object and associate new fd. */
#define ION_IOC_SHARE_BY_ID	_IOWR(ION_IOC_SOFIA_MAGIC, 5, \
						struct ion_share_id_data)

#endif /* _LINUX_XGOLD_ION_H */
