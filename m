Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F8B6D894F
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 23:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbjDEVJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 17:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbjDEVJI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 17:09:08 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6813C1F;
        Wed,  5 Apr 2023 14:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680728940; x=1712264940;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kBtAlLh97wt5jwCzGnjJBSJuimQxEQuTgGnvc1uCkV8=;
  b=aKe48h0qcLvmJrnu+5Z+zvZ7O0gVOCrToYE2OmCl8NXlBXant37ni+9s
   cqO0HHzI4Eg7POPRKWrqEHTdX120LbPmB6IvAJjbF0ihXZwLKdLESfRtT
   uPxrIBUg136cWNf6z3/vEOfDIAC0JIMXTRJQUkl0Ll1ULS+odBQosiooU
   CLJB5dgHNEAex8Bqqsu8xD4VdpL0QugNaGXix9Gt5QI95VeXyOuSdFkh2
   4Y0wUYdoNwq5Kdi8SpSsXpXQAJgs3dH4EoCamlUkrapm5O9acegPhovvp
   bR5t1dn6D0YYPB5of/ysmV9dzAApe2yNR9DjzgeVdAGjvlySJWt/8sEgs
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="407657517"
X-IronPort-AV: E=Sophos;i="5.98,321,1673942400"; 
   d="scan'208";a="407657517"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 14:08:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="1016620276"
X-IronPort-AV: E=Sophos;i="5.98,321,1673942400"; 
   d="scan'208";a="1016620276"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 05 Apr 2023 14:08:25 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pkAMi-000Qnq-1Z;
        Wed, 05 Apr 2023 21:08:24 +0000
Date:   Thu, 6 Apr 2023 05:07:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     ankita@nvidia.com, jgg@nvidia.com, alex.williamson@redhat.com,
        naoya.horiguchi@nec.com, maz@kernel.org, oliver.upton@linux.dev
Cc:     oe-kbuild-all@lists.linux.dev, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 2/6] vfio/nvgpu: expose GPU device memory as BAR1
Message-ID: <202304060424.MtQM4udq-lkp@intel.com>
References: <20230405180134.16932-3-ankita@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405180134.16932-3-ankita@nvidia.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on awilliam-vfio/for-linus]
[also build test WARNING on kvmarm/next akpm-mm/mm-everything linus/master v6.3-rc5 next-20230405]
[cannot apply to awilliam-vfio/next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/ankita-nvidia-com/kvm-determine-memory-type-from-VMA/20230406-020404
base:   https://github.com/awilliam/linux-vfio.git for-linus
patch link:    https://lore.kernel.org/r/20230405180134.16932-3-ankita%40nvidia.com
patch subject: [PATCH v3 2/6] vfio/nvgpu: expose GPU device memory as BAR1
config: sparc-allyesconfig (https://download.01.org/0day-ci/archive/20230406/202304060424.MtQM4udq-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/09ea30fcd2fb02d13a38cab4bf3d903f902408f4
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review ankita-nvidia-com/kvm-determine-memory-type-from-VMA/20230406-020404
        git checkout 09ea30fcd2fb02d13a38cab4bf3d903f902408f4
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc SHELL=/bin/bash drivers/vfio/pci/nvgpu/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304060424.MtQM4udq-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/vfio/pci/nvgpu/main.c:57:5: warning: no previous prototype for 'nvgpu_vfio_pci_mmap' [-Wmissing-prototypes]
      57 | int nvgpu_vfio_pci_mmap(struct vfio_device *core_vdev,
         |     ^~~~~~~~~~~~~~~~~~~
>> drivers/vfio/pci/nvgpu/main.c:100:6: warning: no previous prototype for 'nvgpu_vfio_pci_ioctl' [-Wmissing-prototypes]
     100 | long nvgpu_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
         |      ^~~~~~~~~~~~~~~~~~~~


vim +/nvgpu_vfio_pci_mmap +57 drivers/vfio/pci/nvgpu/main.c

    56	
  > 57	int nvgpu_vfio_pci_mmap(struct vfio_device *core_vdev,
    58				struct vm_area_struct *vma)
    59	{
    60		struct nvgpu_vfio_pci_core_device *nvdev = container_of(
    61			core_vdev, struct nvgpu_vfio_pci_core_device, core_device.vdev);
    62	
    63		unsigned long start_pfn;
    64		unsigned int index;
    65		u64 req_len, pgoff;
    66		int ret = 0;
    67	
    68		index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
    69		if (index != nvdev->mem_prop.bar1_start_offset)
    70			return vfio_pci_core_mmap(core_vdev, vma);
    71	
    72		/*
    73		 * Request to mmap the BAR1. Map to the CPU accessible memory on the
    74		 * GPU using the memory information gathered from the system ACPI
    75		 * tables.
    76		 */
    77		start_pfn = nvdev->mem_prop.hpa >> PAGE_SHIFT;
    78		req_len = vma->vm_end - vma->vm_start;
    79		pgoff = vma->vm_pgoff &
    80			((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
    81		if (pgoff >= (nvdev->mem_prop.mem_length >> PAGE_SHIFT))
    82			return -EINVAL;
    83	
    84		/*
    85		 * Perform a PFN map to the memory. The device BAR1 is backed by the
    86		 * GPU memory now. Check that the mapping does not overflow out of
    87		 * the GPU memory size.
    88		 */
    89		ret = remap_pfn_range(vma, vma->vm_start, start_pfn + pgoff,
    90				      min(req_len, nvdev->mem_prop.mem_length - pgoff),
    91				      vma->vm_page_prot);
    92		if (ret)
    93			return ret;
    94	
    95		vma->vm_pgoff = start_pfn + pgoff;
    96	
    97		return 0;
    98	}
    99	
 > 100	long nvgpu_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
   101				  unsigned long arg)
   102	{
   103		struct nvgpu_vfio_pci_core_device *nvdev = container_of(
   104			core_vdev, struct nvgpu_vfio_pci_core_device, core_device.vdev);
   105	
   106		unsigned long minsz = offsetofend(struct vfio_region_info, offset);
   107		struct vfio_region_info info;
   108	
   109		switch (cmd) {
   110		case VFIO_DEVICE_GET_REGION_INFO:
   111			if (copy_from_user(&info, (void __user *)arg, minsz))
   112				return -EFAULT;
   113	
   114			if (info.argsz < minsz)
   115				return -EINVAL;
   116	
   117			if (info.index == nvdev->mem_prop.bar1_start_offset) {
   118				/*
   119				 * Request to determine the BAR1 region information. Send the
   120				 * GPU memory information.
   121				 */
   122				info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
   123				info.size = nvdev->mem_prop.mem_length;
   124				info.flags = VFIO_REGION_INFO_FLAG_READ |
   125					     VFIO_REGION_INFO_FLAG_WRITE |
   126					     VFIO_REGION_INFO_FLAG_MMAP;
   127				return copy_to_user((void __user *)arg, &info, minsz) ?
   128					       -EFAULT : 0;
   129			}
   130	
   131			if (info.index == nvdev->mem_prop.bar1_start_offset + 1) {
   132				/*
   133				 * The BAR1 region is 64b. Ignore this access.
   134				 */
   135				info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
   136				info.size = 0;
   137				info.flags = 0;
   138				return copy_to_user((void __user *)arg, &info, minsz) ?
   139					-EFAULT : 0;
   140			}
   141	
   142			return vfio_pci_core_ioctl(core_vdev, cmd, arg);
   143	
   144		default:
   145			return vfio_pci_core_ioctl(core_vdev, cmd, arg);
   146		}
   147	}
   148	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
