Return-Path: <kvm+bounces-59679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB2E0BC731B
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 04:20:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C93219E48EE
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 02:20:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A09C11B78F3;
	Thu,  9 Oct 2025 02:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jBBW05E1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD288182D0;
	Thu,  9 Oct 2025 02:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759976393; cv=none; b=HUgdT5lfUD2CAimjE2b9teHj8l++mJqN+PTfqkUiQ+9Uchp6TL9PY1kntITlMih9kFCQdbHfxIEGIKI9SQ/AXJfhMGj4qGZJuhDU5wPgCKI/Cc2c9VST5mZAiGlHaFc8WQ/2aW3ksqGqQBZMR659DjoAsJwGWh0NcNFNwY9owOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759976393; c=relaxed/simple;
	bh=MKwwAjIvNTVYzVSKLCj93oAfQ4vIbNdKNB8W0YNJ6Qg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FC/ETsMn5r5OPk8arapq3I8BSVwtdJrNrWepuMzs9PL/8v8oBL/HVYHyW3r/sjCQtS4vtgVEbA5pRbFdPV5acPMlzYvuQrmrTKhs5A3+xSGMC+cIypCt7zA/mjNSYoB+R55eP8B1bF+Syl2Sfbb0S9YuLlEzamAX5Ksw9uNOulA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jBBW05E1; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759976391; x=1791512391;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MKwwAjIvNTVYzVSKLCj93oAfQ4vIbNdKNB8W0YNJ6Qg=;
  b=jBBW05E1MUnYFZWaxdB/CrGNH0YhcZIm6QcYaCyKHBRYGwEypd7EPUQb
   /+MQkOd1iQfrAVSs8CBM1Uj39Oq7VX+kh0DsfP/AUZAifJOMfUxKl5h0x
   HvHW6em/ugZFcBsDESnaqQQ+juCXybb18nGjBRX2bDD67mqFulYS5F5c0
   6pV0+TZNkxkrfdy6OplVUGptqP6tkM45HSHR0MEraGGWkCTDgKLpD8pPL
   hIl2bMhCWf73SW/PISpd2ShsPlrI5wIu/mu5Yn7sGFNqOPWpGiitroA53
   CPgcjDWK39+lCJ3JLwhBD5nV+U9nTrfAGmB5ne2KGVlHw0sX5ndmRhNmK
   A==;
X-CSE-ConnectionGUID: mdL1U0ecRGGUSFbzfG6UGQ==
X-CSE-MsgGUID: PA2QuWEaR/eC9WBYagUvpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62097737"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62097737"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 19:19:51 -0700
X-CSE-ConnectionGUID: SjjAIAIGQgGwYyFr6uTBmQ==
X-CSE-MsgGUID: dnnE1byERkONzbCEalT4rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,215,1754982000"; 
   d="scan'208";a="211538774"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.232.209]) ([10.124.232.209])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 19:19:44 -0700
Message-ID: <0276af52-c697-46c3-9db8-9284adb6beee@linux.intel.com>
Date: Thu, 9 Oct 2025 10:19:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 32/44] KVM: x86/pmu: Disable interception of select PMU
 MSRs for mediated vPMUs
To: Sean Christopherson <seanjc@google.com>, Sandipan Das <sandidas@amd.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Kan Liang <kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>,
 Mingwei Zhang <mizhang@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>,
 Sandipan Das <sandipan.das@amd.com>
References: <20250806195706.1650976-1-seanjc@google.com>
 <20250806195706.1650976-33-seanjc@google.com>
 <f896966e-8925-4b4f-8f0d-f1ae8aa197f7@amd.com> <aN1vfykNs8Dmv_g0@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <aN1vfykNs8Dmv_g0@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 10/2/2025 2:14 AM, Sean Christopherson wrote:
