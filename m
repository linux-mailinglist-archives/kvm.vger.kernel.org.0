Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9336D89CD
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 23:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjDEVwM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 17:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDEVwL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 17:52:11 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A4E7689;
        Wed,  5 Apr 2023 14:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680731529; x=1712267529;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SGOlJLDT1ioddLPGrnUpcWov0kqYqtqcGa+Y5DPWRow=;
  b=iPI5NM7zMlttUEuf21b48YzKvjUEWZ/g3A2sVaAlrnUI3ggw7A8Bck9K
   1rdGRV7T+jWmR1EUi/lyGoLYV5rzKUCQvF/JguU2PA99jWJ6UoLxj1SIV
   cth0ofTLWoblh3sTzklXSeDSZbF2YF5WL5ccwOzpGzu6hhUsC+nM5ytq6
   W70JsheKotZ88zdAfqG9KqG/KjgpIKDhP4+9Ehr0AqX4e3kNAAg/t0Fw4
   n4Mu0Aqe09Uv2JsI79QNi2PdvYNBo3Xm+HXotSvrDsN+fd5rw7mvYjI1y
   5rSIS3JQoUGMV1rcb5M8u78MU5eeU/PIU29t7ENnNoI016CtPLqYNZkiY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="322227318"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="322227318"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 14:51:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="686883324"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="686883324"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 05 Apr 2023 14:51:32 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pkB2M-000QpX-1j;
        Wed, 05 Apr 2023 21:51:26 +0000
Date:   Thu, 6 Apr 2023 05:50:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     ankita@nvidia.com, jgg@nvidia.com, alex.williamson@redhat.com,
        naoya.horiguchi@nec.com, maz@kernel.org, oliver.upton@linux.dev
Cc:     oe-kbuild-all@lists.linux.dev, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 6/6] vfio/nvgpu: register device memory for poison
 handling
