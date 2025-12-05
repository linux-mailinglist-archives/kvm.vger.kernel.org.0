Return-Path: <kvm+bounces-65312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 93BF3CA61C3
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 05:35:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 332A231B1D9F
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 04:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52F1E2DAFDA;
	Fri,  5 Dec 2025 04:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eOtbGprQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60C52737EB;
	Fri,  5 Dec 2025 04:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764909242; cv=none; b=MY1PGRgE64UjoIeWW+NMWZcmuwCPo7BkGzz85+58bToAHC620HdUEGrpTJCPTRDoT0OPmDvoFc6BLIc+a+LWSu9IGdnE4jhLZfx701KQSwPtk1OhOy6w5kSN5eAWRHLZUGg1D4p8PCPQBxH46+q239zSNSLzB9xE72Zh1JSn0Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764909242; c=relaxed/simple;
	bh=aIXWLsK16waG7MXWO7e8zEfJ8XBA/lm6NJ3ih7dA7wY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YLDFaArhhfkenzb4shbVIPQmfKPMVQ0sCuL8VJIkAoOwAJtkASWPc7vm+ZHCjuKgU313VVCJfRC1ZKHH8fTAvBJ+UQrWEG5nIaI92c4EplgrpMUnbhiJ7jgqrwpI4Z59EhjVgP0O1i5fpQsgQ2imGBVCEX/fKsaLR//ceefM6cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eOtbGprQ; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764909241; x=1796445241;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aIXWLsK16waG7MXWO7e8zEfJ8XBA/lm6NJ3ih7dA7wY=;
  b=eOtbGprQKZoq1boRg4Uqp3DttfS8yT+Vlz1OUXssmFLQKBlZgHpX8/eM
   DVo3buaheejQiiQ4Tcf8pfch9oVClwGnyv1mCBy8QYeT9zVUCDdS4LH70
   LlILusf/hazZD3fgABUkMLf9/v7FpVUaQSRhMV9rJzYuQt4uArwGpR5xc
   Rkt+G7y2sxH6OSFj+/fYW0Nz9s/MR6vMCY4/XznwfC5YgglHGDBmg0bEI
   IKJqsL/WK8R2imrfZlN2yOjc751+xmUELvbxz5gyt1wk10SzGQ1F5+TFG
   A8ZdlzyKzcwxs2D7sHI+N6Wi1QMtchii3T1tbxHt6D01MHz4MUXOnVL47
   w==;
X-CSE-ConnectionGUID: +v2lGH3eRv2EKbX1ME55wA==
X-CSE-MsgGUID: YZTsRbenQNyI0N2DogDqnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="70790459"
X-IronPort-AV: E=Sophos;i="6.20,251,1758610800"; 
   d="scan'208";a="70790459"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 20:34:00 -0800
X-CSE-ConnectionGUID: KFDHs5pbRk6nNvnHN+SREw==
X-CSE-MsgGUID: Ml7yRMGORvitt4XmZ/muEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,251,1758610800"; 
   d="scan'208";a="195221686"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 04 Dec 2025 20:33:56 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vRNVx-00000000Eao-3R11;
	Fri, 05 Dec 2025 04:33:53 +0000
Date: Fri, 5 Dec 2025 12:33:44 +0800
From: kernel test robot <lkp@intel.com>
To: Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Jason Gunthorpe <jgg@nvidia.com>,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	peterx@redhat.com, Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with
 !MAP_FIXED mappings
Message-ID: <202512051241.QtfYgqkx-lkp@intel.com>
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
[also build test WARNING on linus/master v6.18]
[cannot apply to akpm-mm/mm-everything awilliam-vfio/next brauner-vfs/vfs.all next-20251204]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Peter-Xu/mm-thp-Allow-thp_get_unmapped_area_vmflags-to-take-alignment/20251204-231258
base:   https://github.com/awilliam/linux-vfio.git for-linus
patch link:    https://lore.kernel.org/r/20251204151003.171039-5-peterx%40redhat.com
patch subject: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED mappings
config: i386-buildonly-randconfig-004-20251205 (https://download.01.org/0day-ci/archive/20251205/202512051241.QtfYgqkx-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251205/202512051241.QtfYgqkx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512051241.QtfYgqkx-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/vfio/pci/vfio_pci_core.c: In function 'vfio_pci_core_get_mapping_order':
>> drivers/vfio/pci/vfio_pci_core.c:1670:51: warning: left shift count >= width of type [-Wshift-count-overflow]
    1670 |         req_start = (pgoff << PAGE_SHIFT) & ((1UL << VFIO_PCI_OFFSET_SHIFT) - 1);
         |                                                   ^~


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

