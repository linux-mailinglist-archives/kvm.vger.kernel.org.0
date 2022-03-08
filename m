Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682C44D14C2
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 11:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345876AbiCHKaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 05:30:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345848AbiCHK37 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 05:29:59 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F0F3C489
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 02:29:03 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id kx6-20020a17090b228600b001bf859159bfso1822157pjb.1
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 02:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:cc:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=p8/NRHDkv4nhYswvOn46nNnRF6vVZN1beNLSnAJ1y1M=;
        b=F5WUhuR7tiMuhNfbZcB4Lm3QgVdXlaZ26OYKp5ZyJ/2TRz0EzfK5rG6+r77waUAXiW
         tFkPkSCMT93z9qFZPaV2RFQCehogxl2mPfzml7pXUWGQyBgC12A4AHQXB85Ub2HsJ6z0
         ZnqHKRQGjy1QBIEbZCVn/lLIpyENW/FCwMXFSinXYl36EmXJntxP8Ovy3Fr9wmDcmBLr
         VvB5m+wuZjANPbmSHFmEX3shV+/EVceExRw92iRjf1b/DVEJnw2CDlKdev3C3uUQuc9W
         lh9EaSkfJC+6P+35tkW4TgWgTMZ+FDPMdSyHztMDP8OCRGzoACb8mTPvuLLyzfnvYPCF
         +WPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:cc:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=p8/NRHDkv4nhYswvOn46nNnRF6vVZN1beNLSnAJ1y1M=;
        b=nAnq+mwduXchPdGArzj6WkKHHUROzB8wwOLVA1OCriH3OOkRmbyyCzJMamxZxJbOAW
         EAFErtlbj6DAE7kVRyUqeU/a8HCS6YKqud9H5rDSzavT4ydnUyKhNmCQdU5vcDuLLgie
         xnc7INcV+sdn2TOqwuPAhnv10Z3dCwZ6WxtNQ5hPIz5jqOklIGnSth3MA3NAQu/C1ec5
         AawOG0H1hF0KerWEWEKT3ma/eZJGpseEpPNQ1KeruZmmvpXm+Xr3xMxQWIc6zevUZcX7
         fJOzzjkp872JFgTxxoR2CX2trvyuMueulyatsX5VB3kHxMLoeXeDebFqnbVY6Ldoi5Wg
         Nuig==
X-Gm-Message-State: AOAM532bmPrm0hPRFHH/cArc3TJdAPtrBfLvjflLrGdowi5qMcsyQ7Ln
        I23hiz2nU+e1ffnRs7z4yAxlrS9JMB8RU07K
X-Google-Smtp-Source: ABdhPJx5bkAy4eByDtuuX3LcVxeHXUeR3KAaTfsiEBXG+K4ijGK/yIgjJlL97oV/JTvsX3QLSNqQxQ==
X-Received: by 2002:a17:90b:3805:b0:1bf:6eca:2fc7 with SMTP id mq5-20020a17090b380500b001bf6eca2fc7mr3909163pjb.228.1646735343274;
        Tue, 08 Mar 2022 02:29:03 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 23-20020a17090a0b9700b001b8f602eaeasm2326221pjr.53.2022.03.08.02.29.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 02:29:02 -0800 (PST)
Message-ID: <01af48ad-fee3-603a-7b14-5a0ae52bb7f9@gmail.com>
Date:   Tue, 8 Mar 2022 18:28:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH] KVM: x86/pmu: Use different raw event masks for AMD and
 Intel
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
References: <20220308012452.3468611-1-jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <20220308012452.3468611-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/3/2022 9:24 am, Jim Mattson wrote:
> The third nybble of AMD's event select overlaps with Intel's IN_TX and
> IN_TXCP bits. Therefore, we can't use AMD64_RAW_EVENT_MASK on Intel
> platforms that support TSX.

We already have pmu->reserved_bits as the first wall to check "can't use".

> 
> Declare a raw_event_mask in the kvm_pmu structure, initialize it in
> the vendor-specific pmu_refresh() functions, and use that mask for
> PERF_TYPE_RAW configurations in reprogram_gp_counter().
> 
> Fixes: 710c47651431 ("KVM: x86/pmu: Use AMD64_RAW_EVENT_MASK for PERF_TYPE_RAW")

Is it really a fix ?

> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 1 +
>   arch/x86/kvm/pmu.c              | 3 ++-
>   arch/x86/kvm/svm/pmu.c          | 1 +
>   arch/x86/kvm/vmx/pmu_intel.c    | 1 +
>   4 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c45ab8b5c37f..cacd27c1aa19 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -510,6 +510,7 @@ struct kvm_pmu {
>   	u64 global_ctrl_mask;
>   	u64 global_ovf_ctrl_mask;
>   	u64 reserved_bits;
> +	u64 raw_event_mask;
>   	u8 version;
>   	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
>   	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index b1a02993782b..902b6d700215 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -185,6 +185,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>   	u32 type = PERF_TYPE_RAW;
>   	struct kvm *kvm = pmc->vcpu->kvm;
>   	struct kvm_pmu_event_filter *filter;
> +	struct kvm_pmu *pmu = vcpu_to_pmu(pmc->vcpu);

How about pmc_to_pmu(pmc) ?

>   	bool allow_event = true;
>   
>   	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
> @@ -221,7 +222,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>   	}
>   
>   	if (type == PERF_TYPE_RAW)
> -		config = eventsel & AMD64_RAW_EVENT_MASK;
> +		config = eventsel & pmu->raw_event_mask;

If the code base is current kvm/queue,
the checks about (eventsel & HSW_IN_TX*) is still there.

Not sure why we're wasting extra 'u64' space for nothing.

>   
>   	if (pmc->current_config == eventsel && pmc_resume_counter(pmc))
>   		return;
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 886e8ac5cfaa..24eb935b6f85 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -282,6 +282,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>   
>   	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
>   	pmu->reserved_bits = 0xfffffff000280000ull;
> +	pmu->raw_event_mask = AMD64_RAW_EVENT_MASK;
>   	pmu->version = 1;
>   	/* not applicable to AMD; but clean them to prevent any fall out */
>   	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 4e5b1eeeb77c..da71160a50d6 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -485,6 +485,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>   	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
>   	pmu->version = 0;
>   	pmu->reserved_bits = 0xffffffff00200000ull;
> +	pmu->raw_event_mask = X86_RAW_EVENT_MASK;
>   
>   	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
>   	if (!entry || !vcpu->kvm->arch.enable_pmu)
