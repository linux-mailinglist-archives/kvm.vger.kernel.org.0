Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B595B5BA2
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 15:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiILNwJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 09:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiILNwH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 09:52:07 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2151731DC1
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 06:52:04 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id l10so8651695plb.10
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 06:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=/4RJpDcHTnyeNgFQ8a9TRZhL70VzQaaPYPhwoY3FyM0=;
        b=TT/m6xXUYiAmG34jqjtSaXSDf2ErMTttL2bICiiudLeZULeuX9LZLKa7GvR7pU2eYJ
         A1cV+HEYw8E5U25Kal7cWv7o99RJwGhJflS8tDsgsiUO1R1fpfV/9AxP5XM/9VmSIWHF
         LndIKnjDB/TfV/2LGrMB8m5SesZ1gd2MrLsqRlUsHNNHSe9pqf1Gb5D6AVAPag024n66
         uUqxwN3viPsLuJlP2jaGQRJuJgnS8GeGRCv+5Pw+yIzOxndmffTgkEPdrPL6kA5LGdH6
         oDq7Yx5RSg03t+LYPloL5LJTKfz89eTCfFmEperKI1J9qvMU5wEdFQ096hBYWRMRNCWW
         Bf9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=/4RJpDcHTnyeNgFQ8a9TRZhL70VzQaaPYPhwoY3FyM0=;
        b=mhQytKg8a4/9talAYngYcLKzpPEraEUbCYhC0ttTsuG2uaWq+1NR8UokQ6L74pjURb
         tv9GE2xBjEIITII56AOSa8kYQLXNDAGKRUCW+mkJSf12/v5AkhCTV/NB57LGGm64qzsd
         Vv0gE2nGfUiM+LC9cmmD9pS+SytNsH94Sx5UOlQC1+Zyr+9AZ5Gnhp01oFSMQdUtd4zW
         MrLdhZHhuRBHrNW+/13kY6Ud2MHi6CsIQeGZjcoIoQU+IDZKcTuq+8XFs3FZCp3YIP4I
         DXUcUoeMLQbvaTce/jlT2diLkXOvc55FS0QJOCRZMJA3ntLKAtRingYcUGr8sG6Ng5jK
         Idyw==
X-Gm-Message-State: ACgBeo3H4fo9qbl5797C5DKFm9mnufPsRH7Rd+9ro4NsiyZcQPHBGow6
        03Wo4ayw6QB+qDfxa3wpDPJegg==
X-Google-Smtp-Source: AA6agR63dJVcPhgDPjTWPAQKsStqogFvfX4ClfDkxrf/euFjFsDLwH2JRPfk73V5+0JZvA7bYqxSAQ==
X-Received: by 2002:a17:903:2285:b0:177:ab99:9e5 with SMTP id b5-20020a170903228500b00177ab9909e5mr25087264plh.121.1662990722436;
        Mon, 12 Sep 2022 06:52:02 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n9-20020a170902e54900b00174be817124sm6041785plf.221.2022.09.12.06.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 06:52:02 -0700 (PDT)
Date:   Mon, 12 Sep 2022 13:51:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] KVM: x86: Hyper-V invariant TSC control
Message-ID: <Yx85fuFWR/X097SL@google.com>
References: <20220831085009.1627523-1-vkuznets@redhat.com>
 <20220831085009.1627523-2-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831085009.1627523-2-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022, Vitaly Kuznetsov wrote:
> Normally, genuine Hyper-V doesn't expose architectural invariant TSC
> (CPUID.80000007H:EDX[8]) to its guests by default. A special PV MSR
> (HV_X64_MSR_TSC_INVARIANT_CONTROL, 0x40000118) and corresponding CPUID
> feature bit (CPUID.0x40000003.EAX[15]) were introduced. When bit 0 of the
> PV MSR is set, invariant TSC bit starts to show up in CPUID. When the
> feature is exposed to Hyper-V guests, reenlightenment becomes unneeded.
> 
> Add the feature to KVM. Keep CPUID output intact when the feature
> wasn't exposed to L1 and implement the required logic for hiding
> invariant TSC when the feature was exposed and invariant TSC control
> MSR wasn't written to. Copy genuine Hyper-V behavior and forbid to
> disable the feature once it was enabled.
> 
> For the reference, for linux guests, support for the feature was added
> in commit dce7cd62754b ("x86/hyperv: Allow guests to enable InvariantTSC").
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/cpuid.c            |  7 +++++++
>  arch/x86/kvm/hyperv.c           | 19 +++++++++++++++++++
>  arch/x86/kvm/hyperv.h           | 15 +++++++++++++++
>  arch/x86/kvm/x86.c              |  4 +++-
>  5 files changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2c96c43c313a..9098187e13aa 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1021,6 +1021,7 @@ struct kvm_hv {
>  	u64 hv_reenlightenment_control;
>  	u64 hv_tsc_emulation_control;
>  	u64 hv_tsc_emulation_status;
> +	u64 hv_invtsc;

For consistency with the other fields, should this be hv_tsc_invariant_control?
>  
>  	/* How many vCPUs have VP index != vCPU index */
>  	atomic_t num_mismatched_vp_indexes;
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 75dcf7a72605..8ccd45fd66a9 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1444,6 +1444,13 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>  			    (data & TSX_CTRL_CPUID_CLEAR))
>  				*ebx &= ~(F(RTM) | F(HLE));
>  		}
> +		/*
> +		 * Filter out invariant TSC (CPUID.80000007H:EDX[8]) for Hyper-V
> +		 * guests if needed.
> +		 */
> +		if (function == 0x80000007 && kvm_hv_invtsc_filtered(vcpu))

