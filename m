Return-Path: <kvm+bounces-65923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A610CBA5CD
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 07:01:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CBF6630577CD
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 06:00:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2308C2773CC;
	Sat, 13 Dec 2025 06:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dZP5R5Xp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4D82236E5
	for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 06:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765605612; cv=none; b=VQpnu3SE8J9SrtrYvmJhhGH26cFBryl0RsuvqT+26diDcQE/fvkq8bZ3379hhOeEgix0ATnQJ30s8oc4eNUfyN4DkuOMqeq+Zeyzpz8/WzAQK4FUMIwBR6iXsIl9kfn0Ec6OXEnFjrn5YOWPWEue0wNIlgFFB9/ApEiPviV3Bwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765605612; c=relaxed/simple;
	bh=WL4zqdjhP4eWIgWVfNrlgI8rU89YTQc1eFsnk2DTuu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TWyHPCWSyUScBwNZhuJ79/uvXXfjN3WwbA/nBdjHFGnmCKhAVgKw7no+ObokrAnP9/zwpqD1qY8p1zCWB0i/x/j4zQXs2Tzx6Smop0SQ9Ydk5EGEsfDG9WuerKUCegpk6YDyopTbSONvRFIJB0O6KP9P5mGYmZAGGejEsjXkISg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dZP5R5Xp; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765605610; x=1797141610;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WL4zqdjhP4eWIgWVfNrlgI8rU89YTQc1eFsnk2DTuu0=;
  b=dZP5R5Xp3Jor5zhHkb8NnoodLd1FvxA+d4XH/HveP1LdQCMkNy1DiQ46
   wsJQZigOU9DcJiXgsjiKG/AyMY5qXlABxv/GmZ54UtMJtGyObE83DERfh
   I/l0m4BjTVGaO9hwtSeq0D9FS/R4WXQ3eDlYuhJB8Sjq2BVlej6H1PVsq
   C+eVS5uVmvBUdGEf+vJtvPDp+WGIQ3hLL/CfFDjyV8W6rNUBM3Z2wwuLT
   P8bETZwMNbedxJCd/zf40WrRu9iKX0W91jyBXDt8OXmIXRfde9Lszuhai
   oCUkQpTLZxtescg0RUEEblisk7JQACwrlNZRQiSf0wQJWa91J5/1tLE1V
   w==;
X-CSE-ConnectionGUID: wFgfVrIlRbKAHBkIIKIuiw==
X-CSE-MsgGUID: efnl/ZOpTJimC+UEOe5fPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11640"; a="67479181"
X-IronPort-AV: E=Sophos;i="6.21,145,1763452800"; 
   d="scan'208";a="67479181"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2025 22:00:09 -0800
X-CSE-ConnectionGUID: 0dvZTn5IRXWGLU1cN3ZoGA==
X-CSE-MsgGUID: S/O+NmewRDKE54hVKm53Sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,145,1763452800"; 
   d="scan'208";a="201749910"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 12 Dec 2025 22:00:06 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vUIfj-0000000078T-1bmr;
	Sat, 13 Dec 2025 06:00:03 +0000
Date: Sat, 13 Dec 2025 13:59:37 +0800
From: kernel test robot <lkp@intel.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, nd <nd@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: Re: [PATCH 14/32] KVM: arm64: gic-v5: Implement GICv5 load/put and
 save/restore
Message-ID: <202512131338.pYhd9ptc-lkp@intel.com>
References: <20251212152215.675767-15-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251212152215.675767-15-sascha.bischoff@arm.com>

Hi Sascha,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on next-20251212]
[cannot apply to kvmarm/next arm64/for-next/core kvm/queue kvm/next kvm/linux-next v6.18]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Sascha-Bischoff/KVM-arm64-Account-for-RES1-bits-in-DECLARE_FEAT_MAP-and-co/20251212-233140
base:   linus/master
patch link:    https://lore.kernel.org/r/20251212152215.675767-15-sascha.bischoff%40arm.com
patch subject: [PATCH 14/32] KVM: arm64: gic-v5: Implement GICv5 load/put and save/restore
config: arm64-allnoconfig (https://download.01.org/0day-ci/archive/20251213/202512131338.pYhd9ptc-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251213/202512131338.pYhd9ptc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512131338.pYhd9ptc-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/arm64/include/asm/kvm_host.h:36,
                    from include/linux/kvm_host.h:45,
                    from arch/arm64/kernel/asm-offsets.c:16:
>> include/kvm/arm_vgic.h:392:26: error: field 'gicv5_vpe' has incomplete type
     392 |         struct gicv5_vpe gicv5_vpe;
         |                          ^~~~~~~~~
   make[3]: *** [scripts/Makefile.build:182: arch/arm64/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1314: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +/gicv5_vpe +392 include/kvm/arm_vgic.h

   360	
   361	struct vgic_v5_cpu_if {
   362		u64	vgic_apr;
   363		u64	vgic_vmcr;
   364	
   365		/* PPI register state */
   366		u64	vgic_ppi_hmr[2];
   367		u64	vgic_ppi_dvir[2];
   368		u64	vgic_ppi_priorityr[16];
   369	
   370		/* The pending state of the guest. This is merged with the exit state */
   371		u64	vgic_ppi_pendr[2];
   372	
   373		/* The state flushed to the regs when entering the guest */
   374		u64	vgic_ppi_activer_entry[2];
   375		u64	vgic_ich_ppi_enabler_entry[2];
   376		u64	vgic_ppi_pendr_entry[2];
   377	
   378		/* The saved state of the regs when leaving the guest */
   379		u64	vgic_ppi_activer_exit[2];
   380		u64	vgic_ich_ppi_enabler_exit[2];
   381		u64	vgic_ppi_pendr_exit[2];
   382	
   383		/*
   384		 * The ICSR is re-used across host and guest, and hence it needs to be
   385		 * saved/restored. Only one copy is required as the host should block
   386		 * preemption between executing GIC CDRCFG and acccessing the
   387		 * ICC_ICSR_EL1. A guest, of course, can never guarantee this, and hence
   388		 * it is the hyp's responsibility to keep the state constistent.
   389		 */
   390		u64	vgic_icsr;
   391	
 > 392		struct gicv5_vpe gicv5_vpe;
   393	};
   394	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

