Return-Path: <kvm+bounces-57976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 39CCEB83064
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 07:39:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D21E61C21014
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 05:39:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 688DE2D6E40;
	Thu, 18 Sep 2025 05:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bFOdF4iD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E05929BDB6;
	Thu, 18 Sep 2025 05:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758173955; cv=none; b=WhtvAgl+PHWKWWOJj04HvjZlgusS8ZGLjy0ZAsKFW9EhGVW4L9yfLSnxLqNfiJVXCe+uCfDO3ePWK3bVcG8qOe0McvnrG7ay/R9sA81kHfudbSzAJb0TkKfyf1VGy7sdBN4rfUmgcFps6sXsb4p907ovOHdClWbhK5+6DzABowU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758173955; c=relaxed/simple;
	bh=y+jC5ADb61yhBWtArYZLqp9di3X9xAiUey258IJUPcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c9xWBskn4vU6VGQQvfAN3TXwhMbI3Smz9d9gvvIooVa7lT48VV0uBFZCr9SVKCUDgB3zkGRrMcDmo2t/RluefECVloZfzdiHrlBjTNAs4PG2K2UJBSEM12CQ0Z+FPCWCOWjkb1wSxOiCy+eCmAYibmU+bsW17BbvQQVF3foirrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bFOdF4iD; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758173953; x=1789709953;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=y+jC5ADb61yhBWtArYZLqp9di3X9xAiUey258IJUPcs=;
  b=bFOdF4iDl3A83RQADT6zm+kffTj3hewNu5dhjg58OCP/5SEcXI4OKfRk
   D6kGFwI4oUfTrBw108whaciaIDf2DUOEZ0tId8bAyEbygSF34P2itaRWQ
   gS7imEGdVj+QhGvGG6EKI7DoI+EluBDEVkFPMcLU5JRkij45WWORea3iq
   XARAkoKumCRAk6tJXbgHMY7ZuR6tWJ5uXBBz9AXaSGr38QFsnIgNnY3YY
   69BlyH8KGfgAgn4wsZrD+Ee7If3HmEzFBwEaX5XGEXyh8CmzAkd36KhP8
   dP8vohQWFvE/QIsvNAHTbAKW4KLUOyKirhB5WFfU/i3urRC8E3U4Fxr8l
   w==;
X-CSE-ConnectionGUID: mKcNnNGfR46uCmtxWI5McA==
X-CSE-MsgGUID: SnxwSnVlQGiCHY0rIsA1+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="60604379"
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="60604379"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 22:39:13 -0700
X-CSE-ConnectionGUID: Ufc8YFrWTvOutN5VHn7ZoQ==
X-CSE-MsgGUID: d+DbLpL5RNivQdPIyzn/tQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="176233971"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 17 Sep 2025 22:39:07 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uz7MH-0002nP-0J;
	Thu, 18 Sep 2025 05:39:05 +0000
Date: Thu, 18 Sep 2025 13:38:27 +0800
From: kernel test robot <lkp@intel.com>
To: Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-hyperv@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v2 21/21] x86/pvlocks: Move paravirt spinlock functions
 into own header
Message-ID: <202509181317.YubLCpdh-lkp@intel.com>
References: <20250917145220.31064-22-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917145220.31064-22-jgross@suse.com>

Hi Juergen,

kernel test robot noticed the following build errors:

