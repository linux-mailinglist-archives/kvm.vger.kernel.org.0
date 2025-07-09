Return-Path: <kvm+bounces-51997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C508AAFF435
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 23:59:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A16271C45B8A
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 21:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86C4B242D8D;
	Wed,  9 Jul 2025 21:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eOxdHuYI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6D25661;
	Wed,  9 Jul 2025 21:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752098371; cv=none; b=pQJhg8qb1JIr49vv7x8tH6eax1YqDA6bF6oqoVX+UxgcnmAOx+sDCnuHQwO72IsWf6n5ujv3A3/BkcFzZBwMKFqR0Ahw185c/BOEHiwAdVstr7h05LgYbk11EHmBhwac8IEzNLici3f3hH1jQhuaPNZCU5QMzbWgynBv9dhR4CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752098371; c=relaxed/simple;
	bh=eD2dKPan0oJtd+hG31uBmZSGHJyNUWf+tU20HGcVDqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L9uh5CXpOFIgWNx6b9umh+YOVDow44KG8qyp1P4udVczMqlMtXZmY+uwFwKS1t2fGcWfEHTqNbhWc0HTd5ZxPwNYIXpvnL/qlaVE0VsntZPV4rORILUyYyl+yKu3OmhFDmBfUNwSDid/84wy3gm2gyLlKZz27CS8l9EfepKpquQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eOxdHuYI; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752098370; x=1783634370;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eD2dKPan0oJtd+hG31uBmZSGHJyNUWf+tU20HGcVDqM=;
  b=eOxdHuYIgkSeCM5YMuTTMYpL+rIbID+wCeYEeZHqzQUQAvKT/rB/D/kf
   zNfT3zwZOZ8GJWNQzcsoPWmsxedvVK1fj+U+s9e3sV/adFNk/yVulGL2g
   V9iobXhljis8AmNky+goFSnCiDaq4GGe5wbSplmMaQyX5Ati+9UGKJzF4
   OtsUH60RmOSTOIekvvVjg/pjnzHB23eRNO/OkOR6L1d8Dbekgn20q7m7v
   WweTzOSy94a/qBjeIHGO58S7GUkYt2F0dOstQNBRuFrwfSxg/+Wazc28E
   bIlHdjObT8vBuc3N+9e4atWoStCRnVeQ/OKTl0ul8LuQqt6TnYqMIrazh
   g==;
X-CSE-ConnectionGUID: mqh1pYCHQmW93TbGVF+piQ==
X-CSE-MsgGUID: Ne4w8PjRTDWiaP/biPXXwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="54342883"
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="54342883"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 14:59:30 -0700
X-CSE-ConnectionGUID: LyxA6DwPQt+RV72lYsidyA==
X-CSE-MsgGUID: WV/e39FUTnqzerwi1wMNZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="155308121"
Received: from lkp-server01.sh.intel.com (HELO 9ee84586c615) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 09 Jul 2025 14:59:25 -0700
Received: from kbuild by 9ee84586c615 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uZcp0-000479-23;
	Wed, 09 Jul 2025 21:59:22 +0000
Date: Thu, 10 Jul 2025 05:58:35 +0800
From: kernel test robot <lkp@intel.com>
To: Suleiman Souhlal <suleiman@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: oe-kbuild-all@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	John Stultz <jstultz@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, ssouhlal@freebsd.org,
	Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v6 1/3] KVM: x86: Advance guest TSC after deep suspend.
Message-ID: <202507100515.ZQd2P9F8-lkp@intel.com>
References: <20250709070450.473297-2-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250709070450.473297-2-suleiman@google.com>

