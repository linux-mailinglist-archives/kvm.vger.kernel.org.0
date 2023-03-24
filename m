Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562766C888D
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 23:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbjCXWqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 18:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjCXWqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 18:46:45 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C843818AB9
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 15:46:43 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id w135-20020a62828d000000b0062c4eb40ddeso189431pfd.3
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 15:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679698003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y38J5Q0T0ljikOd/ueM85GePmC9PC1NOb8RKF0XdDh4=;
        b=p+a4ya4UwilyU/e2NJKPKG2kW31JLZNQXk8MJBmAe50q7dojOAtor4Hu6v3/V4KmQg
         rFjBa5XQNPSaZd8avNjgaagSsrKSJSV/hXP34YzQRU3al/ezRL4x/Plw8rjfCsaDyJia
         vf6eVYs8tmyf+BKnJri84kaekQ5hFK5zL+d4TcbEJYobgAuyBV+QXFEGeXl2CqSVQt/w
         SYCCP1ggIH2uGioIiBRZQi6vaUuWNaB8tBgNRk/+u5NfoNKlXmD0wQy+246gJXnwiQ77
         HQRcusOnjhDgiZ6gLHzPE2KVKn3RXx8tuVgoq9+rzFQnJ0nRd3qJ8XDjnmxdmk2HTC56
         z36A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679698003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y38J5Q0T0ljikOd/ueM85GePmC9PC1NOb8RKF0XdDh4=;
        b=W77ZmTQ4hHT068v3bfDy+N/RBgg5Cv1fi5rdbzjgqmnSPPkSN6P9QWy4aMbbIPa72a
         zWn+U/MlZ2HVoq9R6Ne14BgD9OJAa2s4Mx3a6zXA58eMXfwg14da7g8gFYI1OGhb/hy0
         lL6i1KuY9l3kOzG18P1R5VBcNXmmRDOtODJNn0OmR3XO+BczB4tu5wSMc9zYm6X2cGNg
         MVzxJnlVXWPHYfLgL9eOsXH2CSyDgYbAhJWVOEt3bUN3AqYdysDLX+Fi0nT1wXrgAP1c
         IIs2RwYhB/c8L16DzGgKyWRaTnzuF2+8PPckE26XyDE7r6ZtVGeuPX3yRo7ls0Tksddi
         jevQ==
X-Gm-Message-State: AAQBX9eghX4xNhFfl+CCUP8a5CRmSHYEHxib0gEWYD8an7d5RAfnwy//
        ARGzK59PdzZ1NY21FAnQbsYRpnPW3vE=
X-Google-Smtp-Source: AKy350YxndtGDU88dvgE/yq9EHp2rISF2og6hi4IiYNjONjbDDxsPLpJU13oIO0RfP6uz7lkNxNjJ14abgY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:760f:b0:23f:b876:cef1 with SMTP id
 s15-20020a17090a760f00b0023fb876cef1mr1333524pjk.5.1679698003324; Fri, 24 Mar
 2023 15:46:43 -0700 (PDT)
