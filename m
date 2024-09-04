Return-Path: <kvm+bounces-25840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93B8596B6EE
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 11:38:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 446F7282CCA
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 09:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 948421CEEBF;
	Wed,  4 Sep 2024 09:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U1BovLor"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB66136657;
	Wed,  4 Sep 2024 09:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725442632; cv=none; b=svgXhWYWDnHpJ/LyefpYRgp2CS5etoVbjfNAg9WpeMcIeJJMVa4AsIpddf1ryg4HYMvZehtRY4F6oXtJgceGM7RSGVbBl4ZQ+w22ll1t2K2kuuPDc/k+SZAY9eGJpvUE1lr7+SG+BnbfrB1G7U48fWDFB5c1Ut6Wgqt2/ylOlVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725442632; c=relaxed/simple;
	bh=MRI42CKgJTs+ilD0WptG4fiGcysSWtMrf69iJuwhEW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n1p6rk5L+J3UzKMKygiyph4+qzwipXztkGbgDZ/lvdcexrFfxFpthHC2Ooqh2v3ulFy6N5MSGUcT9ZSfeMjWE01hJfD/SKB1oW4wKtuA0zV514ME/GJdr6oaPpg58EZFJAJVgx9GVG+VzB+ZqwJWC43QSeKMWRtFOCTJc9imAxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U1BovLor; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725442631; x=1756978631;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MRI42CKgJTs+ilD0WptG4fiGcysSWtMrf69iJuwhEW8=;
  b=U1BovLorYNAIlxHWaPzbEfioLw5zo+znoeGcSh0YniNV5l5mkWxtrICv
   IIWkQrC8M0LMI/5KVbO1sTwFiceQXg5kNV4ViWflMvuen1jHDuUyY8nQn
   MCi3yu4OcB3vWptPfGcW7KeXD9vMWdhXIGfqPyS/5tcceUzQQQ7rK3hwP
   nn5IPvvc8goul+W2126nShqW169pLDslrO4nWDJhzPyx6v/Adp7jQsUTb
   qA0HO3VQ+07TjVB2hbBQm5bf9ZckPqiIQXfy/4uvrcOp45vXCiF0b87qD
   uSYcSxmqxgn8pL6zwvG5/quw+rVT4mhpssD59Pt8lKSrdMNJsi8gqfQVl
   Q==;
X-CSE-ConnectionGUID: M6MZf/eORK6kNyDbLklvPw==
X-CSE-MsgGUID: ZxZI8hi9SfWalFF2KBEZ+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="24282250"
X-IronPort-AV: E=Sophos;i="6.10,201,1719903600"; 
   d="scan'208";a="24282250"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2024 02:37:10 -0700
X-CSE-ConnectionGUID: d0r+BYN8SpGJOZjq18N87w==
X-CSE-MsgGUID: vdCyl8MJT2OrIqkJ7EljEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,201,1719903600"; 
   d="scan'208";a="70076393"
Received: from lkp-server01.sh.intel.com (HELO 9c6b1c7d3b50) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 04 Sep 2024 02:37:07 -0700
Received: from kbuild by 9c6b1c7d3b50 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1slmRk-0007oi-1D;
	Wed, 04 Sep 2024 09:37:04 +0000
Date: Wed, 4 Sep 2024 17:36:31 +0800
From: kernel test robot <lkp@intel.com>
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
	pbonzini@redhat.com, dave.hansen@linux.intel.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, hpa@zytor.com,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	thomas.lendacky@amd.com, michael.roth@amd.com,
	kexec@lists.infradead.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH v2] x86/sev: Fix host kdump support for SNP
Message-ID: <202409041737.FSl6a7vH-lkp@intel.com>
References: <20240903191033.28365-1-Ashish.Kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240903191033.28365-1-Ashish.Kalra@amd.com>

Hi Ashish,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on linus/master v6.11-rc6 next-20240904]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ashish-Kalra/x86-sev-Fix-host-kdump-support-for-SNP/20240904-031215
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20240903191033.28365-1-Ashish.Kalra%40amd.com
patch subject: [PATCH v2] x86/sev: Fix host kdump support for SNP
config: x86_64-randconfig-r073-20240904 (https://download.01.org/0day-ci/archive/20240904/202409041737.FSl6a7vH-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240904/202409041737.FSl6a7vH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409041737.FSl6a7vH-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/x86/kvm/kvm-asm-offsets.c:11:
>> arch/x86/kvm/svm/svm.h:783:13: warning: 'sev_emergency_disable' defined but not used [-Wunused-function]
     783 | static void sev_emergency_disable(void) {}
         |             ^~~~~~~~~~~~~~~~~~~~~


vim +/sev_emergency_disable +783 arch/x86/kvm/svm/svm.h

   763	
   764	static inline void sev_free_vcpu(struct kvm_vcpu *vcpu) {}
   765	static inline void sev_vm_destroy(struct kvm *kvm) {}
   766	static inline void __init sev_set_cpu_caps(void) {}
   767	static inline void __init sev_hardware_setup(void) {}
   768	static inline void sev_hardware_unsetup(void) {}
   769	static inline int sev_cpu_init(struct svm_cpu_data *sd) { return 0; }
   770	static inline int sev_dev_get_attr(u32 group, u64 attr, u64 *val) { return -ENXIO; }
   771	#define max_sev_asid 0
   772	static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code) {}
   773	static inline void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu) {}
   774	static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
   775	{
   776		return 0;
   777	}
   778	static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
   779	static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
   780	{
   781		return 0;
   782	}
 > 783	static void sev_emergency_disable(void) {}
   784	#endif
   785	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

