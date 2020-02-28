Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C36F17341E
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 10:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgB1JfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 04:35:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40508 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726700AbgB1JfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 04:35:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582882511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DpY+KYD45ZukUr2uiluCWuyD5nGDLRfeur7I9dYkvWA=;
        b=dkU+tfuE10tfIrsv3AXDDuU3NFg/xeNTjBj0QmlQrxTRKA7un2HMeIFhcMoRYxRRmb4l9L
        Cx8cpC8vgrOjlq3S5RJ+FJtk1e0NecQJ8rokV1YQWut0f6xsuGTgFdmYM/+pObkwbncZ7T
        97zIMEmARgDtyvYC6lcH60kBYInvnXs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-CITck4GdPSyxqn16rRQiSg-1; Fri, 28 Feb 2020 04:35:08 -0500
X-MC-Unique: CITck4GdPSyxqn16rRQiSg-1
Received: by mail-wr1-f69.google.com with SMTP id p5so1076064wrj.17
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 01:35:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DpY+KYD45ZukUr2uiluCWuyD5nGDLRfeur7I9dYkvWA=;
        b=IsTVOkIlWmELUT2bvgqY+NXk+U9mFbIarcRtpIQWT31C85YoOTf1NDWj2CmO/lcG12
         v7SAcI5AeK/y634u0qb8PSvYxpNONsGfs96NAHwpom9Kh9a3PMSteiGd2F9nkAN43BYV
         fnhOeDSnnkHsLQJFSc2GGsVgJc+WDeY355sk0G8/CyN7TmVMFfZZNK2DHOaJgmzICGPR
         39zPQp64vA05GH53S87gVVbgCSiPiStR7Ygcqzjs30MnAbfHZoGU5qjzl2pvRpltYPqu
         uwyPvfY/wuU7UG/q9i6rOMNnVXf707Zk5gTftvvcXT3h+Clt7RqPiTdpi2crGXsXUrpX
         gPZA==
X-Gm-Message-State: APjAAAUSdhMkddDy9ekVqaLIWm8Gxi5cnSjzilZwhHReQnyVtAz/tu3A
        Z5njM0qVWZ7TxSPcPf9PWJOz4QpGc4ib7H+5AQbjpDAZu3ilIxuhf777SAaNvD4out0PkMd7C7M
        7yf5JzMdpMHak
X-Received: by 2002:adf:ecca:: with SMTP id s10mr4127728wro.255.1582882507329;
        Fri, 28 Feb 2020 01:35:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqxLt681oziTtUHptfVfOG5/Wyl8Pw19WPwf2OGhyjXablKk0sGkMRMSUkJ9cOne6UDNJR6m+Q==
X-Received: by 2002:adf:ecca:: with SMTP id s10mr4127691wro.255.1582882507036;
        Fri, 28 Feb 2020 01:35:07 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:d0d9:ea10:9775:f33f? ([2001:b07:6468:f312:d0d9:ea10:9775:f33f])
        by smtp.gmail.com with ESMTPSA id q138sm590995wme.41.2020.02.28.01.35.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 01:35:06 -0800 (PST)
Subject: Re: [PATCH RESEND v2 2/2] KVM: Pre-allocate 1 cpumask variable per
 cpu for both pv tlb and pv ipis
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Nick Desaulniers <ndesaulniers@google.com>
References: <1581988104-16628-1-git-send-email-wanpengli@tencent.com>
 <1581988104-16628-2-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a232d6bf-0a33-25a6-e76d-b197e677217b@redhat.com>
