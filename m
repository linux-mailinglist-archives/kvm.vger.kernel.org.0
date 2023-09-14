Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B413D7A031E
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 13:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbjINL5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 07:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233897AbjINL5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 07:57:14 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C87CC3
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 04:57:10 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-68fb898ab3bso655166b3a.3
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 04:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694692629; x=1695297429; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wIX/sfEDpgeH0ssfzAesFUh0H6mb5sL6q4aUywTmlSA=;
        b=Nbj2WAC6syOa0rjV3YpMJJwxSJ/f2FHG6ultb2tBrcgmagQDtBnz/5JIPvFSdQ1FVq
         3KXUG3KGbC7EsSlQWcsDGMabmnL+HnR3nSxJdPRhtytIoGVATeb69DC2CVmOJwcjd9qs
         bzO0/nGoBvdXXv9yPPV+aObm8wN+AwYdppTVoxjAdlcRmmMh9P1AobChd4iSy2secW5L
         o8566GaPxc0kDU8r0nancE7kKjp2kconlnXIsTjTmdlQVTZYgDVN/fc5xORyiDD1IyCF
         nVvjMkdZF4Smj5tnGl+F12khYYu01zwAPxqMdOc0BLSGsBg5YKjvu52RjyVvYXbyBOYz
         Qb4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694692629; x=1695297429;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wIX/sfEDpgeH0ssfzAesFUh0H6mb5sL6q4aUywTmlSA=;
        b=t/lxpgf3QXdCHI4TVTCqubb4qemSsyzW9LtuAGZMnw2oR4nYwoTU1dVpLG4uIQaOWN
         2/zyeHcYHTfQz9tTtwOAxVL3YnxY2Ex2d7YNc3RDFJYIOsxI8IndYzkkEs5wyFiuPkIJ
         lTrGVPrComxEYKR9GW2SR8oazxwP7BnA1ZIzkwI5wfU3WByXOhBWYMOqIyDaaGN882qe
         zMU7vPO4hdmUYJM5KD5eM5tkp9M3+PnobFlEabg8N1ZyBnv5alS0fl+b9u8cVz6q9bkW
         I8JA2OmMlJ1akp5JeCi8j79uLwUeUrm5euG1nlhK7Au6zdUs8ZQ/rfVQlZSZrw++9Lej
         l7ow==
X-Gm-Message-State: AOJu0Ywmr9GnEDIl/At+GbnxQ0r0aC7Z5C3dcpCphnkeQrrxRiywHySL
        QmEvBV0EIB87mL+iuyJOZn4=
X-Google-Smtp-Source: AGHT+IED/MNWAIqY0ZktpwugAnieYSSRxE6Txw6uNYBObEaY2R2+Z71v4vDDCdHo28pmxMr6TyEizA==
X-Received: by 2002:a05:6a00:1a52:b0:68f:e0c2:6d46 with SMTP id h18-20020a056a001a5200b0068fe0c26d46mr5384572pfv.23.1694692629428;
        Thu, 14 Sep 2023 04:57:09 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id e11-20020aa78c4b000000b006870ff20254sm1186091pfd.125.2023.09.14.04.57.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 04:57:08 -0700 (PDT)
Message-ID: <3c012a84-de53-0c54-c294-97c1c52b84c3@gmail.com>
Date:   Thu, 14 Sep 2023 19:57:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH 1/2] KVM: x86: Synthesize at most one PMI per VM-exit
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Mingwei Zhang <mizhang@google.com>
Cc:     Like Xu <likexu@tencent.com>, Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <20230901185646.2823254-1-jmattson@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230901185646.2823254-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/2023 2:56 am, Jim Mattson wrote:
> When the irq_work callback, kvm_pmi_trigger_fn(), is invoked during a
> VM-exit that also invokes __kvm_perf_overflow() as a result of
> instruction emulation, kvm_pmu_deliver_pmi() will be called twice
> before the next VM-entry.
> 
> That shouldn't be a problem. The local APIC is supposed to

As you said, that shouldn't be a problem.

