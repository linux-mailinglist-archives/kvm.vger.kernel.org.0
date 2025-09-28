Return-Path: <kvm+bounces-58947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F2E46BA7449
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 17:37:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B02473BC76D
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 15:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 194A2235044;
	Sun, 28 Sep 2025 15:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DF6cBU6b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5116434BA58;
	Sun, 28 Sep 2025 15:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759073814; cv=none; b=dZUpbL9DgLebPm8d++boA8luptdke1VXcZ6dv0vSjt7gX9XgZOU9aNDSXAKHPsPAiwkIU5phQHQ7Ut+0M4FAcn98qoikLEhG0ctqMD2Hma5Oj/7eO+M5UvA31PUR/vCsWPaaQHXEEXikb/x46DOm/3r1f+S5foUOssAuokyIxg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759073814; c=relaxed/simple;
	bh=Ps64nDklqamC6EV1MdTjLHaAg7vz5kbJKj7+3R+gE9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U+4x6RKK01XJSXZ90Fo7UakocMky/wl9vSTsEImwEDTibqVOVZ318JOBdCAVI2z1e7ir+PfPcNunjrH0mCMXoap9DCW//Ln8mlxvHbSRpGKR2om0Qyp/NXkk/SPqAOqq8TDx00MhYf1XnOi8t1tUFAmJjMN9IwvlJirpxthyCmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DF6cBU6b; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759073813; x=1790609813;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ps64nDklqamC6EV1MdTjLHaAg7vz5kbJKj7+3R+gE9M=;
  b=DF6cBU6b/Lvudm930LeQ5Kyg7rBV3+agaSizFXMaNuEH9KLV6QKNlfrM
   9diwsSdoXE7wN0fE8wnsKGnzz2x4s8g5k8G98pG1eyCikc6CKxp+eFqCk
   AQI0OThSTKfI2vBHoRO/TMNdPeayl5A8i0JhnO23v5jsrEbG8vS/Czo3B
   n0za+AHuHdyZciHfulFyaP7rZRPf3TPxKmnc3zGV6dJfSJKme5+jSZk6u
   k39Tv88T5eEOs7UlHv1bB0nV6hfwMolsW55QGL0oc7KXu8tl8Q+CFiuGE
   iKT4WvTepBzj9ZbZrNhqtiSwuAlMNsthVep13KtHjc/Ob5T4V/DLleVz2
   g==;
X-CSE-ConnectionGUID: Eo6++W3bSH+tkaBZOpM6QA==
X-CSE-MsgGUID: KMMlJ4uCTX6RA6ktMEpHGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11567"; a="83945357"
X-IronPort-AV: E=Sophos;i="6.18,299,1751266800"; 
   d="scan'208";a="83945357"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2025 08:36:52 -0700
X-CSE-ConnectionGUID: F6YSfJnxTLOaywNqfs2gRQ==
X-CSE-MsgGUID: jMAzwS4qRquUF6Tp0XctNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,299,1751266800"; 
   d="scan'208";a="201703507"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 28 Sep 2025 08:36:49 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v2tSA-0007t5-0s;
	Sun, 28 Sep 2025 15:36:46 +0000
Date: Sun, 28 Sep 2025 23:36:12 +0800
From: kernel test robot <lkp@intel.com>
To: liu.xuemei1@zte.com.cn, anup@brainfault.org
Cc: oe-kbuild-all@lists.linux.dev, atish.patra@linux.dev,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	alex@ghiti.fr, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RISC-V: KVM: Transparent huge page support
Message-ID: <202509282326.NFfcoD5h-lkp@intel.com>
References: <20250928154450701hRC3fm00QYFnGiM0_M1No@zte.com.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250928154450701hRC3fm00QYFnGiM0_M1No@zte.com.cn>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on kvm/next mst-vhost/linux-next linus/master v6.17-rc7 next-20250926]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/liu-xuemei1-zte-com-cn/RISC-V-KVM-Transparent-huge-page-support/20250928-154904
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20250928154450701hRC3fm00QYFnGiM0_M1No%40zte.com.cn
patch subject: [PATCH] RISC-V: KVM: Transparent huge page support
config: riscv-randconfig-001-20250928 (https://download.01.org/0day-ci/archive/20250928/202509282326.NFfcoD5h-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250928/202509282326.NFfcoD5h-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509282326.NFfcoD5h-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/riscv/kvm/gstage.c: In function 'gstage_supports_huge_mapping':
>> arch/riscv/kvm/gstage.c:108:39: warning: left shift count >= width of type [-Wshift-count-overflow]
     108 |         gpa_start = memslot->base_gfn << PAGE_SIZE;
         |                                       ^~


vim +108 arch/riscv/kvm/gstage.c

    97	
    98	static bool gstage_supports_huge_mapping(struct kvm_memory_slot *memslot, unsigned long hva)
    99	{
   100		gpa_t gpa_start;
   101		hva_t uaddr_start, uaddr_end;
   102		size_t size;
   103	
   104		size = memslot->npages * PAGE_SIZE;
   105		uaddr_start = memslot->userspace_addr;
   106		uaddr_end = uaddr_start + size;
   107	
 > 108		gpa_start = memslot->base_gfn << PAGE_SIZE;
   109	
   110		/*
   111		 * Pages belonging to memslots that don't have the same alignment
   112		 * within a PMD for userspace and GPA cannot be mapped with g-stage
   113		 * PMD entries, because we'll end up mapping the wrong pages.
   114		 *
   115		 * Consider a layout like the following:
   116		 *
   117		 *    memslot->userspace_addr:
   118		 *    +-----+--------------------+--------------------+---+
   119		 *    |abcde|fgh  vs-stage block  |    vs-stage block tv|xyz|
   120		 *    +-----+--------------------+--------------------+---+
   121		 *
   122		 *    memslot->base_gfn << PAGE_SHIFT:
   123		 *      +---+--------------------+--------------------+-----+
   124		 *      |abc|def  g-stage block  |    g-stage block   |tvxyz|
   125		 *      +---+--------------------+--------------------+-----+
   126		 *
   127		 * If we create those g-stage blocks, we'll end up with this incorrect
   128		 * mapping:
   129		 *   d -> f
   130		 *   e -> g
   131		 *   f -> h
   132		 */
   133		if ((gpa_start & (PMD_SIZE - 1)) != (uaddr_start & (PMD_SIZE - 1)))
   134			return false;
   135	
   136		/*
   137		 * Next, let's make sure we're not trying to map anything not covered
   138		 * by the memslot. This means we have to prohibit block size mappings
   139		 * for the beginning and end of a non-block aligned and non-block sized
   140		 * memory slot (illustrated by the head and tail parts of the
   141		 * userspace view above containing pages 'abcde' and 'xyz',
   142		 * respectively).
   143		 *
   144		 * Note that it doesn't matter if we do the check using the
   145		 * userspace_addr or the base_gfn, as both are equally aligned (per
   146		 * the check above) and equally sized.
   147		 */
   148		return (hva >= ALIGN(uaddr_start, PMD_SIZE)) && (hva < ALIGN_DOWN(uaddr_end, PMD_SIZE));
   149	}
   150	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