[auto build test ERROR on tip/sched/core]
[also build test ERROR on kvm/queue kvm/next linus/master v6.17-rc6 next-20250917]
[cannot apply to tip/x86/core kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Juergen-Gross/x86-paravirt-Remove-not-needed-includes-of-paravirt-h/20250917-230321
base:   tip/sched/core
patch link:    https://lore.kernel.org/r/20250917145220.31064-22-jgross%40suse.com
patch subject: [PATCH v2 21/21] x86/pvlocks: Move paravirt spinlock functions into own header
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20250918/202509181317.YubLCpdh-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250918/202509181317.YubLCpdh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509181317.YubLCpdh-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/x86/kernel/alternative.c:4:
   In file included from include/linux/mmu_context.h:5:
   arch/x86/include/asm/mmu_context.h:225:2: error: call to undeclared function 'paravirt_enter_mmap'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     225 |         paravirt_enter_mmap(mm);
         |         ^
   arch/x86/include/asm/mmu_context.h:232:2: error: call to undeclared function 'paravirt_arch_exit_mmap'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     232 |         paravirt_arch_exit_mmap(mm);
         |         ^
   arch/x86/include/asm/mmu_context.h:232:2: note: did you mean 'ldt_arch_exit_mmap'?
   arch/x86/include/asm/mmu_context.h:61:6: note: 'ldt_arch_exit_mmap' declared here
      61 | void ldt_arch_exit_mmap(struct mm_struct *mm);
         |      ^
   In file included from arch/x86/kernel/alternative.c:5:
   In file included from include/linux/perf_event.h:53:
   In file included from include/linux/security.h:35:
   In file included from include/linux/bpf.h:33:
   In file included from arch/x86/include/asm/rqspinlock.h:5:
   arch/x86/include/asm/paravirt.h:570:20: error: static declaration of 'paravirt_enter_mmap' follows non-static declaration
     570 | static inline void paravirt_enter_mmap(struct mm_struct *mm)
         |                    ^
   arch/x86/include/asm/mmu_context.h:225:2: note: previous implicit declaration is here
     225 |         paravirt_enter_mmap(mm);
         |         ^
   In file included from arch/x86/kernel/alternative.c:5:
   In file included from include/linux/perf_event.h:53:
   In file included from include/linux/security.h:35:
   In file included from include/linux/bpf.h:33:
   In file included from arch/x86/include/asm/rqspinlock.h:5:
   arch/x86/include/asm/paravirt.h:576:20: error: static declaration of 'paravirt_arch_exit_mmap' follows non-static declaration
     576 | static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
         |                    ^
   arch/x86/include/asm/mmu_context.h:232:2: note: previous implicit declaration is here
     232 |         paravirt_arch_exit_mmap(mm);
         |         ^
>> arch/x86/kernel/alternative.c:2317:2: error: call to undeclared function 'paravirt_set_cap'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    2317 |         paravirt_set_cap();
         |         ^
   arch/x86/kernel/alternative.c:2317:2: note: did you mean 'paravirt_ret0'?
   arch/x86/include/asm/paravirt-base.h:23:15: note: 'paravirt_ret0' declared here
      23 | unsigned long paravirt_ret0(void);
         |               ^
   5 errors generated.


vim +/paravirt_set_cap +2317 arch/x86/kernel/alternative.c

270a69c4485d7d arch/x86/kernel/alternative.c  Peter Zijlstra            2023-02-08  2288  
9a0b5817ad97bb arch/i386/kernel/alternative.c Gerd Hoffmann             2006-03-23  2289  void __init alternative_instructions(void)
9a0b5817ad97bb arch/i386/kernel/alternative.c Gerd Hoffmann             2006-03-23  2290  {
ebebe30794d38c arch/x86/kernel/alternative.c  Pawan Gupta               2025-05-03  2291  	u64 ibt;
ebebe30794d38c arch/x86/kernel/alternative.c  Pawan Gupta               2025-05-03  2292  
7457c0da024b18 arch/x86/kernel/alternative.c  Peter Zijlstra            2019-05-03  2293  	int3_selftest();
7457c0da024b18 arch/x86/kernel/alternative.c  Peter Zijlstra            2019-05-03  2294  
7457c0da024b18 arch/x86/kernel/alternative.c  Peter Zijlstra            2019-05-03  2295  	/*
7457c0da024b18 arch/x86/kernel/alternative.c  Peter Zijlstra            2019-05-03  2296  	 * The patching is not fully atomic, so try to avoid local
7457c0da024b18 arch/x86/kernel/alternative.c  Peter Zijlstra            2019-05-03  2297  	 * interruptions that might execute the to be patched code.
7457c0da024b18 arch/x86/kernel/alternative.c  Peter Zijlstra            2019-05-03  2298  	 * Other CPUs are not running.
7457c0da024b18 arch/x86/kernel/alternative.c  Peter Zijlstra            2019-05-03  2299  	 */
8f4e956b313dcc arch/i386/kernel/alternative.c Andi Kleen                2007-07-22  2300  	stop_nmi();
123aa76ec0cab5 arch/x86/kernel/alternative.c  Andi Kleen                2009-02-12  2301  
123aa76ec0cab5 arch/x86/kernel/alternative.c  Andi Kleen                2009-02-12  2302  	/*
123aa76ec0cab5 arch/x86/kernel/alternative.c  Andi Kleen                2009-02-12  2303  	 * Don't stop machine check exceptions while patching.
123aa76ec0cab5 arch/x86/kernel/alternative.c  Andi Kleen                2009-02-12  2304  	 * MCEs only happen when something got corrupted and in this
123aa76ec0cab5 arch/x86/kernel/alternative.c  Andi Kleen                2009-02-12  2305  	 * case we must do something about the corruption.
32b1cbe380417f arch/x86/kernel/alternative.c  Marco Ammon               2019-09-02  2306  	 * Ignoring it is worse than an unlikely patching race.
123aa76ec0cab5 arch/x86/kernel/alternative.c  Andi Kleen                2009-02-12  2307  	 * Also machine checks tend to be broadcast and if one CPU
123aa76ec0cab5 arch/x86/kernel/alternative.c  Andi Kleen                2009-02-12  2308  	 * goes into machine check the others follow quickly, so we don't
123aa76ec0cab5 arch/x86/kernel/alternative.c  Andi Kleen                2009-02-12  2309  	 * expect a machine check to cause undue problems during to code
123aa76ec0cab5 arch/x86/kernel/alternative.c  Andi Kleen                2009-02-12  2310  	 * patching.
123aa76ec0cab5 arch/x86/kernel/alternative.c  Andi Kleen                2009-02-12  2311  	 */
8f4e956b313dcc arch/i386/kernel/alternative.c Andi Kleen                2007-07-22  2312  
4e6292114c7412 arch/x86/kernel/alternative.c  Juergen Gross             2021-03-11  2313  	/*
f7af6977621a41 arch/x86/kernel/alternative.c  Juergen Gross             2023-12-10  2314  	 * Make sure to set (artificial) features depending on used paravirt
f7af6977621a41 arch/x86/kernel/alternative.c  Juergen Gross             2023-12-10  2315  	 * functions which can later influence alternative patching.
4e6292114c7412 arch/x86/kernel/alternative.c  Juergen Gross             2021-03-11  2316  	 */
4e6292114c7412 arch/x86/kernel/alternative.c  Juergen Gross             2021-03-11 @2317  	paravirt_set_cap();
4e6292114c7412 arch/x86/kernel/alternative.c  Juergen Gross             2021-03-11  2318  
ebebe30794d38c arch/x86/kernel/alternative.c  Pawan Gupta               2025-05-03  2319  	/* Keep CET-IBT disabled until caller/callee are patched */
ebebe30794d38c arch/x86/kernel/alternative.c  Pawan Gupta               2025-05-03  2320  	ibt = ibt_save(/*disable*/ true);
ebebe30794d38c arch/x86/kernel/alternative.c  Pawan Gupta               2025-05-03  2321  
931ab63664f02b arch/x86/kernel/alternative.c  Peter Zijlstra            2022-10-27  2322  	__apply_fineibt(__retpoline_sites, __retpoline_sites_end,
1d7e707af44613 arch/x86/kernel/alternative.c  Mike Rapoport (Microsoft  2025-01-26  2323) 			__cfi_sites, __cfi_sites_end, true);
931ab63664f02b arch/x86/kernel/alternative.c  Peter Zijlstra            2022-10-27  2324  
7508500900814d arch/x86/kernel/alternative.c  Peter Zijlstra            2021-10-26  2325  	/*
7508500900814d arch/x86/kernel/alternative.c  Peter Zijlstra            2021-10-26  2326  	 * Rewrite the retpolines, must be done before alternatives since
7508500900814d arch/x86/kernel/alternative.c  Peter Zijlstra            2021-10-26  2327  	 * those can rewrite the retpoline thunks.
7508500900814d arch/x86/kernel/alternative.c  Peter Zijlstra            2021-10-26  2328  	 */
1d7e707af44613 arch/x86/kernel/alternative.c  Mike Rapoport (Microsoft  2025-01-26  2329) 	apply_retpolines(__retpoline_sites, __retpoline_sites_end);
1d7e707af44613 arch/x86/kernel/alternative.c  Mike Rapoport (Microsoft  2025-01-26  2330) 	apply_returns(__return_sites, __return_sites_end);
7508500900814d arch/x86/kernel/alternative.c  Peter Zijlstra            2021-10-26  2331  
a82b26451de126 arch/x86/kernel/alternative.c  Peter Zijlstra (Intel     2025-06-03  2332) 	its_fini_core();
a82b26451de126 arch/x86/kernel/alternative.c  Peter Zijlstra (Intel     2025-06-03  2333) 
e81dc127ef6988 arch/x86/kernel/alternative.c  Thomas Gleixner           2022-09-15  2334  	/*
ab9fea59487d8b arch/x86/kernel/alternative.c  Peter Zijlstra            2025-02-07  2335  	 * Adjust all CALL instructions to point to func()-10, including
ab9fea59487d8b arch/x86/kernel/alternative.c  Peter Zijlstra            2025-02-07  2336  	 * those in .altinstr_replacement.
e81dc127ef6988 arch/x86/kernel/alternative.c  Thomas Gleixner           2022-09-15  2337  	 */
e81dc127ef6988 arch/x86/kernel/alternative.c  Thomas Gleixner           2022-09-15  2338  	callthunks_patch_builtin_calls();
e81dc127ef6988 arch/x86/kernel/alternative.c  Thomas Gleixner           2022-09-15  2339  
ab9fea59487d8b arch/x86/kernel/alternative.c  Peter Zijlstra            2025-02-07  2340  	apply_alternatives(__alt_instructions, __alt_instructions_end);
ab9fea59487d8b arch/x86/kernel/alternative.c  Peter Zijlstra            2025-02-07  2341  
be0fffa5ca894a arch/x86/kernel/alternative.c  Peter Zijlstra            2023-06-22  2342  	/*
be0fffa5ca894a arch/x86/kernel/alternative.c  Peter Zijlstra            2023-06-22  2343  	 * Seal all functions that do not have their address taken.
be0fffa5ca894a arch/x86/kernel/alternative.c  Peter Zijlstra            2023-06-22  2344  	 */
1d7e707af44613 arch/x86/kernel/alternative.c  Mike Rapoport (Microsoft  2025-01-26  2345) 	apply_seal_endbr(__ibt_endbr_seal, __ibt_endbr_seal_end);
ed53a0d971926e arch/x86/kernel/alternative.c  Peter Zijlstra            2022-03-08  2346  
ebebe30794d38c arch/x86/kernel/alternative.c  Pawan Gupta               2025-05-03  2347  	ibt_restore(ibt);
ebebe30794d38c arch/x86/kernel/alternative.c  Pawan Gupta               2025-05-03  2348  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

