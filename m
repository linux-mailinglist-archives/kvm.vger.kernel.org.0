Return-Path: <kvm+bounces-30275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B3309B897B
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 03:52:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D45271F228E5
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 02:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 257E713B7A3;
	Fri,  1 Nov 2024 02:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SKNAqQbg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA971369AE
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 02:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730429534; cv=none; b=Et05gfhPlXaTaXHiptJor/MhlLJWmujRt6NBX0nU9MsuitECJ6fJr+HECQN5odXmfMer6t+NIcj/bff5gHlzO3NaJoG0ysAguEoftWbbwWmEyKB9wDiDE4r7wHPCaBR1BtsA8XHDwvCwb7vTpPolRDNiHCVHjAG0Ih2tn6DvwCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730429534; c=relaxed/simple;
	bh=59tX4tpkBBoLdV/egynR8o+RMSZv25btoppP3TMRMEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kz60EsSDnG9jaYHYKBM6gr9nKloBRrs0ccKK0b1520TBsY8TXofWN0OyqkQNxHjAFZaruewDa6sQRJmhh19juEp342HJFNTFheTD6NHQw3MU6osdUc7mKCnuI+r/AdN3rP/cwNRhmTA7TdIPRdR140e1ngwAlDy4eNtjy09YDVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SKNAqQbg; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730429528; x=1761965528;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=59tX4tpkBBoLdV/egynR8o+RMSZv25btoppP3TMRMEQ=;
  b=SKNAqQbgjZ0EwFq+U/Y11LMBQjebRoB3NknVJmtCDExmrCFBPqJcDRSK
   NyPWYMNrImVViP4LNrHltUi2cky9fhZIFM85gKRhUqnNP4aYvRykgJiGN
   UQwnJzTwFKP9hrZhlVZvlQPwq6UxSOfxXDrWuQLwOgHTCa+ZufmofbKtz
   HrOqbwiYLr6RzuFEatQX10TrdpoCtbw8RviOD62yOYwsI4iuHSihG7mro
   hyzUAS4OS1D0w+Xn+f7Hi6N3yvZPOiSPzKO9JT7q+pNdacbM6Bp1Ri7gj
   APVlVPRU+uRz9oFIMloe6l7+Pdt9xmbnBvtYNSRG93bfCVQCHMsW48gdj
   Q==;
X-CSE-ConnectionGUID: hkT5R7bYSLi5ePf7jY29Ew==
X-CSE-MsgGUID: /RzQ1IbvQB2Eluw4XfAt/g==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="29625946"
X-IronPort-AV: E=Sophos;i="6.11,248,1725346800"; 
   d="scan'208";a="29625946"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 19:52:07 -0700
X-CSE-ConnectionGUID: vU9tlH6vRUmAVXZ3vJ/OAA==
X-CSE-MsgGUID: 7F4r3DXQQguEW45TrAx4Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,248,1725346800"; 
   d="scan'208";a="83264184"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 31 Oct 2024 19:52:05 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t6hla-000h4M-18;
	Fri, 01 Nov 2024 02:52:02 +0000
Date: Fri, 1 Nov 2024 10:51:57 +0800
From: kernel test robot <lkp@intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Farrah Chen <farrah.chen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Kai Huang <kai.huang@intel.com>, Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [kvm:kvm-coco-queue 118/186] arch/x86/kvm/mmu/tdp_mmu.c:474:14:
 sparse: sparse: incorrect type in argument 1 (different address spaces)
