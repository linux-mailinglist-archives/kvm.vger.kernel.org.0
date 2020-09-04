Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD07C25CEEB
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 03:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729528AbgIDBCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 21:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728582AbgIDBCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 21:02:09 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FFAC061244;
        Thu,  3 Sep 2020 18:02:09 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id u20so3707055pfn.0;
        Thu, 03 Sep 2020 18:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c/dfQHyGmLG8wXcd04v4MLkeiejmLVC31MQVhgXk8Lc=;
        b=NelfOSVBgWkTwilsbwKCdqLhP+QSWWGWZNBfN9KIctbBow/XV9qt6Dxj897WAdEISL
         aGfXIWjEbOXVfDKkSImBPpy3o7VrTIthvz/mYohkbOi4/+YVyzRR1ozt8XJGHRYPYUC2
         cSDrreATVhWI+6yiY9a4u+gFQBDJC0Eg3oo3vsLSIrozx9miF9b7L2ZTSgqXM8EwE4Tv
         5SWvptLOiejOMY0bQCOV0yezI8IF5iDndSmfqqZ4I0SSYtE5BUBbLFvQEGYB2gIq9xcI
         RlZaoae0KLoaX3iQHNZS0EbijN3Xe/ZNM/9+7+mDYP8UPhUMCAf9rdkXo2rHiJ8qvVG2
         W6Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c/dfQHyGmLG8wXcd04v4MLkeiejmLVC31MQVhgXk8Lc=;
        b=PUwBqGhpeDsh+MGN6m6nqXemB7ZJtzZDo1PeUtRsmHNqA9titZ2MFlbzB46dy1qI2l
         zc/Nlgq+fue3VbW2VddFSunhRMMEKx/+VvlgkBr0VZov2AVF30+lOVKYO9vlJRvNCbSJ
         ONnKlLnQb1U8kSJpcPUhblTJ1M1wMLWl127iyQ19gSQTcH/aiIkOsAU1bePOkK9keida
         GKIhleHx6abdO+UjNzT7VFMZ+tifJENnl/XDEZHVBvoC2elqXsEYf2Q5BNarfl2NkZUf
         6gayqvz+OsV0ebyAtqwAzaT07ObvTYjjEndFdMWmWgljtejUmsQkwEI/LF60aCmRsBRb
         aO6w==
X-Gm-Message-State: AOAM533RXp+FGUyTEZFUqQG6fc1kVr+TPa/NZf06xTf7DU7ZR+HKWGOL
        gwkakIfcI2ozGBcfY0CiCg==
X-Google-Smtp-Source: ABdhPJxLRsbVmaDZmI1/8H0cXEaSI0qbg0hsokU3YgTv/XVFIDmxkQgPmOISrQkQM1qV1Mx1beIzmg==
X-Received: by 2002:a63:455d:: with SMTP id u29mr5139671pgk.178.1599181329089;
        Thu, 03 Sep 2020 18:02:09 -0700 (PDT)
Received: from [127.0.0.1] ([103.7.29.9])
        by smtp.gmail.com with ESMTPSA id r144sm4883806pfc.63.2020.09.03.18.02.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 18:02:08 -0700 (PDT)
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
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Message-ID: <61e2fd6f-effd-64d7-148a-1b1f9fda1449@gmail.com>
Date:   Fri, 4 Sep 2020 09:01:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <87y2lrnnyf.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20/9/3 18:39, Vitaly Kuznetsov wrote:
> Haiwei Li <lihaiwei.kernel@gmail.com> writes:
> 
>> From: Haiwei Li <lihaiwei@tencent.com>
>>
>> check the allocation of per-cpu __pv_cpu_mask. Initialize ops only when
>> successful.
>>
>> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
>> ---
>>    arch/x86/kernel/kvm.c | 24 ++++++++++++++++++++----
>>    1 file changed, 20 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> index 08320b0b2b27..d3c062e551d7 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -555,7 +555,6 @@ static void kvm_send_ipi_mask_allbutself(const
>> struct cpumask *mask, int vector)
>>    static void kvm_setup_pv_ipi(void)
>>    {
>>    	apic->send_IPI_mask = kvm_send_ipi_mask;
>> -	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
>>    	pr_info("setup PV IPIs\n");
>>    }
>>
>> @@ -654,7 +653,6 @@ static void __init kvm_guest_init(void)
>>    	}
>>
>>    	if (pv_tlb_flush_supported()) {
>> -		pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
>>    		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
>>    		pr_info("KVM setup pv remote TLB flush\n");
>>    	}
>> @@ -767,6 +765,14 @@ static __init int activate_jump_labels(void)
>>    }
>>    arch_initcall(activate_jump_labels);
>>
>> +static void kvm_free_pv_cpu_mask(void)
>> +{
>> +	unsigned int cpu;
>> +
>> +	for_each_possible_cpu(cpu)
>> +		free_cpumask_var(per_cpu(__pv_cpu_mask, cpu));
>> +}
>> +
>>    static __init int kvm_alloc_cpumask(void)
>>    {
>>    	int cpu;
>> @@ -785,11 +791,21 @@ static __init int kvm_alloc_cpumask(void)
>>
>>    	if (alloc)
>>    		for_each_possible_cpu(cpu) {
>> -			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
>> -				GFP_KERNEL, cpu_to_node(cpu));
>> +			if (!zalloc_cpumask_var_node(
>> +				per_cpu_ptr(&__pv_cpu_mask, cpu),
>> +				GFP_KERNEL, cpu_to_node(cpu)))
>> +				goto zalloc_cpumask_fail;
>>    		}
>>
>> +#if defined(CONFIG_SMP)
>> +	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
>> +#endif
>> +	pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
> 
> This is too late I'm afraid. If I'm not mistaken PV patching happens
> earlier, so .init.guest_late_init (kvm_guest_init()) is good and
> arch_initcall() is bad.

.init.guest_late_init (kvm_guest_init()) is called before 
arch_initcall() and kvm_flush_tlb_others && kvm_send_ipi_mask_allbutself 
rely on __pv_cpu_mask.  So, i can not put this assign in kvm_guest_init().

> 
> Have you checked that with this patch kvm_flush_tlb_others() is still
> being called?

yes. I add a printk and i get the log.

> 
> Actually, there is no need to assign kvm_flush_tlb_others() so late. We
> can always check if __pv_cpu_mask was allocated and revert back to the
> architectural path if not.
I am sorry i don't really understand. Can you explain in more detail? Thx.

> 
>>    	return 0;
>> +
>> +zalloc_cpumask_fail:
>> +	kvm_free_pv_cpu_mask();
>> +	return -ENOMEM;
>>    }
>>    arch_initcall(kvm_alloc_cpumask);
>>
>> --
>> 2.18.4
>>
> 
