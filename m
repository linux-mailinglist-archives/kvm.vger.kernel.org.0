Return-Path: <kvm+bounces-65917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 62590CBA2A4
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 02:39:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1F579300C35B
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 01:39:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F660224AF7;
	Sat, 13 Dec 2025 01:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ULiMihQI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B001C15624B;
	Sat, 13 Dec 2025 01:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765589994; cv=none; b=Xr1pTgnsvp22RkB5PPxQ3EnT+GX5pvDGR8GQ4YFpS2IM/tacE42IqHLiRy6GRQQR4K5WCHiydvAvUmD3YtSfUpt2wImFsqztx6DXvFRVsJAUJAkew6lkyNH4TBgFGN3nXgWLvOzhLEiPirbjU2w5LoyuLMUcyg8Ykufhs679GZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765589994; c=relaxed/simple;
	bh=nWStk/iImD1snrjk7kIUEv29s9EmkkHk9IJxnr2ZSvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ukPNi9MokdwsLfuwDJNksH7FRKcSslQNAj0nUl2L1BIA1MVBpFOz70MJnbWEybZTgGINq1oFwy2sMLvV8mM97ZtpXQk+73+kYOL9xb7806VqdcBTWl26N2I8K3mgH6Q6PcUVcK78OTZSNy747TrlokeOsJrarEtpe6ZN/2Z+sW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ULiMihQI; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765589992; x=1797125992;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nWStk/iImD1snrjk7kIUEv29s9EmkkHk9IJxnr2ZSvg=;
  b=ULiMihQI1ONYh9izG5CYFAPPTkC38PAfOmOe5m5y8ddd4YDBn11fkGwW
   b4tzqtjhlaYKk9grLVTKAzbX2OIeYvviehRZrxFyQ8wigNEmre8wl1xlY
   IhCssW4RNCuTxPewdo9IZbH7gjS3NQPmAr2nZsBHqC7y5hcjZRZujI8QQ
   6xC2LiWOrIWj43FGX3ZD+qNpXSpAD6eMsly8K/6k82Nzh2qWN+C2JZeKK
   ffQjoqnc6ldgQmcOx6zm59MeeLIcBGHgjJPh4BUeL4+bVCx75uSkQkV2E
   oxwzXkvfzvupy1isVH/dn5b+2Tzkd+oB0sEIxREpwjTfL6ht2o+H2dYa1
   g==;
X-CSE-ConnectionGUID: r5iLGx9gQQaXpj65TBed4Q==
X-CSE-MsgGUID: eDFKov4cQrepTaqFiFAcnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11640"; a="85187716"
X-IronPort-AV: E=Sophos;i="6.21,145,1763452800"; 
   d="scan'208";a="85187716"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2025 17:39:50 -0800
X-CSE-ConnectionGUID: Ov68TNPZSY+c2vY3lTafwg==
X-CSE-MsgGUID: TL28awDAT8GChFRsYUMNlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,145,1763452800"; 
   d="scan'208";a="227888686"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 12 Dec 2025 17:39:47 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vUEbo-000000006tR-1QlY;
	Sat, 13 Dec 2025 01:39:44 +0000
Date: Sat, 13 Dec 2025 09:38:59 +0800
From: kernel test robot <lkp@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, xiaoyao.li@intel.com,
	farrah.chen@intel.com
Subject: Re: [PATCH v2] KVM: x86: Don't read guest CR3 when doing async pf
 while the MMU is direct
Message-ID: <202512130905.LJZI3LOt-lkp@intel.com>
References: <20251212135051.2155280-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251212135051.2155280-1-xiaoyao.li@intel.com>

Hi Xiaoyao,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 7d0a66e4bb9081d75c82ec4957c50034cb0ea449]

url:    https://github.com/intel-lab-lkp/linux/commits/Xiaoyao-Li/KVM-x86-Don-t-read-guest-CR3-when-doing-async-pf-while-the-MMU-is-direct/20251212-220612
base:   7d0a66e4bb9081d75c82ec4957c50034cb0ea449
patch link:    https://lore.kernel.org/r/20251212135051.2155280-1-xiaoyao.li%40intel.com
patch subject: [PATCH v2] KVM: x86: Don't read guest CR3 when doing async pf while the MMU is direct
config: i386-buildonly-randconfig-004-20251213 (https://download.01.org/0day-ci/archive/20251213/202512130905.LJZI3LOt-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251213/202512130905.LJZI3LOt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512130905.LJZI3LOt-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/mmu/mmu.c:4525:14: warning: implicit conversion from 'gpa_t' (aka 'unsigned long long') to 'unsigned long' changes value from 18446744073709551615 to 4294967295 [-Wconstant-conversion]
    4525 |                 arch.cr3 = INVALID_GPA;
         |                          ~ ^~~~~~~~~~~
   include/linux/kvm_types.h:54:22: note: expanded from macro 'INVALID_GPA'
      54 | #define INVALID_GPA     (~(gpa_t)0)
         |                          ^~~~~~~~~
   1 warning generated.

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for I2C_K1
   Depends on [n]: I2C [=m] && HAS_IOMEM [=y] && (ARCH_SPACEMIT || COMPILE_TEST [=y]) && OF [=n]
   Selected by [m]:
   - MFD_SPACEMIT_P1 [=m] && HAS_IOMEM [=y] && (ARCH_SPACEMIT || COMPILE_TEST [=y]) && I2C [=m]


vim +4525 arch/x86/kvm/mmu/mmu.c

  4514	
  4515	static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu,
  4516					    struct kvm_page_fault *fault)
  4517	{
  4518		struct kvm_arch_async_pf arch;
  4519	
  4520		arch.token = alloc_apf_token(vcpu);
  4521		arch.gfn = fault->gfn;
  4522		arch.error_code = fault->error_code;
  4523		arch.direct_map = vcpu->arch.mmu->root_role.direct;
  4524		if (arch.direct_map)
> 4525			arch.cr3 = INVALID_GPA;
  4526		else
  4527			arch.cr3 = kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
  4528	
  4529		return kvm_setup_async_pf(vcpu, fault->addr,
  4530					  kvm_vcpu_gfn_to_hva(vcpu, fault->gfn), &arch);
  4531	}
  4532	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

