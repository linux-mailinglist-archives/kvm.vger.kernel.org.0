Return-Path: <kvm+bounces-65319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AB693CA6CBD
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 10:03:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D1ADE3528C84
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 08:15:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77802339B5E;
	Fri,  5 Dec 2025 07:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dLLZ1Qse"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E391319870;
	Fri,  5 Dec 2025 07:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764920751; cv=none; b=etlT/K6Xqt4GRZ6DKB275gFzqjIEzBjLdzw/tLmqwQX6XoPf0J87Vfv+UpFCn5unNoSgmcr2MwnZrQjh3fX3KsdwFSXlYj1e1wbbRd1IhrMBIIFmTGMxEQj7dpbyyUKgtINg1FdsuFIZ5clfWEM+xQpS3vthzRPMSMm1GeZ6mV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764920751; c=relaxed/simple;
	bh=WNOp5BfXP7vsIwnY3VUCFcqhsa8pHGlNLBn3Wgn/K1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IhDEUoieVpM/X4MxE6SVKQRSkXpTpDe6+0XD5XaswIZrcMv4QK3XNIB9uVIzlJEbD+hycbpXpE183ZMMd+VO0HWuSYW49YzzJM05kAf7DQLFyyxy6hcwt79fE0sCoYPHH0/XEBrzDU06DyLqq4mo+fIqHVH1jOqdaeqqdV+oXQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dLLZ1Qse; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764920745; x=1796456745;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WNOp5BfXP7vsIwnY3VUCFcqhsa8pHGlNLBn3Wgn/K1E=;
  b=dLLZ1QseKr7CbWPnn/VKW/TEEexSWrPGjXPs+sWY8+/TnGkvn73lSNAS
   InXBRoCrdk2QdfHq7mdwA6M0ImZq4MLi182W6WZEIMGYfcGt8YoJlp/KP
   5To6ApvYNbGDTDtO9j1B+MlNYzLOt8GBtPp5kBldhC/lYhRG6yyKSUEx4
   Cf2fmSYtTBWt2R1KTTHQ19hNVcu8zdTzyZPaDVOEFC7LWXkbVRqsOZ2dJ
   uNIgwOSIUjZe2ViZAswRrEIKVt9S9BaGpHqDDrIyhCsvoFCx0O3NWVu5r
   VplChZeJIJ10NUs5dLAgeCwheJzgrP7iwfOaOT/b6JG1/fjMCc8bk+zjH
   Q==;
X-CSE-ConnectionGUID: a3klSM9oQDWMK4gWsOMHqg==
X-CSE-MsgGUID: PyiSwKyuSUmvzR07cemqRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="78304978"
X-IronPort-AV: E=Sophos;i="6.20,251,1758610800"; 
   d="scan'208";a="78304978"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 23:45:38 -0800
X-CSE-ConnectionGUID: xOf9AzaoRc2LvDI67wtJnQ==
X-CSE-MsgGUID: xMR7Dl+RQeG5HC6ZP8b+Fw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,251,1758610800"; 
   d="scan'208";a="196025418"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 04 Dec 2025 23:45:33 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vRQVP-00000000ElB-0rHZ;
	Fri, 05 Dec 2025 07:45:31 +0000
Date: Fri, 5 Dec 2025 15:45:13 +0800
From: kernel test robot <lkp@intel.com>
To: Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>, Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	peterx@redhat.com, Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with
 !MAP_FIXED mappings
Message-ID: <202512051509.bh8Oncoq-lkp@intel.com>
References: <20251204151003.171039-5-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204151003.171039-5-peterx@redhat.com>

Hi Peter,

kernel test robot noticed the following build warnings:

[auto build test WARNING on awilliam-vfio/for-linus]
[also build test WARNING on v6.18]
[cannot apply to akpm-mm/mm-everything awilliam-vfio/next brauner-vfs/vfs.all linus/master next-20251205]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Peter-Xu/mm-thp-Allow-thp_get_unmapped_area_vmflags-to-take-alignment/20251204-231258
base:   https://github.com/awilliam/linux-vfio.git for-linus
patch link:    https://lore.kernel.org/r/20251204151003.171039-5-peterx%40redhat.com
patch subject: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED mappings
config: i386-randconfig-006-20251205 (https://download.01.org/0day-ci/archive/20251205/202512051509.bh8Oncoq-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251205/202512051509.bh8Oncoq-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512051509.bh8Oncoq-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/vfio/pci/vfio_pci_core.c:1670:44: warning: shift count >= width of type [-Wshift-count-overflow]
    1670 |         req_start = (pgoff << PAGE_SHIFT) & ((1UL << VFIO_PCI_OFFSET_SHIFT) - 1);
         |                                                   ^  ~~~~~~~~~~~~~~~~~~~~~
   1 warning generated.


vim +1670 drivers/vfio/pci/vfio_pci_core.c

  1642	
  1643	/*
  1644	 * Hint function for mmap() about the size of mapping to be carried out.
  1645	 * This helps to enable huge pfnmaps as much as possible on BAR mappings.
  1646	 *
  1647	 * This function does the minimum check on mmap() parameters to make the
  1648	 * hint valid only. The majority of mmap() sanity check will be done later
  1649	 * in mmap().
  1650	 */
  1651	int vfio_pci_core_get_mapping_order(struct vfio_device *device,
  1652					    unsigned long pgoff, size_t len)
  1653	{
  1654		struct vfio_pci_core_device *vdev =
  1655		    container_of(device, struct vfio_pci_core_device, vdev);
  1656		struct pci_dev *pdev = vdev->pdev;
  1657		unsigned int index = pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
  1658		unsigned long req_start;
  1659		size_t phys_len;
  1660	
  1661		/* Currently, only bars 0-5 supports huge pfnmap */
  1662		if (index >= VFIO_PCI_ROM_REGION_INDEX)
  1663			return 0;
  1664	
  1665		/*
  1666		 * NOTE: we're keeping things simple as of now, assuming the
  1667		 * physical address of BARs (aka, pci_resource_start(pdev, index))
  1668		 * should always be aligned with pgoff in vfio-pci's address space.
  1669		 */
> 1670		req_start = (pgoff << PAGE_SHIFT) & ((1UL << VFIO_PCI_OFFSET_SHIFT) - 1);
  1671		phys_len = PAGE_ALIGN(pci_resource_len(pdev, index));
  1672	
  1673		/*
  1674		 * If this happens, it will probably fail mmap() later.. mapping
  1675		 * hint isn't important anymore.
  1676		 */
  1677		if (req_start >= phys_len)
  1678			return 0;
  1679	
  1680		phys_len = MIN(phys_len - req_start, len);
  1681	
  1682		if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && phys_len >= PUD_SIZE)
  1683			return PUD_ORDER;
  1684	
  1685		if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && phys_len >= PMD_SIZE)
  1686			return PMD_ORDER;
  1687	
  1688		return 0;
  1689	}
  1690	EXPORT_SYMBOL_GPL(vfio_pci_core_get_mapping_order);
  1691	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