Date:   Fri, 28 Feb 2020 10:35:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1581988104-16628-2-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/02/20 02:08, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Nick Desaulniers Reported:
> 
>   When building with:
>   $ make CC=clang arch/x86/ CFLAGS=-Wframe-larger-than=1000
>   The following warning is observed:
>   arch/x86/kernel/kvm.c:494:13: warning: stack frame size of 1064 bytes in
>   function 'kvm_send_ipi_mask_allbutself' [-Wframe-larger-than=]
>   static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int
>   vector)
>               ^
>   Debugging with:
>   https://github.com/ClangBuiltLinux/frame-larger-than
>   via:
>   $ python3 frame_larger_than.py arch/x86/kernel/kvm.o \
>     kvm_send_ipi_mask_allbutself
>   points to the stack allocated `struct cpumask newmask` in
>   `kvm_send_ipi_mask_allbutself`. The size of a `struct cpumask` is
>   potentially large, as it's CONFIG_NR_CPUS divided by BITS_PER_LONG for
>   the target architecture. CONFIG_NR_CPUS for X86_64 can be as high as
>   8192, making a single instance of a `struct cpumask` 1024 B.
> 
> This patch fixes it by pre-allocate 1 cpumask variable per cpu and use it for 
> both pv tlb and pv ipis..
> 
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Acked-by: Nick Desaulniers <ndesaulniers@google.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * remove '!alloc' check
>  * use new pv check helpers
> 
>  arch/x86/kernel/kvm.c | 33 +++++++++++++++++++++------------
>  1 file changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 76ea8c4..377b224 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -432,6 +432,8 @@ static bool pv_tlb_flush_supported(void)
>  		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
>  }
>  
> +static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
> +
>  #ifdef CONFIG_SMP
>  
>  static bool pv_ipi_supported(void)
> @@ -510,12 +512,12 @@ static void kvm_send_ipi_mask(const struct cpumask *mask, int vector)
>  static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
>  {
>  	unsigned int this_cpu = smp_processor_id();
> -	struct cpumask new_mask;
> +	struct cpumask *new_mask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
>  	const struct cpumask *local_mask;
>  
> -	cpumask_copy(&new_mask, mask);
> -	cpumask_clear_cpu(this_cpu, &new_mask);
> -	local_mask = &new_mask;
> +	cpumask_copy(new_mask, mask);
> +	cpumask_clear_cpu(this_cpu, new_mask);
> +	local_mask = new_mask;
>  	__send_ipi_mask(local_mask, vector);
>  }
>  
> @@ -595,7 +597,6 @@ static void __init kvm_apf_trap_init(void)
>  	update_intr_gate(X86_TRAP_PF, async_page_fault);
>  }
>  
> -static DEFINE_PER_CPU(cpumask_var_t, __pv_tlb_mask);
>  
>  static void kvm_flush_tlb_others(const struct cpumask *cpumask,
>  			const struct flush_tlb_info *info)
> @@ -603,7 +604,7 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
>  	u8 state;
>  	int cpu;
>  	struct kvm_steal_time *src;
> -	struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_tlb_mask);
> +	struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
>  
>  	cpumask_copy(flushmask, cpumask);
>  	/*
> @@ -642,6 +643,7 @@ static void __init kvm_guest_init(void)
>  	if (pv_tlb_flush_supported()) {
>  		pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
>  		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
> +		pr_info("KVM setup pv remote TLB flush\n");
>  	}
>  
>  	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
> @@ -748,24 +750,31 @@ static __init int activate_jump_labels(void)
>  }
>  arch_initcall(activate_jump_labels);
>  
> -static __init int kvm_setup_pv_tlb_flush(void)
> +static __init int kvm_alloc_cpumask(void)
>  {
>  	int cpu;
> +	bool alloc = false;
>  
>  	if (!kvm_para_available() || nopv)
>  		return 0;
>  
> -	if (pv_tlb_flush_supported()) {
> +	if (pv_tlb_flush_supported())
> +		alloc = true;
> +
> +#if defined(CONFIG_SMP)
> +	if (pv_ipi_supported())
> +		alloc = true;
> +#endif
> +
> +	if (alloc)
>  		for_each_possible_cpu(cpu) {
> -			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_tlb_mask, cpu),
> +			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
>  				GFP_KERNEL, cpu_to_node(cpu));
>  		}
> -		pr_info("KVM setup pv remote TLB flush\n");
> -	}
>  
>  	return 0;
>  }
> -arch_initcall(kvm_setup_pv_tlb_flush);
> +arch_initcall(kvm_alloc_cpumask);
>  
>  #ifdef CONFIG_PARAVIRT_SPINLOCKS
>  
> 

Queued now, thanks.

Paolo

