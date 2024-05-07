Return-Path: <kvm+bounces-16798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC5BC8BDBBC
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 08:40:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED29AB23095
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 06:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5136E79B9C;
	Tue,  7 May 2024 06:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kHRNj7nI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BA478C8C;
	Tue,  7 May 2024 06:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715064029; cv=none; b=KJM5FRg39qL9ZXIlq3C4lTEvsT47GsZRqq05Xk4zL21gEus2ctqzSXP5QQ0qW79KJnnJXu5Ay80P/ALuITZKhpkijA2OK/3cGkUJQJI98V7TmcoF8B9TzURDF3YiPSMcEji42XA+dSlIzbA5miy35ZaRLf7UZHPTQ45vEpzUkmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715064029; c=relaxed/simple;
	bh=lRji6tTDCLCRRf3ujzewsDMDsH2PzV2Eu2B51lXry4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ift8yvt9xfoNtmGa+MZVqbYPyZA03CNadsVKG4Mfw/I2w32ZK/TgRHF5LCMRcwNbF/Fy+Ga2L6BPBKNnUjr+xsy4zki9naYcmIqBjZWvTsQ37U5+Gyspgu1l9OTzzCtidFKVzOvzKzH9X4JHToN6xKx6HsNz78MxWzImqAgxS9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kHRNj7nI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90084C4AF18;
	Tue,  7 May 2024 06:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715064029;
	bh=lRji6tTDCLCRRf3ujzewsDMDsH2PzV2Eu2B51lXry4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kHRNj7nIPewkXNrvTtYtB1Ut+pfqG96EG0ihcYqcQf04GXFLQ02EKvyMdYtY7caRK
	 K+w7/DFMyguWiRaPYDYvcX0zi940X9fskGL9nV7sCYBLbrgB28RtTBouKMvwy+BS8C
	 yt7qjuekm0En1EiIJTELzxUNQS8SW/IrfNBYiKD0nrFVO4oHz9HmptCtqPdFSMSClH
	 Bqc+2bwsExrESWIRsFJTN3q1uM5AoV4ZZAmG5TmJCuvg05BoeMEDKr1Mx0+2UMIvuV
	 n4cdOmrcv/FP7JnqfTg7dKWiIGX4DOq3OgAjGGAuEyTEaLqUopOTrHfz4FBQDZR7C4
	 ZJgz8ouXbEx8A==
Date: Tue, 7 May 2024 12:05:51 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Gautam Menghani <gautam@linux.ibm.com>
Cc: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu, 
	Vaibhav Jain <vaibhav@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Subject: Re: [PATCH v6] arch/powerpc/kvm: Add support for reading VPA
 counters for pseries guests
Message-ID: <bk4zdqrzthsxzd5p5ppai4pociac2ww2lsuto5zk7w6snlotuc@2ut5owudosz6>
References: <20240506145605.73794-1-gautam@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240506145605.73794-1-gautam@linux.ibm.com>

