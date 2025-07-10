Return-Path: <kvm+bounces-52006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 42454AFF667
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 03:26:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 457C27B7133
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 01:24:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B998B2701D8;
	Thu, 10 Jul 2025 01:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XHIJjma+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C6F230997;
	Thu, 10 Jul 2025 01:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752110755; cv=none; b=krDtVcLt75BHlKXtiWKDTPbpHqaGQMa6IcicpGPPj4uxkOPgqrIaCHtjd4CBkAwvDUJJcUaOyinJMXlCIp03mk0a9QCPd2KoX9Q6dTQ8Kw2qOKbE7FuUGTgISHQ/AHaZvlZ9/PueG5mtfByKJ8iYQxI32Fkt9Pr97bPqYVVL8KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752110755; c=relaxed/simple;
	bh=c3o3o5MgoZYDwVx/0ytOtVFtAUqCATZ4t7Y9Efk3G7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DlgFSPrf2VxOdWaT6mfHRacQT4b8QYNSZXa1UmEVFC0p9ySQrkudr/rREVBZUVmq2+cL5ykg0H7N+Vj1mFT974JTxtXn5mOgffCh0ROKmOYWw/SwGAYCzYFiPlbxOiUuKIIolxn+ABW+DSiJZCxwJNxpob5FSvg5ZIxNB38FZKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XHIJjma+; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752110754; x=1783646754;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=c3o3o5MgoZYDwVx/0ytOtVFtAUqCATZ4t7Y9Efk3G7A=;
  b=XHIJjma+fk8EH5pM/dker890uDziDvLjhaOJLRoBth7iuxa81raHoAFz
   wQGgbpCfNXjZ83G8DwU/gWkR0UD1/w1gPN9q1svQFH9nW2uv2DJumtxnh
   bpq77h9zdmA0JLT1OIZtDCyQhLMGz52phaz7JJvwGIqE4CB/qesc/edtr
   9L9LtSNWIlb26ftm5KHG/6/Qa0gHpY7Nev02Tldw/qXennil6+hkIQRa9
   B+zENOgL3ISp7bmRzt2dJV7IFTs/Do12jUD4+uXdyWRezzlLY4NuCYxM5
   tVuQkVgx8H/bynOBr/CbiGjLqWHGNS2VTWmw4RJvXOe9tcwKuoCYrHkbH
   Q==;
X-CSE-ConnectionGUID: eHi9ySmxSMul5fA901RegQ==
X-CSE-MsgGUID: +WDUqpHETmKnZgzRRvabhQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="58048147"
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="58048147"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 18:25:53 -0700
X-CSE-ConnectionGUID: r+oFE+c+Q6SJBTij1pblqw==
X-CSE-MsgGUID: hcN+cDC2QEiYF/r1fFfVlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="156269224"
Received: from lkp-server01.sh.intel.com (HELO 9ee84586c615) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 09 Jul 2025 18:25:48 -0700
Received: from kbuild by 9ee84586c615 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uZg2k-0004JD-23;
	Thu, 10 Jul 2025 01:25:46 +0000
