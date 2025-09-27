Return-Path: <kvm+bounces-58928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FBE1BA6202
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 19:15:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 950A9189E2D5
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 17:15:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A645D2D8DD1;
	Sat, 27 Sep 2025 17:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M7uhH/gC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B0E17E4;
	Sat, 27 Sep 2025 17:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758993321; cv=none; b=sFJm7IiCXGNZE5eQoAe6cMOchTrOOi4jgxAaBidMilRnbAvaJf9puA6cxYWQ3lo2VJ8VQMQfNZrStcwDVNXxvQO/GnfW528rt2VFZjT7uvFEAq6qgaEsasCbUut00eW1ok7DXv4SpcY60CJHHg3cZqIGWxFZWZT0SfK+QYNb0So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758993321; c=relaxed/simple;
	bh=EirxfAdYtb+idmVV2ek0+dgQhvpkG6voZOoMYEXUy+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CIBM/udEvSyCPMLNE33I9BHATMIlochFfJIGWt0x++f9jOzzajinlADFIQHqbdyNkkrGUH4Nzreb4vjGWq0S27D2FgdsBhPVkr+kV+2WlmVgTbmjOvilFfMK7mvcv6gOOl0g+3APhkKM+ln69cXemAh6uI2qBkbnkIzLmT8AeFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M7uhH/gC; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758993320; x=1790529320;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EirxfAdYtb+idmVV2ek0+dgQhvpkG6voZOoMYEXUy+w=;
  b=M7uhH/gCgWKp38CjiOXVR+AS728C6FEljuVxMipMt6bCiFKfDcbFEw65
   wXemyikttv1M0dRH67gSr/Hu/3b6lF1pegKeY0+6TVgqu8fRT1cfqeAYV
   lwMYNgz3wZRAyDtZ3fRPsFag4DCLJiI83mFxKWxbqS2pNlnEIRL4AaYLQ
   J3Mn6j3czt4EOZwWzg6dsiZzyYBqNjmH1SZOQh0s1bLRrgXXKH/4PbXWk
   OC3ick1/SYtzSALO/cIuKhkJxo8PcwEOqEbduodxf5uF63LCOJkj7BToF
   /T8zDI0lCVaw2RiiUIrfegFqY3BkoSxPrj0b/CQyG92bcN+3ivLHvJBHO
   w==;
X-CSE-ConnectionGUID: Ze5+RuLfQtiK45+YZpPGHg==
X-CSE-MsgGUID: 4fl/DckFR3u8o+e8qLsmwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11566"; a="63929773"
X-IronPort-AV: E=Sophos;i="6.18,298,1751266800"; 
   d="scan'208";a="63929773"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2025 10:15:19 -0700
X-CSE-ConnectionGUID: ncsgsvn7SmKqpvpiEywQJg==
X-CSE-MsgGUID: jATeppt5SRSMXxU7/3U17w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,298,1751266800"; 
   d="scan'208";a="176994667"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 27 Sep 2025 10:15:16 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v2YVo-0007EJ-1E;
	Sat, 27 Sep 2025 17:15:09 +0000
Date: Sun, 28 Sep 2025 01:14:56 +0800
From: kernel test robot <lkp@intel.com>
To: Gautam Gala <ggala@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: Fix to clear PTE when discarding a swapped
 page
Message-ID: <202509280003.NWFBhwme-lkp@intel.com>
References: <20250924121707.145350-1-ggala@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924121707.145350-1-ggala@linux.ibm.com>

Hi Gautam,

kernel test robot noticed the following build warnings:

[auto build test WARNING on s390/features]
[also build test WARNING on linus/master v6.17-rc7 next-20250926]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Gautam-Gala/KVM-s390-Fix-to-clear-PTE-when-discarding-a-swapped-page/20250924-201847
base:   https://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git features
patch link:    https://lore.kernel.org/r/20250924121707.145350-1-ggala%40linux.ibm.com
patch subject: [PATCH] KVM: s390: Fix to clear PTE when discarding a swapped page
config: s390-defconfig (https://download.01.org/0day-ci/archive/20250928/202509280003.NWFBhwme-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project cafc064fc7a96b3979a023ddae1da2b499d6c954)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250928/202509280003.NWFBhwme-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509280003.NWFBhwme-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/s390/boot/als.c:9:
   In file included from arch/s390/include/asm/sclp.h:26:
   In file included from arch/s390/include/asm/chpid.h:10:
   In file included from arch/s390/include/asm/cio.h:10:
   In file included from arch/s390/include/asm/dma-types.h:7:
   In file included from include/linux/io.h:12:
   In file included from arch/s390/include/asm/io.h:15:
>> arch/s390/include/asm/pgtable.h:2065:48: warning: passing 'unsigned long *' to parameter of type 'long *' converts between pointers to integer types with different sign [-Wpointer-sign]
    2065 |                 value = __atomic64_or_barrier(PGSTE_PCL_BIT, ptr);
         |                                                              ^~~
   arch/s390/include/asm/atomic_ops.h:161:1: note: passing argument to parameter 'ptr' here
     161 | __ATOMIC64_OPS(__atomic64_or,  "ogr")
         | ^
   arch/s390/include/asm/atomic_ops.h:157:2: note: expanded from macro '__ATOMIC64_OPS'
     157 |         __ATOMIC64_OP(op_name##_barrier, op_string)
         |         ^
   arch/s390/include/asm/atomic_ops.h:141:53: note: expanded from macro '__ATOMIC64_OP'
     141 | static __always_inline long op_name(long val, long *ptr)                \
         |                                                     ^
   1 warning generated.


vim +2065 arch/s390/include/asm/pgtable.h

  2057	
  2058	static inline pgste_t pgste_get_lock(pte_t *ptep)
  2059	{
  2060		unsigned long value = 0;
  2061	#ifdef CONFIG_PGSTE
  2062		unsigned long *ptr = (unsigned long *)(ptep + PTRS_PER_PTE);
  2063	
  2064		do {
> 2065			value = __atomic64_or_barrier(PGSTE_PCL_BIT, ptr);
  2066		} while (value & PGSTE_PCL_BIT);
  2067		value |= PGSTE_PCL_BIT;
  2068	#endif
  2069		return __pgste(value);
  2070	}
  2071	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

