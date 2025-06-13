Return-Path: <kvm+bounces-49548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E0E03AD98CA
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 01:52:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FF271722F7
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 23:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1662328ECE3;
	Fri, 13 Jun 2025 23:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f9r1nWtR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3C9226D18
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 23:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749858756; cv=none; b=cu560zA7UYOMCocuz2MrVlpnjUAl+QdXEJGQuvY9XcP/z1JnktdsnFqK6O16Um8aCeMxzIihpYo8f0o6ImHklZKm41/WIX+mXhQQHpkChFOnwnMLq7GU62KrIiO9EuSNlo9CcvkbWPFbOwpW7xQdaqHoVVOJiXX2gaA1S1WwmyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749858756; c=relaxed/simple;
	bh=OWvPD1dU5IDAtkf7IDNh5cbjqWSHEExPWJK4KF5Wdzc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=C5Bym7Vgvc9+s8kTYnH9uXzJs68AwUFfce5GFY7q1ONhf4KkJm+kDfx98MDnziW0CGEBJynUXGoqnNLYv48BnFsS1WaUzHsS/gxAI5uoHetl1Bkdi6kdUB9yPdZvW7ryFOkgnkDXmgRy18ELd8zgfbEwPtdBa8m3ujGDxn3x86E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f9r1nWtR; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749858753; x=1781394753;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=OWvPD1dU5IDAtkf7IDNh5cbjqWSHEExPWJK4KF5Wdzc=;
  b=f9r1nWtR4i4e3oAprf63P+fZaRq5J3/YlJgzGCw5lV5/hqZw91GRkArE
   DWWXIZlEqkE+9qep5ivqPh75YDHMIf6t50s2zezugMuIzyFs6oC4zmiha
   94F3ehEbuSJNIW9AcBNrGiuUzrd5mvDAbyESyXbCf2OPpCPj+3A3oEInq
   ev/OF7XZjxs6BPmcxdBPShfIabHRyPvM+VKp6sYrz3ecJT9fOX7wtA2Wb
   /UkUausOx1MVJkZpXcWYValuNixePEPqkk0HTWjqSctmHFe51Dp90fpso
   n9JNv3kXNR/YmEafAbjkuMs+vk9Ahs/H3oEAroHYc1BdetSE2rid1wV9+
   w==;
X-CSE-ConnectionGUID: /tIIHu75QqiLREFAAu7Sug==
X-CSE-MsgGUID: wTCk1IDnQMGrw9Fczs5E+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11463"; a="51800768"
X-IronPort-AV: E=Sophos;i="6.16,235,1744095600"; 
   d="scan'208";a="51800768"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 16:52:33 -0700
X-CSE-ConnectionGUID: a4TULeShSUeQ5ietSM4G3g==
X-CSE-MsgGUID: mUSpDBIjTnmdE6++JpLItw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,235,1744095600"; 
   d="scan'208";a="171146347"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 13 Jun 2025 16:52:31 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uQECC-000D66-1j;
	Fri, 13 Jun 2025 23:52:28 +0000
Date: Sat, 14 Jun 2025 07:52:24 +0800
From: kernel test robot <lkp@intel.com>
To: Fuad Tabba <tabba@google.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Farrah Chen <farrah.chen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>,
	Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>
Subject: [kvm:queue 14/30] arch/x86/kvm/vmx/tdx.c:3167:28: error: implicit
 declaration of function 'kvm_gmem_populate'; did you mean
 'vmemmap_populate'?
Message-ID: <202506140732.sMHshe1f-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Fuad,

FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   79150772457f4d45e38b842d786240c36bb1f97f
commit: ec772b9375ae2bb6b4bd0442c0b396f9f5440882 [14/30] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
config: x86_64-buildonly-randconfig-003-20250614 (https://download.01.org/0day-ci/archive/20250614/202506140732.sMHshe1f-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250614/202506140732.sMHshe1f-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506140732.sMHshe1f-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kvm/vmx/tdx.c: In function 'tdx_vcpu_init_mem_region':
>> arch/x86/kvm/vmx/tdx.c:3167:28: error: implicit declaration of function 'kvm_gmem_populate'; did you mean 'vmemmap_populate'? [-Werror=implicit-function-declaration]
    3167 |                 gmem_ret = kvm_gmem_populate(kvm, gpa_to_gfn(region.gpa),
         |                            ^~~~~~~~~~~~~~~~~
         |                            vmemmap_populate
   cc1: some warnings being treated as errors


vim +3167 arch/x86/kvm/vmx/tdx.c

c846b451d3c5d4b Isaku Yamahata 2024-11-12  3122  
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3123  static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3124  {
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3125  	struct vcpu_tdx *tdx = to_tdx(vcpu);
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3126  	struct kvm *kvm = vcpu->kvm;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3127  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3128  	struct kvm_tdx_init_mem_region region;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3129  	struct tdx_gmem_post_populate_arg arg;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3130  	long gmem_ret;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3131  	int ret;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3132  
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3133  	if (tdx->state != VCPU_TD_STATE_INITIALIZED)
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3134  		return -EINVAL;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3135  
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3136  	guard(mutex)(&kvm->slots_lock);
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3137  
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3138  	/* Once TD is finalized, the initial guest memory is fixed. */
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3139  	if (kvm_tdx->state == TD_STATE_RUNNABLE)
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3140  		return -EINVAL;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3141  
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3142  	if (cmd->flags & ~KVM_TDX_MEASURE_MEMORY_REGION)
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3143  		return -EINVAL;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3144  
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3145  	if (copy_from_user(&region, u64_to_user_ptr(cmd->data), sizeof(region)))
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3146  		return -EFAULT;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3147  
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3148  	if (!PAGE_ALIGNED(region.source_addr) || !PAGE_ALIGNED(region.gpa) ||
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3149  	    !region.nr_pages ||
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3150  	    region.gpa + (region.nr_pages << PAGE_SHIFT) <= region.gpa ||
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3151  	    !vt_is_tdx_private_gpa(kvm, region.gpa) ||
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3152  	    !vt_is_tdx_private_gpa(kvm, region.gpa + (region.nr_pages << PAGE_SHIFT) - 1))
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3153  		return -EINVAL;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3154  
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3155  	kvm_mmu_reload(vcpu);
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3156  	ret = 0;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3157  	while (region.nr_pages) {
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3158  		if (signal_pending(current)) {
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3159  			ret = -EINTR;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3160  			break;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3161  		}
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3162  
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3163  		arg = (struct tdx_gmem_post_populate_arg) {
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3164  			.vcpu = vcpu,
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3165  			.flags = cmd->flags,
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3166  		};
c846b451d3c5d4b Isaku Yamahata 2024-11-12 @3167  		gmem_ret = kvm_gmem_populate(kvm, gpa_to_gfn(region.gpa),
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3168  					     u64_to_user_ptr(region.source_addr),
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3169  					     1, tdx_gmem_post_populate, &arg);
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3170  		if (gmem_ret < 0) {
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3171  			ret = gmem_ret;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3172  			break;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3173  		}
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3174  
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3175  		if (gmem_ret != 1) {
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3176  			ret = -EIO;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3177  			break;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3178  		}
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3179  
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3180  		region.source_addr += PAGE_SIZE;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3181  		region.gpa += PAGE_SIZE;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3182  		region.nr_pages--;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3183  
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3184  		cond_resched();
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3185  	}
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3186  
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3187  	if (copy_to_user(u64_to_user_ptr(cmd->data), &region, sizeof(region)))
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3188  		ret = -EFAULT;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3189  	return ret;
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3190  }
c846b451d3c5d4b Isaku Yamahata 2024-11-12  3191  

:::::: The code at line 3167 was first introduced by commit
:::::: c846b451d3c5d4ba304bbeeaf7aa9a04bb432408 KVM: TDX: Add an ioctl to create initial guest memory

:::::: TO: Isaku Yamahata <isaku.yamahata@intel.com>
:::::: CC: Paolo Bonzini <pbonzini@redhat.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

