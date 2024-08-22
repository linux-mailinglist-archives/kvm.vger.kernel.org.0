Return-Path: <kvm+bounces-24821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAC9D95B81C
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 16:15:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 836EC286DFB
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 14:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D40021CBE94;
	Thu, 22 Aug 2024 14:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TevxDDKJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D7C1C93DF;
	Thu, 22 Aug 2024 14:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724336120; cv=none; b=Wwst54UiBhJXAV4+2byb554n6T5js0Wlyd8HBpslnKMTxN6YhyRrELkgHs9g3tEMIGs3+68zDEZg+OtGRVby/yDyvikEL6V4sRU1QY6eG4T1WvAO+KbPKzoIuqg/fhfdzOmn54NUkrdxw9RC4FFOuhBwctyZJB04QoT08YXredE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724336120; c=relaxed/simple;
	bh=N0UsVQc1quPucMHanRFreY+o7eT0pQqsYArCHU/T7LU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hdfIXA9r7E3xV02oq2OU/DLhl0nqlpsFnT6wNApxa1L2MfiZFUEEqmuZenAHLEl7En8ga1qr5Kz8i4NEpiEuOjp7/z0dqSS2tq5eCIoZ7HpbGnNk7CkI9vXi/slkMBctKQjwDH2tjITKKkhHO0H/JCh48rhBH0xc0I2JANcmPVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TevxDDKJ; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724336118; x=1755872118;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N0UsVQc1quPucMHanRFreY+o7eT0pQqsYArCHU/T7LU=;
  b=TevxDDKJd6IOdjGt+nvwWMTw5a0I7ZHqvMxGMy/bOD7udeATqLBrWqab
   aROaz4vk/pS0xKSosBkdjFrlhjX5Xys973j+8j30TQN9BAwnLrdXX1jqG
   dlwc6EVM2meNStFS++Pri0br/4E4mFkrWQkmQMhStPZNJ1qyQ9guaa8wi
   wrS09Jp04BLdVITiyO/+1cdyV+2drsREReeCukCwKuT077pQalJWaaWIa
   kl0Am8yiel4yjbwAQbDkbfEz4HqILspXmBTJpDWfstpMpAvoiOedUOGUi
   7yGCL8Q3khz15uc7MJsJNWY2veFfsgboxQg5tPErP3YlDS5KrNy8MhfuM
   Q==;
X-CSE-ConnectionGUID: zFp3rmF0T0OfdnRV71Mp5Q==
X-CSE-MsgGUID: 4qUrexL3Rn+ce1d4E2E6+A==
X-IronPort-AV: E=McAfee;i="6700,10204,11172"; a="48146858"
X-IronPort-AV: E=Sophos;i="6.10,167,1719903600"; 
   d="scan'208";a="48146858"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2024 07:15:17 -0700
X-CSE-ConnectionGUID: dT51fZTvSqWFhZRqkA8Wdw==
X-CSE-MsgGUID: gLBrdYJoT2KS1cHWkU+wpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,167,1719903600"; 
   d="scan'208";a="62175288"
Received: from lkp-server01.sh.intel.com (HELO 9a732dc145d3) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 22 Aug 2024 07:15:12 -0700
Received: from kbuild by 9a732dc145d3 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sh8aj-000Cqv-2a;
	Thu, 22 Aug 2024 14:15:09 +0000
Date: Thu, 22 Aug 2024 22:14:25 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v4 18/43] arm64: RME: Handle realm enter/exit
Message-ID: <202408222119.6YF3UR6O-lkp@intel.com>
References: <20240821153844.60084-19-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821153844.60084-19-steven.price@arm.com>

