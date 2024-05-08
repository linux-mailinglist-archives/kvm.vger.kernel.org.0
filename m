Return-Path: <kvm+bounces-17069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A1048C070F
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 00:03:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38F9F1F235BB
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 22:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08D3E132C16;
	Wed,  8 May 2024 22:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hI8znKbl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8A51327E7;
	Wed,  8 May 2024 22:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715205822; cv=none; b=csIFo3Ew34/CaD4tSS2uB0nfvK5sYcBQ1OCaMj96Zrsm73EiYWUM1OVRWfkCuHX491vlxGieQ2zEjxBatx1IxDc1jiBYK1lR35ATG0g6GDq3zwEVehIhYpTdNtAwTKoJe+M9yZGmhs0lSeYsy37ySW0bXInmft4sphQsythR6D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715205822; c=relaxed/simple;
	bh=MwCElC3OBKp/cJ+1svaxu+IZk8ykmSOHAaVCSaTJSh0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=JG+eLH1Xv3lYlsUgJlxPWjQP1eQhQVZXXNThcLlTbpG6XWgmnMqPJB04gpLNaPKOy2FiZ7YE8fXXR5fOPpZ13/ZE4mUNCFoGdA9FINFefvdCMpcOKpaMeD06XAHN0iHVuxSLQWZsIaja7o7KB3jykzScJe8DV9u1rnwElQCeZpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hI8znKbl; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715205821; x=1746741821;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=MwCElC3OBKp/cJ+1svaxu+IZk8ykmSOHAaVCSaTJSh0=;
  b=hI8znKbltxNO0jTJCbLJaqwYeRVNqwhaL9Gvf+MBO7gxPRALSz+lnGKv
   azkKP29B/bFbx4wu95q4LJQkK2+hDPiq1A5bkGpgC7uIeA5VWTtmDqruq
   TXs5trP0IQuZTYx+RuzNodTw07rTirygQa0HvrmJfqeYTpyt7K0Vi9+fd
   B4pWH6RNMAIgzez83r0U9N7C9BpwjySEMLBnSEg8cXtSdv6dk3hYmgRVQ
   hnokmQ3UTDfhrQn0olOKptZIEmcWjak07tFbiKxhjQCrF911oOWWDjZXY
   jgtQMNr6HXjxh5lUSCAepk0Fcg7QPi2iWKpsBqG7V1mZEf0nKNld0w9gy
   g==;
X-CSE-ConnectionGUID: VFOmwhEcRp211tAtEpPaWg==
X-CSE-MsgGUID: WxVNQILIRrydEFlxN89nSw==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="11035349"
X-IronPort-AV: E=Sophos;i="6.08,145,1712646000"; 
   d="scan'208";a="11035349"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 15:03:40 -0700
X-CSE-ConnectionGUID: AhdY0wduThqQLsp+R1mdyw==
X-CSE-MsgGUID: APEVtscnS0e4Od1qEDfijw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,145,1712646000"; 
   d="scan'208";a="59890758"
Received: from soc-cp83kr3.jf.intel.com (HELO [10.24.10.50]) ([10.24.10.50])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 15:03:40 -0700
Message-ID: <ee652d0a-2b5c-4dbc-ab48-d0608ab87d79@intel.com>
Date: Wed, 8 May 2024 15:03:39 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Chen, Zide" <zide.chen@intel.com>
Subject: Re: [PATCH v2 24/54] KVM: x86/pmu: Create a function prototype to
 disable MSR interception
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
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-25-mizhang@google.com>
Content-Language: en-US
In-Reply-To: <20240506053020.3911940-25-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/5/2024 10:29 PM, Mingwei Zhang wrote:
> Add one extra pmu function prototype in kvm_pmu_ops to disable PMU MSR
> interception.
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  arch/x86/include/asm/kvm-x86-pmu-ops.h | 1 +
>  arch/x86/kvm/cpuid.c                   | 4 ++++
>  arch/x86/kvm/pmu.c                     | 5 +++++
>  arch/x86/kvm/pmu.h                     | 2 ++
>  4 files changed, 12 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> index fd986d5146e4..1b7876dcb3c3 100644
> --- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> @@ -24,6 +24,7 @@ KVM_X86_PMU_OP(is_rdpmc_passthru_allowed)
>  KVM_X86_PMU_OP_OPTIONAL(reset)
>  KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
>  KVM_X86_PMU_OP_OPTIONAL(cleanup)
> +KVM_X86_PMU_OP_OPTIONAL(passthrough_pmu_msrs)
>  
>  #undef KVM_X86_PMU_OP
>  #undef KVM_X86_PMU_OP_OPTIONAL
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 77352a4abd87..b577ba649feb 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -381,6 +381,10 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
>  
>  	kvm_pmu_refresh(vcpu);
> +
> +	if (is_passthrough_pmu_enabled(vcpu))
> +		kvm_pmu_passthrough_pmu_msrs(vcpu);
> +
>  	vcpu->arch.cr4_guest_rsvd_bits =
>  	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
>  
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 3afefe4cf6e2..bd94f2d67f5c 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -1059,3 +1059,8 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>  	kfree(filter);
>  	return r;
>  }
> +
> +void kvm_pmu_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
> +{
> +	static_call_cond(kvm_x86_pmu_passthrough_pmu_msrs)(vcpu);
> +}

Don't quite understand why a separate callback is needed. It seems it's
not messier if put this logic in the kvm_x86_vcpu_after_set_cpuid()
callback.

