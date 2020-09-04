Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A19625D570
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 11:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbgIDJxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 05:53:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42843 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726425AbgIDJxj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 05:53:39 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-feIGm8B6NbuDsV3bhL0Kmg-1; Fri, 04 Sep 2020 05:53:36 -0400
X-MC-Unique: feIGm8B6NbuDsV3bhL0Kmg-1
Received: by mail-wr1-f69.google.com with SMTP id b8so2155069wrr.2
        for <kvm@vger.kernel.org>; Fri, 04 Sep 2020 02:53:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=XuQnmthJvDLeG392mDM96epZMMU8GpEeywFOGW3d2iY=;
        b=VLJHp042cxRlavwIgZns/jjkFlHLW8ndQuYHHiftYOCcQJdFvXKzq3OlaE4lzR2LRQ
         Q70dZSeDsKmdrgndE7si4Wa45RH5s4rjd3qulH+lZ3Zt6tECl+tRX1ntVAAlhF7qZpYY
         4tnOy0OeJi16A+XdyTuJoeTipbaEcq9hrn3RVXLi7CkGxYAvASceIebUOe8+lL7aU8pM
         KgxaubAYv97DeGyv3cNfKXAkPPuEDbHxWqY69MSuv8DAuY7zcTa9FHa0m7EZsKaMD9E8
         1+1aqeL/PXhr7UHWNrUBWc8pnwtMkfrjNlVy24Av+NSYrgZMMBdL6W6vYDXDy/i5ucCS
         J+IA==
X-Gm-Message-State: AOAM532OMwpxckR+e2k4DiPIw4XkrpSBdVFznkWVEwgzreIOdnVzzZ1N
        z/XIQT38OR7t2YZPuv7/gUgeBiUe0VNSInbWYkNFMIhCPn/T07651dWOxDJnUX5zv/ImpCuzqJ7
        taAYmnZvlhSNi
X-Received: by 2002:adf:aad1:: with SMTP id i17mr7201335wrc.360.1599213215534;
        Fri, 04 Sep 2020 02:53:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSCrthi5wieW53gN2JmiJVsoaNYo7jdb7Y9sDqWukIfC3bkehGBXDXGrjLm3FMXeNdQiCOYA==
X-Received: by 2002:adf:aad1:: with SMTP id i17mr7201311wrc.360.1599213215277;
        Fri, 04 Sep 2020 02:53:35 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i16sm6484337wrq.73.2020.09.04.02.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 02:53:34 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Haiwei Li <lihaiwei.kernel@gmail.com>
Cc:     "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "wanpengli\@tencent.com" <wanpengli@tencent.com>,
        "jmattson\@google.com" <jmattson@google.com>,
        "joro\@8bytes.org" <joro@8bytes.org>, tglx@linutronix.de,
        mingo@redhat.com, "bp\@alien8.de" <bp@alien8.de>,
        "hpa\@zytor.com" <hpa@zytor.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86\@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2] KVM: Check the allocation of pv cpu mask
In-Reply-To: <61e2fd6f-effd-64d7-148a-1b1f9fda1449@gmail.com>
References: <654d8c60-49f0-e398-be25-24aed352360d@gmail.com> <87y2lrnnyf.fsf@vitty.brq.redhat.com> <61e2fd6f-effd-64d7-148a-1b1f9fda1449@gmail.com>
Date:   Fri, 04 Sep 2020 11:53:33 +0200
Message-ID: <87o8mlooki.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Haiwei Li <lihaiwei.kernel@gmail.com> writes:

