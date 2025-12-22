Return-Path: <kvm+bounces-66511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B20DCD6C43
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:09:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5F1D73070A37
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:03:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E172934F499;
	Mon, 22 Dec 2025 16:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TWRWEj6j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C15B34F26F
	for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 16:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422408; cv=none; b=S4nFy5ibqDJxUSAq+YPlrlyhO/bCqTbZ+210dO5JMrD2tEliy8JfPmhJzt1CEjCZ5RJKhdrX5bRRgMCdqbbQm2RzhCWvkQUGY0bl8WbQSSp4xoFN7Lh/gpUTsXzylC6Wp9beD0ueHUagLE+raL2URxqkZbF7vRKBI4nbW5iurFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422408; c=relaxed/simple;
	bh=SLzPCyVSf2GCKYqR6ihp41nIyXMktxWN6o79iAcwaVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fhZCQFIIQI9ZQyEPs7fo4ay91g5ATaJWtjG30P0KvZu0n+J0gIOf182w6KN9QcBjZPub9QEdo1lr6ValwuAhYC8RaLYE8Gx3tvUgOCnnau831Jo5uWU4Cc3MgW0sYj3I9QnAK2LoIiHK3Yh4zRiQG/Zvbdn1u2vPAiOosUT1Zbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TWRWEj6j; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766422406; x=1797958406;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SLzPCyVSf2GCKYqR6ihp41nIyXMktxWN6o79iAcwaVc=;
  b=TWRWEj6jswPKwFATdx2TyUi/xMY4YZ/kSTbHIz7nxuaCYDmeP7z+l86H
   kqSURJZqNsqIlYqhM08yod8qKYxXkEbu/d4MwFXlNKJa5D5mRilW7tYVV
   +qjlC47cbOo49M7DiyoBpMud+tkEh4je8YfkUzZclKfLx4Xt7bNBhybcB
   SL3r8BDLCh2wppW3GYbB7qlZVF7SA+HttarODiruyZ+L/Mtbo0rW3MuEw
   +3IhQFStlgpvVKMvykZGSdc8tvg+tF9pR8uof5J5AcJMuDzbp2kojB2pb
   /zKe9YganBMJfOLZ2tYjiDxBN1onyGoKyeGf2D78sErvMIMzt29Q3PsrO
   A==;
X-CSE-ConnectionGUID: LEyZbNcVQdOAixiY0tgzPQ==
X-CSE-MsgGUID: tgv3cgcUTAeJg7gJaoGkeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11650"; a="55849964"
X-IronPort-AV: E=Sophos;i="6.21,168,1763452800"; 
   d="scan'208";a="55849964"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2025 08:53:26 -0800
X-CSE-ConnectionGUID: 6fDkPJhHRFmrLp8CGDNaLQ==
X-CSE-MsgGUID: AZDQkn5AQxWF4NRtHppNNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,168,1763452800"; 
   d="scan'208";a="204049302"
Received: from igk-lkp-server01.igk.intel.com (HELO 8a0c053bdd2a) ([10.211.93.152])
  by fmviesa005.fm.intel.com with ESMTP; 22 Dec 2025 08:53:22 -0800
Received: from kbuild by 8a0c053bdd2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXj9s-000000005Ym-1Tsx;
	Mon, 22 Dec 2025 16:53:20 +0000
Date: Mon, 22 Dec 2025 17:52:47 +0100
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
Message-ID: <202512221751.nHKObHNq-lkp@intel.com>
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
[also build test ERROR on v6.19-rc2 next-20251219]
[cannot apply to kvmarm/next arm64/for-next/core kvm/queue kvm/next kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Sascha-Bischoff/KVM-arm64-Account-for-RES1-bits-in-DECLARE_FEAT_MAP-and-co/20251212-233140
base:   linus/master
patch link:    https://lore.kernel.org/r/20251212152215.675767-15-sascha.bischoff%40arm.com
patch subject: [PATCH 14/32] KVM: arm64: gic-v5: Implement GICv5 load/put and save/restore
config: arm64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20251222/202512221751.nHKObHNq-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project ecaf673850beb241957352bd61e95ed34256635f)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251222/202512221751.nHKObHNq-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512221751.nHKObHNq-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/arm64/kernel/asm-offsets.c:16:
   In file included from ./include/linux/kvm_host.h:45:
   In file included from ./arch/arm64/include/asm/kvm_host.h:36:
>> ./include/kvm/arm_vgic.h:392:19: error: field has incomplete type 'struct gicv5_vpe'
     392 |         struct gicv5_vpe gicv5_vpe;
         |                          ^
   ./include/kvm/arm_vgic.h:392:9: note: forward declaration of 'struct gicv5_vpe'
     392 |         struct gicv5_vpe gicv5_vpe;
         |                ^
   1 error generated.


vim +392 ./include/kvm/arm_vgic.h

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