This can be an else-if.  Kinda weird, but it could be written as

		else if (function = 0x80000007) {
			if (kvm_hv_invtsc_filtered(vcpu))
				*edx &= ~SF(CONSTANT_TSC)
		}

to make it a pure function+index check.

> +			*edx &= ~(1 << 8);

Ugh, scattered.  Can you add a kvm_only_cpuid_leafs entry so that the bit doesn't
have to be open coded?

> +
>  	} else {
>  		*eax = *ebx = *ecx = *edx = 0;
>  		/*
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index ed804447589c..df90cd7501b9 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -991,6 +991,7 @@ static bool kvm_hv_msr_partition_wide(u32 msr)
>  	case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
>  	case HV_X64_MSR_TSC_EMULATION_CONTROL:
>  	case HV_X64_MSR_TSC_EMULATION_STATUS:
> +	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
>  	case HV_X64_MSR_SYNDBG_OPTIONS:
>  	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>  		r = true;
> @@ -1275,6 +1276,9 @@ static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
>  	case HV_X64_MSR_TSC_EMULATION_STATUS:
>  		return hv_vcpu->cpuid_cache.features_eax &
>  			HV_ACCESS_REENLIGHTENMENT;
> +	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
> +		return hv_vcpu->cpuid_cache.features_eax &
> +			HV_ACCESS_TSC_INVARIANT;
>  	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
>  	case HV_X64_MSR_CRASH_CTL:
>  		return hv_vcpu->cpuid_cache.features_edx &
> @@ -1402,6 +1406,17 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
>  		if (!host)
>  			return 1;
>  		break;
> +	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
> +		/* Only bit 0 is supported */
> +		if (data & ~BIT_ULL(0))

Can a #define be added instead of open coding bit 0?

> +			return 1;
> +

Doesn't the host CPUID need to be honored on writes from the guest?

> +		/* The feature can't be disabled from the guest */
> +		if (!host && hv->hv_invtsc && !data)
> +			return 1;
> +
> +		hv->hv_invtsc = data;
> +		break;
>  	case HV_X64_MSR_SYNDBG_OPTIONS:
>  	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>  		return syndbg_set_msr(vcpu, msr, data, host);
> @@ -1577,6 +1592,9 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
>  	case HV_X64_MSR_TSC_EMULATION_STATUS:
>  		data = hv->hv_tsc_emulation_status;
>  		break;
> +	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
> +		data = hv->hv_invtsc;
> +		break;
>  	case HV_X64_MSR_SYNDBG_OPTIONS:
>  	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>  		return syndbg_get_msr(vcpu, msr, pdata, host);
> @@ -2497,6 +2515,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  			ent->eax |= HV_MSR_REFERENCE_TSC_AVAILABLE;
>  			ent->eax |= HV_ACCESS_FREQUENCY_MSRS;
>  			ent->eax |= HV_ACCESS_REENLIGHTENMENT;
> +			ent->eax |= HV_ACCESS_TSC_INVARIANT;
>  
>  			ent->ebx |= HV_POST_MESSAGES;
>  			ent->ebx |= HV_SIGNAL_EVENTS;
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index da2737f2a956..1a6316ab55eb 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -133,6 +133,21 @@ static inline bool kvm_hv_has_stimer_pending(struct kvm_vcpu *vcpu)
>  			     HV_SYNIC_STIMER_COUNT);
>  }
>  
> +/*
> + * With HV_ACCESS_TSC_INVARIANT feature, invariant TSC (CPUID.80000007H:EDX[8])
> + * is only observed after HV_X64_MSR_TSC_INVARIANT_CONTROL was written to.
> + */
> +static inline bool kvm_hv_invtsc_filtered(struct kvm_vcpu *vcpu)

Can this be more strongly worded, e.g. maybe kvm_hv_is_invtsc_disabled()?  "Filtered"
doesn't strictly mean disabled and makes it sound like there's something else that
needs to act on the "filtering"

> +{
> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
> +
> +	if (hv_vcpu && hv_vcpu->cpuid_cache.features_eax & HV_ACCESS_TSC_INVARIANT)

Ah, I almost missed the inner check.  Can you write this as:

	if (!hv_vcpu)
		return false;

so that the potentially postive/happy path is at the end?  I.e. follow the common
pattern of:

	if (!something)
		return -ERRNO;

	return 0;

> +		return !hv->hv_invtsc;

Kinda silly, but I think it's worth checking the exact bit here.  I don't see how
the TSC can get more invariant, but if another bit is added, this could silently
break.  And probably no need to grab to_kvm_v() locally.

	return to_kvm_hv(vcpu->kvm)->hv_invtsc;


> +
> +	return false;

Shouldn't this be "return true" if HyperV is enabled but doesn't have the CPUID
bit set?  I assume the expectation is that host userspace won't set the common
INVTSC flag without also setting HV_ACCESS_TSC_INVARIANT, but it's confusing logic
as is.

All in all, I think this?

	if (!hv_vcpu)
		return false;

	return hv_vcpu->cpuid_cache.features_eax & HV_ACCESS_TSC_INVARIANT &&
	       to_kvm_hv(vcpu->kvm)->hv_invtsc & BIT(0);

> +}
> +
>  void kvm_hv_process_stimers(struct kvm_vcpu *vcpu);
>  
>  void kvm_hv_setup_tsc_page(struct kvm *kvm,