Hi Steven,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvmarm/next]
[also build test WARNING on kvm/queue arm64/for-next/core linus/master v6.11-rc4 next-20240822]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Price/KVM-Prepare-for-handling-only-shared-mappings-in-mmu_notifier-events/20240821-235327
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
patch link:    https://lore.kernel.org/r/20240821153844.60084-19-steven.price%40arm.com
patch subject: [PATCH v4 18/43] arm64: RME: Handle realm enter/exit
config: arm64-allmodconfig (https://download.01.org/0day-ci/archive/20240822/202408222119.6YF3UR6O-lkp@intel.com/config)
compiler: clang version 20.0.0git (https://github.com/llvm/llvm-project 26670e7fa4f032a019d23d56c6a02926e854e8af)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240822/202408222119.6YF3UR6O-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408222119.6YF3UR6O-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/arm64/kvm/rme-exit.c:6:
   In file included from include/linux/kvm_host.h:16:
   In file included from include/linux/mm.h:2228:
   include/linux/vmstat.h:500:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     500 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     501 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:507:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     507 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     508 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:514:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     514 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   include/linux/vmstat.h:519:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     519 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     520 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:528:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     528 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     529 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/rme-exit.c:61:23: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
      61 |         [ESR_ELx_EC_SYS64]      = rec_exit_sys_reg,
         |                                   ^~~~~~~~~~~~~~~~
   arch/arm64/kvm/rme-exit.c:60:27: note: previous initialization is here
      60 |         [0 ... ESR_ELx_EC_MAX]  = rec_exit_reason_notimpl,
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/rme-exit.c:62:26: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
      62 |         [ESR_ELx_EC_DABT_LOW]   = rec_exit_sync_dabt,
         |                                   ^~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/rme-exit.c:60:27: note: previous initialization is here
      60 |         [0 ... ESR_ELx_EC_MAX]  = rec_exit_reason_notimpl,
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/rme-exit.c:63:26: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
      63 |         [ESR_ELx_EC_IABT_LOW]   = rec_exit_sync_iabt
         |                                   ^~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/rme-exit.c:60:27: note: previous initialization is here
      60 |         [0 ... ESR_ELx_EC_MAX]  = rec_exit_reason_notimpl,
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~
>> arch/arm64/kvm/rme-exit.c:94:6: warning: variable 'top_ipa' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
      94 |         if (realm_is_addr_protected(realm, base) &&
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      95 |             realm_is_addr_protected(realm, top - 1)) {
         |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/rme-exit.c:108:44: note: uninitialized use occurs here
     108 |         kvm_prepare_memory_fault_exit(vcpu, base, top_ipa - base, false, false,
         |                                                   ^~~~~~~
   arch/arm64/kvm/rme-exit.c:94:2: note: remove the 'if' if its condition is always true
      94 |         if (realm_is_addr_protected(realm, base) &&
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      95 |             realm_is_addr_protected(realm, top - 1)) {
         |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/arm64/kvm/rme-exit.c:94:6: warning: variable 'top_ipa' is used uninitialized whenever '&&' condition is false [-Wsometimes-uninitialized]
      94 |         if (realm_is_addr_protected(realm, base) &&
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/rme-exit.c:108:44: note: uninitialized use occurs here
     108 |         kvm_prepare_memory_fault_exit(vcpu, base, top_ipa - base, false, false,
         |                                                   ^~~~~~~
   arch/arm64/kvm/rme-exit.c:94:6: note: remove the '&&' if its condition is always true
      94 |         if (realm_is_addr_protected(realm, base) &&
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/rme-exit.c:91:23: note: initialize the variable 'top_ipa' to silence this warning
      91 |         unsigned long top_ipa;
         |                              ^
         |                               = 0
   10 warnings generated.


vim +94 arch/arm64/kvm/rme-exit.c

    58	
    59	static exit_handler_fn rec_exit_handlers[] = {
  > 60		[0 ... ESR_ELx_EC_MAX]	= rec_exit_reason_notimpl,
    61		[ESR_ELx_EC_SYS64]	= rec_exit_sys_reg,
    62		[ESR_ELx_EC_DABT_LOW]	= rec_exit_sync_dabt,
    63		[ESR_ELx_EC_IABT_LOW]	= rec_exit_sync_iabt
    64	};
    65	
    66	static int rec_exit_psci(struct kvm_vcpu *vcpu)
    67	{
    68		struct realm_rec *rec = &vcpu->arch.rec;
    69		int i;
    70		int ret;
    71	
    72		for (i = 0; i < REC_RUN_GPRS; i++)
    73			vcpu_set_reg(vcpu, i, rec->run->exit.gprs[i]);
    74	
    75		ret = kvm_smccc_call_handler(vcpu);
    76	
    77		for (i = 0; i < REC_RUN_GPRS; i++)
    78			rec->run->enter.gprs[i] = vcpu_get_reg(vcpu, i);
    79	
    80		return ret;
    81	}
    82	
    83	static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
    84	{
    85		struct kvm *kvm = vcpu->kvm;
    86		struct realm *realm = &kvm->arch.realm;
    87		struct realm_rec *rec = &vcpu->arch.rec;
    88		unsigned long base = rec->run->exit.ripas_base;
    89		unsigned long top = rec->run->exit.ripas_top;
    90		unsigned long ripas = rec->run->exit.ripas_value & 1;
    91		unsigned long top_ipa;
    92		int ret = -EINVAL;
    93	
  > 94		if (realm_is_addr_protected(realm, base) &&
    95		    realm_is_addr_protected(realm, top - 1)) {
    96			kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
    97						   kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
    98			write_lock(&kvm->mmu_lock);
    99			ret = realm_set_ipa_state(vcpu, base, top, ripas, &top_ipa);
   100			write_unlock(&kvm->mmu_lock);
   101		}
   102	
   103		WARN(ret && ret != -ENOMEM,
   104		     "Unable to satisfy SET_IPAS for %#lx - %#lx, ripas: %#lx\n",
   105		     base, top, ripas);
   106	
   107		/* Exit to VMM to complete the change */
 > 108		kvm_prepare_memory_fault_exit(vcpu, base, top_ipa - base, false, false,
   109					      ripas == 1);
   110	
   111		return 0;
   112	}
   113	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