> On 20/9/3 18:39, Vitaly Kuznetsov wrote:
>> Haiwei Li <lihaiwei.kernel@gmail.com> writes:
>> 
>>> From: Haiwei Li <lihaiwei@tencent.com>
>>>
>>> check the allocation of per-cpu __pv_cpu_mask. Initialize ops only when
>>> successful.
>>>
>>> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
>>> ---
>>>    arch/x86/kernel/kvm.c | 24 ++++++++++++++++++++----
>>>    1 file changed, 20 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>>> index 08320b0b2b27..d3c062e551d7 100644
>>> --- a/arch/x86/kernel/kvm.c
>>> +++ b/arch/x86/kernel/kvm.c
>>> @@ -555,7 +555,6 @@ static void kvm_send_ipi_mask_allbutself(const
>>> struct cpumask *mask, int vector)
>>>    static void kvm_setup_pv_ipi(void)
>>>    {
>>>    	apic->send_IPI_mask = kvm_send_ipi_mask;
>>> -	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
>>>    	pr_info("setup PV IPIs\n");
>>>    }
>>>
>>> @@ -654,7 +653,6 @@ static void __init kvm_guest_init(void)
>>>    	}
>>>
>>>    	if (pv_tlb_flush_supported()) {
>>> -		pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
>>>    		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
>>>    		pr_info("KVM setup pv remote TLB flush\n");
>>>    	}
>>> @@ -767,6 +765,14 @@ static __init int activate_jump_labels(void)
>>>    }
>>>    arch_initcall(activate_jump_labels);
>>>
>>> +static void kvm_free_pv_cpu_mask(void)
>>> +{
>>> +	unsigned int cpu;
>>> +
>>> +	for_each_possible_cpu(cpu)
>>> +		free_cpumask_var(per_cpu(__pv_cpu_mask, cpu));
>>> +}
>>> +
>>>    static __init int kvm_alloc_cpumask(void)
>>>    {
>>>    	int cpu;
>>> @@ -785,11 +791,21 @@ static __init int kvm_alloc_cpumask(void)
>>>
>>>    	if (alloc)
>>>    		for_each_possible_cpu(cpu) {
>>> -			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
>>> -				GFP_KERNEL, cpu_to_node(cpu));
>>> +			if (!zalloc_cpumask_var_node(
>>> +				per_cpu_ptr(&__pv_cpu_mask, cpu),
>>> +				GFP_KERNEL, cpu_to_node(cpu)))
>>> +				goto zalloc_cpumask_fail;
>>>    		}
>>>
>>> +#if defined(CONFIG_SMP)
>>> +	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
>>> +#endif
>>> +	pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
>> 
>> This is too late I'm afraid. If I'm not mistaken PV patching happens
>> earlier, so .init.guest_late_init (kvm_guest_init()) is good and
>> arch_initcall() is bad.
>
> .init.guest_late_init (kvm_guest_init()) is called before 
> arch_initcall() and kvm_flush_tlb_others && kvm_send_ipi_mask_allbutself 
> rely on __pv_cpu_mask.  So, i can not put this assign in kvm_guest_init().
>
>> 
>> Have you checked that with this patch kvm_flush_tlb_others() is still
>> being called?
>
> yes. I add a printk and i get the log.
>

This is weird. I do the following on top of your patch:

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index d3c062e551d7..f441209ff0a4 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -620,6 +620,8 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
        struct kvm_steal_time *src;
        struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
 
+       trace_printk("PV TLB flush %d CPUs\n", cpumask_weight(cpumask));
+
        cpumask_copy(flushmask, cpumask);
        /*
         * We have to call flush only on online vCPUs. And

With your patch I don't see any calls:

# grep -c -v '^#' /sys/kernel/debug/tracing/trace
0

with your patch reverted I see them:

# grep -c -v '^#' /sys/kernel/debug/tracing/trace
4571


>> 
>> Actually, there is no need to assign kvm_flush_tlb_others() so late. We
>> can always check if __pv_cpu_mask was allocated and revert back to the
>> architectural path if not.
> I am sorry i don't really understand. Can you explain in more detail? Thx.
>

I mean we can always call e.g. kvm_flush_tlb_others(), even if (very
unlikely) the mask wasn't allocated. We just need to check for
that. Something like (completely untested):

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index d3c062e551d7..e3676cdee6a2 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -620,6 +620,11 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
        struct kvm_steal_time *src;
        struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
 
+       if (unlikely(!flushmask)) {
+               flushmask = cpumask;
+               goto do_native;
+       }
+
        cpumask_copy(flushmask, cpumask);
        /*
         * We have to call flush only on online vCPUs. And
@@ -635,6 +640,7 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
                }
        }
 
+do_native:
        native_flush_tlb_others(flushmask, info);
 }
 

>> 
>>>    	return 0;
>>> +
>>> +zalloc_cpumask_fail:
>>> +	kvm_free_pv_cpu_mask();
>>> +	return -ENOMEM;
>>>    }
>>>    arch_initcall(kvm_alloc_cpumask);
>>>
>>> --
>>> 2.18.4
>>>
>> 
>

-- 
Vitaly