> automatically set the mask flag in LVTPC when it handles a PMI, so the
> second PMI should be inhibited. However, KVM's local APIC emulation
> fails to set the mask flag in LVTPC when it handles a PMI, so two PMIs
> are delivered via the local APIC. In the common case, where LVTPC is
> configured to deliver an NMI, the first NMI is vectored through the
> guest IDT, and the second one is held pending. When the NMI handler
> returns, the second NMI is vectored through the IDT. For Linux guests,
> this results in the "dazed and confused" spurious NMI message.
> 
> Though the obvious fix is to set the mask flag in LVTPC when handling
> a PMI, KVM's logic around synthesizing a PMI is unnecessarily
> convoluted.

Any obstruction issues on fixing in this direction ?

> 
> Remove the irq_work callback for synthesizing a PMI, and all of the
> logic for invoking it. Instead, to prevent a vcpu from leaving C0 with
> a PMI pending, add a check for KVM_REQ_PMI to kvm_vcpu_has_events().
> 
> Fixes: 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  1 -
>   arch/x86/kvm/pmu.c              | 27 +--------------------------
>   arch/x86/kvm/x86.c              |  3 +++
>   3 files changed, 4 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3bc146dfd38d..f6b9e3ae08bf 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -528,7 +528,6 @@ struct kvm_pmu {
>   	u64 raw_event_mask;
>   	struct kvm_pmc gp_counters[KVM_INTEL_PMC_MAX_GENERIC];
>   	struct kvm_pmc fixed_counters[KVM_PMC_MAX_FIXED];
> -	struct irq_work irq_work;
>   
>   	/*
>   	 * Overlay the bitmap with a 64-bit atomic so that all bits can be
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index bf653df86112..0c117cd24077 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -93,14 +93,6 @@ void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
>   #undef __KVM_X86_PMU_OP
>   }
>   
> -static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
> -{
> -	struct kvm_pmu *pmu = container_of(irq_work, struct kvm_pmu, irq_work);
> -	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
> -
> -	kvm_pmu_deliver_pmi(vcpu);
> -}
> -
>   static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
>   {
>   	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> @@ -124,20 +116,7 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
>   		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
>   	}
>   
> -	if (!pmc->intr || skip_pmi)
> -		return;
> -
> -	/*
> -	 * Inject PMI. If vcpu was in a guest mode during NMI PMI
> -	 * can be ejected on a guest mode re-entry. Otherwise we can't
> -	 * be sure that vcpu wasn't executing hlt instruction at the
> -	 * time of vmexit and is not going to re-enter guest mode until
> -	 * woken up. So we should wake it, but this is impossible from
> -	 * NMI context. Do it from irq work instead.
> -	 */
> -	if (in_pmi && !kvm_handling_nmi_from_guest(pmc->vcpu))
> -		irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
> -	else
> +	if (pmc->intr && !skip_pmi)
>   		kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
>   }
>   
> @@ -677,9 +656,6 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>   
>   void kvm_pmu_reset(struct kvm_vcpu *vcpu)
>   {
> -	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> -
> -	irq_work_sync(&pmu->irq_work);
>   	static_call(kvm_x86_pmu_reset)(vcpu);
>   }
>   
> @@ -689,7 +665,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
>   
>   	memset(pmu, 0, sizeof(*pmu));
>   	static_call(kvm_x86_pmu_init)(vcpu);
> -	init_irq_work(&pmu->irq_work, kvm_pmi_trigger_fn);
>   	pmu->event_count = 0;
>   	pmu->need_cleanup = false;
>   	kvm_pmu_refresh(vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c381770bcbf1..0732c09fbd2d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12841,6 +12841,9 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>   		return true;
>   #endif
>   
> +	if (kvm_test_request(KVM_REQ_PMI, vcpu))
> +		return true;
> +
>   	if (kvm_arch_interrupt_allowed(vcpu) &&
>   	    (kvm_cpu_has_interrupt(vcpu) ||
>   	    kvm_guest_apic_has_interrupt(vcpu)))
