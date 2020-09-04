Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA8225D887
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 14:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730172AbgIDMWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 08:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729932AbgIDMV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 08:21:59 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E532C061244;
        Fri,  4 Sep 2020 05:21:59 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id c3so813700plz.5;
        Fri, 04 Sep 2020 05:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/D0mUWcrQeh1VGNvRjy5IHBKR+r68K0heXZUGkRNS8g=;
        b=GLKStaCRMO+1eIHpLmuzBSzRtLI9N5RUndnwQn7qxYvSBXLmNZsr115dxnurU2iHxF
         sPsXrDe75CV4gXGzD2vhTAG31wNPoI93uqIOt63SIvuMMDA1N6/wqH71ANw/VvyjO2UI
         +oxUXyc0nGf5BiA0Pk+C8dLAwkm9o+JJ+5s+kV6wWNwBMU62pClIeqViZfJbvQKjS3Lf
         T6sbOjlGWU1kMoW1VPiH181sPkT07A8GOz+//RWy6GR8Kql7Fkpge2gRPn5wd4byzmoS
         GVlDWpwfIMGrLpVmJXVxtqJkXMpKkfC66EGnLA0XCkAB5nMvzgwiFYXCQ1FnaoibJX7D
         PVGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/D0mUWcrQeh1VGNvRjy5IHBKR+r68K0heXZUGkRNS8g=;
        b=XxxgdcC7WXwjhPfIGNwcY/HCnYdaN7VjCo/HvfdJ2jpjGx6iQa6HwT3j+4e/SlTSYh
         f2fC1U42kByKfz8gpSR3T8KcF1TqntG7ZLVMd4bNN3GVANVzOMM5P7GOF1iOAlsSlJck
         BHdioWvI0qJL1gfjGpl0tD/qhijRm+Mcs0556i26FvSFnjKFU+xmNJ59gjdretoMDB+m
         Ueh4MkvsAUvhfCbFeRL76m1Kzn4OWpy/4sVyRgl765hEyWg8LDe3CzlAYJCPxebpBz3y
         espxumbQt62Zp3nJuXHbzuqR9+bn8p9TGpcWKUESqEcPaUt5byr54cmb0XHmOPfuQMRG
         /47Q==
X-Gm-Message-State: AOAM5306l14PM5mTkIqCj1B8JlH1+9i5mWelFqcplw1cZe+RHKp+eCOA
        3ux5r7FgZh3VOhZq4nwg2w==
X-Google-Smtp-Source: ABdhPJyT9cGvYCXYSye7La6eftbiTPUOu9x0D1fXBNV5cqyRsJBXSYSQzldwWNMWotI/AeD3jXLnPA==
X-Received: by 2002:a17:90a:7acb:: with SMTP id b11mr8058656pjl.171.1599222118755;
        Fri, 04 Sep 2020 05:21:58 -0700 (PDT)
Received: from [127.0.0.1] ([103.7.29.7])
        by smtp.gmail.com with ESMTPSA id i9sm5867467pgb.37.2020.09.04.05.21.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 05:21:58 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: Check the allocation of pv cpu mask
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>, tglx@linutronix.de,
        mingo@redhat.com, "bp@alien8.de" <bp@alien8.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
References: <654d8c60-49f0-e398-be25-24aed352360d@gmail.com>
 <87y2lrnnyf.fsf@vitty.brq.redhat.com>
 <61e2fd6f-effd-64d7-148a-1b1f9fda1449@gmail.com>
 <87o8mlooki.fsf@vitty.brq.redhat.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Message-ID: <b56d5af9-9489-738f-aff2-d8ce64171fc0@gmail.com>