Hi Suleiman,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on kvm/next kvm/linux-next linus/master v6.16-rc5 next-20250709]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Suleiman-Souhlal/KVM-x86-Advance-guest-TSC-after-deep-suspend/20250709-150751
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20250709070450.473297-2-suleiman%40google.com
patch subject: [PATCH v6 1/3] KVM: x86: Advance guest TSC after deep suspend.
config: i386-buildonly-randconfig-002-20250710 (https://download.01.org/0day-ci/archive/20250710/202507100515.ZQd2P9F8-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250710/202507100515.ZQd2P9F8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507100515.ZQd2P9F8-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/x86/kvm/x86.c: In function 'kvm_arch_vcpu_load':
   arch/x86/kvm/x86.c:5044:27: error: implicit declaration of function 'kvm_get_time_and_clockread'; did you mean 'kvm_get_monotonic_and_clockread'? [-Werror=implicit-function-declaration]
    5044 |                 advance = kvm_get_time_and_clockread(&kernel_ns, &tsc_now);
         |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~
         |                           kvm_get_monotonic_and_clockread
   arch/x86/kvm/x86.c:5062:17: error: 'kvm' undeclared (first use in this function)
    5062 |                 kvm->arch.host_was_suspended = false;
         |                 ^~~
   arch/x86/kvm/x86.c:5062:17: note: each undeclared identifier is reported only once for each function it appears in
   In file included from include/linux/bitops.h:7,
                    from include/linux/kernel.h:23,
                    from include/linux/cpumask.h:11,
                    from include/linux/alloc_tag.h:13,
                    from include/linux/percpu.h:5,
                    from include/linux/context_tracking_state.h:5,
                    from include/linux/hardirq.h:5,
                    from include/linux/kvm_host.h:7,
                    from arch/x86/kvm/x86.c:20:
   arch/x86/kvm/x86.c:5063:71: error: 'flags' undeclared (first use in this function)
    5063 |                 raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
         |                                                                       ^~~~~
   include/linux/typecheck.h:11:16: note: in definition of macro 'typecheck'
      11 |         typeof(x) __dummy2; \
         |                ^
   arch/x86/kvm/x86.c:5063:17: note: in expansion of macro 'raw_spin_unlock_irqrestore'
    5063 |                 raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~
>> include/linux/typecheck.h:12:25: warning: comparison of distinct pointer types lacks a cast
      12 |         (void)(&__dummy == &__dummy2); \
         |                         ^~
   include/linux/spinlock.h:281:17: note: in expansion of macro 'typecheck'
     281 |                 typecheck(unsigned long, flags);                \
         |                 ^~~~~~~~~
   arch/x86/kvm/x86.c:5063:17: note: in expansion of macro 'raw_spin_unlock_irqrestore'
    5063 |                 raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/x86.c: At top level:
   arch/x86/kvm/x86.c:5068:9: error: expected identifier or '(' before 'if'
    5068 |         if (unlikely(vcpu->cpu != cpu) || kvm_check_tsc_unstable()) {
         |         ^~
   include/linux/kvm_host.h:182:39: error: expected declaration specifiers or '...' before '(' token
     182 | #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
         |                                       ^
   include/linux/kvm_host.h:186:36: note: in expansion of macro 'KVM_ARCH_REQ_FLAGS'
     186 | #define KVM_ARCH_REQ(nr)           KVM_ARCH_REQ_FLAGS(nr, 0)
         |                                    ^~~~~~~~~~~~~~~~~~
   arch/x86/include/asm/kvm_host.h:94:41: note: in expansion of macro 'KVM_ARCH_REQ'
      94 | #define KVM_REQ_STEAL_UPDATE            KVM_ARCH_REQ(8)
         |                                         ^~~~~~~~~~~~
   arch/x86/kvm/x86.c:5096:26: note: in expansion of macro 'KVM_REQ_STEAL_UPDATE'
    5096 |         kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
         |                          ^~~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/x86.c:5096:48: error: unknown type name 'vcpu'
    5096 |         kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
         |                                                ^~~~
   arch/x86/kvm/x86.c:5097:1: error: expected identifier or '(' before '}' token
    5097 | }
         | ^
   cc1: some warnings being treated as errors


vim +12 include/linux/typecheck.h

e0deaff470900a Andrew Morton 2008-07-25   4  
e0deaff470900a Andrew Morton 2008-07-25   5  /*
e0deaff470900a Andrew Morton 2008-07-25   6   * Check at compile time that something is of a particular type.
e0deaff470900a Andrew Morton 2008-07-25   7   * Always evaluates to 1 so you may use it easily in comparisons.
e0deaff470900a Andrew Morton 2008-07-25   8   */
e0deaff470900a Andrew Morton 2008-07-25   9  #define typecheck(type,x) \
e0deaff470900a Andrew Morton 2008-07-25  10  ({	type __dummy; \
e0deaff470900a Andrew Morton 2008-07-25  11  	typeof(x) __dummy2; \
e0deaff470900a Andrew Morton 2008-07-25 @12  	(void)(&__dummy == &__dummy2); \
e0deaff470900a Andrew Morton 2008-07-25  13  	1; \
e0deaff470900a Andrew Morton 2008-07-25  14  })
e0deaff470900a Andrew Morton 2008-07-25  15  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