Date:   Fri, 24 Mar 2023 15:46:42 -0700
In-Reply-To: <20230321112742.25255-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20230321112742.25255-1-likexu@tencent.com>
Message-ID: <ZB4oUhmIKPF2lAzN@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: Add Intel PMU supported fixed counters bit mask
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Per Intel SDM, fixed-function performance counter 'i' is supported if:
> 
> 	FxCtr[i]_is_supported := ECX[i] || (EDX[4:0] > i);
> 
> which means that the KVM user space can use EDX to limit the number of
> fixed counters and at the same time, using ECX to enable part of other
> KVM supported fixed counters.
> 
> Add a bitmap (instead of always checking the vcpu's CPUIDs) to keep track
> of the guest available fixed counters and perform the semantic checks.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/pmu.h              |  8 +++++
>  arch/x86/kvm/vmx/pmu_intel.c    | 53 +++++++++++++++++++++------------
>  3 files changed, 44 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a45de1118a42..14689e583127 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -565,6 +565,8 @@ struct kvm_pmu {
>  	 */
>  	bool need_cleanup;
>  
> +	DECLARE_BITMAP(supported_fixed_pmc_idx, KVM_PMC_MAX_FIXED);

Why add a new bitmap?  all_valid_pmc_idx is a strict superset, no?

> +static inline bool fixed_ctr_is_supported(struct kvm_pmu *pmu, unsigned int idx)
> +{
> +	return test_bit(idx, pmu->supported_fixed_pmc_idx);
> +}
> +
>  /* returns fixed PMC with the specified MSR */
>  static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
>  {
> @@ -120,6 +125,9 @@ static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
>  		u32 index = array_index_nospec(msr - base,
>  					       pmu->nr_arch_fixed_counters);
>  
> +		if (!fixed_ctr_is_supported(pmu, index))
> +			return NULL;
> +
>  		return &pmu->fixed_counters[index];
>  	}
>  
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index e8a3be0b9df9..12f4b2fe7756 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -43,13 +43,16 @@ static int fixed_pmc_events[] = {1, 0, 7};
>  static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
>  {
>  	struct kvm_pmc *pmc;
> -	u8 old_fixed_ctr_ctrl = pmu->fixed_ctr_ctrl;
> +	u8 new_ctrl, old_ctrl, old_fixed_ctr_ctrl = pmu->fixed_ctr_ctrl;
>  	int i;
>  
>  	pmu->fixed_ctr_ctrl = data;
>  	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> -		u8 new_ctrl = fixed_ctrl_field(data, i);
> -		u8 old_ctrl = fixed_ctrl_field(old_fixed_ctr_ctrl, i);

Please keep the variable declarations in the loop (I've had to eat my words about
variable shadowing), e.g. to prevent accessing new_ctrl or old_ctrl after the loop.

> +		if (!fixed_ctr_is_supported(pmu, i))
> +			continue;
> +
> +		new_ctrl = fixed_ctrl_field(data, i);
> +		old_ctrl = fixed_ctrl_field(old_fixed_ctr_ctrl, i);
>  
>  		if (old_ctrl == new_ctrl)
>  			continue;
> @@ -125,6 +128,9 @@ static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
>  
>  	idx &= ~(3u << 30);
>  
> +	if (fixed && !fixed_ctr_is_supported(pmu, idx))
> +		return false;
> +
>  	return fixed ? idx < pmu->nr_arch_fixed_counters
>  		     : idx < pmu->nr_arch_gp_counters;
>  }
> @@ -145,7 +151,7 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
>  		counters = pmu->gp_counters;
>  		num_counters = pmu->nr_arch_gp_counters;
>  	}
> -	if (idx >= num_counters)
> +	if (idx >= num_counters || (fixed && !fixed_ctr_is_supported(pmu, idx)))
>  		return NULL;
>  	*mask &= pmu->counter_bitmask[fixed ? KVM_PMC_FIXED : KVM_PMC_GP];
>  	return &counters[array_index_nospec(idx, num_counters)];
> @@ -500,6 +506,9 @@ static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
>  	int i;
>  
>  	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
> +		if (!fixed_ctr_is_supported(pmu, i))
> +			continue;
> +
>  		pmc = &pmu->fixed_counters[i];
>  		event = fixed_pmc_events[array_index_nospec(i, size)];
>  		pmc->eventsel = (intel_arch_events[event].unit_mask << 8) |
> @@ -520,6 +529,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  
>  	pmu->nr_arch_gp_counters = 0;
>  	pmu->nr_arch_fixed_counters = 0;
> +	bitmap_zero(pmu->supported_fixed_pmc_idx, KVM_PMC_MAX_FIXED);

Side topic, isn't KVM missing a bitmap_zero() on all_valid_pmc_idx?

>  	pmu->counter_bitmask[KVM_PMC_GP] = 0;
>  	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
>  	pmu->version = 0;

...

> +	if (pmu->version > 1) {
>  		pmu->nr_arch_fixed_counters =
> -			min3(ARRAY_SIZE(fixed_pmc_events),
> -			     (size_t) edx.split.num_counters_fixed,
> -			     (size_t)kvm_pmu_cap.num_counters_fixed);
> +			min_t(int, ARRAY_SIZE(fixed_pmc_events),
> +			      kvm_pmu_cap.num_counters_fixed);

Leaving nr_arch_fixed_counters set to kvm_pmu_cap.num_counters_fixed seems odd.
E.g. if userspace reduces the number of counters to 1, shouldn't that be reflected
in the PMU metadata?

Ah, you did that so the iteration works.  That's super confusing.  And silly,
because in the end, pmu->nr_arch_fixed_counters is just kvm_pmu_cap.num_counters_fixed.

THis holds true:

	BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_events) != KVM_PMC_MAX_FIXED);

and KVM does this

	kvm_pmu_cap.num_counters_fixed = min(kvm_pmu_cap.num_counters_fixed,
					     KVM_PMC_MAX_FIXED);

ergo the above min_t() is a nop.

One option would be to just use kvm_pmu_cap.num_counters_fixed, but I think it
makes more sense to use for_each_set_bit(), or perhaps for_each_set_bitrange_from()
if all_valid_pmc_idx is used.

And then end up with something like so:

static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
{
	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
	bool fixed = idx & (1u << 30);

	idx &= ~(3u << 30);

	return fixed ? fixed_ctr_is_supported(pmu, idx)
		     : idx < pmu->nr_arch_gp_counters;
}

static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
					    unsigned int idx, u64 *mask)
{
	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
	bool fixed = idx & (1u << 30);
	struct kvm_pmc *counters;
	unsigned int num_counters;

	if (!intel_is_valid_rdpmc_ecx(vcpu, idx))
		return NULL;

	idx &= ~(3u << 30);
	if (fixed) {
		counters = pmu->fixed_counters;
		num_counters = kvm_pmu_cap.num_counters_fixed;
	} else {
		counters = pmu->gp_counters;
		num_counters = pmu->nr_arch_gp_counters;
	}
	*mask &= pmu->counter_bitmask[fixed ? KVM_PMC_FIXED : KVM_PMC_GP];
	return &counters[array_index_nospec(idx, num_counters)];
}
