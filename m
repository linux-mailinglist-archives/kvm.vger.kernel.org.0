Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369D1292768
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 14:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgJSMge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 08:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgJSMge (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Oct 2020 08:36:34 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C07C0613CE;
        Mon, 19 Oct 2020 05:36:33 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id j18so5955472pfa.0;
        Mon, 19 Oct 2020 05:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+IfHdmrtrv7otmFjk0VFjYsi8am5SoJYfDZn7Odg9ks=;
        b=FCxvk7rIOyC+X6GUmHiNsy0mJ/C9wmgoMDAVThoszbRGA2kcJWbqvt4whfWZuMrd3e
         pJR/v5PyRCz0/ECXgA5r8ao3jxGp+fHhqymslaoXyibzydh2Y4NXRzciL4TBAXHtPKlJ
         amiZiaCoKXzzwQbvFUOyfqukdrOPUB3ABlW5Tpd2Fj2g11Mn4wXbtPGjSIIdsQM8Qwud
         KBq3VSPZP5+d87/tnJIuj3XWxb+/sBg+ttZW2bBP8k1Ze7w0n5DPEM+RsPg9urqJE/2W
         n30OG5mx/hcjNfr+MjHHsBwrblqTxbCp6A8q4THVyjqyGbCLhM9xrmgkTq3IZzO6Dcib
         bzlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+IfHdmrtrv7otmFjk0VFjYsi8am5SoJYfDZn7Odg9ks=;
        b=b25/GSCLvWRR2Sf7D6VPDBtHxBfS/V1VQUwFrTcdPopBtEHzAg39PdeCmRHVJz6qfR
         5FZQvz9qrkXBymBQ/6lNb1ENGjlCxIBfyKECLH4xfSKT/i1U9oFmat5L9bJFmeIkb+iU
         VuHN9CmfiMZhBK9P8/3+cAmRaaRRfiGj+yp+fvpeyoxAqFFhVmimu/n2GINkSAnUpM1F
         bu2BTJEm7SBU1TGT0Asd6JxzxNDKZeW8IHH1r5mUqbTg8RNl0vFP1Q+lGu29naHwSzxL
         3g/oRfnnO5i1jaizE0y3LU4xFer8WFWX1ul+J+/yvs0vN0gpG2Jzw9MXq57/25060bL8
         goew==
X-Gm-Message-State: AOAM531j+TePSA9Azcs1tlMvp+77cDEUVgEYTKGv3bo+zv6d6eI/jYWK
        KVaZ92THl/pmlFgg1xgYTw==
X-Google-Smtp-Source: ABdhPJwqR7O6RVpQ3SkuAp7z4wPratZdwY+vM2/A2iDJoPq+hvwPjuNkA46qkJFjR9qkIgh9rfMW7Q==
X-Received: by 2002:a63:560a:: with SMTP id k10mr14086693pgb.350.1603110993220;
        Mon, 19 Oct 2020 05:36:33 -0700 (PDT)
Received: from [127.0.0.1] ([103.7.29.7])
        by smtp.gmail.com with ESMTPSA id a11sm3681517pfn.125.2020.10.19.05.36.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 05:36:32 -0700 (PDT)
Subject: Re: [PATCH v4] KVM: Check the allocation of pv cpu mask
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        Haiwei Li <lihaiwei@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201017175436.17116-1-lihaiwei.kernel@gmail.com>
 <87r1pu4fxv.fsf@vitty.brq.redhat.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Message-ID: <0330c9df-7ede-815b-0e6e-10fb883eda35@gmail.com>
Date:   Mon, 19 Oct 2020 20:36:22 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.3
MIME-Version: 1.0
In-Reply-To: <87r1pu4fxv.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/19 19:23, Vitaly Kuznetsov wrote:
> lihaiwei.kernel@gmail.com writes:
> 
>> From: Haiwei Li <lihaiwei@tencent.com>
>>
>> check the allocation of per-cpu __pv_cpu_mask. Init
>> 'send_IPI_mask_allbutself' only when successful and check the allocation
>> of __pv_cpu_mask in 'kvm_flush_tlb_others'.
>>
>> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
>> ---
>> v1 -> v2:
>>   * add CONFIG_SMP for kvm_send_ipi_mask_allbutself to prevent build error
>> v2 -> v3:
>>   * always check the allocation of __pv_cpu_mask in kvm_flush_tlb_others
>> v3 -> v4:
>>   * mov kvm_setup_pv_ipi to kvm_alloc_cpumask and get rid of kvm_apic_init
>>
>>   arch/x86/kernel/kvm.c | 53 +++++++++++++++++++++++++++++--------------
>>   1 file changed, 36 insertions(+), 17 deletions(-)
>>
>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> index 42c6e0deff9e..be28203cc098 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -547,16 +547,6 @@ static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
>>   	__send_ipi_mask(local_mask, vector);
>>   }
>>   
>> -/*
>> - * Set the IPI entry points
>> - */
>> -static void kvm_setup_pv_ipi(void)
>> -{
>> -	apic->send_IPI_mask = kvm_send_ipi_mask;
>> -	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
>> -	pr_info("setup PV IPIs\n");
>> -}
>> -
>>   static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
>>   {
>>   	int cpu;
>> @@ -619,6 +609,11 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
>>   	struct kvm_steal_time *src;
>>   	struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
>>   
>> +	if (unlikely(!flushmask)) {
>> +		native_flush_tlb_others(cpumask, info);
>> +		return;
>> +	}
>> +
>>   	cpumask_copy(flushmask, cpumask);
>>   	/*
>>   	 * We have to call flush only on online vCPUs. And
>> @@ -732,10 +727,6 @@ static uint32_t __init kvm_detect(void)
>>   
>>   static void __init kvm_apic_init(void)
>>   {
>> -#if defined(CONFIG_SMP)
>> -	if (pv_ipi_supported())
>> -		kvm_setup_pv_ipi();
>> -#endif
>>   }
> 
> Do we still need the now-empty function?

It's not necessary. I will remove it.

> 
>>   
>>   static void __init kvm_init_platform(void)
>> @@ -765,10 +756,18 @@ static __init int activate_jump_labels(void)
>>   }
>>   arch_initcall(activate_jump_labels);
>>   
>> +static void kvm_free_cpumask(void)
>> +{
>> +	unsigned int cpu;
>> +
>> +	for_each_possible_cpu(cpu)
>> +		free_cpumask_var(per_cpu(__pv_cpu_mask, cpu));
>> +}
>> +
>>   static __init int kvm_alloc_cpumask(void)
>>   {
>>   	int cpu;
>> -	bool alloc = false;
>> +	bool alloc = false, alloced = true;
>>   
>>   	if (!kvm_para_available() || nopv)
>>   		return 0;
>> @@ -783,10 +782,30 @@ static __init int kvm_alloc_cpumask(void)
>>   
>>   	if (alloc)
>>   		for_each_possible_cpu(cpu) {
>> -			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
>> -				GFP_KERNEL, cpu_to_node(cpu));
>> +			if (!zalloc_cpumask_var_node(
>> +				per_cpu_ptr(&__pv_cpu_mask, cpu),
>> +				GFP_KERNEL, cpu_to_node(cpu))) {
>> +				alloced = false;
>> +				break;
>> +			}
>>   		}
>>   
>> +#if defined(CONFIG_SMP)
>> +	/* Set the IPI entry points */
>> +	if (pv_ipi_supported()) {
> 
> What if we define pv_ipi_supported() in !CONFIG_SMP case as 'false'?
> 
> The code we have above:
> 
>          if (pv_tlb_flush_supported())
> 		alloc = true;
> 
> #if defined(CONFIG_SMP)
>          if (pv_ipi_supported())
> 		alloc = true;
> #endif
> 
>        	if (alloc)
> ...
> 
> will transform into 'if (pv_tlb_flush_supported() ||
> pv_ipi_supported())' and we'll get rid of 'alloc' variable.
> 
> Also, we can probably get rid of this new 'alloced' variable and switch
> to checking if the cpumask for the last CPU in cpu_possible_mask is not
> NULL.

Get it. It's a good point. I will do it. Thanks for your patience and 
kindness.

>   
>> +		apic->send_IPI_mask = kvm_send_ipi_mask;
>> +		if (alloced)
>> +			apic->send_IPI_mask_allbutself =
>> +				kvm_send_ipi_mask_allbutself;
>> +		pr_info("setup PV IPIs\n");
> 
> I'd rather not set 'apic->send_IPI_mask = kvm_send_ipi_mask' in case we
> failed to alloc cpumask too. It is weird that in case of an allocation
> failure *some* IPIs will use the PV path and some won't. It's going to
> be a nightmare to debug.

Agree. And 'pv_ops.mmu.tlb_remove_table = tlb_remove_table' should not 
be set either. What do you think? Thanks.

     Haiwei Li
