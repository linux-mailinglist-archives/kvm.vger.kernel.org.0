Return-Path: <kvm+bounces-54313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE3A2B1E377
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 09:35:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81452A016BE
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 07:34:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63AED25CC4D;
	Fri,  8 Aug 2025 07:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QCzzD3i1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0108B22A1D5;
	Fri,  8 Aug 2025 07:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754638251; cv=none; b=XwO1jHQMAPmzk7T8Ft4iQtznGFk4L7BUh3fZGGJ+CASnGhwkMmYG3M5Jy8G5NnNCm29XizmwsEB4+6iLwY87ZEg/+0DkZpvMRG5HJ1xGh1oEf9JxvD53OT+Vg7W+1akcsBmwHk6H9bsEqXSdQLcHsf/pH06lMg3k1QO+RWX5z64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754638251; c=relaxed/simple;
	bh=N93jbXCfcX8tT1d6Si749lOVTvmyst9EjSTFBREX9yk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nruZ3qvapTGs62IZhreh8gMrvQGZErsFNmDD0BMVgUDTPnyc48WRSF4zKLz6ToSLnvijNNXzpo8yd2L53YX5q1IcMK7TIrdgMagoQgFHdeAKWxBZaLt8jDwAFL9INhr+B9NAAXBQOk5WRHP+ej0yvY9UyGkHIM7joKHXMq5jBVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QCzzD3i1; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754638250; x=1786174250;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=N93jbXCfcX8tT1d6Si749lOVTvmyst9EjSTFBREX9yk=;
  b=QCzzD3i1ZbnrUsaoWeChKbnC1N8x9UaGsrMi70uG1KNUlfB1lk3cxNuS
   whO1L3uNXl5+RGB1Y7v6FMmYJRN+T82P5XvdT5XHcetVgRyLsuqQxVBnK
   kiddcc0bzrOtY2oOp/MgLTljAL20f+LLMsKM9f3gyfb5aQASmGFJ2D4Mg
   Oz3VN6rvs2BhUuHbcMNF0Oljy/N6UmKZGozlCenQgIY04M+Kwg2zC3dvn
   3ywXd3gIjQe7jnYCFua+3wXRiedRLtBELpnF6dHzzngpPmjVdb3Z/r4Qj
   3mXRUjDAj9WgTQvUaJxXIo8LkbRIHPWwIZpzTYtMRcdRJtm8Kevhh+xV6
   g==;
X-CSE-ConnectionGUID: jCqLyoTHR0eEEdyMNCz5Ig==
X-CSE-MsgGUID: RwgnHLbQTwiXDxCzctC8nQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="56860991"
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="56860991"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 00:30:50 -0700
X-CSE-ConnectionGUID: nPT+neYWR5ic6FwTvd4gdw==
X-CSE-MsgGUID: 3HIOr3NzSxqUGeU1ve8zNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="165677254"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.106]) ([10.124.240.106])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 00:30:43 -0700
Message-ID: <f3e09bef-8bc9-48ac-983e-7a18c2ff4ad2@linux.intel.com>
Date: Fri, 8 Aug 2025 15:30:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/44] perf: Add APIs to load/put guest mediated PMU
 context
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Kan Liang <kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>,
 Mingwei Zhang <mizhang@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>,
 Sandipan Das <sandipan.das@amd.com>
References: <20250806195706.1650976-1-seanjc@google.com>
 <20250806195706.1650976-8-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250806195706.1650976-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 8/7/2025 3:56 AM, Sean Christopherson wrote:
