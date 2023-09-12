Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B991379D06B
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 13:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234743AbjILLzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 07:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234786AbjILLzE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 07:55:04 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF98510D0
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 04:55:00 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1bf11b1c7d0so45753015ad.0
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 04:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694519700; x=1695124500; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0FerURhc9U7m/MJvgQjSA3w3G9vaRhSWLbIq3M551Nw=;
        b=Ad3wQv313ajXpbqO+wSB3OHVsWTAkVdBxqQsHB+5e6E1xkP/yMsaUrH0KHnvQOLzSW
         QFC48uuTAQCWY0nNQVbUFx4slqJyrcbY8UVxKNEajx8KLx6w667IlrXL5ZM359zntvM6
         XlS0pt4WkpSMWArxQSNO+m6eqkM8MrxkLqD6eSqo+BICb79R8AqGumc5M4Ie2wRTyLqx
         PLP46nkrJlyMm9sMJfaLH7PeSlazCwWuuuNeQQhprkd5iAO7tViUDNpmGIevzsOYCIrq
         AwN54WzhStAuZsCe9v4tWyA1fGmevU4Fne0UfU07MoWH0ENfJbhtcWVX713pPOC5r4BU
         NgsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694519700; x=1695124500;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0FerURhc9U7m/MJvgQjSA3w3G9vaRhSWLbIq3M551Nw=;
        b=sWzriCscg7qNJdpB3wAooSkmJtbAoOt9YTMIApsJGYy3xfdKKNfgK9pO5e8VCGpDKC
         moEwVit+uXH5OFg8ew35QQHEtiPCB7o1VRUJXfy0t7oSa6n9+9k/TMzmEVXDPjvQBMYo
         QUpsGmJ3+2HhKcCP6R9Ev5zWP9zZ0pNqzVv8xKEeG//p4lIpsj2QpnXUDwyyRIqrxwEI
         uK7Ve8YI7M0yqB23OoQNmF11cQpGC+nG3rpt6o29mebSOMCVYTLg+jh/FiBlsP1PF9cI
         1VBuf1xjd0ZELQCCke+OufQrducTYUqvvaQ5tndKrbNj/eDPJTuH4T9oni7gn0KKXwbI
         JJ3g==
X-Gm-Message-State: AOJu0YyMgz7o6PuVKwglEB9T926nL8y37TPWmzqc3s1cxyCAuRl/+Y2w
        Pg3rJQWYf83OLGCY5tREnc8=
X-Google-Smtp-Source: AGHT+IF+a5LOxMbrDVbZnnMuo+PR2pm0pmrVpJc5bWLGI77UyelPgXdJD7jAIgiXUjIQcFlxA/DgEw==
X-Received: by 2002:a17:902:e88d:b0:1bb:cd5a:ba53 with SMTP id w13-20020a170902e88d00b001bbcd5aba53mr3373468plg.14.1694519700104;
        Tue, 12 Sep 2023 04:55:00 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id w11-20020a170902e88b00b001bde440e693sm8296879plg.44.2023.09.12.04.54.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Sep 2023 04:54:59 -0700 (PDT)
Message-ID: <af7c3bae-d63c-1a11-e5ba-588c0dcd3368@gmail.com>
Date:   Tue, 12 Sep 2023 19:54:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH 1/9] KVM: x86/PMU: Don't release vLBR caused by PMI
Content-Language: en-US
To:     Xiong Zhang <xiong.y.zhang@intel.com>
Cc:     seanjc@google.com, zhiyuan.lv@intel.com, zhenyu.z.wang@intel.com,
        kan.liang@intel.com, dapeng1.mi@linux.intel.com,
        kvm@vger.kernel.org
References: <20230901072809.640175-1-xiong.y.zhang@intel.com>
 <20230901072809.640175-2-xiong.y.zhang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230901072809.640175-2-xiong.y.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/9/2023 3:28 pm, Xiong Zhang wrote:
> vLBR event will be released at vcpu sched-in time if LBR_EN bit is not
> set in GUEST_IA32_DEBUGCTL VMCS field, this bit is cleared in two cases:
> 1. guest disable LBR through WRMSR
> 2. KVM disable LBR at PMI injection to emulate guest FREEZE_LBR_ON_PMI.
> 
> The first case is guest LBR won't be used anymore and vLBR event can be
> released, but guest LBR is still be used in the second case, vLBR event
> can not be released.
> 
> Considering this serial:
> 1. vPMC overflow, KVM injects vPMI and clears guest LBR_EN
> 2. guest handles PMI, and reads LBR records.
> 3. vCPU is sched-out, later sched-in, vLBR event is released.

This has nothing to do with vPMI. If guest lbr is disabled and the guest
LBR driver doesn't read it before the KVM vLBR event is released (typically
after two sched slices), that part of the LBR records are lost in terms of
design. What is needed here is a generic KVM mechanism to close this gap.

> 4. Guest continue reading LBR records, KVM creates vLBR event again,
> the vLBR event is the only LBR user on host now, host PMU driver will
> reset HW LBR facility at vLBR creataion.
> 5. Guest gets the remain LBR records with reset state.
> This is conflict with FREEZE_LBR_ON_PMI meaning, so vLBR event can
> not be release on PMI.
> 
> This commit adds a freeze_on_pmi flag, this flag is set at pmi
> injection and is cleared when guest operates guest DEBUGCTL_MSR. If
> this flag is true, vLBR event will not be released.
> 
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> ---
>   arch/x86/kvm/vmx/pmu_intel.c |  5 ++++-
>   arch/x86/kvm/vmx/vmx.c       | 12 +++++++++---
>   arch/x86/kvm/vmx/vmx.h       |  3 +++
>   3 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index f2efa0bf7ae8..3a36a91638c6 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -628,6 +628,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
>   	lbr_desc->records.nr = 0;
>   	lbr_desc->event = NULL;
>   	lbr_desc->msr_passthrough = false;
> +	lbr_desc->freeze_on_pmi = false;
>   }
>   
>   static void intel_pmu_reset(struct kvm_vcpu *vcpu)
> @@ -670,6 +671,7 @@ static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
>   	if (data & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI) {
>   		data &= ~DEBUGCTLMSR_LBR;
>   		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> +		vcpu_to_lbr_desc(vcpu)->freeze_on_pmi = true;
>   	}
>   }
>   
> @@ -761,7 +763,8 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
>   
>   static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
>   {
> -	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
> +	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR) &&
> +	    !vcpu_to_lbr_desc(vcpu)->freeze_on_pmi)
>   		intel_pmu_release_guest_lbr_event(vcpu);
>   }
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e6849f780dba..199d0da1dbee 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2223,9 +2223,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
>   
>   		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> -		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
> -		    (data & DEBUGCTLMSR_LBR))
> -			intel_pmu_create_guest_lbr_event(vcpu);
> +
> +		if (intel_pmu_lbr_is_enabled(vcpu)) {
> +			struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
> +
> +			lbr_desc->freeze_on_pmi = false;
> +			if (!lbr_desc->event && (data & DEBUGCTLMSR_LBR))
> +				intel_pmu_create_guest_lbr_event(vcpu);
> +		}
> +
>   		return 0;
>   	}
>   	case MSR_IA32_BNDCFGS:
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index c2130d2c8e24..9729ccfa75ae 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -107,6 +107,9 @@ struct lbr_desc {
>   
>   	/* True if LBRs are marked as not intercepted in the MSR bitmap */
>   	bool msr_passthrough;
> +
> +	/* True if LBR is frozen on PMI */
> +	bool freeze_on_pmi;
>   };
>   
>   /*