Date:   Fri, 4 Sep 2020 20:21:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <87o8mlooki.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20/9/4 17:53, Vitaly Kuznetsov wrote:
> Haiwei Li <lihaiwei.kernel@gmail.com> writes:
> 
>> On 20/9/3 18:39, Vitaly Kuznetsov wrote:
>>> Haiwei Li <lihaiwei.kernel@gmail.com> writes:
>>>
>>>> From: Haiwei Li <lihaiwei@tencent.com>
>>>>
>>>> check the allocation of per-cpu __pv_cpu_mask. Initialize ops only when
>>>> successful.
>>>>
>>>> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
>>>> ---
>>>>     arch/x86/kernel/kvm.c | 24 ++++++++++++++++++++----
>>>>     1 file changed, 20 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>>>> index 08320b0b2b27..d3c062e551d7 100644
>>>> --- a/arch/x86/kernel/kvm.c
>>>> +++ b/arch/x86/kernel/kvm.c
>>>> @@ -555,7 +555,6 @@ static void kvm_send_ipi_mask_allbutself(const
>>>> struct cpumask *mask, int vector)
>>>>     static void kvm_setup_pv_ipi(void)
>>>>     {
>>>>     	apic->send_IPI_mask = kvm_send_ipi_mask;
>>>> -	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
>>>>     	pr_info("setup PV IPIs\n");
>>>>     }
>>>>
>>>> @@ -654,7 +653,6 @@ static void __init kvm_guest_init(void)
>>>>     	}
>>>>
>>>>     	if (pv_tlb_flush_supported()) {
>>>> -		pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
>>>>     		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
>>>>     		pr_info("KVM setup pv remote TLB flush\n");
>>>>     	}
>>>> @@ -767,6 +765,14 @@ static __init int activate_jump_labels(void)
>>>>     }
>>>>     arch_initcall(activate_jump_labels);
>>>>
>>>> +static void kvm_free_pv_cpu_mask(void)
>>>> +{
>>>> +	unsigned int cpu;
>>>> +
>>>> +	for_each_possible_cpu(cpu)
>>>> +		free_cpumask_var(per_cpu(__pv_cpu_mask, cpu));
>>>> +}
>>>> +
>>>>     static __init int kvm_alloc_cpumask(void)
>>>>     {
>>>>     	int cpu;
>>>> @@ -785,11 +791,21 @@ static __init int kvm_alloc_cpumask(void)
>>>>
>>>>     	if (alloc)
>>>>     		for_each_possible_cpu(cpu) {
>>>> -			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
>>>> -				GFP_KERNEL, cpu_to_node(cpu));
>>>> +			if (!zalloc_cpumask_var_node(
>>>> +				per_cpu_ptr(&__pv_cpu_mask, cpu),
>>>> +				GFP_KERNEL, cpu_to_node(cpu)))
>>>> +				goto zalloc_cpumask_fail;
>>>>     		}
>>>>
>>>> +#if defined(CONFIG_SMP)
>>>> +	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
>>>> +#endif
>>>> +	pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
>>>
>>> This is too late I'm afraid. If I'm not mistaken PV patching happens
>>> earlier, so .init.guest_late_init (kvm_guest_init()) is good and
>>> arch_initcall() is bad.
>>
>> .init.guest_late_init (kvm_guest_init()) is called before
>> arch_initcall() and kvm_flush_tlb_others && kvm_send_ipi_mask_allbutself
>> rely on __pv_cpu_mask.  So, i can not put this assign in kvm_guest_init().
>>
>>>
>>> Have you checked that with this patch kvm_flush_tlb_others() is still
>>> being called?
>>
>> yes. I add a printk and i get the log.
>>
> 
> This is weird. I do the following on top of your patch:
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index d3c062e551d7..f441209ff0a4 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -620,6 +620,8 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
>          struct kvm_steal_time *src;
>          struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
>   
> +       trace_printk("PV TLB flush %d CPUs\n", cpumask_weight(cpumask));
> +
>          cpumask_copy(flushmask, cpumask);
>          /*
>           * We have to call flush only on online vCPUs. And
> 
> With your patch I don't see any calls:
> 
> # grep -c -v '^#' /sys/kernel/debug/tracing/trace
> 0
> 
> with your patch reverted I see them:
> 
> # grep -c -v '^#' /sys/kernel/debug/tracing/trace
> 4571

I just retested. You are right. I'm sorry.

> 
> 
>>>
>>> Actually, there is no need to assign kvm_flush_tlb_others() so late. We
>>> can always check if __pv_cpu_mask was allocated and revert back to the
>>> architectural path if not.
>> I am sorry i don't really understand. Can you explain in more detail? Thx.
>>
> 
> I mean we can always call e.g. kvm_flush_tlb_others(), even if (very
> unlikely) the mask wasn't allocated. We just need to check for
> that. Something like (completely untested):
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index d3c062e551d7..e3676cdee6a2 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -620,6 +620,11 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
>          struct kvm_steal_time *src;
>          struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
>   
> +       if (unlikely(!flushmask)) {
> +               flushmask = cpumask;
> +               goto do_native;
> +       }
> +

I see. I appreciate your patience and kindness.

I will send a new version.

>          cpumask_copy(flushmask, cpumask);
>          /*
>           * We have to call flush only on online vCPUs. And
> @@ -635,6 +640,7 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
>                  }
>          }
>   
> +do_native:
>          native_flush_tlb_others(flushmask, info);
>   }
>   
> 
>>>
>>>>     	return 0;
>>>> +
>>>> +zalloc_cpumask_fail:
>>>> +	kvm_free_pv_cpu_mask();
>>>> +	return -ENOMEM;
>>>>     }
>>>>     arch_initcall(kvm_alloc_cpumask);
>>>>
>>>> --
>>>> 2.18.4
>>>>
>>>
>>
> 
