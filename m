Return-Path: <kvm+bounces-28676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 21C1799B201
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 10:10:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 992331F2222F
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 08:10:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E864145A18;
	Sat, 12 Oct 2024 08:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QofDKWNq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1826F142900
	for <kvm@vger.kernel.org>; Sat, 12 Oct 2024 08:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728720605; cv=none; b=cl4osO9gy5rC6Yx0LzJ1H5cl1ai1RKfXh961psZvfuKI769KHu8+7h7BpO/h1Ldm/C+3EQ6t4Hhww5BzDZ7Sr7AHk9Rg9MAUOmNnIOVM72+3Eh5pbn6ei46HiWwWzbHOs5WooFS89TZYiz8P5idv+oG9eZ/0l3TVG4MhLMuIhdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728720605; c=relaxed/simple;
	bh=IRFRClIYONgdiEOMKeSINr0GwJJTjPi8PBGY44mZ92Y=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ePHnUxIpskj8OcDXwc0eb+Cb6MlGgGjQaQWou10dPYzMAqe7B4z0VtZ6aoIjNIvdAk6mNv7vK8p67sediNGr1bZUjEz5Ya/ut+GS7NMSIpjaVamsTp6RR7R+hyhMxcC48RcASapbar+MF5Nn6DYrIvVhYKia+lFR+R/zjlLcjq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QofDKWNq; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728720604; x=1760256604;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=IRFRClIYONgdiEOMKeSINr0GwJJTjPi8PBGY44mZ92Y=;
  b=QofDKWNqRT3keB8aXlE7xs6PM4gxwACA2/5OFnevTfWwZNOLtBI96fKM
   WdQSZqq5lmyCdSRK7ISAS0PJWbPeUvjccoDY1jtas17n/Kq3+XMROxc56
   pCNY5BUlPmtg0qZe7b86iZ84ppojEeQVqRsZneGCi3FgZM+WN97HIIV1D
   +78tf4ED0geTRQwd6+rGYb2xgLoWJRFH2EZJLqBDhP8xbd9W72Kcqh1ns
   VBQPMam/LxRq4u4BXbW2076SbvOSKf8RV9JlgGu9VCmuk2KyWqg1N0baZ
   8qhCUFiqK654UQXudsAQRqq8AEpeg9TZvusXJRu7LnFojLoR79R5qdfBJ
   w==;
X-CSE-ConnectionGUID: e+u5I1m7Rgmd7P48ctJztQ==
X-CSE-MsgGUID: 0RngIK3bR5Glb28aGQeKSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31001632"
X-IronPort-AV: E=Sophos;i="6.11,198,1725346800"; 
   d="scan'208";a="31001632"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2024 01:10:04 -0700
X-CSE-ConnectionGUID: VZElFrpkQ8irvAlqFCqruw==
X-CSE-MsgGUID: sUd1gg0WSpenQmblxe0jBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,198,1725346800"; 
   d="scan'208";a="81671048"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 12 Oct 2024 01:09:57 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1szXCE-000DBn-38;
	Sat, 12 Oct 2024 08:09:54 +0000
Date: Sat, 12 Oct 2024 16:09:22 +0800
From: kernel test robot <lkp@intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Robert Hu <robert.hu@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Danmei Wei <danmei.wei@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Kai Huang <kai.huang@intel.com>, Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [kvm:kvm-coco-queue 62/109] arch/x86/kvm/mmu/tdp_mmu.c:474:14:
 sparse: sparse: incorrect type in argument 1 (different address spaces)
