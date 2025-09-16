Return-Path: <kvm+bounces-57697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A2E9B590B4
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 10:32:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 261BF7B3484
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 08:28:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1F732EA49C;
	Tue, 16 Sep 2025 08:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b4wNBC7V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CEF31FBC92;
	Tue, 16 Sep 2025 08:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758011323; cv=none; b=Z3g/S8qe/Syhw+VOJTByJCleXTcn9qTss2Hti0zwiH3QtCNhgpLjp9FFffGpBRgZr8dTV+AYURUif1FVA2XGf47zSNeiJtqsxvs6Fctv7yCbuYbmcsPsetqXNcVg8Au2qaMiNyW+Eujb5+N6Kel3CMgck2DwLJXAezYq7+2Y62c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758011323; c=relaxed/simple;
	bh=7rZzmcZLv9RcXOrgsLrtqR65y9Gz2zX3jgF0fEyTaGc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JMfAAdjLiVENoY8gHQNImxxGKQFoBxPzsS7vJMt1BdeLrg60Fh+2OEZzjtLU31y6dkA12b6NY9U3hNo7DfNGME6xIThcqu1E/og2XesfnII79HVsqnmA4qJeE7XZclzN/Xf2ToRvxZGtqFeisjtP1lnV3wIz1qMGiyHzWwEYKiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b4wNBC7V; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758011321; x=1789547321;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7rZzmcZLv9RcXOrgsLrtqR65y9Gz2zX3jgF0fEyTaGc=;
  b=b4wNBC7V2Lp/+2Xcr+bbkOcVyWools0bbUWIFMBTjiE4yhu85tniwTPA
   bvw1L7NYQ+YSuMfOXvk78rB0GY46FPbC2S1ROK5xOarNdLTmvu/05gp5f
   AEq2O7gj9GEP0BeZ8+lCVYiw35mfC6/RB+GO/DLQXQVFX4rXUF8tY7k6/
   TyTCaz26MagSEITujCc5LQy1uztZfTTyyBePWuMxWQd521dIsd5GVT/Lz
   jdYZIbSPDILtqJyUlxzO5Y+EE4U/NjBPjNpWmQ3m1Bp9ACDgdLYMLoj5V
   cVzjmg+W4pZHE7JdTcl+Hn1ftfdx2u3Ss9ZuEP1UvRrShMmJzIObdckp9
   A==;
X-CSE-ConnectionGUID: ZWqrIchJRPKVKsBRUvE/bg==
X-CSE-MsgGUID: lCQQ23raSouOEezfOClCsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="60213297"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="60213297"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 01:28:40 -0700
X-CSE-ConnectionGUID: 4FJli7jeSrWQDVKFk2dTLA==
X-CSE-MsgGUID: dRgPX5jOQTqA7hs25Hsmfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="180126156"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 01:28:38 -0700
Message-ID: <c4b9d87b-fddc-420b-ac86-7da48a42610f@linux.intel.com>
Date: Tue, 16 Sep 2025 16:28:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 09/41] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-10-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250912232319.429659-10-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/13/2025 7:22 AM, Sean Christopherson wrote:
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

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

Two nits below.

> ---
>   arch/x86/kvm/x86.c | 86 +++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 85 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c5e38d6943fe..a95ca2fbd3a9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -136,6 +136,9 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
>   static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
>   
>   static DEFINE_MUTEX(vendor_module_lock);
> +static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
> +static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
> +
>   struct kvm_x86_ops kvm_x86_ops __read_mostly;
>   
>   #define KVM_X86_OP(func)					     \
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
> +
> +/*
> + * Lock and/or reload guest FPU and access xstate MSRs. For accesses initiated


Lock is unconditional and reload is conditional.
"and/or" seems not accurate?

> + * by host, guest FPU is loaded in __msr_io(). For accesses initiated by guest,
> + * guest FPU should have been loaded already.
> + */
> +static __always_inline void kvm_access_xstate_msr(struct kvm_vcpu *vcpu,
> +						  struct msr_data *msr_info,
> +						  int access)
> +{
> +	BUILD_BUG_ON(access != MSR_TYPE_R && access != MSR_TYPE_W);
> +
> +	KVM_BUG_ON(!is_xstate_managed_msr(vcpu, msr_info->index), vcpu->kvm);
> +	KVM_BUG_ON(!vcpu->arch.guest_fpu.fpstate->in_use, vcpu->kvm);
> +
> +	kvm_fpu_get();
> +	if (access == MSR_TYPE_R)
> +		rdmsrq(msr_info->index, msr_info->data);
> +	else
> +		wrmsrq(msr_info->index, msr_info->data);
> +	kvm_fpu_put();
> +}
> +
> +static __maybe_unused void kvm_set_xstate_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> +{
> +	kvm_access_xstate_msr(vcpu, msr_info, MSR_TYPE_W);
> +}
> +
> +static __maybe_unused void kvm_get_xstate_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> +{
> +	kvm_access_xstate_msr(vcpu, msr_info, MSR_TYPE_R);
> +}
> +
>   int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   {
>   	u32 msr = msr_info->index;
> @@ -4551,11 +4614,25 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
>   		    int (*do_msr)(struct kvm_vcpu *vcpu,
>   				  unsigned index, u64 *data))
>   {
> +	bool fpu_loaded = false;
>   	int i;
>   
> -	for (i = 0; i < msrs->nmsrs; ++i)
> +	for (i = 0; i < msrs->nmsrs; ++i) {
> +		/*
> +		 * If userspace is accessing one or more XSTATE-managed MSRs,
> +		 * temporarily load the guest's FPU state so that the guest's
> +		 * MSR value(s) is resident in hardware, i.e. so that KVM can

Using "i.e." and "so that" together feels repetitive.[...]