Message-ID: <202411011026.TPHQXlbi-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-coco-queue
head:   49c492a89914b02fa5011d9ea9848318c6c98dd9
commit: 8c503164d3c974ae4ae50e75867b3563e983d267 [118/186] KVM: x86/tdp_mmu: Propagate building mirror page tables
config: x86_64-randconfig-123-20241101 (https://download.01.org/0day-ci/archive/20241101/202411011026.TPHQXlbi-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241101/202411011026.TPHQXlbi-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411011026.TPHQXlbi-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> arch/x86/kvm/mmu/tdp_mmu.c:474:14: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile *v @@     got unsigned long long [noderef] [usertype] __rcu *__ai_ptr @@
   arch/x86/kvm/mmu/tdp_mmu.c:474:14: sparse:     expected void const volatile *v
   arch/x86/kvm/mmu/tdp_mmu.c:474:14: sparse:     got unsigned long long [noderef] [usertype] __rcu *__ai_ptr
>> arch/x86/kvm/mmu/tdp_mmu.c:474:14: sparse: sparse: cast removes address space '__rcu' of expression
>> arch/x86/kvm/mmu/tdp_mmu.c:474:14: sparse: sparse: cast removes address space '__rcu' of expression
>> arch/x86/kvm/mmu/tdp_mmu.c:474:14: sparse: sparse: cast removes address space '__rcu' of expression
>> arch/x86/kvm/mmu/tdp_mmu.c:474:14: sparse: sparse: cast removes address space '__rcu' of expression
>> arch/x86/kvm/mmu/tdp_mmu.c:746:29: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected unsigned long long [usertype] *sptep @@     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep @@
   arch/x86/kvm/mmu/tdp_mmu.c:746:29: sparse:     expected unsigned long long [usertype] *sptep
   arch/x86/kvm/mmu/tdp_mmu.c:746:29: sparse:     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep
   arch/x86/kvm/mmu/tdp_mmu.c:1241:25: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected unsigned long long [usertype] *sptep @@     got unsigned long long [noderef] [usertype] __rcu *[addressable] [usertype] sptep @@
   arch/x86/kvm/mmu/tdp_mmu.c:1241:25: sparse:     expected unsigned long long [usertype] *sptep
   arch/x86/kvm/mmu/tdp_mmu.c:1241:25: sparse:     got unsigned long long [noderef] [usertype] __rcu *[addressable] [usertype] sptep
>> arch/x86/kvm/mmu/tdp_mmu.c:474:14: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/tdp_mmu.c:474:14: sparse: sparse: dereference of noderef expression
   arch/x86/kvm/mmu/tdp_mmu.c:610:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected unsigned long long [usertype] *sptep @@     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep @@
   arch/x86/kvm/mmu/tdp_mmu.c:610:33: sparse:     expected unsigned long long [usertype] *sptep
   arch/x86/kvm/mmu/tdp_mmu.c:610:33: sparse:     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep
   arch/x86/kvm/mmu/tdp_mmu.c: note: in included file (through include/linux/rbtree.h, include/linux/mm_types.h, include/linux/mmzone.h, ...):
   include/linux/rcupdate.h:880:25: sparse: sparse: context imbalance in '__tdp_mmu_zap_root' - unexpected unlock
   arch/x86/kvm/mmu/tdp_mmu.c:610:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected unsigned long long [usertype] *sptep @@     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep @@
   arch/x86/kvm/mmu/tdp_mmu.c:610:33: sparse:     expected unsigned long long [usertype] *sptep
   arch/x86/kvm/mmu/tdp_mmu.c:610:33: sparse:     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep
   arch/x86/kvm/mmu/tdp_mmu.c:610:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected unsigned long long [usertype] *sptep @@     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep @@
   arch/x86/kvm/mmu/tdp_mmu.c:610:33: sparse:     expected unsigned long long [usertype] *sptep
   arch/x86/kvm/mmu/tdp_mmu.c:610:33: sparse:     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep
   arch/x86/kvm/mmu/tdp_mmu.c:610:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected unsigned long long [usertype] *sptep @@     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep @@
   arch/x86/kvm/mmu/tdp_mmu.c:610:33: sparse:     expected unsigned long long [usertype] *sptep
   arch/x86/kvm/mmu/tdp_mmu.c:610:33: sparse:     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep
   arch/x86/kvm/mmu/tdp_mmu.c:1524:33: sparse: sparse: context imbalance in 'tdp_mmu_split_huge_pages_root' - unexpected unlock
   arch/x86/kvm/mmu/tdp_mmu.c:610:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected unsigned long long [usertype] *sptep @@     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep @@
   arch/x86/kvm/mmu/tdp_mmu.c:610:33: sparse:     expected unsigned long long [usertype] *sptep
   arch/x86/kvm/mmu/tdp_mmu.c:610:33: sparse:     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep
   arch/x86/kvm/mmu/tdp_mmu.c:610:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected unsigned long long [usertype] *sptep @@     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep @@
   arch/x86/kvm/mmu/tdp_mmu.c:610:33: sparse:     expected unsigned long long [usertype] *sptep
   arch/x86/kvm/mmu/tdp_mmu.c:610:33: sparse:     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep

vim +474 arch/x86/kvm/mmu/tdp_mmu.c

   455	
   456	static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sptep,
   457							 gfn_t gfn, u64 old_spte,
   458							 u64 new_spte, int level)
   459	{
   460		bool was_present = is_shadow_present_pte(old_spte);
   461		bool is_present = is_shadow_present_pte(new_spte);
   462		bool is_leaf = is_present && is_last_spte(new_spte, level);
   463		kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
   464		int ret = 0;
   465	
   466		KVM_BUG_ON(was_present, kvm);
   467	
   468		lockdep_assert_held(&kvm->mmu_lock);
   469		/*
   470		 * We need to lock out other updates to the SPTE until the external
   471		 * page table has been modified. Use FROZEN_SPTE similar to
   472		 * the zapping case.
   473		 */
 > 474		if (!try_cmpxchg64(sptep, &old_spte, FROZEN_SPTE))
   475			return -EBUSY;
   476	
   477		/*
   478		 * Use different call to either set up middle level
   479		 * external page table, or leaf.
   480		 */
   481		if (is_leaf) {
   482			ret = static_call(kvm_x86_set_external_spte)(kvm, gfn, level, new_pfn);
   483		} else {
   484			void *external_spt = get_external_spt(gfn, new_spte, level);
   485	
   486			KVM_BUG_ON(!external_spt, kvm);
   487			ret = static_call(kvm_x86_link_external_spt)(kvm, gfn, level, external_spt);
   488		}
   489		if (ret)
   490			__kvm_tdp_mmu_write_spte(sptep, old_spte);
   491		else
   492			__kvm_tdp_mmu_write_spte(sptep, new_spte);
   493		return ret;
   494	}
   495	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

