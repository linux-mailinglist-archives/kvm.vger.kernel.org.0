Return-Path: <kvm+bounces-29735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9329E9B0996
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 18:16:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2D631C23466
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 16:16:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7594170854;
	Fri, 25 Oct 2024 16:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="culC0GUY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E957080E;
	Fri, 25 Oct 2024 16:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729872983; cv=none; b=dshX3Q6cXywyvHHyUzBZH/dr8qnmtegY4FwgDRF1+tGRpI4uqjOKwURyCVeO306wbPDic5SXbzBgZPFgYy62vq+O3iHjGwSGPRoXMqGfteeAbqvAN8E9yAufKwl7S/LXYpfDOXAD2h6FGu+mTB71YmfQxZtAly41AC11u8eaxlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729872983; c=relaxed/simple;
	bh=jAyEYdh61XeY7Gsp+z+t8Gb7g67E3e88u1Ybd1z+u8M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gTuur95wrjEVQsKF4sOsaXyfnbZgSFbg2ZYOD1pSSudYoxffYfLtYUCemjvt24rkWvMJXYXNmHJASHsNxP8wnWPUlHhbkzHTiEXjC65PoubEeJaGGZztuKuCjbkRiaFuHob9Cnpwiw9kOalg5bMMUNIS06CjrGbSJ//8Cq9n5Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=culC0GUY; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729872981; x=1761408981;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jAyEYdh61XeY7Gsp+z+t8Gb7g67E3e88u1Ybd1z+u8M=;
  b=culC0GUYLyRb8Nq3agJl2TUYKZ6sq9L8qToZ36/hM6K8WqzWI6BOIQxF
   S5k6wnLonyd7z3686z+IybVxav94DP7cHmJLu9l/fbdTCOshYnT39+yul
   TKOuTJ+hJONu0ERiwdSDsTHUw95bkHPWfbpoPKNVNXpTMcbFUz7QFbg5H
   MJ56zLDVzUcS4X0ToAokogjde310xf07cyJY88HfgXAja9hZVasIBwvq7
   9M+RIIYn7ILCTWgICHRCckJ8KslC4bI+VQkozzwoohVfgtvu9c7yMpP3I
   E/PMaMTh0IKDPLyfi2v60tM7tAJ9VniToEBIpvmIJr811WYQp4lzIOORp
   A==;
X-CSE-ConnectionGUID: CAbqRnVpS8CmDh4I/r8Gcw==
X-CSE-MsgGUID: Hwgbh5U1S2mRUKmMDUR/fA==
X-IronPort-AV: E=McAfee;i="6700,10204,11236"; a="32407167"
X-IronPort-AV: E=Sophos;i="6.11,232,1725346800"; 
   d="scan'208";a="32407167"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2024 09:16:21 -0700
X-CSE-ConnectionGUID: RpympDO8R2uMpCQDRTAaaA==
X-CSE-MsgGUID: nKB+BOxNT2izVtoTvjHSvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,232,1725346800"; 
   d="scan'208";a="111764279"
Received: from soc-cp83kr3.clients.intel.com (HELO [10.24.8.117]) ([10.24.8.117])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2024 09:16:20 -0700
Message-ID: <d0d8a945-1623-448a-b08a-8877464a4531@intel.com>
Date: Fri, 25 Oct 2024 09:16:20 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 43/58] KVM: x86/pmu: Introduce PMU operator for
 setting counter overflow
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-44-mizhang@google.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20240801045907.4010984-44-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/31/2024 9:58 PM, Mingwei Zhang wrote:
> Introduce PMU operator for setting counter overflow. When emulating counter
> increment, multiple counters could overflow at the same time, i.e., during
> the execution of the same instruction. In passthrough PMU, having an PMU
> operator provides convenience to update the PMU global status in one shot
> with details hidden behind the vendor specific implementation.

Since neither Intel nor AMD does implement this API, this patch should
be dropped.

> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  arch/x86/include/asm/kvm-x86-pmu-ops.h | 1 +
>  arch/x86/kvm/pmu.h                     | 1 +
>  arch/x86/kvm/vmx/pmu_intel.c           | 5 +++++
>  3 files changed, 7 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> index 72ca78df8d2b..bd5b118a5ce5 100644
> --- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> @@ -28,6 +28,7 @@ KVM_X86_PMU_OP_OPTIONAL(passthrough_pmu_msrs)
>  KVM_X86_PMU_OP_OPTIONAL(save_pmu_context)
>  KVM_X86_PMU_OP_OPTIONAL(restore_pmu_context)
>  KVM_X86_PMU_OP_OPTIONAL(incr_counter)
> +KVM_X86_PMU_OP_OPTIONAL(set_overflow)
>  
>  #undef KVM_X86_PMU_OP
>  #undef KVM_X86_PMU_OP_OPTIONAL
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 325f17673a00..78a7f0c5f3ba 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -45,6 +45,7 @@ struct kvm_pmu_ops {
>  	void (*save_pmu_context)(struct kvm_vcpu *vcpu);
>  	void (*restore_pmu_context)(struct kvm_vcpu *vcpu);
>  	bool (*incr_counter)(struct kvm_pmc *pmc);
> +	void (*set_overflow)(struct kvm_vcpu *vcpu);
>  
>  	const u64 EVENTSEL_EVENT;
>  	const int MAX_NR_GP_COUNTERS;
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 42af2404bdb9..2d46c911f0b7 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -881,6 +881,10 @@ static void intel_restore_guest_pmu_context(struct kvm_vcpu *vcpu)
>  	wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl_hw);
>  }
>  
> +static void intel_set_overflow(struct kvm_vcpu *vcpu)
> +{
> +}
> +
>  struct kvm_pmu_ops intel_pmu_ops __initdata = {
>  	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
>  	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
> @@ -897,6 +901,7 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
>  	.save_pmu_context = intel_save_guest_pmu_context,
>  	.restore_pmu_context = intel_restore_guest_pmu_context,
>  	.incr_counter = intel_incr_counter,
> +	.set_overflow = intel_set_overflow,
>  	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
>  	.MAX_NR_GP_COUNTERS = KVM_INTEL_PMC_MAX_GENERIC,
>  	.MIN_NR_GP_COUNTERS = 1,