> On Fri, Sep 26, 2025, Sandipan Das wrote:
>> On 8/7/2025 1:26 AM, Sean Christopherson wrote:
>>> From: Dapeng Mi <dapeng1.mi@linux.intel.com>
>>>
>>> For vCPUs with a mediated vPMU, disable interception of counter MSRs for
>>> PMCs that are exposed to the guest, and for GLOBAL_CTRL and related MSRs
>>> if they are fully supported according to the vCPU model, i.e. if the MSRs
>>> and all bits supported by hardware exist from the guest's point of view.
>>>
>>> Do NOT passthrough event selector or fixed counter control MSRs, so that
>>> KVM can enforce userspace-defined event filters, e.g. to prevent use of
>>> AnyThread events (which is unfortunately a setting in the fixed counter
>>> control MSR).
>>>
>>> Defer support for nested passthrough of mediated PMU MSRs to the future,
>>> as the logic for nested MSR interception is unfortunately vendor specific.
> ...
>
>>>  #define MSR_AMD64_LBR_SELECT			0xc000010e
>>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>>> index 4246e1d2cfcc..817ef852bdf9 100644
>>> --- a/arch/x86/kvm/pmu.c
>>> +++ b/arch/x86/kvm/pmu.c
>>> @@ -715,18 +715,14 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>>>  	return 0;
>>>  }
>>>  
>>> -bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
>>> +bool kvm_need_perf_global_ctrl_intercept(struct kvm_vcpu *vcpu)
>>>  {
>>>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>>  
>>>  	if (!kvm_vcpu_has_mediated_pmu(vcpu))
>>>  		return true;
>>>  
>>> -	/*
>>> -	 * VMware allows access to these Pseduo-PMCs even when read via RDPMC
>>> -	 * in Ring3 when CR4.PCE=0.
>>> -	 */
>>> -	if (enable_vmware_backdoor)
>>> +	if (!kvm_pmu_has_perf_global_ctrl(pmu))
>>>  		return true;
>>>  
>>>  	/*
>>> @@ -735,7 +731,22 @@ bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
>>>  	 * capabilities themselves may be a subset of hardware capabilities.
>>>  	 */
>>>  	return pmu->nr_arch_gp_counters != kvm_host_pmu.num_counters_gp ||
>>> -	       pmu->nr_arch_fixed_counters != kvm_host_pmu.num_counters_fixed ||
>>> +	       pmu->nr_arch_fixed_counters != kvm_host_pmu.num_counters_fixed;
>>> +}
>>> +EXPORT_SYMBOL_GPL(kvm_need_perf_global_ctrl_intercept);
>>> +
>>> +bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
>>> +{
>>> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>> +
>>> +	/*
>>> +	 * VMware allows access to these Pseduo-PMCs even when read via RDPMC
>>> +	 * in Ring3 when CR4.PCE=0.
>>> +	 */
>>> +	if (enable_vmware_backdoor)
>>> +		return true;
>>> +
>>> +	return kvm_need_perf_global_ctrl_intercept(vcpu) ||
>>>  	       pmu->counter_bitmask[KVM_PMC_GP] != (BIT_ULL(kvm_host_pmu.bit_width_gp) - 1) ||
>>>  	       pmu->counter_bitmask[KVM_PMC_FIXED] != (BIT_ULL(kvm_host_pmu.bit_width_fixed) - 1);
>>>  }
>> There is a case for AMD processors where the global MSRs are absent in the guest
>> but the guest still uses the same number of counters as what is advertised by the
>> host capabilities. So RDPMC interception is not necessary for all cases where
>> global control is unavailable.o
> Hmm, I think Intel would be the same?  Ah, no, because the host will have fixed
> counters, but the guest will not.  However, that's not directly related to
> kvm_pmu_has_perf_global_ctrl(), so I think this would be correct?
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 4414d070c4f9..4c5b2712ee4c 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -744,16 +744,13 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>         return 0;
>  }
>  
> -bool kvm_need_perf_global_ctrl_intercept(struct kvm_vcpu *vcpu)
> +static bool kvm_need_pmc_intercept(struct kvm_vcpu *vcpu)

The function name kvm_need_pmc_intercept() seems a little bit misleading
and make users think this function is used to check if a certain PMC is
intercepted. Maybe we can rename the function to kvm_need_global_intercept().

Others look good to me. Thanks.


>  {
>         struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>  
>         if (!kvm_vcpu_has_mediated_pmu(vcpu))
>                 return true;
>  
> -       if (!kvm_pmu_has_perf_global_ctrl(pmu))
> -               return true;
> -
>         /*
>          * Note!  Check *host* PMU capabilities, not KVM's PMU capabilities, as
>          * KVM's capabilities are constrained based on KVM support, i.e. KVM's
> @@ -762,6 +759,13 @@ bool kvm_need_perf_global_ctrl_intercept(struct kvm_vcpu *vcpu)
>         return pmu->nr_arch_gp_counters != kvm_host_pmu.num_counters_gp ||
>                pmu->nr_arch_fixed_counters != kvm_host_pmu.num_counters_fixed;
>  }
> +
> +bool kvm_need_perf_global_ctrl_intercept(struct kvm_vcpu *vcpu)
> +{
> +
> +       return kvm_need_pmc_intercept(vcpu) ||
> +              !kvm_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu));
> +}
>  EXPORT_SYMBOL_GPL(kvm_need_perf_global_ctrl_intercept);
>  
>  bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
> @@ -775,7 +779,7 @@ bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
>         if (enable_vmware_backdoor)
>                 return true;
>  
> -       return kvm_need_perf_global_ctrl_intercept(vcpu) ||
> +       return kvm_need_pmc_intercept(vcpu) ||
>                pmu->counter_bitmask[KVM_PMC_GP] != (BIT_ULL(kvm_host_pmu.bit_width_gp) - 1) ||
>                pmu->counter_bitmask[KVM_PMC_FIXED] != (BIT_ULL(kvm_host_pmu.bit_width_fixed) - 1);
>  }
>

