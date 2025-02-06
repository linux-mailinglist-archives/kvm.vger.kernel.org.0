Return-Path: <kvm+bounces-37541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96EF9A2B68B
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 00:28:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBD303A6583
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 23:28:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FD0823AE67;
	Thu,  6 Feb 2025 23:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="avcge3l/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9A723908D;
	Thu,  6 Feb 2025 23:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738884514; cv=none; b=Lu6Fm3LBw/9Qn41imdnoyWalWKarEPN0Rk6vN/QZyYPrPPML5IqkrsWshUVAZsJKOBF0fI+mpVy1WhXtPmdnhYWJ3jo0N9WV37ngaXAVNFFgTltTBShLOwmKy3CkiBgRD7pwpRGR+mvN26aVKfjhPMqgPN1AVgkMzMUGnBpt85Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738884514; c=relaxed/simple;
	bh=IqCJRbnd/ake/rfsaywutu7ZEKHtAxX14+3WiTsN3po=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ql1eKzSSpnYGL+B+hO8l6mpF8NcBi9JX5FxouiqyQHdyb9WF+20X3XZ9YDXAY+bBFO+0tYWyB1jXLmVFW1C4OBwjFUO1AwYeoR9HWpwWjlrbJsVC/T1kRAPnlql3NvcWXm6HiR+yfQPjnsvjQYo2hwyFuv5nfxFsXeOMtcgGhUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=avcge3l/; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738884512; x=1770420512;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IqCJRbnd/ake/rfsaywutu7ZEKHtAxX14+3WiTsN3po=;
  b=avcge3l/RdLBZXWQyfN30RQ1r+GR1kTEZVPesmxCqx3nFctzfzzH0A7u
   H6a3kzt/uYiWUOV+jaxOq+/0Vsnkg7ON1MLPhtlim92pOsso83hdZaiqy
   Ahv1F5ZZ63Se3E4eKWkJVkYA8AnQZEncxwnmLs3WGKS91b24lzHUdPISI
   24CW8LAdJfEfUClNE+aXsDB9yP0g8vmNAP0qvbLSND/cJEEq/RvRL3DDF
   ZL2L3dpc5j/08JGeFhMFxbVVPMR7+Q450qtoit5MGQlwZzAWCmaAGmEkI
   nigONFSN0QreRuM71pmXgYOL4wT3z1cl8jje/BomrG9NzJF+m1IaWmFl9
   w==;
X-CSE-ConnectionGUID: S/FHRYUdSqubGwAej3zOIA==
X-CSE-MsgGUID: y7Nq7/BZRVa8SdPkbs2sog==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="39646303"
X-IronPort-AV: E=Sophos;i="6.13,265,1732608000"; 
   d="scan'208";a="39646303"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 15:28:32 -0800
X-CSE-ConnectionGUID: 0cmOU3WWQ066b+PBqxIT4w==
X-CSE-MsgGUID: d3vf7E8eTA28v3i/7CNOvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,265,1732608000"; 
   d="scan'208";a="116395562"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 06 Feb 2025 15:28:28 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tgBII-000xVn-1R;
	Thu, 06 Feb 2025 23:28:26 +0000
Date: Fri, 7 Feb 2025 07:27:30 +0800
From: kernel test robot <lkp@intel.com>
To: Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, Colton Lewis <coltonlewis@google.com>
Subject: Re: [PATCH v2] KVM: arm64: Remove cyclical dependency in arm_pmuv3.h
Message-ID: <202502070744.hqS7ZVVX-lkp@intel.com>
References: <20250206001744.3155465-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206001744.3155465-1-coltonlewis@google.com>

Hi Colton,

kernel test robot noticed the following build errors:

[auto build test ERROR on 2014c95afecee3e76ca4a56956a936e23283f05b]

url:    https://github.com/intel-lab-lkp/linux/commits/Colton-Lewis/KVM-arm64-Remove-cyclical-dependency-in-arm_pmuv3-h/20250206-082034
base:   2014c95afecee3e76ca4a56956a936e23283f05b
patch link:    https://lore.kernel.org/r/20250206001744.3155465-1-coltonlewis%40google.com
patch subject: [PATCH v2] KVM: arm64: Remove cyclical dependency in arm_pmuv3.h
config: arm64-allnoconfig (https://download.01.org/0day-ci/archive/20250207/202502070744.hqS7ZVVX-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250207/202502070744.hqS7ZVVX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502070744.hqS7ZVVX-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/arm64/include/asm/kvm_host.h:38,
                    from include/linux/kvm_host.h:45,
                    from arch/arm64/kernel/asm-offsets.c:15:
>> include/kvm/arm_pmu.h:177:20: error: static declaration of 'kvm_vcpu_pmu_resync_el0' follows non-static declaration
     177 | static inline void kvm_vcpu_pmu_resync_el0(void) {}
         |                    ^~~~~~~~~~~~~~~~~~~~~~~
   In file included from arch/arm64/include/asm/arm_pmuv3.h:10,
                    from include/linux/perf/arm_pmuv3.h:316,
                    from include/kvm/arm_pmu.h:11:
   arch/arm64/include/asm/kvm_pmu.h:6:6: note: previous declaration of 'kvm_vcpu_pmu_resync_el0' with type 'void(void)'
       6 | void kvm_vcpu_pmu_resync_el0(void);
         |      ^~~~~~~~~~~~~~~~~~~~~~~
   make[3]: *** [scripts/Makefile.build:102: arch/arm64/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1264: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:251: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:251: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +/kvm_vcpu_pmu_resync_el0 +177 include/kvm/arm_pmu.h

5421db1be3b11c5 Marc Zyngier           2021-04-14  163  
20492a62b99bd43 Marc Zyngier           2022-05-16  164  #define kvm_vcpu_has_pmu(vcpu)		({ false; })
20492a62b99bd43 Marc Zyngier           2022-05-16  165  static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
20492a62b99bd43 Marc Zyngier           2022-05-16  166  static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
20492a62b99bd43 Marc Zyngier           2022-05-16  167  static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
27131b199f9fdc0 Raghavendra Rao Ananta 2023-10-20  168  static inline void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu) {}
3d0dba5764b9430 Marc Zyngier           2022-11-13  169  static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
3d0dba5764b9430 Marc Zyngier           2022-11-13  170  {
3d0dba5764b9430 Marc Zyngier           2022-11-13  171  	return 0;
3d0dba5764b9430 Marc Zyngier           2022-11-13  172  }
bc512d6a9b92390 Oliver Upton           2023-10-19  173  static inline u64 kvm_pmu_evtyper_mask(struct kvm *kvm)
bc512d6a9b92390 Oliver Upton           2023-10-19  174  {
bc512d6a9b92390 Oliver Upton           2023-10-19  175  	return 0;
bc512d6a9b92390 Oliver Upton           2023-10-19  176  }
b1f778a223a2a8a Marc Zyngier           2023-08-20 @177  static inline void kvm_vcpu_pmu_resync_el0(void) {}
20492a62b99bd43 Marc Zyngier           2022-05-16  178  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

