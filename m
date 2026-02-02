Return-Path: <kvm+bounces-69863-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OMGDFI6/gGl3AgMAu9opvQ
	(envelope-from <kvm+bounces-69863-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 16:15:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CB14ECE07C
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 16:15:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5D76F304812E
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 15:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DCD9377544;
	Mon,  2 Feb 2026 15:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jKJj06CP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903FE374725;
	Mon,  2 Feb 2026 15:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770044588; cv=none; b=QHS0Sl5AAPNEJLe+kzYW9IV4sXIK3yGUWFUScDP7AN/HbQOmrxyX8My8zqYWFi9p2InCQGtXjPOq/FML2xhy/XW6i29bC3Rwgez2KxUAsG2RDjywgW0pyju9R7rS1DYkGWR1mEEXvW8FjLI5vEqSSbtBKNuK+3mAOnorIGKS7No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770044588; c=relaxed/simple;
	bh=f4jiSWaAUMy80OsaVE6o84JI4KEEK5M17ot8dH2cPts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FbxqSpD74TuTT79G0gqTREfbyPFqeDll8Z8nrJP20KjcbMm5k0FxqdcU1EIlnuDi2rHmGq0BYC1iht0sKMJUTR+67RKlRhfc2JTqeDvaIK2cYiSXdTDslW/8+fxsxelnDSHwHtFdDRaR67mqtndv7eqMHEmTn9XdENgxgEIVEDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jKJj06CP; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770044587; x=1801580587;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=f4jiSWaAUMy80OsaVE6o84JI4KEEK5M17ot8dH2cPts=;
  b=jKJj06CPv+ezALh2mBlTbMnJoPB1sy3SbWh8JCRhDhurYymgQUePITGV
   h8GQx/Qf0FR8z1RWlEA5oElZ4B/HYCyBINzP4myqR4g+E1Gce4PEmum5M
   FSzRL5PbwG6cot3ECjtklMaoukzc4uvYq6G9LHMg8gW33YkSrmZ8iNz8O
   h3cacoszZR/hWHUv2pgWFOpn3S8Z/0l5sM/IfoPoS9dXNfRMx+eNhmM1w
   hT6vR6AqGuotCmm4TRpMXdva3rqayH6bfXTfsRpfTTUFgMyL26/QRp6Dw
   fIUjmylWvU9fVc7J7qaKdmBRwieOrP+pucZwa0zFPYM7YGGSUFb627awN
   w==;
X-CSE-ConnectionGUID: cY6TY4gPQB6gnOqrCjJ3Tg==
X-CSE-MsgGUID: dN4VzvijSPS5G1Hdkdld6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="71099598"
X-IronPort-AV: E=Sophos;i="6.21,269,1763452800"; 
   d="scan'208";a="71099598"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 07:03:06 -0800
X-CSE-ConnectionGUID: 1Sm55USrTViCYi6oLwwXlg==
X-CSE-MsgGUID: ZhozEz8UQCq9wlrljDbqsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,269,1763452800"; 
   d="scan'208";a="209698373"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 02 Feb 2026 07:03:00 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vmvS4-00000000ffw-49bj;
	Mon, 02 Feb 2026 15:02:56 +0000
Date: Mon, 2 Feb 2026 23:02:50 +0800
From: kernel test robot <lkp@intel.com>
To: Shashank Balaji <shashank.mahadasyam@sony.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
	jailhouse-dev@googlegroups.com, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org, Rahul Bukte <rahul.bukte@sony.com>,
	Shashank Balaji <shashank.mahadasyam@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>,
	Tim Bird <tim.bird@sony.com>
Subject: Re: [PATCH 1/3] x86/x2apic: disable x2apic on resume if the kernel
 expects so
Message-ID: <202602022242.iSdFHMDI-lkp@intel.com>
References: <20260202-x2apic-fix-v1-1-71c8f488a88b@sony.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202-x2apic-fix-v1-1-71c8f488a88b@sony.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69863-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[32];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid,01.org:url]
X-Rspamd-Queue-Id: CB14ECE07C
X-Rspamd-Action: no action

Hi Shashank,

kernel test robot noticed the following build errors:

[auto build test ERROR on 18f7fcd5e69a04df57b563360b88be72471d6b62]

