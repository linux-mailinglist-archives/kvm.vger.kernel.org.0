Return-Path: <kvm+bounces-67494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B556FD06A1C
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 01:43:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9F16B30341FC
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 00:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7AEB1DE885;
	Fri,  9 Jan 2026 00:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RIg6dMTb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA601F95C;
	Fri,  9 Jan 2026 00:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767919402; cv=none; b=tj8zUkBlqjjY6VD20U0jGCR11ZurnjiYwNGgkYIjcl4OgJl0UkeAoG58XJmQxCWTUjNlM5v91bNSXE0xWtr6Jv89wEIrn0oJN5x+AvMZMzbO6nzOx40sX9nRF3RjJ2BKaTKzTB9o/LzMJ/JXNtGKSJKiqpLpCTsWxmig82GLOUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767919402; c=relaxed/simple;
	bh=zVzERIgtq6HANfaqGjDaXa14817otLnOv1j2W1S2R40=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KuXKfkR6Pz7l/P8K+adulFs85GEntHfycf3MDfCBi+9XJT4/0WTo0aWc2RhzsfXWPytvp3D6LrmiOuDrYLav61Z6c54217PWvsVS7iVN++MllglfjTgd6EI1r5ZpXqOHQt2h+rRcTavIGe1yRZVYjrxgiqnTLAra8UgzPQsZbEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RIg6dMTb; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767919401; x=1799455401;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zVzERIgtq6HANfaqGjDaXa14817otLnOv1j2W1S2R40=;
  b=RIg6dMTbnMIoy3pwYucBqnad6pEOsWLlkcws7zqN3kIMStwZQzy2bltt
   tdGuU70F8wxZ3hPHgloU2ElpEVsmEdNhwMv5ncqOlF4KtPHAtnOuIPSsF
   1G1VfeEcQJSBVmpijF6CaG1CYBjkWCrRhvBvX0OlCWAcLjjxrnsyUHuOh
   wD2ARBb6dctSE55et9aOI4LR1oULNucugso9BtW6dM9zBH4g9TUW4niC/
   +LDXvgIIGb0fvIWYYC6e6WqAKBUdpgSGquPrLFW00iBgZ7hoF1yzF69YS
   XDaNO/op9NWGjj8fkHgFB363OjgG/HJxEo/Y37cilCeV8+FZYusPWsviY
   w==;
X-CSE-ConnectionGUID: oZhVJmxSRWKz/RMWkP5o2g==
X-CSE-MsgGUID: ajwxLqNOQPyDPkKbYVns3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="69379399"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="69379399"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 16:43:20 -0800
X-CSE-ConnectionGUID: VKvGiQJ1RGCD67zKyZQvxg==
X-CSE-MsgGUID: WiZL7CY1Q6a6wgJASFoWvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="208393548"
Received: from igk-lkp-server01.igk.intel.com (HELO 92b2e8bd97aa) ([10.211.93.152])
  by orviesa005.jf.intel.com with ESMTP; 08 Jan 2026 16:43:15 -0800
Received: from kbuild by 92b2e8bd97aa with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1ve0au-000000001tk-2Obc;
	Fri, 09 Jan 2026 00:43:12 +0000
Date: Fri, 9 Jan 2026 01:42:24 +0100
From: kernel test robot <lkp@intel.com>
To: Samiullah Khawaja <skhawaja@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, David Matlack <dmatlack@google.com>
Cc: oe-kbuild-all@lists.linux.dev, Samiullah Khawaja <skhawaja@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Shuah Khan <skhan@linuxfoundation.org>, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>
Subject: Re: [PATCH 3/3] vfio: selftests: Add iommufd hwpt replace test
Message-ID: <202601090106.YNZaDPcd-lkp@intel.com>
References: <20260107201800.2486137-4-skhawaja@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107201800.2486137-4-skhawaja@google.com>

Hi Samiullah,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 6cd6c12031130a349a098dbeb19d8c3070d2dfbe]