Message-ID: <202304060554.C67nAJzr-lkp@intel.com>
References: <20230405180134.16932-7-ankita@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405180134.16932-7-ankita@nvidia.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on awilliam-vfio/for-linus]
[also build test WARNING on kvmarm/next akpm-mm/mm-everything linus/master v6.3-rc5]
[cannot apply to awilliam-vfio/next next-20230405]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/ankita-nvidia-com/kvm-determine-memory-type-from-VMA/20230406-020404
base:   https://github.com/awilliam/linux-vfio.git for-linus
patch link:    https://lore.kernel.org/r/20230405180134.16932-7-ankita%40nvidia.com
patch subject: [PATCH v3 6/6] vfio/nvgpu: register device memory for poison handling
config: sparc-allyesconfig (https://download.01.org/0day-ci/archive/20230406/202304060554.C67nAJzr-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/f2eb3c3417670adc1615fc629e6363d50c0623b4
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review ankita-nvidia-com/kvm-determine-memory-type-from-VMA/20230406-020404
        git checkout f2eb3c3417670adc1615fc629e6363d50c0623b4
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc SHELL=/bin/bash drivers/vfio/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304060554.C67nAJzr-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/vfio/pci/nvgpu/main.c:27:6: warning: no previous prototype for 'nvgpu_vfio_pci_pfn_memory_failure' [-Wmissing-prototypes]
      27 | void nvgpu_vfio_pci_pfn_memory_failure(struct pfn_address_space *pfn_space,
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/vfio/pci/nvgpu/main.c:126:6: warning: no previous prototype for 'nvgpu_vfio_pci_close_device' [-Wmissing-prototypes]
     126 | void nvgpu_vfio_pci_close_device(struct vfio_device *core_vdev)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/vfio/pci/nvgpu/main.c:136:5: warning: no previous prototype for 'nvgpu_vfio_pci_mmap' [-Wmissing-prototypes]
     136 | int nvgpu_vfio_pci_mmap(struct vfio_device *core_vdev,
         |     ^~~~~~~~~~~~~~~~~~~
   drivers/vfio/pci/nvgpu/main.c:182:6: warning: no previous prototype for 'nvgpu_vfio_pci_ioctl' [-Wmissing-prototypes]
     182 | long nvgpu_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
         |      ^~~~~~~~~~~~~~~~~~~~


vim +/nvgpu_vfio_pci_pfn_memory_failure +27 drivers/vfio/pci/nvgpu/main.c

    26	
  > 27	void nvgpu_vfio_pci_pfn_memory_failure(struct pfn_address_space *pfn_space,
    28					       unsigned long pfn)
    29	{
    30		struct nvgpu_vfio_pci_core_device *nvdev = container_of(
    31			pfn_space, struct nvgpu_vfio_pci_core_device, pfn_address_space);
    32	
    33		/*
    34		 * MM has called to notify a poisoned page. Track that in the bitmap.
    35		 */
    36		__set_bit(pfn - (pfn_space->node.start), nvdev->mem_prop.pfn_bitmap);
    37	}
    38	
    39	struct pfn_address_space_ops nvgpu_vfio_pci_pas_ops = {
    40		.failure = nvgpu_vfio_pci_pfn_memory_failure,
    41	};
    42	
    43	static int
    44	nvgpu_vfio_pci_register_pfn_range(struct nvgpu_vfio_pci_core_device *nvdev,
    45					  struct vm_area_struct *vma)
    46	{
    47		unsigned long nr_pages;
    48		int ret = 0;
    49	
    50		nr_pages = nvdev->mem_prop.mem_length >> PAGE_SHIFT;
    51	
    52		nvdev->pfn_address_space.node.start = vma->vm_pgoff;
    53		nvdev->pfn_address_space.node.last = vma->vm_pgoff + nr_pages - 1;
    54		nvdev->pfn_address_space.ops = &nvgpu_vfio_pci_pas_ops;
    55		nvdev->pfn_address_space.mapping = vma->vm_file->f_mapping;
    56	
    57		ret = register_pfn_address_space(&(nvdev->pfn_address_space));
    58	
    59		return ret;
    60	}
    61	
    62	static vm_fault_t nvgpu_vfio_pci_fault(struct vm_fault *vmf)
    63	{
    64		unsigned long mem_offset = vmf->pgoff - vmf->vma->vm_pgoff;
    65		struct nvgpu_vfio_pci_core_device *nvdev = container_of(
    66			vmf->vma->vm_file->private_data,
    67			struct nvgpu_vfio_pci_core_device, core_device.vdev);
    68		int ret;
    69	
    70		/*
    71		 * Check if the page is poisoned.
    72		 */
    73		if (mem_offset < (nvdev->mem_prop.mem_length >> PAGE_SHIFT) &&
    74			test_bit(mem_offset, nvdev->mem_prop.pfn_bitmap))
    75			return VM_FAULT_HWPOISON;
    76	
    77		ret = remap_pfn_range(vmf->vma,
    78				vmf->vma->vm_start + (mem_offset << PAGE_SHIFT),
    79				DUMMY_PFN, PAGE_SIZE,
    80				vmf->vma->vm_page_prot);
    81		if (ret)
    82			return VM_FAULT_ERROR;
    83	
    84		return VM_FAULT_NOPAGE;
    85	}
    86	
    87	static const struct vm_operations_struct nvgpu_vfio_pci_mmap_ops = {
    88		.fault = nvgpu_vfio_pci_fault,
    89	};
    90	
    91	static int vfio_get_bar1_start_offset(struct vfio_pci_core_device *vdev)
    92	{
    93		u8 val = 0;
    94	
    95		pci_read_config_byte(vdev->pdev, 0x10, &val);
    96		/*
    97		 * The BAR1 start offset in the PCI config space depends on the BAR0
    98		 * size. Check if the BAR0 is 64b and return the approproiate BAR1
    99		 * offset.
   100		 */
   101		if (val & PCI_BASE_ADDRESS_MEM_TYPE_64)
   102			return VFIO_PCI_BAR2_REGION_INDEX;
   103	
   104		return VFIO_PCI_BAR1_REGION_INDEX;
   105	}
   106	
   107	static int nvgpu_vfio_pci_open_device(struct vfio_device *core_vdev)
   108	{
   109		struct nvgpu_vfio_pci_core_device *nvdev = container_of(
   110			core_vdev, struct nvgpu_vfio_pci_core_device, core_device.vdev);
   111		struct vfio_pci_core_device *vdev =
   112			container_of(core_vdev, struct vfio_pci_core_device, vdev);
   113		int ret;
   114	
   115		ret = vfio_pci_core_enable(vdev);
   116		if (ret)
   117			return ret;
   118	
   119		vfio_pci_core_finish_enable(vdev);
   120	
   121		nvdev->mem_prop.bar1_start_offset = vfio_get_bar1_start_offset(vdev);
   122	
   123		return ret;
   124	}
   125	
 > 126	void nvgpu_vfio_pci_close_device(struct vfio_device *core_vdev)
   127	{
   128		struct nvgpu_vfio_pci_core_device *nvdev = container_of(
   129			core_vdev, struct nvgpu_vfio_pci_core_device, core_device.vdev);
   130	
   131		unregister_pfn_address_space(&(nvdev->pfn_address_space));
   132	
   133		vfio_pci_core_close_device(core_vdev);
   134	}
   135	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
