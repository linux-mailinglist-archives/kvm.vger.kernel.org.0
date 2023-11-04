Return-Path: <kvm+bounces-573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 44DC27E0EA3
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 10:36:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D1282B213FB
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 09:36:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B9F9111BC;
	Sat,  4 Nov 2023 09:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z8CINsO5"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A487FDDC8
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 09:36:04 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9181B2;
	Sat,  4 Nov 2023 02:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699090562; x=1730626562;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p/vZ9aQJJ8vbDAzRwB2cAWFoPhpzbeHXMAy/cAJcjkw=;
  b=Z8CINsO5wBK3LerG9EYfeqtcotNVW3fKVSZAvLheejWh2VkdTaULz5PA
   XmJZZlmFLnKDMcjye1cT3h8gsIc4UMVv2jyHajeRBgCp/uF2UcuIpUOts
   Mhqli190GT4HjPFVfLAiXS+5P9CLSAJaHJ0tgezOIE+STl32t2GpK2K1l
   p7J6GNL//e3uKH5o6KvbcGDlUza5H7dZlaI2iH/mKLtsn4slSm2MK2K/F
   EU/TwVKNKBh4+TmdBC4DnkN4GWXQdPNhhXTzXsXYqf4qlE6SpMJmZehru
   5z5w2CyZsMk2ncxjB/elX7IjZd3fXo7Vb/NLOqU8GF0yoJ47e6rSxEeoC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10883"; a="475307850"
X-IronPort-AV: E=Sophos;i="6.03,276,1694761200"; 
   d="scan'208";a="475307850"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2023 02:36:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,276,1694761200"; 
   d="scan'208";a="3159059"
Received: from lkp-server01.sh.intel.com (HELO 17d9e85e5079) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 04 Nov 2023 02:35:58 -0700
Received: from kbuild by 17d9e85e5079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qzD4N-0003jr-1d;
	Sat, 04 Nov 2023 09:35:55 +0000
Date: Sat, 4 Nov 2023 17:35:13 +0800
From: kernel test robot <lkp@intel.com>
To: ankita@nvidia.com, jgg@nvidia.com, alex.williamson@redhat.com,
	yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com
Cc: oe-kbuild-all@lists.linux.dev, aniketa@nvidia.com, cjia@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
	acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
	danw@nvidia.com, anuaggarwal@nvidia.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <202311041743.tL7StQAH-lkp@intel.com>