Message-ID: <202410121644.Eq7zRGPO-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-coco-queue
head:   d2c7662a6ea1c325a9ae878b3f1a265264bcd18b
commit: b6bcd88ad43aebc2385c7ff418b0532e80e60e19 [62/109] KVM: x86/tdp_mmu: Propagate building mirror page tables
config: x86_64-randconfig-121-20241011 (https://download.01.org/0day-ci/archive/20241012/202410121644.Eq7zRGPO-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241012/202410121644.Eq7zRGPO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410121644.Eq7zRGPO-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> arch/x86/kvm/mmu/tdp_mmu.c:474:14: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile *v @@     got unsigned long long [noderef] [usertype] __rcu *__ai_ptr @@
   arch/x86/kvm/mmu/tdp_mmu.c:474:14: sparse:     expected void const volatile *v
   arch/x86/kvm/mmu/tdp_mmu.c:474:14: sparse:     got unsigned long long [noderef] [usertype] __rcu *__ai_ptr
>> arch/x86/kvm/mmu/tdp_mmu.c:474:14: sparse: sparse: cast removes address space '__rcu' of expression
>> arch/x86/kvm/mmu/tdp_mmu.c:474:14: sparse: sparse: cast removes address space '__rcu' of expression
>> arch/x86/kvm/mmu/tdp_mmu.c:474:14: sparse: sparse: cast removes address space '__rcu' of expression
>> arch/x86/kvm/mmu/tdp_mmu.c:474:14: sparse: sparse: cast removes address space '__rcu' of expression
>> arch/x86/kvm/mmu/tdp_mmu.c:754:29: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected unsigned long long [usertype] *sptep @@     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep @@
   arch/x86/kvm/mmu/tdp_mmu.c:754:29: sparse:     expected unsigned long long [usertype] *sptep
   arch/x86/kvm/mmu/tdp_mmu.c:754:29: sparse:     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep
   arch/x86/kvm/mmu/tdp_mmu.c:1246:25: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected unsigned long long [usertype] *sptep @@     got unsigned long long [noderef] [usertype] __rcu *[addressable] [usertype] sptep @@
   arch/x86/kvm/mmu/tdp_mmu.c:1246:25: sparse:     expected unsigned long long [usertype] *sptep
   arch/x86/kvm/mmu/tdp_mmu.c:1246:25: sparse:     got unsigned long long [noderef] [usertype] __rcu *[addressable] [usertype] sptep
>> arch/x86/kvm/mmu/tdp_mmu.c:474:14: sparse: sparse: dereference of noderef expression
>> arch/x86/kvm/mmu/tdp_mmu.c:474:14: sparse: sparse: dereference of noderef expression
   arch/x86/kvm/mmu/tdp_mmu.c:618:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected unsigned long long [usertype] *sptep @@     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep @@
   arch/x86/kvm/mmu/tdp_mmu.c:618:33: sparse:     expected unsigned long long [usertype] *sptep
   arch/x86/kvm/mmu/tdp_mmu.c:618:33: sparse:     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep
   arch/x86/kvm/mmu/tdp_mmu.c: note: in included file (through include/linux/rbtree.h, include/linux/mm_types.h, include/linux/mmzone.h, ...):
   include/linux/rcupdate.h:869:25: sparse: sparse: context imbalance in '__tdp_mmu_zap_root' - unexpected unlock
   arch/x86/kvm/mmu/tdp_mmu.c:618:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected unsigned long long [usertype] *sptep @@     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep @@
   arch/x86/kvm/mmu/tdp_mmu.c:618:33: sparse:     expected unsigned long long [usertype] *sptep
   arch/x86/kvm/mmu/tdp_mmu.c:618:33: sparse:     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep
   arch/x86/kvm/mmu/tdp_mmu.c:618:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected unsigned long long [usertype] *sptep @@     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep @@
   arch/x86/kvm/mmu/tdp_mmu.c:618:33: sparse:     expected unsigned long long [usertype] *sptep
   arch/x86/kvm/mmu/tdp_mmu.c:618:33: sparse:     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep
   arch/x86/kvm/mmu/tdp_mmu.c:618:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected unsigned long long [usertype] *sptep @@     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep @@
   arch/x86/kvm/mmu/tdp_mmu.c:618:33: sparse:     expected unsigned long long [usertype] *sptep
   arch/x86/kvm/mmu/tdp_mmu.c:618:33: sparse:     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep
   arch/x86/kvm/mmu/tdp_mmu.c:1536:33: sparse: sparse: context imbalance in 'tdp_mmu_split_huge_pages_root' - unexpected unlock
   arch/x86/kvm/mmu/tdp_mmu.c:618:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected unsigned long long [usertype] *sptep @@     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep @@
   arch/x86/kvm/mmu/tdp_mmu.c:618:33: sparse:     expected unsigned long long [usertype] *sptep
   arch/x86/kvm/mmu/tdp_mmu.c:618:33: sparse:     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep
   arch/x86/kvm/mmu/tdp_mmu.c:618:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected unsigned long long [usertype] *sptep @@     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep @@
   arch/x86/kvm/mmu/tdp_mmu.c:618:33: sparse:     expected unsigned long long [usertype] *sptep
   arch/x86/kvm/mmu/tdp_mmu.c:618:33: sparse:     got unsigned long long [noderef] [usertype] __rcu *[usertype] sptep

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

