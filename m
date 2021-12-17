Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A73847866B
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 09:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbhLQIpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 03:45:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38977 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230194AbhLQIpU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Dec 2021 03:45:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639730720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W1WFS25x/hLZ6A8mSaxKO8h95Gv9OAldcWDpPXz2GBE=;
        b=VPCl7IUVCQQGI3WkJlh0cUY8iUhSUm1XEV+E1KtRSpmNpv2c1OQ6IVx7hpN7CFN2fFjupb
        X9h2r5kGoC3o2yQnXWJET6KmeROqGb5UgaL83dTYGVbc11hzcfrdlq6Hq+1KLfrJ0UzrNJ
        +/7QzLgQrZtYaB9ifFC9hlua84g011Q=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-PzWuFYClO7y6cPV8x9ddnQ-1; Fri, 17 Dec 2021 03:45:18 -0500
X-MC-Unique: PzWuFYClO7y6cPV8x9ddnQ-1
Received: by mail-ed1-f69.google.com with SMTP id y17-20020a056402271100b003f7ef5ca612so1284882edd.17
        for <kvm@vger.kernel.org>; Fri, 17 Dec 2021 00:45:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=W1WFS25x/hLZ6A8mSaxKO8h95Gv9OAldcWDpPXz2GBE=;
        b=SXcoKJbkDLTOL8J4q7T/71lqRkomqttYiQd6QpdBOPy7+k1ORSk1FlsJX4r4WLcmYg
         f36mW8hR0ASd6r1XyvTI80cSi4tcL/Uc7v7K+glakD0JRH0B7C9pb5Q/shySvXKjQr21
         ZuvkGty9LWelOZlYSBSXl1vcNKpNKjYHadPxyqwigdP2LlvzWQKuzz0F5a+Ggtv+cTKz
         ewdTUJPzrx/z+nVjcT4iXTLW+e0EKeotVnyRxjw1EZjYZDkqE2gVEFsiJCKMjP5DDa27
         6OiAU7Z/bsKnl/2DPRVHDRBWUgYQSi4SNNrCz3oxrgKduc7RFUycrzpyePVpBpr/uf0i
         qNfw==
X-Gm-Message-State: AOAM5332LFq976GmLMiCt0YExb4uX+A/3ffiTLvSxiCr2WA02eGt8/fe
        3IaDp13Mkst4Opub4HlkSsiNtazP6JkvFFEMr4l8ChTnOr/RHE93NMw5OsogC1Oh2jxXryzDhF5
        lux/t7QNZvn/Q
X-Received: by 2002:a05:6402:1e92:: with SMTP id f18mr1829658edf.153.1639730717773;
        Fri, 17 Dec 2021 00:45:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyulrYmwimpg1/zvrNRe0VHKW9o3WEZBH7A+DzvCdKBr++K0QKgOB5w5yxBs04sV5UeBcVGCA==
X-Received: by 2002:a05:6402:1e92:: with SMTP id f18mr1829642edf.153.1639730717557;
        Fri, 17 Dec 2021 00:45:17 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id b73sm1091762edf.37.2021.12.17.00.45.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Dec 2021 00:45:17 -0800 (PST)
Message-ID: <afacee89-4edb-f4fb-156d-7b6c8dd0bb3b@redhat.com>
Date:   Fri, 17 Dec 2021 09:44:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: x86: Use div64_ul instead of do_div
Content-Language: en-US
To:     cgel.zte@gmail.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <20211217084155.452262-1-deng.changcheng@zte.com.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211217084155.452262-1-deng.changcheng@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/21 09:41, cgel.zte@gmail.com wrote:
> From: Changcheng Deng <deng.changcheng@zte.com.cn>
> 
> do_div() does a 64-by-32 division. Here the divisor is an unsigned long
> which on some platforms is 64 bit wide. So use div64_ul instead of do_div
> to avoid a possible truncation.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
> ---
>   arch/x86/kvm/lapic.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index c5028e6b0f96..3b629870632c 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1707,7 +1707,7 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
>   	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
>   
>   	ns = (tscdeadline - guest_tsc) * 1000000ULL;
> -	do_div(ns, this_tsc_khz);
> +	ns = div64_ul(ns, this_tsc_khz);
>   
>   	if (likely(tscdeadline > guest_tsc) &&
>   	    likely(ns > apic->lapic_timer.timer_advance_ns)) {
> 

You could change this_tsc_khz to u32 instead, it's assigned from a 
32-bit value.

Using div64_ul would be unnecessary and less efficient.

Paolo

