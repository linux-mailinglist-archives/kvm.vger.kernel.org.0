Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A937A559F0
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 23:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfFYV33 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 17:29:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:5376 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfFYV33 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 17:29:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jun 2019 14:29:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,417,1557212400"; 
   d="scan'208";a="172501044"
Received: from ray.jf.intel.com (HELO [10.7.201.139]) ([10.7.201.139])
  by orsmga002.jf.intel.com with ESMTP; 25 Jun 2019 14:29:23 -0700
Subject: Re: [PATCH 4/9] x86/mm/tlb: Flush remote and local TLBs concurrently
To:     Nadav Amit <namit@vmware.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
References: <20190613064813.8102-1-namit@vmware.com>
 <20190613064813.8102-5-namit@vmware.com>
From:   Dave Hansen <dave.hansen@intel.com>
Openpgp: preference=signencrypt
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
Message-ID: <723d63ee-c8cb-14a1-0eb9-265e580360f4@intel.com>
Date:   Tue, 25 Jun 2019 14:29:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190613064813.8102-5-namit@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/12/19 11:48 PM, Nadav Amit wrote:
> To improve TLB shootdown performance, flush the remote and local TLBs
> concurrently. Introduce flush_tlb_multi() that does so. The current
> flush_tlb_others() interface is kept, since paravirtual interfaces need
> to be adapted first before it can be removed. This is left for future
> work. In such PV environments, TLB flushes are not performed, at this
> time, concurrently.
> 
> Add a static key to tell whether this new interface is supported.
> 
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Stephen Hemminger <sthemmin@microsoft.com>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: x86@kernel.org
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: linux-hyperv@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: virtualization@lists.linux-foundation.org
> Cc: kvm@vger.kernel.org
> Cc: xen-devel@lists.xenproject.org
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  arch/x86/hyperv/mmu.c                 |  2 +
>  arch/x86/include/asm/paravirt.h       |  8 +++
>  arch/x86/include/asm/paravirt_types.h |  6 +++
>  arch/x86/include/asm/tlbflush.h       |  6 +++
>  arch/x86/kernel/kvm.c                 |  1 +
>  arch/x86/kernel/paravirt.c            |  3 ++
>  arch/x86/mm/tlb.c                     | 71 ++++++++++++++++++++++-----
>  arch/x86/xen/mmu_pv.c                 |  2 +
>  8 files changed, 87 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/hyperv/mmu.c b/arch/x86/hyperv/mmu.c
> index e65d7fe6489f..ca28b400c87c 100644
> --- a/arch/x86/hyperv/mmu.c
> +++ b/arch/x86/hyperv/mmu.c
> @@ -233,4 +233,6 @@ void hyperv_setup_mmu_ops(void)
>  	pr_info("Using hypercall for remote TLB flush\n");
>  	pv_ops.mmu.flush_tlb_others = hyperv_flush_tlb_others;
>  	pv_ops.mmu.tlb_remove_table = tlb_remove_table;
> +
> +	static_key_disable(&flush_tlb_multi_enabled.key);
>  }
> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
> index c25c38a05c1c..192be7254457 100644
> --- a/arch/x86/include/asm/paravirt.h
> +++ b/arch/x86/include/asm/paravirt.h
> @@ -47,6 +47,8 @@ static inline void slow_down_io(void)
>  #endif
>  }
>  
> +DECLARE_STATIC_KEY_TRUE(flush_tlb_multi_enabled);
> +
>  static inline void __flush_tlb(void)
>  {
>  	PVOP_VCALL0(mmu.flush_tlb_user);
> @@ -62,6 +64,12 @@ static inline void __flush_tlb_one_user(unsigned long addr)
>  	PVOP_VCALL1(mmu.flush_tlb_one_user, addr);
>  }
>  
> +static inline void flush_tlb_multi(const struct cpumask *cpumask,
> +				   const struct flush_tlb_info *info)
> +{
> +	PVOP_VCALL2(mmu.flush_tlb_multi, cpumask, info);
> +}
> +
>  static inline void flush_tlb_others(const struct cpumask *cpumask,
>  				    const struct flush_tlb_info *info)
>  {
> diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
> index 946f8f1f1efc..b93b3d90729a 100644
> --- a/arch/x86/include/asm/paravirt_types.h
> +++ b/arch/x86/include/asm/paravirt_types.h
> @@ -211,6 +211,12 @@ struct pv_mmu_ops {
>  	void (*flush_tlb_user)(void);
>  	void (*flush_tlb_kernel)(void);
>  	void (*flush_tlb_one_user)(unsigned long addr);
> +	/*
> +	 * flush_tlb_multi() is the preferred interface, which is capable to
> +	 * flush both local and remote CPUs.
> +	 */
> +	void (*flush_tlb_multi)(const struct cpumask *cpus,
> +				const struct flush_tlb_info *info);
>  	void (*flush_tlb_others)(const struct cpumask *cpus,
>  				 const struct flush_tlb_info *info);
>  
> diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
> index dee375831962..79272938cf79 100644
> --- a/arch/x86/include/asm/tlbflush.h
> +++ b/arch/x86/include/asm/tlbflush.h
> @@ -569,6 +569,9 @@ static inline void flush_tlb_page(struct vm_area_struct *vma, unsigned long a)
>  	flush_tlb_mm_range(vma->vm_mm, a, a + PAGE_SIZE, PAGE_SHIFT, false);
>  }
>  
> +void native_flush_tlb_multi(const struct cpumask *cpumask,
> +			     const struct flush_tlb_info *info);
> +
>  void native_flush_tlb_others(const struct cpumask *cpumask,
>  			     const struct flush_tlb_info *info);
>  
> @@ -593,6 +596,9 @@ static inline void arch_tlbbatch_add_mm(struct arch_tlbflush_unmap_batch *batch,
>  extern void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch);
>  
>  #ifndef CONFIG_PARAVIRT
> +#define flush_tlb_multi(mask, info)	\
> +	native_flush_tlb_multi(mask, info)
> +
>  #define flush_tlb_others(mask, info)	\
>  	native_flush_tlb_others(mask, info)
>  
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 5169b8cc35bb..00d81e898717 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -630,6 +630,7 @@ static void __init kvm_guest_init(void)
>  	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
>  		pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
>  		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
> +		static_key_disable(&flush_tlb_multi_enabled.key);
>  	}
>  
>  	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> index 98039d7fb998..ac00afed5570 100644
> --- a/arch/x86/kernel/paravirt.c
> +++ b/arch/x86/kernel/paravirt.c
> @@ -159,6 +159,8 @@ unsigned paravirt_patch_insns(void *insn_buff, unsigned len,
>  	return insn_len;
>  }
>  
> +DEFINE_STATIC_KEY_TRUE(flush_tlb_multi_enabled);
> +
>  static void native_flush_tlb(void)
>  {
>  	__native_flush_tlb();
> @@ -363,6 +365,7 @@ struct paravirt_patch_template pv_ops = {
>  	.mmu.flush_tlb_user	= native_flush_tlb,
>  	.mmu.flush_tlb_kernel	= native_flush_tlb_global,
>  	.mmu.flush_tlb_one_user	= native_flush_tlb_one_user,
> +	.mmu.flush_tlb_multi	= native_flush_tlb_multi,
>  	.mmu.flush_tlb_others	= native_flush_tlb_others,
>  	.mmu.tlb_remove_table	=
>  			(void (*)(struct mmu_gather *, void *))tlb_remove_page,
> diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
> index c34bcf03f06f..db73d5f1dd43 100644
> --- a/arch/x86/mm/tlb.c
> +++ b/arch/x86/mm/tlb.c
> @@ -551,7 +551,7 @@ static void flush_tlb_func_common(const struct flush_tlb_info *f,
>  		 * garbage into our TLB.  Since switching to init_mm is barely
>  		 * slower than a minimal flush, just switch to init_mm.
>  		 *
> -		 * This should be rare, with native_flush_tlb_others skipping
> +		 * This should be rare, with native_flush_tlb_multi skipping
>  		 * IPIs to lazy TLB mode CPUs.
>  		 */

Nit, since we're messing with this, it can now be
"native_flush_tlb_multi()" since it is a function.

>  		switch_mm_irqs_off(NULL, &init_mm, NULL);
> @@ -635,9 +635,12 @@ static void flush_tlb_func_common(const struct flush_tlb_info *f,
>  	this_cpu_write(cpu_tlbstate.ctxs[loaded_mm_asid].tlb_gen, mm_tlb_gen);
>  }
>  
> -static void flush_tlb_func_local(const void *info, enum tlb_flush_reason reason)
> +static void flush_tlb_func_local(void *info)
>  {
>  	const struct flush_tlb_info *f = info;
> +	enum tlb_flush_reason reason;
> +
> +	reason = (f->mm == NULL) ? TLB_LOCAL_SHOOTDOWN : TLB_LOCAL_MM_SHOOTDOWN;

Should we just add the "reason" to flush_tlb_info?  It's OK-ish to imply
it like this, but seems like it would be nicer and easier to track down
the origins of these things if we did this at the caller.

>  	flush_tlb_func_common(f, true, reason);
>  }
> @@ -655,14 +658,21 @@ static void flush_tlb_func_remote(void *info)
>  	flush_tlb_func_common(f, false, TLB_REMOTE_SHOOTDOWN);
>  }
>  
> -static bool tlb_is_not_lazy(int cpu, void *data)
> +static inline bool tlb_is_not_lazy(int cpu)
>  {
>  	return !per_cpu(cpu_tlbstate.is_lazy, cpu);
>  }

Nit: the compiler will probably inline this sucker anyway.  So, for
these kinds of patches, I'd resist the urge to do these kinds of tweaks,
especially since it starts to hide the important change on the line.

> -void native_flush_tlb_others(const struct cpumask *cpumask,
> -			     const struct flush_tlb_info *info)
> +static DEFINE_PER_CPU(cpumask_t, flush_tlb_mask);
> +
> +void native_flush_tlb_multi(const struct cpumask *cpumask,
> +			    const struct flush_tlb_info *info)
>  {
> +	/*
> +	 * Do accounting and tracing. Note that there are (and have always been)
> +	 * cases in which a remote TLB flush will be traced, but eventually
> +	 * would not happen.
> +	 */
>  	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH);
>  	if (info->end == TLB_FLUSH_ALL)
>  		trace_tlb_flush(TLB_REMOTE_SEND_IPI, TLB_FLUSH_ALL);
> @@ -682,10 +692,14 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
>  		 * means that the percpu tlb_gen variables won't be updated
>  		 * and we'll do pointless flushes on future context switches.
>  		 *
> -		 * Rather than hooking native_flush_tlb_others() here, I think
> +		 * Rather than hooking native_flush_tlb_multi() here, I think
>  		 * that UV should be updated so that smp_call_function_many(),
>  		 * etc, are optimal on UV.
>  		 */
> +		local_irq_disable();
> +		flush_tlb_func_local((__force void *)info);
> +		local_irq_enable();
> +
>  		cpumask = uv_flush_tlb_others(cpumask, info);
>  		if (cpumask)
>  			smp_call_function_many(cpumask, flush_tlb_func_remote,
> @@ -704,11 +718,39 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
>  	 * doing a speculative memory access.
>  	 */
>  	if (info->freed_tables)
> -		smp_call_function_many(cpumask, flush_tlb_func_remote,
> -			       (void *)info, 1);
> -	else
> -		on_each_cpu_cond_mask(tlb_is_not_lazy, flush_tlb_func_remote,
> -				(void *)info, 1, GFP_ATOMIC, cpumask);
> +		__smp_call_function_many(cpumask, flush_tlb_func_remote,
> +					 flush_tlb_func_local, (void *)info, 1);
> +	else {

I prefer brackets be added for 'if' blocks like this since it doesn't
take up any meaningful space and makes it less prone to compile errors.

> +		/*
> +		 * Although we could have used on_each_cpu_cond_mask(),
> +		 * open-coding it has several performance advantages: (1) we can
> +		 * use specialized functions for remote and local flushes; (2)
> +		 * no need for indirect branch to test if TLB is lazy; (3) we
> +		 * can use a designated cpumask for evaluating the condition
> +		 * instead of allocating a new one.
> +		 *
> +		 * This works under the assumption that there are no nested TLB
> +		 * flushes, an assumption that is already made in
> +		 * flush_tlb_mm_range().
> +		 */
> +		struct cpumask *cond_cpumask = this_cpu_ptr(&flush_tlb_mask);

This is logically a stack-local variable, right?  But, since we've got
preempt off and cpumasks can be huge, we don't want to allocate it on
the stack.  That might be worth a comment somewhere.

> +		int cpu;
> +
> +		cpumask_clear(cond_cpumask);
> +
> +		for_each_cpu(cpu, cpumask) {
> +			if (tlb_is_not_lazy(cpu))
> +				__cpumask_set_cpu(cpu, cond_cpumask);
> +		}

FWIW, it's probably worth calling out in the changelog that this loop
exists in on_each_cpu_cond_mask() too.  It looks bad here, but it's no
worse than what it replaces.

> +		__smp_call_function_many(cond_cpumask, flush_tlb_func_remote,
> +					 flush_tlb_func_local, (void *)info, 1);
> +	}
> +}

There was a __force on an earlier 'info' cast.  Could you talk about
that for a minute an explain why that one is needed?

> +void native_flush_tlb_others(const struct cpumask *cpumask,
> +			     const struct flush_tlb_info *info)
> +{
> +	native_flush_tlb_multi(cpumask, info);
>  }
>  
>  /*
> @@ -774,10 +816,15 @@ static void flush_tlb_on_cpus(const cpumask_t *cpumask,
>  {
>  	int this_cpu = smp_processor_id();
>  
> +	if (static_branch_likely(&flush_tlb_multi_enabled)) {
> +		flush_tlb_multi(cpumask, info);
> +		return;
> +	}

Probably needs a comment for posterity above the if()^^:

	/* Use the optimized flush_tlb_multi() where we can. */

> --- a/arch/x86/xen/mmu_pv.c
> +++ b/arch/x86/xen/mmu_pv.c
> @@ -2474,6 +2474,8 @@ void __init xen_init_mmu_ops(void)
>  
>  	pv_ops.mmu = xen_mmu_ops;
>  
> +	static_key_disable(&flush_tlb_multi_enabled.key);
> +
>  	memset(dummy_mapping, 0xff, PAGE_SIZE);
>  }

More comments, please.  Perhaps:

	Existing paravirt TLB flushes are incompatible with
	flush_tlb_multi() because....  Disable it when they are
	in use.
