Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFDA41708B
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 12:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245073AbhIXLAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 07:00:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58745 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244324AbhIXLAT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 07:00:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632481126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+avbAFgULwFzOcDYCXAi3BOfXOHWtlpycP3EvS/iTb8=;
        b=hk1YGvfYHCfZWJeMd07Ve1RE4UOEnRllj6o9iQR51ug7WUMtkpWQhS0OoqDzXFyABS0fGR
        qSUBws1RUCXrTR2qmWF4WZ4Sq0zOCAjPJDbsKmPMF+rBsRmXk3vtXvDOgo3nN83o6Re4pA
        LEAM1P7TDtsVSVH/RQCwbSJ95csYKJ0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-vMxPo9AGMjqRGr6IoE4CdA-1; Fri, 24 Sep 2021 06:58:42 -0400
X-MC-Unique: vMxPo9AGMjqRGr6IoE4CdA-1
Received: by mail-ed1-f71.google.com with SMTP id z6-20020a50cd06000000b003d2c2e38f1fso9890783edi.1
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 03:58:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+avbAFgULwFzOcDYCXAi3BOfXOHWtlpycP3EvS/iTb8=;
        b=xV0lIRgmySYyrztW+7iSJcAPasVy85U/WF5K9egrutUtwljxPGicjgMgFVnA3ZhB18
         1+weaPuG4qZqQw6Ss43kxIHIHYhuNKekGUXk6tWrKPZGQoKpVIpUQEQumlytg2iJlho6
         S0/d6pciBloKxbkxMcjcTCDY/uUBdvoWx/XkIaU/DOkbkEJi4/xp6CHyVoYtNkcRTf6Z
         umMbDfVwh7ItT7lWTdvjFARNVzA4yNAtBiWxgOqSjpDDGvV2uafWb1FW6ZeEjxn7rRTX
         jcXJqHTYeG5TMJa7kGBCOindI/yNpmIGBIyakubkV6kVhVVepdAKvMB8GPTQ7WGPPO8C
         ZNHw==
X-Gm-Message-State: AOAM5332LQ0vDb2RQ+u6cmJb8/6A0HpecUswAFiODGxaSye+LwejoiZM
        O4AmreGQW/pKHDgMyzI+4FQ4pfFARv7Tzmotd6oD8UFC7k96DKPoJq6peJ7Tmw1I038LpTLbeaD
        oZJxcnqsESki5
X-Received: by 2002:a50:8246:: with SMTP id 64mr4093142edf.373.1632481121554;
        Fri, 24 Sep 2021 03:58:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgkGOyikHq8tExExzdzXcfYomJx/PLN8AAT9Fxo15vnYGbK6pGKVnlXnDgB1WVO7YS1lCRlQ==
X-Received: by 2002:a50:8246:: with SMTP id 64mr4093121edf.373.1632481121350;
        Fri, 24 Sep 2021 03:58:41 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l11sm5604951edv.67.2021.09.24.03.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 03:58:40 -0700 (PDT)
Message-ID: <560adace-15dd-570c-a8e5-c1ab623a5806@redhat.com>
Date:   Fri, 24 Sep 2021 12:58:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 1/5] nSVM: Expose FLUSHBYASID CPUID feature to nested
 guests
Content-Language: en-US
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org
References: <20210920235134.101970-1-krish.sadhukhan@oracle.com>
 <20210920235134.101970-2-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210920235134.101970-2-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/09/21 01:51, Krish Sadhukhan wrote:
> The FLUSHBYASID CPUID feature controls the availability of  commands
> 0x3 and 0x7 of TLB_CONTROL. If FLUSHBYASID is supported by the VCPU,
> those TLB_CONTROL commands will be available to nested guests.

The hypervisor would have to implement them.  Right now the VMCB12 
tlb_ctl is not used.

         /* Also overwritten later if necessary.  */
         svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;

So this won't work.

Paolo

> Therefore,
> expose FLUSHBYASID CPUID feature to nested guests.
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>   arch/x86/kvm/svm/svm.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 1a70e11f0487..0f8748af8569 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -931,6 +931,9 @@ static __init void svm_set_cpu_caps(void)
>   
>   		/* Nested VM can receive #VMEXIT instead of triggering #GP */
>   		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
> +
> +		if (boot_cpu_has(X86_FEATURE_FLUSHBYASID))
> +			kvm_cpu_cap_set(X86_FEATURE_FLUSHBYASID);
>   	}
>   
>   	/* CPUID 0x80000008 */
> 

