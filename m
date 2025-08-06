Return-Path: <kvm+bounces-54088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C47AB1C154
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 09:29:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B648D62674A
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 07:29:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C63E221ABB9;
	Wed,  6 Aug 2025 07:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NkuFJdBk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933AF218ABD;
	Wed,  6 Aug 2025 07:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754465343; cv=none; b=Vhb10waGt/870SxJTDJC8Q9rOaziwka2HWFzIe9ivFmmLutLy7L2KF7NQPPQm7ppgJCI3nkTUDNey6U/c02jMsVqeq8LmdHwwe3ZJQU3K1BIRqGarGCReoESHnalSjye5B+T+eGuSNF0mkE8woTX/+UmaAENbhgt+09qtJXHLSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754465343; c=relaxed/simple;
	bh=nzfVoQpgu16GDo/1/T0SO/jDTb67u8e64+BqVD7VTts=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X8jV4MYqqItbRQnbx1FX+lDMMHYaNjMb7ejIJn+xquwDvPS7+Vzfk2idrsfvLec9o6tpRb7JUmbbgWBYK2dS2x+ex4iICq0UOFI8fQP6Rt+skugjzkXuO7UI33fvqecnUUbxF26sCK7MSGlyLfr/9Vh0Hlbn+hcV0kmQsFLQUNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NkuFJdBk; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754465342; x=1786001342;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nzfVoQpgu16GDo/1/T0SO/jDTb67u8e64+BqVD7VTts=;
  b=NkuFJdBk03tCwmIcurTlGEITyJyMzU940ZjUeBnMq99RTfCORNDM8hIQ
   dCqO5DWc+f+DYYq1W7tEstypbYVEFAOGOjxIwPS+/MBZFMSRoprn0P2TB
   s0hL0WwvJZ2/tsROZmg/vSL0KO5ZEbJwYiNJvh2eNkTLe35v1muIOa78I
   8tfnDY9qYY9leQUxjataJJmsjQ2lhhvBCtSyEeqy7HtYtbrJ3dEkDx0Y6
   rzKQx0/zp39Aw16DGE1BXEJIoYZ474i16pe/Xajp8pgpSfD041st6qgQB
   Cj9dApD4PEFeFUmvceKMJ9LvHLczg9Lt9p0WwGcpkh1jWdbqijnA6Om5X
   w==;
X-CSE-ConnectionGUID: NyFPIPf2S+W7fTlcyWzyXQ==
X-CSE-MsgGUID: VvuxzRaASNujvJgojCBMxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="55809795"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="55809795"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 00:29:01 -0700
X-CSE-ConnectionGUID: mWfULvGaRZyz4uqcOgmgMA==
X-CSE-MsgGUID: DYOzjoRNQuSvXGgejzpHmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="164720531"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.106]) ([10.124.240.106])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 00:28:59 -0700
Message-ID: <b57fd626-ab0f-492b-b3fa-c6d8d692455f@linux.intel.com>
Date: Wed, 6 Aug 2025 15:28:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/18] KVM: x86/pmu: Rename pmc_speculative_in_use() to
 pmc_is_locally_enabled()
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li
 <xin@zytor.com>, Sandipan Das <sandipan.das@amd.com>
References: <20250805190526.1453366-1-seanjc@google.com>
 <20250805190526.1453366-13-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250805190526.1453366-13-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 8/6/2025 3:05 AM, Sean Christopherson wrote:
> Rename pmc_speculative_in_use() to pmc_is_locally_enabled() to better
> capture what it actually tracks, and to show its relationship to
> pmc_is_globally_enabled().  While neither AMD nor Intel refer to event
> selectors or the fixed counter control MSR as "local", it's the obvious
> name to pair with "global".
>
> As for "speculative", there's absolutely nothing speculative about the
> checks.  E.g. for PMUs without PERF_GLOBAL_CTRL, from the guest's
> perspective, the counters are "in use" without any qualifications.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/pmu.c           | 6 +++---
>  arch/x86/kvm/pmu.h           | 2 +-
>  arch/x86/kvm/vmx/pmu_intel.c | 2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index b0f0275a2c2e..e73c2a44028b 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -493,7 +493,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
>  
>  static bool pmc_event_is_allowed(struct kvm_pmc *pmc)
>  {
> -	return pmc_is_globally_enabled(pmc) && pmc_speculative_in_use(pmc) &&
> +	return pmc_is_globally_enabled(pmc) && pmc_is_locally_enabled(pmc) &&
>  	       check_pmu_event_filter(pmc);
>  }
>  
> @@ -572,7 +572,7 @@ void kvm_pmu_recalc_pmc_emulation(struct kvm_pmu *pmu, struct kvm_pmc *pmc)
>  	 * omitting a PMC from a bitmap could result in a missed event if the
>  	 * filter is changed to allow counting the event.
>  	 */
> -	if (!pmc_speculative_in_use(pmc))
> +	if (!pmc_is_locally_enabled(pmc))
>  		return;
>  
>  	if (pmc_is_event_match(pmc, kvm_pmu_eventsel.INSTRUCTIONS_RETIRED))
> @@ -907,7 +907,7 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
>  		      pmu->pmc_in_use, X86_PMC_IDX_MAX);
>  
>  	kvm_for_each_pmc(pmu, pmc, i, bitmask) {
> -		if (pmc->perf_event && !pmc_speculative_in_use(pmc))
> +		if (pmc->perf_event && !pmc_is_locally_enabled(pmc))
>  			pmc_stop_counter(pmc);
>  	}
>  
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index cb93a936a177..08ae644db00e 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -160,7 +160,7 @@ static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
>  	return NULL;
>  }
>  
> -static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
> +static inline bool pmc_is_locally_enabled(struct kvm_pmc *pmc)
>  {
>  	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
>  
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 0b173602821b..07baff96300f 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -762,7 +762,7 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
>  	int bit, hw_idx;
>  
>  	kvm_for_each_pmc(pmu, pmc, bit, (unsigned long *)&pmu->global_ctrl) {
> -		if (!pmc_speculative_in_use(pmc) ||
> +		if (!pmc_is_locally_enabled(pmc) ||
>  		    !pmc_is_globally_enabled(pmc) || !pmc->perf_event)
>  			continue;
>  

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