References: <20231015163047.20391-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231015163047.20391-1-ankita@nvidia.com>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on awilliam-vfio/for-linus]
[also build test WARNING on linus/master v6.6 next-20231103]
[cannot apply to awilliam-vfio/next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/ankita-nvidia-com/vfio-nvgpu-Add-vfio-pci-variant-module-for-grace-hopper/20231017-131546
base:   https://github.com/awilliam/linux-vfio.git for-linus
patch link:    https://lore.kernel.org/r/20231015163047.20391-1-ankita%40nvidia.com
patch subject: [PATCH v12 1/1] vfio/nvgpu: Add vfio pci variant module for grace hopper
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20231104/202311041743.tL7StQAH-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231104/202311041743.tL7StQAH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311041743.tL7StQAH-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/vfio/pci/nvgrace-gpu/main.c:226:9: warning: no previous prototype for 'nvgrace_gpu_read_mem' [-Wmissing-prototypes]
     226 | ssize_t nvgrace_gpu_read_mem(void __user *buf, size_t count, loff_t *ppos,
         |         ^~~~~~~~~~~~~~~~~~~~
>> drivers/vfio/pci/nvgrace-gpu/main.c:298:9: warning: no previous prototype for 'nvgrace_gpu_write_mem' [-Wmissing-prototypes]
     298 | ssize_t nvgrace_gpu_write_mem(size_t count, loff_t *ppos, const void __user *buf,
         |         ^~~~~~~~~~~~~~~~~~~~~


vim +/nvgrace_gpu_read_mem +226 drivers/vfio/pci/nvgrace-gpu/main.c

   214	
   215	/*
   216	 * Read count bytes from the device memory at an offset. The actual device
   217	 * memory size (available) may not be a power-of-2. So the driver fakes
   218	 * the size to a power-of-2 (reported) when exposing to a user space driver.
   219	 *
   220	 * Read request beyond the actual device size is filled with ~0, while
   221	 * those beyond the actual reported size is skipped.
   222	 *
   223	 * A read from a negative or an offset greater than reported size, a negative
   224	 * count are considered error conditions and returned with an -EINVAL.
   225	 */
 > 226	ssize_t nvgrace_gpu_read_mem(void __user *buf, size_t count, loff_t *ppos,
   227				      struct nvgrace_gpu_vfio_pci_core_device *nvdev)
   228	{
   229		u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
   230		size_t mem_count, i, bar_size = roundup_pow_of_two(nvdev->memlength);
   231		u8 val = 0xFF;
   232	
   233		if (offset >= bar_size)
   234			return -EINVAL;
   235	
   236		/* Clip short the read request beyond reported BAR size */
   237		count = min(count, bar_size - (size_t)offset);
   238	
   239		/*
   240		 * Determine how many bytes to be actually read from the device memory.
   241		 * Read request beyond the actual device memory size is filled with ~0,
   242		 * while those beyond the actual reported size is skipped.
   243		 */
   244		if (offset >= nvdev->memlength)
   245			mem_count = 0;
   246		else
   247			mem_count = min(count, nvdev->memlength - (size_t)offset);
   248	
   249		/*
   250		 * Handle read on the BAR2 region. Map to the target device memory
   251		 * physical address and copy to the request read buffer.
   252		 */
   253		if (copy_to_user(buf, (u8 *)nvdev->memmap + offset, mem_count))
   254			return -EFAULT;
   255	
   256		/*
   257		 * Only the device memory present on the hardware is mapped, which may
   258		 * not be power-of-2 aligned. A read to an offset beyond the device memory
   259		 * size is filled with ~0.
   260		 */
   261		for (i = mem_count; i < count; i++)
   262			put_user(val, (unsigned char __user *)(buf + i));
   263	
   264		*ppos += count;
   265		return count;
   266	}
   267	
   268	static ssize_t nvgrace_gpu_vfio_pci_read(struct vfio_device *core_vdev,
   269						  char __user *buf, size_t count, loff_t *ppos)
   270	{
   271		unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
   272		struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
   273			core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
   274		int ret;
   275	
   276		if (index == VFIO_PCI_BAR2_REGION_INDEX) {
   277			ret = nvgrace_gpu_memmap(nvdev);
   278			if (ret)
   279				return ret;
   280	
   281			return nvgrace_gpu_read_mem(buf, count, ppos, nvdev);
   282		}
   283	
   284		return vfio_pci_core_read(core_vdev, buf, count, ppos);
   285	}
   286	
   287	/*
   288	 * Write count bytes to the device memory at a given offset. The actual device
   289	 * memory size (available) may not be a power-of-2. So the driver fakes the
   290	 * size to a power-of-2 (reported) when exposing to a user space driver.
   291	 *
   292	 * Write request beyond the actual device size are dropped, while those
   293	 * beyond the actual reported size are skipped entirely.
   294	 *
   295	 * A write to a negative or an offset greater than the reported size, a
   296	 * negative count are considered error conditions and returned with an -EINVAL.
   297	 */
 > 298	ssize_t nvgrace_gpu_write_mem(size_t count, loff_t *ppos, const void __user *buf,
   299				       struct nvgrace_gpu_vfio_pci_core_device *nvdev)
   300	{
   301		u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
   302		size_t mem_count, bar_size = roundup_pow_of_two(nvdev->memlength);
   303	
   304		if (offset >= bar_size)
   305			return -EINVAL;
   306	
   307		/* Clip short the write request beyond reported BAR size */
   308		count = min(count, bar_size - (size_t)offset);
   309	
   310		/*
   311		 * Determine how many bytes to be actually written to the device memory.
   312		 * Do not write to the offset beyond available size.
   313		 */
   314		if (offset >= nvdev->memlength)
   315			goto exitfn;
   316	
   317		mem_count = min(count, nvdev->memlength - (size_t)offset);
   318	
   319		/*
   320		 * Only the device memory present on the hardware is mapped, which may
   321		 * not be power-of-2 aligned. A write to the BAR2 region implies an
   322		 * access outside the available device memory on the hardware. Drop
   323		 * those write requests.
   324		 */
   325		if (copy_from_user((u8 *)nvdev->memmap + offset, buf, mem_count))
   326			return -EFAULT;
   327	
   328	exitfn:
   329		*ppos += count;
   330		return count;
   331	}
   332	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