On Mon, May 06, 2024 at 08:26:03PM GMT, Gautam Menghani wrote:
> PAPR hypervisor has introduced three new counters in the VPA area of
> LPAR CPUs for KVM L2 guest (see [1] for terminology) observability - 2
> for context switches from host to guest and vice versa, and 1 counter
> for getting the total time spent inside the KVM guest. Add a tracepoint
> that enables reading the counters for use by ftrace/perf. Note that this
> tracepoint is only available for nestedv2 API (i.e, KVM on PowerVM).
> 
> [1] Terminology:
> a. L1 refers to the VM (LPAR) booted on top of PAPR hypervisor
> b. L2 refers to the KVM guest booted on top of L1.
> 
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> ---
> v5 -> v6:
> 1. Use TRACE_EVENT_FN to enable/disable counters only once.
> 2. Remove the agg. counters from vcpu->arch.
> 3. Use PACA to maintain old counter values instead of zeroing on every
> entry.
> 4. Simplify variable names
> 
> v4 -> v5:
> 1. Define helper functions for getting/setting the accumulation counter
> in L2's VPA
> 
> v3 -> v4:
> 1. After vcpu_run, check the VPA flag instead of checking for tracepoint
> being enabled for disabling the cs time accumulation.
> 
> v2 -> v3:
> 1. Move the counter disabling and zeroing code to a different function.
> 2. Move the get_lppaca() inside the tracepoint_enabled() branch.
> 3. Add the aggregation logic to maintain total context switch time.
> 
> v1 -> v2:
> 1. Fix the build error due to invalid struct member reference.
> 
>  arch/powerpc/include/asm/lppaca.h | 11 +++++--
>  arch/powerpc/include/asm/paca.h   |  5 +++
>  arch/powerpc/kvm/book3s_hv.c      | 52 +++++++++++++++++++++++++++++++
>  arch/powerpc/kvm/trace_hv.h       | 27 ++++++++++++++++
>  4 files changed, 92 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/lppaca.h b/arch/powerpc/include/asm/lppaca.h
> index 61ec2447dabf..f40a646bee3c 100644
> --- a/arch/powerpc/include/asm/lppaca.h
> +++ b/arch/powerpc/include/asm/lppaca.h
> @@ -62,7 +62,8 @@ struct lppaca {
>  	u8	donate_dedicated_cpu;	/* Donate dedicated CPU cycles */
>  	u8	fpregs_in_use;
>  	u8	pmcregs_in_use;
> -	u8	reserved8[28];
> +	u8	l2_counters_enable;  /* Enable usage of counters for KVM guest */
> +	u8	reserved8[27];
>  	__be64	wait_state_cycles;	/* Wait cycles for this proc */
>  	u8	reserved9[28];
>  	__be16	slb_count;		/* # of SLBs to maintain */
> @@ -92,9 +93,13 @@ struct lppaca {
>  	/* cacheline 4-5 */
>  
>  	__be32	page_ins;		/* CMO Hint - # page ins by OS */
> -	u8	reserved12[148];
> +	u8	reserved12[28];
> +	volatile __be64 l1_to_l2_cs_tb;
> +	volatile __be64 l2_to_l1_cs_tb;
> +	volatile __be64 l2_runtime_tb;
> +	u8 reserved13[96];
>  	volatile __be64 dtl_idx;	/* Dispatch Trace Log head index */
> -	u8	reserved13[96];
> +	u8	reserved14[96];
>  } ____cacheline_aligned;
>  
>  #define lppaca_of(cpu)	(*paca_ptrs[cpu]->lppaca_ptr)
> diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
> index 1d58da946739..f20ac7a6efa4 100644
> --- a/arch/powerpc/include/asm/paca.h
> +++ b/arch/powerpc/include/asm/paca.h
> @@ -278,6 +278,11 @@ struct paca_struct {
>  	struct mce_info *mce_info;
>  	u8 mce_pending_irq_work;
>  #endif /* CONFIG_PPC_BOOK3S_64 */
> +#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
> +	u64 l1_to_l2_cs;
> +	u64 l2_to_l1_cs;
> +	u64 l2_runtime_agg;
> +#endif
>  } ____cacheline_aligned;
>  
>  extern void copy_mm_to_paca(struct mm_struct *mm);
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 8e86eb577eb8..ed69ad58bd02 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -4108,6 +4108,54 @@ static void vcpu_vpa_increment_dispatch(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +static inline int kvmhv_get_l2_counters_status(void)
> +{
> +	return get_lppaca()->l2_counters_enable;
> +}
> +
> +static inline void kvmhv_set_l2_counters_status(int cpu, bool status)
> +{
> +	if (status)
> +		lppaca_of(cpu).l2_counters_enable = 1;
> +	else
> +		lppaca_of(cpu).l2_counters_enable = 0;
> +}
> +
> +int kmvhv_counters_tracepoint_regfunc(void)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		kvmhv_set_l2_counters_status(cpu, true);
> +	}
> +	return 0;
> +}
> +
> +void kmvhv_counters_tracepoint_unregfunc(void)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		kvmhv_set_l2_counters_status(cpu, false);
> +	}
> +}
> +
> +static void do_trace_nested_cs_time(struct kvm_vcpu *vcpu)
> +{
> +	struct lppaca *lp = get_lppaca();
> +	u64 l1_to_l2_ns, l2_to_l1_ns, l2_runtime_ns;
> +
> +	l1_to_l2_ns = tb_to_ns(be64_to_cpu(lp->l1_to_l2_cs_tb));
> +	l2_to_l1_ns = tb_to_ns(be64_to_cpu(lp->l2_to_l1_cs_tb));
> +	l2_runtime_ns = tb_to_ns(be64_to_cpu(lp->l2_runtime_tb));
> +	trace_kvmppc_vcpu_stats(vcpu, l1_to_l2_ns - local_paca->l1_to_l2_cs,
> +					l2_to_l1_ns - local_paca->l2_to_l1_cs,
> +					l2_runtime_ns - local_paca->l2_runtime_agg);

Depending on how the hypervisor works, if the vcpu was in l2 when the 
tracepoint is enabled, the counters may not be updated on exit and we 
may emit a trace with all values zero. If that is possible, it might be 
a good idea to only emit the trace if any of the counters are non-zero.

Otherwise, this looks good to me.
Acked-by: Naveen N Rao <naveen@kernel.org>


- Naveen

> +	local_paca->l1_to_l2_cs = l1_to_l2_ns;
> +	local_paca->l2_to_l1_cs = l2_to_l1_ns;
> +	local_paca->l2_runtime_agg = l2_runtime_ns;
> +}
> +
>  static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
>  				     unsigned long lpcr, u64 *tb)
>  {
> @@ -4156,6 +4204,10 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
>  
>  	timer_rearm_host_dec(*tb);
>  
> +	/* Record context switch and guest_run_time data */
> +	if (kvmhv_get_l2_counters_status())
> +		do_trace_nested_cs_time(vcpu);
> +
>  	return trap;
>  }
>  
> diff --git a/arch/powerpc/kvm/trace_hv.h b/arch/powerpc/kvm/trace_hv.h
> index 8d57c8428531..dc118ab88f23 100644
> --- a/arch/powerpc/kvm/trace_hv.h
> +++ b/arch/powerpc/kvm/trace_hv.h
> @@ -238,6 +238,9 @@
>  	{H_MULTI_THREADS_ACTIVE,	"H_MULTI_THREADS_ACTIVE"}, \
>  	{H_OUTSTANDING_COP_OPS,		"H_OUTSTANDING_COP_OPS"}
>  
> +int kmvhv_counters_tracepoint_regfunc(void);
> +void kmvhv_counters_tracepoint_unregfunc(void);
> +
>  TRACE_EVENT(kvm_guest_enter,
>  	TP_PROTO(struct kvm_vcpu *vcpu),
>  	TP_ARGS(vcpu),
> @@ -512,6 +515,30 @@ TRACE_EVENT(kvmppc_run_vcpu_exit,
>  			__entry->vcpu_id, __entry->exit, __entry->ret)
>  );
>  
> +TRACE_EVENT_FN(kvmppc_vcpu_stats,
> +	TP_PROTO(struct kvm_vcpu *vcpu, u64 l1_to_l2_cs, u64 l2_to_l1_cs, u64 l2_runtime),
> +
> +	TP_ARGS(vcpu, l1_to_l2_cs, l2_to_l1_cs, l2_runtime),
> +
> +	TP_STRUCT__entry(
> +		__field(int,		vcpu_id)
> +		__field(u64,		l1_to_l2_cs)
> +		__field(u64,		l2_to_l1_cs)
> +		__field(u64,		l2_runtime)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->vcpu_id  = vcpu->vcpu_id;
> +		__entry->l1_to_l2_cs = l1_to_l2_cs;
> +		__entry->l2_to_l1_cs = l2_to_l1_cs;
> +		__entry->l2_runtime = l2_runtime;
> +	),
> +
> +	TP_printk("VCPU %d: l1_to_l2_cs_time=%llu ns l2_to_l1_cs_time=%llu ns l2_runtime=%llu ns",
> +		__entry->vcpu_id,  __entry->l1_to_l2_cs,
> +		__entry->l2_to_l1_cs, __entry->l2_runtime),
> +	kmvhv_counters_tracepoint_regfunc, kmvhv_counters_tracepoint_unregfunc
> +);
>  #endif /* _TRACE_KVM_HV_H */
>  
>  /* This part must be outside protection */
> -- 
> 2.44.0
> 

