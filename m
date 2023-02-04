Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B2D68A919
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 09:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbjBDI4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Feb 2023 03:56:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjBDI4m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Feb 2023 03:56:42 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DAFF3754F
        for <kvm@vger.kernel.org>; Sat,  4 Feb 2023 00:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675501001; x=1707037001;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=z1Os81dv7xzZJVvTa+yNC5+XR3mnTuAq7NYN1yvO0T0=;
  b=a9ioOq2bV3O+i/NkvbtCt3Pk+KLWJxAgyoVBnG8bvQOHlDhRfl4Yo4Y9
   2Ox6JHSB0VTBbwKcuzsU02YEXMwrXoogGJ0nvFipDJoTP5NWosGxrkFhL
   v2aEQaokyhxtj/9VHj+y3PSdkCwvFl0gdkdcU4gjoNAoiIW/pbMvV1bYs
   mIV98Ztibzowe7MRZRlQM0WUJCXMZqfaftuCjkWXIljKdCnQCPsDJ6JU6
   wD22qlybVHFCrEhuhccnyAk6eq0lAvvnLB5uRYc8Gsc3C9+cqvFebcfZL
   lqlvz5JFWvdlfjn/+Zi/DybXE/NYrzv5VHEYzmZ9cPnkyZqcy9DcOiqwe
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="356275531"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="356275531"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2023 00:56:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="808599382"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="808599382"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 04 Feb 2023 00:56:38 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pOELd-0001BE-2R;
        Sat, 04 Feb 2023 08:56:37 +0000
Date:   Sat, 4 Feb 2023 16:56:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        jgg@nvidia.com
Cc:     oe-kbuild-all@lists.linux.dev, kevin.tian@intel.com,
        chao.p.peng@linux.intel.com, eric.auger@redhat.com,
        yi.l.liu@intel.com, yi.y.sun@linux.intel.com, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] docs: vfio: Update vfio.rst per latest interfaces
Message-ID: <202302041603.N8YkuJks-lkp@intel.com>
References: <20230203083345.711443-3-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203083345.711443-3-yi.l.liu@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on awilliam-vfio/for-linus]
[also build test WARNING on linus/master v6.2-rc6 next-20230203]
[cannot apply to awilliam-vfio/next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yi-Liu/vfio-Update-the-kdoc-for-vfio_device_ops/20230203-163612
base:   https://github.com/awilliam/linux-vfio.git for-linus
patch link:    https://lore.kernel.org/r/20230203083345.711443-3-yi.l.liu%40intel.com
patch subject: [PATCH v2 2/2] docs: vfio: Update vfio.rst per latest interfaces
reproduce:
        # https://github.com/intel-lab-lkp/linux/commit/8db2c0d3414387502a6c743d6fa383cec960e3ba
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yi-Liu/vfio-Update-the-kdoc-for-vfio_device_ops/20230203-163612
        git checkout 8db2c0d3414387502a6c743d6fa383cec960e3ba
        make menuconfig
        # enable CONFIG_COMPILE_TEST, CONFIG_WARN_MISSING_DOCUMENTS, CONFIG_WARN_ABI_ERRORS
        make htmldocs

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> Documentation/driver-api/vfio.rst:264: WARNING: Inline emphasis start-string without end-string.
>> Documentation/driver-api/vfio.rst:296: WARNING: Literal block ends without a blank line; unexpected unindent.
>> Documentation/driver-api/vfio.rst:305: WARNING: Unexpected indentation.
>> Documentation/driver-api/vfio.rst:306: WARNING: Block quote ends without a blank line; unexpected unindent.

vim +264 Documentation/driver-api/vfio.rst

   263	
 > 264		vfio_alloc_device(dev_struct, member, dev, ops);
   265		void vfio_put_device(struct vfio_device *device);
   266	
   267	vfio_register_group_dev() indicates to the core to begin tracking the
   268	iommu_group of the specified dev and register the dev as owned by a VFIO bus
   269	driver. Once vfio_register_group_dev() returns it is possible for userspace to
   270	start accessing the driver, thus the driver should ensure it is completely
   271	ready before calling it. The driver provides an ops structure for callbacks
   272	similar to a file operations structure::
   273	
   274		struct vfio_device_ops {
   275			char	*name;
   276			int	(*init)(struct vfio_device *vdev);
   277			void	(*release)(struct vfio_device *vdev);
   278			int	(*bind_iommufd)(struct vfio_device *vdev,
   279						struct iommufd_ctx *ictx, u32 *out_device_id);
   280			void	(*unbind_iommufd)(struct vfio_device *vdev);
   281			int	(*attach_ioas)(struct vfio_device *vdev, u32 *pt_id);
   282			int	(*open_device)(struct vfio_device *vdev);
   283			void	(*close_device)(struct vfio_device *vdev);
   284			ssize_t	(*read)(struct vfio_device *vdev, char __user *buf,
   285					size_t count, loff_t *ppos);
   286			ssize_t	(*write)(struct vfio_device *vdev, const char __user *buf,
   287				 size_t count, loff_t *size);
   288			long	(*ioctl)(struct vfio_device *vdev, unsigned int cmd,
   289					 unsigned long arg);
   290			int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
   291			void	(*request)(struct vfio_device *vdev, unsigned int count);
   292			int	(*match)(struct vfio_device *vdev, char *buf);
   293			void	(*dma_unmap)(struct vfio_device *vdev, u64 iova, u64 length);
   294			int	(*device_feature)(struct vfio_device *device, u32 flags,
   295						  void __user *arg, size_t argsz);
 > 296	};
   297	
   298	Each function is passed the vdev that was originally registered
   299	in the vfio_register_group_dev() or vfio_register_emulated_iommu_dev()
   300	call above.  This allows the bus driver to obtain its private data using
   301	container_of().
   302	- The init/release callbacks are issued when vfio_device is initialized
   303	- and released.
   304	- The open/close_device callbacks are issued when a new file descriptor is
 > 305	  created for a device (via VFIO_GROUP_GET_DEVICE_FD).
 > 306	- The ioctl interface provides a direct pass through for VFIO_DEVICE_* ioctls.
   307	- The [un]bind_iommufd callbacks are issued when the device is bound to
   308	- and unbound from iommufd.
   309	- The attach_ioas callback is issued when the device is attached to an IOAS
   310	  managed by the bound iommufd. The attached IOAS is automatically detached
   311	  when the device is unbound from the iommufd.
   312	- The read/write/mmap interfaces implement the device region access defined by
   313	  the device's own VFIO_DEVICE_GET_REGION_INFO ioctl.
   314	- The request callback is issued when device is going to be unregistered.
   315	- The dma_unmap callback is issued when a range of iova's are unmapped in
   316	  the container or IOAS attached by the device. Drivers which care about
   317	  DMA unmap can implement this callback and must tolerate receiving unmap
   318	  notifications before the device is opened.
   319	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
