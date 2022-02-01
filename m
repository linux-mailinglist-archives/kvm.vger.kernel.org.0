Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8D34A5C35
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 13:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238017AbiBAM1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 07:27:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57928 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237639AbiBAM1T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Feb 2022 07:27:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643718439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QU0LlTq3DNJ2aWGrY3I47oz46MhAt45cXF+2l6bSy50=;
        b=K09HJe5tq3U9JrorDaxe1r5+KAyz/wHnGo/cLk+KMAaOCO5VuMMVhT0x97c3eHaVTNlgcN
        m2qYWGFy2Xx2c1KbZUJcrzbEBimYwBXM9lr4VBGBx2jKtN9nc3z6n/LsL/6gNxB7/mcmU9
        8SpEPLY2x6kei2QB0Bcz4HrGKxnFdww=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-527-XcUWtOduP06VHJbYKdLTdw-1; Tue, 01 Feb 2022 07:27:18 -0500
X-MC-Unique: XcUWtOduP06VHJbYKdLTdw-1
Received: by mail-ej1-f70.google.com with SMTP id i21-20020a1709063c5500b006b4c7308c19so6455334ejg.14
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 04:27:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QU0LlTq3DNJ2aWGrY3I47oz46MhAt45cXF+2l6bSy50=;
        b=w/9pLYj7RBo5dmB/rPoa3qL05wZYDEHLup9um8ww7JoQYL/oNfMvS9Bh4YA3wqPZ6G
         3epkc2B0Q96XeYKSry774qu7hXqeyiahKl4GpN2ZtmyRHoNX9tIChcJPevdGpxPmePHS
         7x4Uhdm+2cEhuedzruID2M3HfM+uPzQBAelyHlheNH9N+GfzkgKNVahXPOZXV2hGmswP
         oJaXgwbg5QIJeIT9PpbZkF6nY1Qifn6UPo0GJLCQcOsGeG+Nx0Ljb4+b9S0u9MIJF3Qk
         3XOXmXL9G9IfR1KITvsI/a/54OZb4fKbyFkkvm2Ei8vmBRbFXx7L/9OnWtBcFN+H1Jxa
         +CIQ==
X-Gm-Message-State: AOAM53297GC5oyjRZX7Nh5ZNNeGMV7HiDjPiFAQcCaXvimtwEvlLIh0B
        nxLLS5iCsGcGqctpnTwqfFBBKcudklLdG28jcIrMRJK8W4fYU8JRGfcqOAd9lkLewNsFpHm+/cK
        vQawFg1FzZRfE
X-Received: by 2002:a05:6402:11c7:: with SMTP id j7mr24649133edw.139.1643718436960;
        Tue, 01 Feb 2022 04:27:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzxvQfD1ugn3GcyGE17Ijc47P10fYXOOsLGZCFSxw3+lazJMWWpy0/0FjPHI3mmvbNuPGwVzQ==
X-Received: by 2002:a05:6402:11c7:: with SMTP id j7mr24649122edw.139.1643718436788;
        Tue, 01 Feb 2022 04:27:16 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id d15sm14767385ejw.143.2022.02.01.04.27.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 04:27:16 -0800 (PST)
Message-ID: <cfd81a98-5616-8abd-cdf6-fd28c29d970a@redhat.com>
Date:   Tue, 1 Feb 2022 13:27:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
References: <20220117085307.93030-1-likexu@tencent.com>
 <20220117085307.93030-3-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220117085307.93030-3-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/17/22 09:53, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Currently, we have [intel|knc|p4|p6]_perfmon_event_map on the Intel
> platforms and amd_[f17h]_perfmon_event_map on the AMD platforms.
> 
> Early clumsy KVM code or other potential perf_event users may have
> hard-coded these perfmon_maps (e.g., arch/x86/kvm/svm/pmu.c), so
> it would not make sense to program a common hardware event based
> on the generic "enum perf_hw_id" once the two tables do not match.
> 
> Let's provide an interface for callers outside the perf subsystem to get
> the counter config based on the perfmon_event_map currently in use,
> and it also helps to save bytes.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>   arch/x86/events/core.c            | 9 +++++++++
>   arch/x86/include/asm/perf_event.h | 2 ++
>   2 files changed, 11 insertions(+)
> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 38b2c779146f..751048f4cc97 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -693,6 +693,15 @@ void x86_pmu_disable_all(void)
>   	}
>   }
>   
> +u64 perf_get_hw_event_config(int perf_hw_id)
> +{
> +	if (perf_hw_id < x86_pmu.max_events)
> +		return x86_pmu.event_map(perf_hw_id);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(perf_get_hw_event_config);
> +
>   struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
>   {
>   	return static_call(x86_pmu_guest_get_msrs)(nr);
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index 8fc1b5003713..d1e325517b74 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -492,9 +492,11 @@ static inline void perf_check_microcode(void) { }
>   
>   #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
>   extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
> +extern u64 perf_get_hw_event_config(int perf_hw_id);
>   extern int x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
>   #else
>   struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
> +u64 perf_get_hw_event_config(int perf_hw_id);

Should this be an inline that returns 0?

>   static inline int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
>   {
>   	return -1;

Peter, please review/ack this.

Paolo

