Return-Path: <kvm+bounces-28021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E23D991ABB
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 22:43:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73BA51C215CC
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 20:43:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF43615ECD5;
	Sat,  5 Oct 2024 20:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WW4VyEmr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EA418E1F;
	Sat,  5 Oct 2024 20:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728161013; cv=none; b=XL4xV9Mh5EapX1wkd04yClL5gxrR67rXztL5Zjtw61wfrLsPeZlOgxFmX7t7MBH4vrI4yMgRU86265c3q50F8pRxU60CPg2uv7ddcHUXwY+x4GYXVaZhbxP55lF0HhaKGCvfTelYO2zUGOjKGGquwHNmr5IPGccD2FuP9KxeFds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728161013; c=relaxed/simple;
	bh=lsgnJXAxYG9046D09VfIkQsGwV62AF9kV+ssxGi2PqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aaNqaeOkaDjCPgg0PtZEgTTAReQHWjvjKGHeDc4wNYdBY4rpl92DI67fU9v5kixm+EAFVgCPi0vDwuWwI1EdyybFY8RpZ+CIwQtQQLbYTsQXdlGoffmnIRXCHqC+3DfqeOXiRfhT72atZpEZttVDEShq/xKMfHs+LnUXiN9eTIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WW4VyEmr; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728161010; x=1759697010;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lsgnJXAxYG9046D09VfIkQsGwV62AF9kV+ssxGi2PqY=;
  b=WW4VyEmr7s6MDaybM0bfR75/YmPUX1+9OHCI8lu91pvEHhDhAOHCXjtO
   wX4UaeOWcVdlm8PypBLJ9qUwr60+RI4bnmmubR1vK3qzD2c/mSvJWXOmf
   Y7RjWQdDrb7BJ0TsbTDjBWkhPMxdyCmbYfszgYYb9ORCvv+S6sGuCgdIF
   p8FyBWaedxIkAq3EI524MzmCSifTmQE2m7RZUlWO7oGvtVYu4SXWZes10
   uNRqJwaDXQMvutx99TbE3JJwGuStfjad0SD5aiL1fUKXZ8h5RBLeASN+o
   WOvqAm3mJfMGVmvmzMAAAJy0Wr23KVjsbk1/zT7grmvSErhBgyZek/WJn
   w==;
X-CSE-ConnectionGUID: HVcH1M2ASmSBH95OmuyPqQ==
X-CSE-MsgGUID: 4tBKqRJZTru3/D78JiK1DA==
X-IronPort-AV: E=McAfee;i="6700,10204,11216"; a="27498962"
X-IronPort-AV: E=Sophos;i="6.11,181,1725346800"; 
   d="scan'208";a="27498962"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2024 13:43:29 -0700
X-CSE-ConnectionGUID: +iWCmUraSnGFb4suOA7nEA==
X-CSE-MsgGUID: N4Yg2KpMQBW5EuugzdObNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,181,1725346800"; 
   d="scan'208";a="105893318"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 05 Oct 2024 13:43:27 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sxBca-0003LO-1u;
	Sat, 05 Oct 2024 20:43:24 +0000
Date: Sun, 6 Oct 2024 04:43:08 +0800
From: kernel test robot <lkp@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, seanjc@google.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] KVM: x86: leave kvm.ko out of the build if no vendor
 module is requested
Message-ID: <202410060426.e9Xsnkvi-lkp@intel.com>
References: <20241003230806.229001-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241003230806.229001-2-pbonzini@redhat.com>