Date: Thu, 10 Jul 2025 09:25:03 +0800
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
Message-ID: <202507100824.oV2rHgt9-lkp@intel.com>
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

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on kvm/next kvm/linux-next linus/master v6.16-rc5 next-20250709]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Suleiman-Souhlal/KVM-x86-Advance-guest-TSC-after-deep-suspend/20250709-150751
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20250709070450.473297-2-suleiman%40google.com
patch subject: [PATCH v6 1/3] KVM: x86: Advance guest TSC after deep suspend.
config: i386-buildonly-randconfig-002-20250710 (https://download.01.org/0day-ci/archive/20250710/202507100824.oV2rHgt9-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250710/202507100824.oV2rHgt9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507100824.oV2rHgt9-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kvm/x86.c: In function 'kvm_arch_vcpu_load':
>> arch/x86/kvm/x86.c:5044:27: error: implicit declaration of function 'kvm_get_time_and_clockread'; did you mean 'kvm_get_monotonic_and_clockread'? [-Werror=implicit-function-declaration]
    5044 |                 advance = kvm_get_time_and_clockread(&kernel_ns, &tsc_now);
         |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~
         |                           kvm_get_monotonic_and_clockread
>> arch/x86/kvm/x86.c:5062:17: error: 'kvm' undeclared (first use in this function)
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
>> arch/x86/kvm/x86.c:5063:71: error: 'flags' undeclared (first use in this function)
    5063 |                 raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
         |                                                                       ^~~~~
   include/linux/typecheck.h:11:16: note: in definition of macro 'typecheck'
      11 |         typeof(x) __dummy2; \
         |                ^
   arch/x86/kvm/x86.c:5063:17: note: in expansion of macro 'raw_spin_unlock_irqrestore'
    5063 |                 raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/typecheck.h:12:25: warning: comparison of distinct pointer types lacks a cast
      12 |         (void)(&__dummy == &__dummy2); \
         |                         ^~
   include/linux/spinlock.h:281:17: note: in expansion of macro 'typecheck'
     281 |                 typecheck(unsigned long, flags);                \
         |                 ^~~~~~~~~
   arch/x86/kvm/x86.c:5063:17: note: in expansion of macro 'raw_spin_unlock_irqrestore'
    5063 |                 raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/kvm/x86.c: At top level:
>> arch/x86/kvm/x86.c:5068:9: error: expected identifier or '(' before 'if'
    5068 |         if (unlikely(vcpu->cpu != cpu) || kvm_check_tsc_unstable()) {
         |         ^~
>> include/linux/kvm_host.h:182:39: error: expected declaration specifiers or '...' before '(' token
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
>> arch/x86/kvm/x86.c:5096:48: error: unknown type name 'vcpu'
    5096 |         kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
         |                                                ^~~~
>> arch/x86/kvm/x86.c:5097:1: error: expected identifier or '(' before '}' token
    5097 | }
         | ^
   cc1: some warnings being treated as errors


vim +5044 arch/x86/kvm/x86.c

  4997	
  4998	void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
  4999	{
  5000		struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
  5001	
  5002		vcpu->arch.l1tf_flush_l1d = true;
  5003	
  5004		if (vcpu->scheduled_out && pmu->version && pmu->event_count) {
  5005			pmu->need_cleanup = true;
  5006			kvm_make_request(KVM_REQ_PMU, vcpu);
  5007		}
  5008	
  5009		/* Address WBINVD may be executed by guest */
  5010		if (need_emulate_wbinvd(vcpu)) {
  5011			if (kvm_x86_call(has_wbinvd_exit)())
  5012				cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
  5013			else if (vcpu->cpu != -1 && vcpu->cpu != cpu)
  5014				smp_call_function_single(vcpu->cpu,
  5015						wbinvd_ipi, NULL, 1);
  5016		}
  5017	
  5018		kvm_x86_call(vcpu_load)(vcpu, cpu);
  5019	
  5020		if (vcpu != per_cpu(last_vcpu, cpu)) {
  5021			/*
  5022			 * Flush the branch predictor when switching vCPUs on the same
  5023			 * physical CPU, as each vCPU needs its own branch prediction
  5024			 * domain.  No IBPB is needed when switching between L1 and L2
  5025			 * on the same vCPU unless IBRS is advertised to the vCPU; that
  5026			 * is handled on the nested VM-Exit path.
  5027			 */
  5028			if (static_branch_likely(&switch_vcpu_ibpb))
  5029				indirect_branch_prediction_barrier();
  5030			per_cpu(last_vcpu, cpu) = vcpu;
  5031		}
  5032	
  5033		/* Save host pkru register if supported */
  5034		vcpu->arch.host_pkru = read_pkru();
  5035	
  5036		/* Apply any externally detected TSC adjustments (due to suspend) */
  5037		if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
  5038			unsigned long flags;
  5039			struct kvm *kvm;
  5040			bool advance;
  5041			u64 kernel_ns, l1_tsc, offset, tsc_now;
  5042	
  5043			kvm = vcpu->kvm;
> 5044			advance = kvm_get_time_and_clockread(&kernel_ns, &tsc_now);
  5045			raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
  5046			/*
  5047			 * Advance the guest's TSC to current time instead of only
  5048			 * preventing it from going backwards, while making sure
  5049			 * all the vCPUs use the same offset.
  5050			 */
  5051			if (kvm->arch.host_was_suspended && advance) {
  5052				l1_tsc = nsec_to_cycles(vcpu,
  5053							kvm->arch.kvmclock_offset + kernel_ns);
  5054				offset = kvm_compute_l1_tsc_offset(vcpu, l1_tsc);
  5055				kvm->arch.cur_tsc_offset = offset;
  5056				kvm_vcpu_write_tsc_offset(vcpu, offset);
  5057			} else if (advance)
  5058				kvm_vcpu_write_tsc_offset(vcpu, kvm->arch.cur_tsc_offset);
  5059			} else {
  5060				adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
  5061			}
> 5062			kvm->arch.host_was_suspended = false;
> 5063			raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
  5064			vcpu->arch.tsc_offset_adjustment = 0;
  5065			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
  5066		}
  5067	
> 5068		if (unlikely(vcpu->cpu != cpu) || kvm_check_tsc_unstable()) {
  5069			s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
  5070					rdtsc() - vcpu->arch.last_host_tsc;
  5071			if (tsc_delta < 0)
  5072				mark_tsc_unstable("KVM discovered backwards TSC");
  5073	
  5074			if (kvm_check_tsc_unstable()) {
  5075				u64 offset = kvm_compute_l1_tsc_offset(vcpu,
  5076							vcpu->arch.last_guest_tsc);
  5077				kvm_vcpu_write_tsc_offset(vcpu, offset);
  5078				if (!vcpu->arch.guest_tsc_protected)
  5079					vcpu->arch.tsc_catchup = 1;
  5080			}
  5081	
  5082			if (kvm_lapic_hv_timer_in_use(vcpu))
  5083				kvm_lapic_restart_hv_timer(vcpu);
  5084	
  5085			/*
  5086			 * On a host with synchronized TSC, there is no need to update
  5087			 * kvmclock on vcpu->cpu migration
  5088			 */
  5089			if (!vcpu->kvm->arch.use_master_clock || vcpu->cpu == -1)
  5090				kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
  5091			if (vcpu->cpu != cpu)
  5092				kvm_make_request(KVM_REQ_MIGRATE_TIMER, vcpu);
  5093			vcpu->cpu = cpu;
  5094		}
  5095	
> 5096		kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
> 5097	}
  5098	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