url:    https://github.com/intel-lab-lkp/linux/commits/Samiullah-Khawaja/iommu-vt-d-Allow-replacing-no_pasid-iommu_domain/20260108-041955
base:   6cd6c12031130a349a098dbeb19d8c3070d2dfbe
patch link:    https://lore.kernel.org/r/20260107201800.2486137-4-skhawaja%40google.com
patch subject: [PATCH 3/3] vfio: selftests: Add iommufd hwpt replace test
config: i386-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260109/202601090106.YNZaDPcd-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260109/202601090106.YNZaDPcd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601090106.YNZaDPcd-lkp@intel.com/

All warnings (new ones prefixed by >>):

         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:32:37: note: expanded from macro 'VFIO_ASSERT_EQ'
      32 | #define VFIO_ASSERT_EQ(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, ==, ##__VA_ARGS__)
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:27:4: note: expanded from macro 'VFIO_ASSERT_OP'
      26 |         fprintf(stderr, "  Observed: %#lx %s %#lx\n",                           \
         |                                      ~~~~
      27 |                         (u64)__lhs, #_op, (u64)__rhs);                          \
         |                         ^~~~~~~~~~
   In file included from tools/testing/selftests/vfio/vfio_iommufd_hwpt_replace_test.c:8:
   In file included from tools/testing/selftests/vfio/lib/include/libvfio.h:6:
   tools/testing/selftests/vfio/lib/include/libvfio/iommu.h:51:2: warning: format specifies type 'unsigned long' but the argument has type 'u64' (aka 'unsigned long long') [-Wformat]
      51 |         VFIO_ASSERT_EQ(__iommu_unmap(iommu, region, NULL), 0);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:32:37: note: expanded from macro 'VFIO_ASSERT_EQ'
      32 | #define VFIO_ASSERT_EQ(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, ==, ##__VA_ARGS__)
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:27:22: note: expanded from macro 'VFIO_ASSERT_OP'
      26 |         fprintf(stderr, "  Observed: %#lx %s %#lx\n",                           \
         |                                              ~~~~
      27 |                         (u64)__lhs, #_op, (u64)__rhs);                          \
         |                                           ^~~~~~~~~~
   In file included from tools/testing/selftests/vfio/vfio_iommufd_hwpt_replace_test.c:8:
   In file included from tools/testing/selftests/vfio/lib/include/libvfio.h:6:
   tools/testing/selftests/vfio/lib/include/libvfio/iommu.h:58:2: warning: format specifies type 'unsigned long' but the argument has type 'u64' (aka 'unsigned long long') [-Wformat]
      58 |         VFIO_ASSERT_EQ(__iommu_unmap_all(iommu, NULL), 0);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:32:37: note: expanded from macro 'VFIO_ASSERT_EQ'
      32 | #define VFIO_ASSERT_EQ(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, ==, ##__VA_ARGS__)
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:27:4: note: expanded from macro 'VFIO_ASSERT_OP'
      26 |         fprintf(stderr, "  Observed: %#lx %s %#lx\n",                           \
         |                                      ~~~~
      27 |                         (u64)__lhs, #_op, (u64)__rhs);                          \
         |                         ^~~~~~~~~~
   In file included from tools/testing/selftests/vfio/vfio_iommufd_hwpt_replace_test.c:8:
   In file included from tools/testing/selftests/vfio/lib/include/libvfio.h:6:
   tools/testing/selftests/vfio/lib/include/libvfio/iommu.h:58:2: warning: format specifies type 'unsigned long' but the argument has type 'u64' (aka 'unsigned long long') [-Wformat]
      58 |         VFIO_ASSERT_EQ(__iommu_unmap_all(iommu, NULL), 0);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:32:37: note: expanded from macro 'VFIO_ASSERT_EQ'
      32 | #define VFIO_ASSERT_EQ(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, ==, ##__VA_ARGS__)
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:27:22: note: expanded from macro 'VFIO_ASSERT_OP'
      26 |         fprintf(stderr, "  Observed: %#lx %s %#lx\n",                           \
         |                                              ~~~~
      27 |                         (u64)__lhs, #_op, (u64)__rhs);                          \
         |                                           ^~~~~~~~~~
   In file included from tools/testing/selftests/vfio/vfio_iommufd_hwpt_replace_test.c:8:
   In file included from tools/testing/selftests/vfio/lib/include/libvfio.h:8:
   tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h:80:2: warning: format specifies type 'unsigned long' but the argument has type 'u64' (aka 'unsigned long long') [-Wformat]
      80 |         VFIO_ASSERT_NE(r, -1, "F_GETFL failed for fd %d\n", fd);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:33:37: note: expanded from macro 'VFIO_ASSERT_NE'
      33 | #define VFIO_ASSERT_NE(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, !=, ##__VA_ARGS__)
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:27:4: note: expanded from macro 'VFIO_ASSERT_OP'
      26 |         fprintf(stderr, "  Observed: %#lx %s %#lx\n",                           \
         |                                      ~~~~
      27 |                         (u64)__lhs, #_op, (u64)__rhs);                          \
         |                         ^~~~~~~~~~
   In file included from tools/testing/selftests/vfio/vfio_iommufd_hwpt_replace_test.c:8:
   In file included from tools/testing/selftests/vfio/lib/include/libvfio.h:8:
   tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h:80:2: warning: format specifies type 'unsigned long' but the argument has type 'u64' (aka 'unsigned long long') [-Wformat]
      80 |         VFIO_ASSERT_NE(r, -1, "F_GETFL failed for fd %d\n", fd);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:33:37: note: expanded from macro 'VFIO_ASSERT_NE'
      33 | #define VFIO_ASSERT_NE(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, !=, ##__VA_ARGS__)
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:27:22: note: expanded from macro 'VFIO_ASSERT_OP'
      26 |         fprintf(stderr, "  Observed: %#lx %s %#lx\n",                           \
         |                                              ~~~~
      27 |                         (u64)__lhs, #_op, (u64)__rhs);                          \
         |                                           ^~~~~~~~~~
   In file included from tools/testing/selftests/vfio/vfio_iommufd_hwpt_replace_test.c:8:
   In file included from tools/testing/selftests/vfio/lib/include/libvfio.h:8:
   tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h:83:2: warning: format specifies type 'unsigned long' but the argument has type 'u64' (aka 'unsigned long long') [-Wformat]
      83 |         VFIO_ASSERT_NE(r, -1, "F_SETFL O_NONBLOCK failed for fd %d\n", fd);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:33:37: note: expanded from macro 'VFIO_ASSERT_NE'
      33 | #define VFIO_ASSERT_NE(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, !=, ##__VA_ARGS__)
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:27:4: note: expanded from macro 'VFIO_ASSERT_OP'
      26 |         fprintf(stderr, "  Observed: %#lx %s %#lx\n",                           \
         |                                      ~~~~
      27 |                         (u64)__lhs, #_op, (u64)__rhs);                          \
         |                         ^~~~~~~~~~
   In file included from tools/testing/selftests/vfio/vfio_iommufd_hwpt_replace_test.c:8:
   In file included from tools/testing/selftests/vfio/lib/include/libvfio.h:8:
   tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h:83:2: warning: format specifies type 'unsigned long' but the argument has type 'u64' (aka 'unsigned long long') [-Wformat]
      83 |         VFIO_ASSERT_NE(r, -1, "F_SETFL O_NONBLOCK failed for fd %d\n", fd);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:33:37: note: expanded from macro 'VFIO_ASSERT_NE'
      33 | #define VFIO_ASSERT_NE(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, !=, ##__VA_ARGS__)
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:27:22: note: expanded from macro 'VFIO_ASSERT_OP'
      26 |         fprintf(stderr, "  Observed: %#lx %s %#lx\n",                           \
         |                                              ~~~~
      27 |                         (u64)__lhs, #_op, (u64)__rhs);                          \
         |                                           ^~~~~~~~~~
>> tools/testing/selftests/vfio/vfio_iommufd_hwpt_replace_test.c:23:2: warning: format specifies type 'unsigned long' but the argument has type 'u64' (aka 'unsigned long long') [-Wformat]
      23 |         VFIO_ASSERT_NE(vaddr, MAP_FAILED);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:33:37: note: expanded from macro 'VFIO_ASSERT_NE'
      33 | #define VFIO_ASSERT_NE(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, !=, ##__VA_ARGS__)
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:27:4: note: expanded from macro 'VFIO_ASSERT_OP'
      26 |         fprintf(stderr, "  Observed: %#lx %s %#lx\n",                           \
         |                                      ~~~~
      27 |                         (u64)__lhs, #_op, (u64)__rhs);                          \
         |                         ^~~~~~~~~~
>> tools/testing/selftests/vfio/vfio_iommufd_hwpt_replace_test.c:23:2: warning: format specifies type 'unsigned long' but the argument has type 'u64' (aka 'unsigned long long') [-Wformat]
      23 |         VFIO_ASSERT_NE(vaddr, MAP_FAILED);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:33:37: note: expanded from macro 'VFIO_ASSERT_NE'
      33 | #define VFIO_ASSERT_NE(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, !=, ##__VA_ARGS__)
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:27:22: note: expanded from macro 'VFIO_ASSERT_OP'
      26 |         fprintf(stderr, "  Observed: %#lx %s %#lx\n",                           \
         |                                              ~~~~
      27 |                         (u64)__lhs, #_op, (u64)__rhs);                          \
         |                                           ^~~~~~~~~~
   tools/testing/selftests/vfio/vfio_iommufd_hwpt_replace_test.c:35:2: warning: format specifies type 'unsigned long' but the argument has type 'u64' (aka 'unsigned long long') [-Wformat]
      35 |         VFIO_ASSERT_EQ(munmap(region->vaddr, region->size), 0);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:32:37: note: expanded from macro 'VFIO_ASSERT_EQ'
      32 | #define VFIO_ASSERT_EQ(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, ==, ##__VA_ARGS__)
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:27:4: note: expanded from macro 'VFIO_ASSERT_OP'
      26 |         fprintf(stderr, "  Observed: %#lx %s %#lx\n",                           \
         |                                      ~~~~
      27 |                         (u64)__lhs, #_op, (u64)__rhs);                          \
         |                         ^~~~~~~~~~
   tools/testing/selftests/vfio/vfio_iommufd_hwpt_replace_test.c:35:2: warning: format specifies type 'unsigned long' but the argument has type 'u64' (aka 'unsigned long long') [-Wformat]
      35 |         VFIO_ASSERT_EQ(munmap(region->vaddr, region->size), 0);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:32:37: note: expanded from macro 'VFIO_ASSERT_EQ'
      32 | #define VFIO_ASSERT_EQ(_a, _b, ...) VFIO_ASSERT_OP(_a, _b, ==, ##__VA_ARGS__)
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tools/testing/selftests/vfio/lib/include/libvfio/assert.h:27:22: note: expanded from macro 'VFIO_ASSERT_OP'
      26 |         fprintf(stderr, "  Observed: %#lx %s %#lx\n",                           \
         |                                              ~~~~
      27 |                         (u64)__lhs, #_op, (u64)__rhs);                          \
         |                                           ^~~~~~~~~~
   14 warnings generated.


vim +23 tools/testing/selftests/vfio/vfio_iommufd_hwpt_replace_test.c

    13	
    14	static void region_setup(struct iommu *iommu,
    15				 struct iova_allocator *iova_allocator,
    16				 struct dma_region *region, u64 size)
    17	{
    18		const int flags = MAP_SHARED | MAP_ANONYMOUS;
    19		const int prot = PROT_READ | PROT_WRITE;
    20		void *vaddr;
    21	
    22		vaddr = mmap(NULL, size, prot, flags, -1, 0);
  > 23		VFIO_ASSERT_NE(vaddr, MAP_FAILED);
    24	
    25		region->vaddr = vaddr;
    26		region->iova = iova_allocator_alloc(iova_allocator, size);
    27		region->size = size;
    28	
    29		iommu_map(iommu, region);
    30	}
    31	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