url:    https://github.com/intel-lab-lkp/linux/commits/Shashank-Balaji/x86-x2apic-disable-x2apic-on-resume-if-the-kernel-expects-so/20260202-181147
base:   18f7fcd5e69a04df57b563360b88be72471d6b62
patch link:    https://lore.kernel.org/r/20260202-x2apic-fix-v1-1-71c8f488a88b%40sony.com
patch subject: [PATCH 1/3] x86/x2apic: disable x2apic on resume if the kernel expects so
config: x86_64-buildonly-randconfig-001-20260202 (https://download.01.org/0day-ci/archive/20260202/202602022242.iSdFHMDI-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260202/202602022242.iSdFHMDI-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602022242.iSdFHMDI-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kernel/apic/apic.c: In function 'lapic_resume':
>> arch/x86/kernel/apic/apic.c:2463:17: error: implicit declaration of function '__x2apic_disable'; did you mean '__x2apic_enable'? [-Wimplicit-function-declaration]
    2463 |                 __x2apic_disable();
         |                 ^~~~~~~~~~~~~~~~
         |                 __x2apic_enable


vim +2463 arch/x86/kernel/apic/apic.c

  2435	
  2436	static void lapic_resume(void *data)
  2437	{
  2438		unsigned int l, h;
  2439		unsigned long flags;
  2440		int maxlvt;
  2441	
  2442		if (!apic_pm_state.active)
  2443			return;
  2444	
  2445		local_irq_save(flags);
  2446	
  2447		/*
  2448		 * IO-APIC and PIC have their own resume routines.
  2449		 * We just mask them here to make sure the interrupt
  2450		 * subsystem is completely quiet while we enable x2apic
  2451		 * and interrupt-remapping.
  2452		 */
  2453		mask_ioapic_entries();
  2454		legacy_pic->mask_all();
  2455	
  2456		if (x2apic_mode) {
  2457			__x2apic_enable();
  2458		} else {
  2459			/*
  2460			 * x2apic may have been re-enabled by the
  2461			 * firmware on resuming from s2ram
  2462			 */
> 2463			__x2apic_disable();
  2464	
  2465			/*
  2466			 * Make sure the APICBASE points to the right address
  2467			 *
  2468			 * FIXME! This will be wrong if we ever support suspend on
  2469			 * SMP! We'll need to do this as part of the CPU restore!
  2470			 */
  2471			if (boot_cpu_data.x86 >= 6) {
  2472				rdmsr(MSR_IA32_APICBASE, l, h);
  2473				l &= ~MSR_IA32_APICBASE_BASE;
  2474				l |= MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
  2475				wrmsr(MSR_IA32_APICBASE, l, h);
  2476			}
  2477		}
  2478	
  2479		maxlvt = lapic_get_maxlvt();
  2480		apic_write(APIC_LVTERR, ERROR_APIC_VECTOR | APIC_LVT_MASKED);
  2481		apic_write(APIC_ID, apic_pm_state.apic_id);
  2482		apic_write(APIC_DFR, apic_pm_state.apic_dfr);
  2483		apic_write(APIC_LDR, apic_pm_state.apic_ldr);
  2484		apic_write(APIC_TASKPRI, apic_pm_state.apic_taskpri);
  2485		apic_write(APIC_SPIV, apic_pm_state.apic_spiv);
  2486		apic_write(APIC_LVT0, apic_pm_state.apic_lvt0);
  2487		apic_write(APIC_LVT1, apic_pm_state.apic_lvt1);
  2488	#ifdef CONFIG_X86_THERMAL_VECTOR
  2489		if (maxlvt >= 5)
  2490			apic_write(APIC_LVTTHMR, apic_pm_state.apic_thmr);
  2491	#endif
  2492	#ifdef CONFIG_X86_MCE_INTEL
  2493		if (maxlvt >= 6)
  2494			apic_write(APIC_LVTCMCI, apic_pm_state.apic_cmci);
  2495	#endif
  2496		if (maxlvt >= 4)
  2497			apic_write(APIC_LVTPC, apic_pm_state.apic_lvtpc);
  2498		apic_write(APIC_LVTT, apic_pm_state.apic_lvtt);
  2499		apic_write(APIC_TDCR, apic_pm_state.apic_tdcr);
  2500		apic_write(APIC_TMICT, apic_pm_state.apic_tmict);
  2501		apic_write(APIC_ESR, 0);
  2502		apic_read(APIC_ESR);
  2503		apic_write(APIC_LVTERR, apic_pm_state.apic_lvterr);
  2504		apic_write(APIC_ESR, 0);
  2505		apic_read(APIC_ESR);
  2506	
  2507		irq_remapping_reenable(x2apic_mode);
  2508	
  2509		local_irq_restore(flags);
  2510	}
  2511	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