Hi Paolo,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on linus/master v6.12-rc1 next-20241004]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Paolo-Bonzini/KVM-x86-leave-kvm-ko-out-of-the-build-if-no-vendor-module-is-requested/20241004-071034
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20241003230806.229001-2-pbonzini%40redhat.com
patch subject: [PATCH 1/2] KVM: x86: leave kvm.ko out of the build if no vendor module is requested
config: i386-randconfig-r052-20241006 (https://download.01.org/0day-ci/archive/20241006/202410060426.e9Xsnkvi-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241006/202410060426.e9Xsnkvi-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410060426.e9Xsnkvi-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/x86/kvm/vmx/vmx.c:759:2: error: use of undeclared identifier 'kvm_rebooting'
     759 |         kvm_rebooting = true;
         |         ^
>> arch/x86/kvm/vmx/vmx.c:5903:7: error: call to undeclared function '__xfer_to_guest_mode_work_pending'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    5903 |                 if (__xfer_to_guest_mode_work_pending())
         |                     ^
>> arch/x86/kvm/vmx/vmx.c:6822:17: error: no member named 'mmu_invalidate_seq' in 'struct kvm'
    6822 |         mmu_seq = kvm->mmu_invalidate_seq;
         |                   ~~~  ^
>> arch/x86/kvm/vmx/vmx.c:6835:6: error: call to undeclared function 'mmu_invalidate_retry_gfn'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    6835 |         if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn)) {
         |             ^
   4 errors generated.
--
>> arch/x86/kvm/vmx/posted_intr.c:178:3: error: call to undeclared function '__apic_send_IPI_self'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     178 |                 __apic_send_IPI_self(POSTED_INTR_WAKEUP_VECTOR);
         |                 ^
>> arch/x86/kvm/vmx/posted_intr.c:286:33: error: no member named 'irq_routing' in 'struct kvm'
     286 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:527:10: note: expanded from macro '__rcu_dereference_check'
     527 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
         |                 ^
>> arch/x86/kvm/vmx/posted_intr.c:286:33: error: no member named 'irq_routing' in 'struct kvm'
     286 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:527:31: note: expanded from macro '__rcu_dereference_check'
     527 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
         |                                      ^
>> arch/x86/kvm/vmx/posted_intr.c:286:33: error: no member named 'irq_routing' in 'struct kvm'
     286 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:527:53: note: expanded from macro '__rcu_dereference_check'
     527 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
         |                                                            ^
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/compiler_types.h:510:22: note: expanded from macro 'compiletime_assert'
     510 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                             ^~~~~~~~~
   include/linux/compiler_types.h:498:23: note: expanded from macro '_compiletime_assert'
     498 |         __compiletime_assert(condition, msg, prefix, suffix)
         |                              ^~~~~~~~~
   include/linux/compiler_types.h:490:9: note: expanded from macro '__compiletime_assert'
     490 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
>> arch/x86/kvm/vmx/posted_intr.c:286:33: error: no member named 'irq_routing' in 'struct kvm'
     286 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:527:53: note: expanded from macro '__rcu_dereference_check'
     527 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
         |                                                            ^
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/compiler_types.h:510:22: note: expanded from macro 'compiletime_assert'
     510 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                             ^~~~~~~~~
   include/linux/compiler_types.h:498:23: note: expanded from macro '_compiletime_assert'
     498 |         __compiletime_assert(condition, msg, prefix, suffix)
         |                              ^~~~~~~~~
   include/linux/compiler_types.h:490:9: note: expanded from macro '__compiletime_assert'
     490 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
>> arch/x86/kvm/vmx/posted_intr.c:286:33: error: no member named 'irq_routing' in 'struct kvm'
     286 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:527:53: note: expanded from macro '__rcu_dereference_check'
     527 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
         |                                                            ^
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/compiler_types.h:510:22: note: expanded from macro 'compiletime_assert'
     510 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                             ^~~~~~~~~
   include/linux/compiler_types.h:498:23: note: expanded from macro '_compiletime_assert'
     498 |         __compiletime_assert(condition, msg, prefix, suffix)
         |                              ^~~~~~~~~
   include/linux/compiler_types.h:490:9: note: expanded from macro '__compiletime_assert'
     490 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
>> arch/x86/kvm/vmx/posted_intr.c:286:33: error: no member named 'irq_routing' in 'struct kvm'
     286 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:527:53: note: expanded from macro '__rcu_dereference_check'
     527 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
         |                                                            ^
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/compiler_types.h:510:22: note: expanded from macro 'compiletime_assert'
     510 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                             ^~~~~~~~~
   include/linux/compiler_types.h:498:23: note: expanded from macro '_compiletime_assert'
     498 |         __compiletime_assert(condition, msg, prefix, suffix)
         |                              ^~~~~~~~~
   include/linux/compiler_types.h:490:9: note: expanded from macro '__compiletime_assert'
     490 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
>> arch/x86/kvm/vmx/posted_intr.c:286:33: error: no member named 'irq_routing' in 'struct kvm'
     286 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:527:53: note: expanded from macro '__rcu_dereference_check'
     527 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
         |                                                            ^
   note: (skipping 2 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/compiler_types.h:510:22: note: expanded from macro 'compiletime_assert'
     510 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                             ^~~~~~~~~
   include/linux/compiler_types.h:498:23: note: expanded from macro '_compiletime_assert'
     498 |         __compiletime_assert(condition, msg, prefix, suffix)
         |                              ^~~~~~~~~
   include/linux/compiler_types.h:490:9: note: expanded from macro '__compiletime_assert'
     490 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
>> arch/x86/kvm/vmx/posted_intr.c:286:33: error: no member named 'irq_routing' in 'struct kvm'
     286 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:527:53: note: expanded from macro '__rcu_dereference_check'
     527 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
         |                                                            ^
   include/asm-generic/rwonce.h:50:14: note: expanded from macro 'READ_ONCE'
      50 |         __READ_ONCE(x);                                                 \
         |                     ^
   include/asm-generic/rwonce.h:44:65: note: expanded from macro '__READ_ONCE'
      44 | #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
         |                                                                  ^
   include/linux/compiler_types.h:466:13: note: expanded from macro '__unqual_scalar_typeof'
     466 |                 _Generic((x),                                           \
         |                           ^
>> arch/x86/kvm/vmx/posted_intr.c:286:33: error: no member named 'irq_routing' in 'struct kvm'
     286 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:527:53: note: expanded from macro '__rcu_dereference_check'
     527 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
         |                                                            ^
   include/asm-generic/rwonce.h:50:14: note: expanded from macro 'READ_ONCE'
      50 |         __READ_ONCE(x);                                                 \
         |                     ^
   include/asm-generic/rwonce.h:44:65: note: expanded from macro '__READ_ONCE'
      44 | #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
         |                                                                  ^
   include/linux/compiler_types.h:473:15: note: expanded from macro '__unqual_scalar_typeof'
     473 |                          default: (x)))
         |                                    ^
>> arch/x86/kvm/vmx/posted_intr.c:286:33: error: no member named 'irq_routing' in 'struct kvm'
     286 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:527:53: note: expanded from macro '__rcu_dereference_check'
     527 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
         |                                                            ^
   include/asm-generic/rwonce.h:50:14: note: expanded from macro 'READ_ONCE'
      50 |         __READ_ONCE(x);                                                 \
         |                     ^
   include/asm-generic/rwonce.h:44:72: note: expanded from macro '__READ_ONCE'
      44 | #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
         |                                                                         ^
>> arch/x86/kvm/vmx/posted_intr.c:286:33: error: no member named 'irq_routing' in 'struct kvm'
     286 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:530:12: note: expanded from macro '__rcu_dereference_check'
     530 |         ((typeof(*p) __force __kernel *)(local)); \
         |                   ^
>> arch/x86/kvm/vmx/posted_intr.c:286:9: error: assigning to 'struct kvm_irq_routing_table *' from incompatible type 'void'
     286 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/x86/kvm/vmx/posted_intr.c:287:25: error: incomplete definition of type 'struct kvm_irq_routing_table'
     287 |         if (guest_irq >= irq_rt->nr_rt_entries ||
         |                          ~~~~~~^
   include/linux/kvm_types.h:11:8: note: forward declaration of 'struct kvm_irq_routing_table'
      11 | struct kvm_irq_routing_table;
         |        ^
   arch/x86/kvm/vmx/posted_intr.c:288:25: error: incomplete definition of type 'struct kvm_irq_routing_table'
     288 |             hlist_empty(&irq_rt->map[guest_irq])) {
         |                          ~~~~~~^
   include/linux/kvm_types.h:11:8: note: forward declaration of 'struct kvm_irq_routing_table'
      11 | struct kvm_irq_routing_table;
         |        ^
   arch/x86/kvm/vmx/posted_intr.c:290:26: error: incomplete definition of type 'struct kvm_irq_routing_table'
     290 |                              guest_irq, irq_rt->nr_rt_entries);
         |                                         ~~~~~~^
   include/linux/printk.h:623:42: note: expanded from macro 'pr_warn_once'
     623 |         printk_once(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
         |                                                 ^~~~~~~~~~~
   include/linux/printk.h:604:30: note: expanded from macro 'printk_once'
     604 |         DO_ONCE_LITE(printk, fmt, ##__VA_ARGS__)
         |                                     ^~~~~~~~~~~
   include/linux/once_lite.h:11:32: note: expanded from macro 'DO_ONCE_LITE'
      11 |         DO_ONCE_LITE_IF(true, func, ##__VA_ARGS__)
         |                                       ^~~~~~~~~~~
   include/linux/once_lite.h:31:9: note: expanded from macro 'DO_ONCE_LITE_IF'
      31 |                         func(__VA_ARGS__);                              \
         |                              ^~~~~~~~~~~
   include/linux/printk.h:465:60: note: expanded from macro 'printk'
     465 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                            ^~~~~~~~~~~
   include/linux/printk.h:437:19: note: expanded from macro 'printk_index_wrap'
     437 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/kvm_types.h:11:8: note: forward declaration of 'struct kvm_irq_routing_table'
      11 | struct kvm_irq_routing_table;
         |        ^
   arch/x86/kvm/vmx/posted_intr.c:294:33: error: incomplete definition of type 'struct kvm_irq_routing_table'
     294 |         hlist_for_each_entry(e, &irq_rt->map[guest_irq], link) {
         |                                  ~~~~~~^
   include/linux/list.h:1163:31: note: expanded from macro 'hlist_for_each_entry'
    1163 |         for (pos = hlist_entry_safe((head)->first, typeof(*(pos)), member);\
         |                                      ^~~~
   include/linux/list.h:1152:12: note: expanded from macro 'hlist_entry_safe'
    1152 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                   ^~~
   include/linux/kvm_types.h:11:8: note: forward declaration of 'struct kvm_irq_routing_table'
      11 | struct kvm_irq_routing_table;
         |        ^
   arch/x86/kvm/vmx/posted_intr.c:294:33: error: incomplete definition of type 'struct kvm_irq_routing_table'
     294 |         hlist_for_each_entry(e, &irq_rt->map[guest_irq], link) {
         |                                  ~~~~~~^
   include/linux/list.h:1163:31: note: expanded from macro 'hlist_for_each_entry'
    1163 |         for (pos = hlist_entry_safe((head)->first, typeof(*(pos)), member);\
         |                                      ^~~~
   include/linux/list.h:1152:28: note: expanded from macro 'hlist_entry_safe'
    1152 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                                   ^~~
   include/linux/kvm_types.h:11:8: note: forward declaration of 'struct kvm_irq_routing_table'
      11 | struct kvm_irq_routing_table;
         |        ^
   18 errors generated.
--
>> arch/x86/kvm/svm/svm.c:597:2: error: use of undeclared identifier 'kvm_rebooting'
     597 |         kvm_rebooting = true;
         |         ^
   1 error generated.
--
>> arch/x86/kvm/svm/avic.c:909:33: error: no member named 'irq_routing' in 'struct kvm'
     909 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:527:10: note: expanded from macro '__rcu_dereference_check'
     527 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
         |                 ^
>> arch/x86/kvm/svm/avic.c:909:33: error: no member named 'irq_routing' in 'struct kvm'
     909 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:527:31: note: expanded from macro '__rcu_dereference_check'
     527 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
         |                                      ^
>> arch/x86/kvm/svm/avic.c:909:33: error: no member named 'irq_routing' in 'struct kvm'
     909 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:527:53: note: expanded from macro '__rcu_dereference_check'
     527 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
         |                                                            ^
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/compiler_types.h:510:22: note: expanded from macro 'compiletime_assert'
     510 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                             ^~~~~~~~~
   include/linux/compiler_types.h:498:23: note: expanded from macro '_compiletime_assert'
     498 |         __compiletime_assert(condition, msg, prefix, suffix)
         |                              ^~~~~~~~~
   include/linux/compiler_types.h:490:9: note: expanded from macro '__compiletime_assert'
     490 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
>> arch/x86/kvm/svm/avic.c:909:33: error: no member named 'irq_routing' in 'struct kvm'
     909 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:527:53: note: expanded from macro '__rcu_dereference_check'
     527 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
         |                                                            ^
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/compiler_types.h:510:22: note: expanded from macro 'compiletime_assert'
     510 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                             ^~~~~~~~~
   include/linux/compiler_types.h:498:23: note: expanded from macro '_compiletime_assert'
     498 |         __compiletime_assert(condition, msg, prefix, suffix)
         |                              ^~~~~~~~~
   include/linux/compiler_types.h:490:9: note: expanded from macro '__compiletime_assert'
     490 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
>> arch/x86/kvm/svm/avic.c:909:33: error: no member named 'irq_routing' in 'struct kvm'
     909 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:527:53: note: expanded from macro '__rcu_dereference_check'
     527 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
         |                                                            ^
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/compiler_types.h:510:22: note: expanded from macro 'compiletime_assert'
     510 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                             ^~~~~~~~~
   include/linux/compiler_types.h:498:23: note: expanded from macro '_compiletime_assert'
     498 |         __compiletime_assert(condition, msg, prefix, suffix)
         |                              ^~~~~~~~~
   include/linux/compiler_types.h:490:9: note: expanded from macro '__compiletime_assert'
     490 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
>> arch/x86/kvm/svm/avic.c:909:33: error: no member named 'irq_routing' in 'struct kvm'
     909 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:527:53: note: expanded from macro '__rcu_dereference_check'
     527 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
         |                                                            ^
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/compiler_types.h:510:22: note: expanded from macro 'compiletime_assert'
     510 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                             ^~~~~~~~~
   include/linux/compiler_types.h:498:23: note: expanded from macro '_compiletime_assert'
     498 |         __compiletime_assert(condition, msg, prefix, suffix)
         |                              ^~~~~~~~~
   include/linux/compiler_types.h:490:9: note: expanded from macro '__compiletime_assert'
     490 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
>> arch/x86/kvm/svm/avic.c:909:33: error: no member named 'irq_routing' in 'struct kvm'
     909 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:527:53: note: expanded from macro '__rcu_dereference_check'
     527 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
         |                                                            ^
   note: (skipping 2 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/compiler_types.h:510:22: note: expanded from macro 'compiletime_assert'
     510 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                             ^~~~~~~~~
   include/linux/compiler_types.h:498:23: note: expanded from macro '_compiletime_assert'
     498 |         __compiletime_assert(condition, msg, prefix, suffix)
         |                              ^~~~~~~~~
   include/linux/compiler_types.h:490:9: note: expanded from macro '__compiletime_assert'
     490 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
>> arch/x86/kvm/svm/avic.c:909:33: error: no member named 'irq_routing' in 'struct kvm'
     909 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:527:53: note: expanded from macro '__rcu_dereference_check'
     527 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
         |                                                            ^
   include/asm-generic/rwonce.h:50:14: note: expanded from macro 'READ_ONCE'
      50 |         __READ_ONCE(x);                                                 \
         |                     ^
   include/asm-generic/rwonce.h:44:65: note: expanded from macro '__READ_ONCE'
      44 | #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
         |                                                                  ^
   include/linux/compiler_types.h:466:13: note: expanded from macro '__unqual_scalar_typeof'
     466 |                 _Generic((x),                                           \
         |                           ^
>> arch/x86/kvm/svm/avic.c:909:33: error: no member named 'irq_routing' in 'struct kvm'
     909 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:527:53: note: expanded from macro '__rcu_dereference_check'
     527 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
         |                                                            ^
   include/asm-generic/rwonce.h:50:14: note: expanded from macro 'READ_ONCE'
      50 |         __READ_ONCE(x);                                                 \
         |                     ^
   include/asm-generic/rwonce.h:44:65: note: expanded from macro '__READ_ONCE'
      44 | #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
         |                                                                  ^
   include/linux/compiler_types.h:473:15: note: expanded from macro '__unqual_scalar_typeof'
     473 |                          default: (x)))
         |                                    ^
>> arch/x86/kvm/svm/avic.c:909:33: error: no member named 'irq_routing' in 'struct kvm'
     909 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:527:53: note: expanded from macro '__rcu_dereference_check'
     527 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
         |                                                            ^
   include/asm-generic/rwonce.h:50:14: note: expanded from macro 'READ_ONCE'
      50 |         __READ_ONCE(x);                                                 \
         |                     ^
   include/asm-generic/rwonce.h:44:72: note: expanded from macro '__READ_ONCE'
      44 | #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
         |                                                                         ^
>> arch/x86/kvm/svm/avic.c:909:33: error: no member named 'irq_routing' in 'struct kvm'
     909 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                                   ~~~  ^
   include/linux/srcu.h:217:58: note: expanded from macro 'srcu_dereference'
     217 | #define srcu_dereference(p, ssp) srcu_dereference_check((p), (ssp), 0)
         |                                                          ^
   include/linux/srcu.h:204:27: note: expanded from macro 'srcu_dereference_check'
     204 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
         |                                  ^
   include/linux/rcupdate.h:530:12: note: expanded from macro '__rcu_dereference_check'
     530 |         ((typeof(*p) __force __kernel *)(local)); \
         |                   ^
>> arch/x86/kvm/svm/avic.c:909:9: error: assigning to 'struct kvm_irq_routing_table *' from incompatible type 'void'
     909 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
         |                ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/x86/kvm/svm/avic.c:911:25: error: incomplete definition of type 'struct kvm_irq_routing_table'
     911 |         if (guest_irq >= irq_rt->nr_rt_entries ||
         |                          ~~~~~~^
   include/linux/kvm_types.h:11:8: note: forward declaration of 'struct kvm_irq_routing_table'
      11 | struct kvm_irq_routing_table;
         |        ^
   arch/x86/kvm/svm/avic.c:912:22: error: incomplete definition of type 'struct kvm_irq_routing_table'
     912 |                 hlist_empty(&irq_rt->map[guest_irq])) {
         |                              ~~~~~~^
   include/linux/kvm_types.h:11:8: note: forward declaration of 'struct kvm_irq_routing_table'
      11 | struct kvm_irq_routing_table;
         |        ^
   arch/x86/kvm/svm/avic.c:914:26: error: incomplete definition of type 'struct kvm_irq_routing_table'
     914 |                              guest_irq, irq_rt->nr_rt_entries);
         |                                         ~~~~~~^
   include/linux/printk.h:623:42: note: expanded from macro 'pr_warn_once'
     623 |         printk_once(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
         |                                                 ^~~~~~~~~~~
   include/linux/printk.h:604:30: note: expanded from macro 'printk_once'
     604 |         DO_ONCE_LITE(printk, fmt, ##__VA_ARGS__)
         |                                     ^~~~~~~~~~~
   include/linux/once_lite.h:11:32: note: expanded from macro 'DO_ONCE_LITE'
      11 |         DO_ONCE_LITE_IF(true, func, ##__VA_ARGS__)
         |                                       ^~~~~~~~~~~
   include/linux/once_lite.h:31:9: note: expanded from macro 'DO_ONCE_LITE_IF'
      31 |                         func(__VA_ARGS__);                              \
         |                              ^~~~~~~~~~~
   include/linux/printk.h:465:60: note: expanded from macro 'printk'
     465 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                            ^~~~~~~~~~~
   include/linux/printk.h:437:19: note: expanded from macro 'printk_index_wrap'
     437 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/kvm_types.h:11:8: note: forward declaration of 'struct kvm_irq_routing_table'
      11 | struct kvm_irq_routing_table;
         |        ^
   arch/x86/kvm/svm/avic.c:918:33: error: incomplete definition of type 'struct kvm_irq_routing_table'
     918 |         hlist_for_each_entry(e, &irq_rt->map[guest_irq], link) {
         |                                  ~~~~~~^
   include/linux/list.h:1163:31: note: expanded from macro 'hlist_for_each_entry'
    1163 |         for (pos = hlist_entry_safe((head)->first, typeof(*(pos)), member);\
         |                                      ^~~~
   include/linux/list.h:1152:12: note: expanded from macro 'hlist_entry_safe'
    1152 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                   ^~~
   include/linux/kvm_types.h:11:8: note: forward declaration of 'struct kvm_irq_routing_table'
      11 | struct kvm_irq_routing_table;
         |        ^
   arch/x86/kvm/svm/avic.c:918:33: error: incomplete definition of type 'struct kvm_irq_routing_table'
     918 |         hlist_for_each_entry(e, &irq_rt->map[guest_irq], link) {
         |                                  ~~~~~~^
   include/linux/list.h:1163:31: note: expanded from macro 'hlist_for_each_entry'
    1163 |         for (pos = hlist_entry_safe((head)->first, typeof(*(pos)), member);\
         |                                      ^~~~
   include/linux/list.h:1152:28: note: expanded from macro 'hlist_entry_safe'
    1152 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                                   ^~~
   include/linux/kvm_types.h:11:8: note: forward declaration of 'struct kvm_irq_routing_table'
      11 | struct kvm_irq_routing_table;
         |        ^
   17 errors generated.


vim +/kvm_rebooting +759 arch/x86/kvm/vmx/vmx.c

22e420e127399f arch/x86/kvm/vmx/vmx.c Sean Christopherson 2023-07-21  753  
590b09b1d88e18 arch/x86/kvm/vmx/vmx.c Sean Christopherson 2024-08-29  754  void vmx_emergency_disable_virtualization_cpu(void)
8f536b7697a0d4 arch/x86/kvm/vmx.c     Zhang Yanfei        2012-12-06  755  {
8f536b7697a0d4 arch/x86/kvm/vmx.c     Zhang Yanfei        2012-12-06  756  	int cpu = raw_smp_processor_id();
8f536b7697a0d4 arch/x86/kvm/vmx.c     Zhang Yanfei        2012-12-06  757  	struct loaded_vmcs *v;
8f536b7697a0d4 arch/x86/kvm/vmx.c     Zhang Yanfei        2012-12-06  758  
6ae44e012f4c35 arch/x86/kvm/vmx/vmx.c Sean Christopherson 2023-07-21 @759  	kvm_rebooting = true;
6ae44e012f4c35 arch/x86/kvm/vmx/vmx.c Sean Christopherson 2023-07-21  760  
a788fbb763b500 arch/x86/kvm/vmx/vmx.c Sean Christopherson 2023-07-21  761  	/*
a788fbb763b500 arch/x86/kvm/vmx/vmx.c Sean Christopherson 2023-07-21  762  	 * Note, CR4.VMXE can be _cleared_ in NMI context, but it can only be
a788fbb763b500 arch/x86/kvm/vmx/vmx.c Sean Christopherson 2023-07-21  763  	 * set in task context.  If this races with VMX is disabled by an NMI,
a788fbb763b500 arch/x86/kvm/vmx/vmx.c Sean Christopherson 2023-07-21  764  	 * VMCLEAR and VMXOFF may #UD, but KVM will eat those faults due to
a788fbb763b500 arch/x86/kvm/vmx/vmx.c Sean Christopherson 2023-07-21  765  	 * kvm_rebooting set.
a788fbb763b500 arch/x86/kvm/vmx/vmx.c Sean Christopherson 2023-07-21  766  	 */
a788fbb763b500 arch/x86/kvm/vmx/vmx.c Sean Christopherson 2023-07-21  767  	if (!(__read_cr4() & X86_CR4_VMXE))
a788fbb763b500 arch/x86/kvm/vmx/vmx.c Sean Christopherson 2023-07-21  768  		return;
a788fbb763b500 arch/x86/kvm/vmx/vmx.c Sean Christopherson 2023-07-21  769  
8f536b7697a0d4 arch/x86/kvm/vmx.c     Zhang Yanfei        2012-12-06  770  	list_for_each_entry(v, &per_cpu(loaded_vmcss_on_cpu, cpu),
8f536b7697a0d4 arch/x86/kvm/vmx.c     Zhang Yanfei        2012-12-06  771  			    loaded_vmcss_on_cpu_link)
8f536b7697a0d4 arch/x86/kvm/vmx.c     Zhang Yanfei        2012-12-06  772  		vmcs_clear(v->vmcs);
119b5cb4ffd016 arch/x86/kvm/vmx/vmx.c Sean Christopherson 2023-07-21  773  
22e420e127399f arch/x86/kvm/vmx/vmx.c Sean Christopherson 2023-07-21  774  	kvm_cpu_vmxoff();
8f536b7697a0d4 arch/x86/kvm/vmx.c     Zhang Yanfei        2012-12-06  775  }
8f536b7697a0d4 arch/x86/kvm/vmx.c     Zhang Yanfei        2012-12-06  776  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

