Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C454E487AB2
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 17:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348357AbiAGQtA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 11:49:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26829 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348339AbiAGQs7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 11:48:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641574139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pe8Sm++2ldV2D4FESGtTZqyhOkRzo4sYNja8DFQQ4Ws=;
        b=XyniP/gh/Pj6zvqWbABjDKAaXVcGnh6VRaGuxfuhm14roD05agaLn8jBX1LS4sNP/WPQOC
        8hfQTDmAwskS3Ysca7rssxzKk6+LMolqHfbOWeH5QhI3Lw8HC1EVoIeKJIUb8wfcEPDQZ6
        o5tUySTGtNQPar2rQ4B8ZADyqorkWPg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-77-zlM-457fOQ6l6-EKAE2pxg-1; Fri, 07 Jan 2022 11:48:58 -0500
X-MC-Unique: zlM-457fOQ6l6-EKAE2pxg-1
Received: by mail-ed1-f69.google.com with SMTP id h11-20020a05640250cb00b003fa024f87c2so5133775edb.4
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 08:48:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Pe8Sm++2ldV2D4FESGtTZqyhOkRzo4sYNja8DFQQ4Ws=;
        b=TLNskeahZXZe/v+vHSz7TncgZwAD7VPTyMYfIt6EnIPuICQecpqTeGIOfxmWMfJ0tW
         gFFD5FeR3UsOVmBnFNtSTJfKRINpViImk7RMzelOgOMAYUPkAuBKUmjaUt6keU3e1Q+5
         Y83QpxgZTg8Xp25N2zx2YZ+w+iCKmAQUzgxIHBPEVNqJKzO2fUlOfifnuTGer4n8capV
         +fyscOvVRDCOdRVqCJAlJCR1KkIc5745ELSlFADH8XtQ1lhbqVmh2kTiEpe2efZ1CdHo
         PIvsqRX9cLYt723kZqtW2Afep4K1FMc1uaOZS3ve0LnZ3EFHJWJty+iCQSTR7D4uIfJr
         ODCQ==
X-Gm-Message-State: AOAM532ky1wqDgYlyCZAZ6SSQO/NRAsxu3pfAbgIKZlhpCOtmTg77tHB
        bCbfnp06XGMo1lahsUv9GF/ix4CiVDFhNQxdNazimw6h++/9BYOuoCQP9Z6ZX5HoMHhpB25DM98
        TYQG7SEM30c2A
X-Received: by 2002:a05:6402:160d:: with SMTP id f13mr7452087edv.247.1641574136883;
        Fri, 07 Jan 2022 08:48:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzw9GmYU/PvuyJWTylj1DpMTk+X9aHstLHorYT7pdYL7AK0d+kGMLgm3nZMVGs4NnICyCkBzA==
X-Received: by 2002:a05:6402:160d:: with SMTP id f13mr7452068edv.247.1641574136694;
        Fri, 07 Jan 2022 08:48:56 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id z22sm2330165edd.68.2022.01.07.08.48.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 08:48:56 -0800 (PST)
Message-ID: <80dc4ee6-9401-a86b-f090-981abeb64354@redhat.com>
Date:   Fri, 7 Jan 2022 17:48:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2] KVM: x86/pmu: Fix available_event_types check for
 REF_CPU_CYCLES event
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220105051509.69437-1-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220105051509.69437-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/5/22 06:15, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> According to CPUID 0x0A.EBX bit vector, the event [7] should be the
> unrealized event "Topdown Slots" instead of the *kernel* generalized
> common hardware event "REF_CPU_CYCLES", so we need to skip the cpuid
> unavaliblity check in the intel_pmc_perf_hw_id() for the last
> REF_CPU_CYCLES event and update the confusing comment.
> 
> If the event is marked as unavailable in the Intel guest CPUID
> 0AH.EBX leaf, we need to avoid any perf_event creation, whether
> it's a gp or fixed counter. To distinguish whether it is a rejected
> event or an event that needs to be programmed with PERF_TYPE_RAW type,
> a new special returned value of "PERF_COUNT_HW_MAX + 1" is introduced.
> 
> Fixes: 62079d8a43128 ("KVM: PMU: add proper support for fixed counter 2")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
> v1 -> v2 Changelog:
> - Refine comment based on commit c1d6f42f1a42;
> - Squash the idea "avoid event creation for rejected hw_config" into this commit;
> - Squash the idea "PERF_COUNT_HW_MAX + 1" into this commit;
> 
> Previous:
> https://lore.kernel.org/kvm/20211112095139.21775-3-likexu@tencent.com/
> 
>   arch/x86/kvm/pmu.c           |  3 +++
>   arch/x86/kvm/vmx/pmu_intel.c | 18 ++++++++++++------
>   2 files changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 8abdadb7e22a..e632693a2266 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -109,6 +109,9 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>   		.config = config,
>   	};
>   
> +	if (type == PERF_TYPE_HARDWARE && config >= PERF_COUNT_HW_MAX)
> +		return;
> +
>   	attr.sample_period = get_sample_period(pmc, pmc->counter);
>   
>   	if (in_tx)
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 5e0ac57d6d1b..ffccfd9823c0 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -21,7 +21,6 @@
>   #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
>   
>   static struct kvm_event_hw_type_mapping intel_arch_events[] = {
> -	/* Index must match CPUID 0x0A.EBX bit vector */
>   	[0] = { 0x3c, 0x00, PERF_COUNT_HW_CPU_CYCLES },
>   	[1] = { 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },
>   	[2] = { 0x3c, 0x01, PERF_COUNT_HW_BUS_CYCLES  },
> @@ -29,6 +28,7 @@ static struct kvm_event_hw_type_mapping intel_arch_events[] = {
>   	[4] = { 0x2e, 0x41, PERF_COUNT_HW_CACHE_MISSES },
>   	[5] = { 0xc4, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
>   	[6] = { 0xc5, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
> +	/* The above index must match CPUID 0x0A.EBX bit vector */
>   	[7] = { 0x00, 0x03, PERF_COUNT_HW_REF_CPU_CYCLES },
>   };
>   
> @@ -75,11 +75,17 @@ static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
>   	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
>   	int i;
>   
> -	for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++)
> -		if (intel_arch_events[i].eventsel == event_select &&
> -		    intel_arch_events[i].unit_mask == unit_mask &&
> -		    (pmc_is_fixed(pmc) || pmu->available_event_types & (1 << i)))
> -			break;
> +	for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++) {
> +		if (intel_arch_events[i].eventsel != event_select ||
> +		    intel_arch_events[i].unit_mask != unit_mask)
> +			continue;
> +
> +		/* disable event that reported as not present by cpuid */
> +		if ((i < 7) && !(pmu->available_event_types & (1 << i)))
> +			return PERF_COUNT_HW_MAX + 1;
> +
> +		break;
> +	}
>   
>   	if (i == ARRAY_SIZE(intel_arch_events))
>   		return PERF_COUNT_HW_MAX;

Queued, thanks.

Paolo

