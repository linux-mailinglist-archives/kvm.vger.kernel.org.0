Return-Path: <kvm+bounces-57602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E5990B582BE
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 19:05:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0234C170C08
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 17:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E12A2877FA;
	Mon, 15 Sep 2025 17:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="PswIMUK7"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DAF286424;
	Mon, 15 Sep 2025 17:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757955915; cv=none; b=WHmEA47to1NhEcRpY6ohhhULM9Inj1v2Qt3vAXiQ7KSjMeK3wqyuEEFCX/+YqvimNWosZNKsM13dwXTDkzWNeuzXBghEEgNym5XrZ3SMF7gEYxii7+rz9xNlexV31+L/jo2pUKgoxZTRfRW3OTCi3UmrfzHCJnHEsYM9zZ/HfpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757955915; c=relaxed/simple;
	bh=UYHu4XvkaRjYogwIfNpvwksawDBauQBnyHYV6E8cpTo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VFNiogxGUpXV5S1zgyUwqw6okGsptCVPsX8P2bMcb1CFyGk0adkp66v0OJaC+LWP82waytil5vJODFlslpy54NzIKze1exhOpxReLdSKXip7P7Zo8PFIYSUxWsiQjtKtv7UV1qCUeDqzPHtLZwZFFn5JgymDEgWBrEbOLMvO1CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=PswIMUK7; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [0.0.0.0] ([134.134.137.72])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 58FH4vE22801932
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 15 Sep 2025 10:04:57 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 58FH4vE22801932
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1757955898;
	bh=JbWMiStndH0zdL0jqV2oFj5rZ7N3e7IVzr7NBcUkyX0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PswIMUK7RLrOYL724NWLO+FU07YSavIOCsEN0Lo3+H1kLXvlqoAAziDmyUeHPrE7i
	 1TLh7s91nbQh/4uA+p7cLa5LY7e9/WOzOLv/2Nb/08l2Nkf5zagSiskgeSrKKXIffS
	 DBjc+m3khQq0wLBsjBMRITk1MaGkH5/Q3SmQt+vHPDYat77jP2m4urEyW5MOL65NoJ
	 wOokMJ2IpYolNK9TWk2lFWPf+d6OaztfznYv/FFdNPZJLHjR4hj8qqnRn8Nx08k6Nr
	 alrKEX9VPXbMUG25G+QZWak9FXaAjpumFnFt0FI8USzG8u9oHbm3C1tGgkfYSYz0M1
	 JDoRQq0MWQ05g==
Message-ID: <65184bb3-0a36-49c3-b212-4b19f2df7092@zytor.com>
Date: Mon, 15 Sep 2025 10:04:51 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 09/41] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Mathias Krause <minipli@grsecurity.net>,
        John Allen <john.allen@amd.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-10-seanjc@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20250912232319.429659-10-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/2025 4:22 PM, Sean Christopherson wrote:
> Load the guest's FPU state if userspace is accessing MSRs whose values
> are managed by XSAVES. Introduce two helpers, kvm_{get,set}_xstate_msr(),
> to facilitate access to such kind of MSRs.
> 
> If MSRs supported in kvm_caps.supported_xss are passed through to guest,
> the guest MSRs are swapped with host's before vCPU exits to userspace and
> after it reenters kernel before next VM-entry.
> 
> Because the modified code is also used for the KVM_GET_MSRS device ioctl(),
> explicitly check @vcpu is non-null before attempting to load guest state.
> The XSAVE-managed MSRs cannot be retrieved via the device ioctl() without
> loading guest FPU state (which doesn't exist).
> 
> Note that guest_cpuid_has() is not queried as host userspace is allowed to
> access MSRs that have not been exposed to the guest, e.g. it might do
> KVM_SET_MSRS prior to KVM_SET_CPUID2.
> 
> The two helpers are put here in order to manifest accessing xsave-managed
> MSRs requires special check and handling to guarantee the correctness of
> read/write to the MSRs.
> 
> Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> [sean: drop S_CET, add big comment, move accessors to x86.c]
> Signed-off-by: Sean Christopherson <seanjc@google.com>


Reviewed-by: Xin Li (Intel) <xin@zytor.com>


> ---
>   arch/x86/kvm/x86.c | 86 +++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 85 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c5e38d6943fe..a95ca2fbd3a9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3801,6 +3804,66 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>   	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
>   }
>   
> +/*
> + * Returns true if the MSR in question is managed via XSTATE, i.e. is context
> + * switched with the rest of guest FPU state.  Note!  S_CET is _not_ context
> + * switched via XSTATE even though it _is_ saved/restored via XSAVES/XRSTORS.
> + * Because S_CET is loaded on VM-Enter and VM-Exit via dedicated VMCS fields,
> + * the value saved/restored via XSTATE is always the host's value.  That detail
> + * is _extremely_ important, as the guest's S_CET must _never_ be resident in
> + * hardware while executing in the host.  Loading guest values for U_CET and
> + * PL[0-3]_SSP while executing in the kernel is safe, as U_CET is specific to
> + * userspace, and PL[0-3]_SSP are only consumed when transitioning to lower
> + * privilegel levels, i.e. are effectively only consumed by userspace as well.
> + */
> +static bool is_xstate_managed_msr(struct kvm_vcpu *vcpu, u32 msr)
> +{
> +	if (!vcpu)
> +		return false;
> +
> +	switch (msr) {
> +	case MSR_IA32_U_CET:
> +		return guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) ||
> +		       guest_cpu_cap_has(vcpu, X86_FEATURE_IBT);
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		return guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
> +	default:
> +		return false;
> +	}
> +}

With this new version of is_xstate_managed_msr(), which checks against vcpu
capabilities instead of KVM, patch 9 of KVM FRED patches[1] no longer needs
to make any change to it.  And this is the only conflict when I apply KVM
FRED patches on top of this v15 mega-CET patch series.

[1] https://lore.kernel.org/lkml/20250829153149.2871901-10-xin@zytor.com/