> From: Kan Liang <kan.liang@linux.intel.com>
>
> Add exported APIs to load/put a guest mediated PMU context.  KVM will
> load the guest PMU shortly before VM-Enter, and put the guest PMU shortly
> after VM-Exit.
>
> On the perf side of things, schedule out all exclude_guest events when the
> guest context is loaded, and schedule them back in when the guest context
> is put.  I.e. yield the hardware PMU resources to the guest, by way of KVM.
>
> Note, perf is only responsible for managing host context.  KVM is
> responsible for loading/storing guest state to/from hardware.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> [sean: shuffle patches around, write changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  include/linux/perf_event.h |  2 ++
>  kernel/events/core.c       | 61 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 63 insertions(+)
>
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 0958b6d0a61c..42d019d70b42 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1925,6 +1925,8 @@ extern u64 perf_event_pause(struct perf_event *event, bool reset);
>  #ifdef CONFIG_PERF_GUEST_MEDIATED_PMU
>  int perf_create_mediated_pmu(void);
>  void perf_release_mediated_pmu(void);
> +void perf_load_guest_context(unsigned long data);
> +void perf_put_guest_context(void);
>  #endif
>  
>  #else /* !CONFIG_PERF_EVENTS: */
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 6875b56ddd6b..77398b1ad4c5 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -469,10 +469,19 @@ static cpumask_var_t perf_online_pkg_mask;
>  static cpumask_var_t perf_online_sys_mask;
>  static struct kmem_cache *perf_event_cache;
>  
> +#ifdef CONFIG_PERF_GUEST_MEDIATED_PMU
> +static DEFINE_PER_CPU(bool, guest_ctx_loaded);
> +
> +static __always_inline bool is_guest_mediated_pmu_loaded(void)
> +{
> +	return __this_cpu_read(guest_ctx_loaded);
> +}
> +#else
>  static __always_inline bool is_guest_mediated_pmu_loaded(void)
>  {
>  	return false;
>  }
> +#endif
>  
>  /*
>   * perf event paranoia level:
> @@ -6379,6 +6388,58 @@ void perf_release_mediated_pmu(void)
>  	atomic_dec(&nr_mediated_pmu_vms);
>  }
>  EXPORT_SYMBOL_GPL(perf_release_mediated_pmu);
> +
> +/* When loading a guest's mediated PMU, schedule out all exclude_guest events. */
> +void perf_load_guest_context(unsigned long data)

nit: the "data" argument is not used in this patch, we may defer to
introduce it in patch 09/44.


> +{
> +	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
> +
> +	lockdep_assert_irqs_disabled();
> +
> +	guard(perf_ctx_lock)(cpuctx, cpuctx->task_ctx);
> +
> +	if (WARN_ON_ONCE(__this_cpu_read(guest_ctx_loaded)))
> +		return;
> +
> +	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
> +	ctx_sched_out(&cpuctx->ctx, NULL, EVENT_GUEST);
> +	if (cpuctx->task_ctx) {
> +		perf_ctx_disable(cpuctx->task_ctx, EVENT_GUEST);
> +		task_ctx_sched_out(cpuctx->task_ctx, NULL, EVENT_GUEST);
> +	}
> +
> +	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
> +	if (cpuctx->task_ctx)
> +		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
> +
> +	__this_cpu_write(guest_ctx_loaded, true);
> +}
> +EXPORT_SYMBOL_GPL(perf_load_guest_context);
> +
> +void perf_put_guest_context(void)
> +{
> +	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
> +
> +	lockdep_assert_irqs_disabled();
> +
> +	guard(perf_ctx_lock)(cpuctx, cpuctx->task_ctx);
> +
> +	if (WARN_ON_ONCE(!__this_cpu_read(guest_ctx_loaded)))
> +		return;
> +
> +	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
> +	if (cpuctx->task_ctx)
> +		perf_ctx_disable(cpuctx->task_ctx, EVENT_GUEST);
> +
> +	perf_event_sched_in(cpuctx, cpuctx->task_ctx, NULL, EVENT_GUEST);
> +
> +	if (cpuctx->task_ctx)
> +		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
> +	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
> +
> +	__this_cpu_write(guest_ctx_loaded, false);
> +}
> +EXPORT_SYMBOL_GPL(perf_put_guest_context);
>  #else
>  static int mediated_pmu_account_event(struct perf_event *event) { return 0; }
>  static void mediated_pmu_unaccount_event(struct perf_event *event) {}

