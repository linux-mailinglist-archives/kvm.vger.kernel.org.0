Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE4E671A12
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 12:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjARLKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 06:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjARLJ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 06:09:58 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A50A5D109
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 02:17:22 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id v10so47730453edi.8
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 02:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H6ol8sai5DSETE3D+zujMvxltBJArSra6pkGjRfRXcQ=;
        b=OKuh87dDHhB4r7B/XfGPzn8hfY+yL11ZKBITLUzzh0qgBkiusgIeE1QTBPQBq+7LX/
         FhoX/TBO0j3DrTmeRrjfOy75s5FP8iLPtpgWjG+OE8REU0nBtin/5/G1s3Ed6+b8HKtD
         rDuu4lliSBOfsjFhexY9S8wHKAf290rP5+fTGS5fySCIWm0U1d6GWPfh0/eQw3S1+Lgv
         lKWqAYPlrSEnqvkW7lOcOxEAiJadaetD07TXPTIM5UnHQKf+fctNnoQWGDMYDKfMQhk+
         PwK+s8jrP6W5m7nYgwO9ccqUkjwi7Pw9S6h311EwltRvVGYiUyEGw3JqiD2LCgfkRNoB
         GYUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H6ol8sai5DSETE3D+zujMvxltBJArSra6pkGjRfRXcQ=;
        b=12Gq+caAi5/4OpQ5tNjJlu5TPwY/5LAbOTBjmPsidrZN25rP31pDD6sihdYI7s8uv+
         1cFXk9bNbvOt4EZ6B7uXKUfiONvPQ8rva0JYUw7ZQaA+JHWL5HGVVmdmUXTe7BicCZQU
         n+alb7z1umz0yN5Xh4lejSFIo5DRN4+tJULRlJC/AwCP6mDI7snCLfyIk7X6wPwGA2Iz
         /yslD7YrRMCBtByXwFQpNTilo7gsMPrCNTUt+BZtcghdWCE0iWBjmfeW1U/sr4kpzyI+
         erzaUm4PkmKgJm2yU9oK9JRilrLSKcZQH5ixEHTUa0xz9e1JuSYXkhPW1vZ4VPK0rZV+
         vAkQ==
X-Gm-Message-State: AFqh2koVxzmlp7P8+3QUDjZZjNwMUjZJKehNjnqC61KsWYhgHF3IA1kJ
        VTXmkk0ZZcqz48dA9lD9tVkp3w==
X-Google-Smtp-Source: AMrXdXtnqYQxYTHzWZ2KiGPhZG9eVT4RMx08GspQk3hYnE29LeJ7Ai1qxXVecF9Bx9ZV7W9flh8JQw==
X-Received: by 2002:a05:6402:1012:b0:46b:34a:3945 with SMTP id c18-20020a056402101200b0046b034a3945mr6264556edu.31.1674037041150;
        Wed, 18 Jan 2023 02:17:21 -0800 (PST)
Received: from ?IPV6:2003:f6:af03:d200:ef9b:6781:7d3:df26? (p200300f6af03d200ef9b678107d3df26.dip0.t-ipconnect.de. [2003:f6:af03:d200:ef9b:6781:7d3:df26])
        by smtp.gmail.com with ESMTPSA id b20-20020aa7c6d4000000b004610899742asm13950048eds.13.2023.01.18.02.17.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 02:17:20 -0800 (PST)
Message-ID: <1b4d4488-9afc-91e9-790d-5b669d00217b@grsecurity.net>
Date:   Wed, 18 Jan 2023 11:17:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 3/3] KVM: x86: do not unload MMU roots when only toggling
 CR0.WP
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230117204556.16217-1-minipli@grsecurity.net>
 <20230117204556.16217-4-minipli@grsecurity.net> <Y8cTMnyBzNdO5dY3@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <Y8cTMnyBzNdO5dY3@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17.01.23 22:29, Sean Christopherson wrote:
> On Tue, Jan 17, 2023, Mathias Krause wrote:
>> There is no need to unload the MMU roots when only CR0.WP has changed --
>> the paging structures are still valid, only the permission bitmap needs
>> to be updated.
> 
> This doesn't hold true when KVM is using shadow paging, in which case CR0.WP
> affects the shadow page tables.  I believe that also holds true for nNPT :-(

Oh, I knew there would be a case I missed. Thank you for pointing it out!

> nEPT doesn't consume CR0.WP so we could expedite that case as well, though
> identifying that case might be annoying.

I'm fine with starting with optimizing L1 only as the performance gain
for this usual case is huge already. But sure, if more is possible, I'm
all for it. It's just that I lack the knowledge about KVM internals to
figure it out all by myself.

>> Change kvm_mmu_reset_context() to get passed the need for unloading MMU
>> roots and explicitly avoid it if only CR0.WP was toggled on a CR0 write
>> caused VMEXIT.
> 
> One thing we should explore on top of this is not intercepting CR0.WP (on Intel)
> when TDP is enabled.  It could even trigger after toggling CR0.WP N times, e.g.
> to optimize the grsecurity use case without negatively impacting workloads with
> a static CR0.WP, as walking guest memory would require an "extra" VMREAD to get
> CR0.WP in that case.

That would be even better, agreed. I'll look into it and will try to
come up with something.

> Unfortunately, AMD doesn't provide per-bit controls.
> 
>> This change brings a huge performance gain as the following micro-
>> benchmark running 'ssdd 10 50000' from rt-tests[1] on a grsecurity L1 VM
>> shows (runtime in seconds, lower is better):
>>
>>                       legacy MMU   TDP MMU
>> kvm.git/queue             11.55s    13.91s
>> kvm.git/queue+patch        7.44s     7.94s
>>
>> For legacy MMU this is ~35% faster, for TTP MMU ~43% faster.
>>
>> [1] https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git
>>
>> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
>> ---
> 
> ...
> 
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 508074e47bc0..d7c326ab94de 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -902,7 +902,9 @@ EXPORT_SYMBOL_GPL(load_pdptrs);
>>  
>>  void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0)
>>  {
>> -	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
>> +	unsigned long cr0_change = cr0 ^ old_cr0;
>> +
>> +	if (cr0_change & X86_CR0_PG) {
>>  		kvm_clear_async_pf_completion_queue(vcpu);
>>  		kvm_async_pf_hash_reset(vcpu);
>>  
>> @@ -914,10 +916,18 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
>>  			kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
>>  	}
>>  
>> -	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS)
>> -		kvm_mmu_reset_context(vcpu);
>> +	if (cr0_change & KVM_MMU_CR0_ROLE_BITS) {
>> +		bool unload_mmu =
>> +			cr0_change & (KVM_MMU_CR0_ROLE_BITS & ~X86_CR0_WP);
> 
> As above, this needs to guarded with a check that the MMU is direct.  And rather
> than add a flag to kvm_mmu_reset_context(), just call kvm_init_mmu() directly.
> E.g. I think this would work?
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d07563d0e204..8f9fac6d81d2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -927,6 +927,11 @@ EXPORT_SYMBOL_GPL(load_pdptrs);
>  
>  void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0)
>  {
> +       if (vcpu->arch.mmu->root_role.direct && (cr0 ^ old_cr0) == X86_CR0_WP) {
> +               kvm_init_mmu(vcpu);
> +               return;
> +       }
> +
>         if ((cr0 ^ old_cr0) & X86_CR0_PG) {
>                 kvm_clear_async_pf_completion_queue(vcpu);
>                 kvm_async_pf_hash_reset(vcpu);

Looks much simpler and more direct. Nice. :)

I'll re-test and send a v2 later today.

Thanks,
Mathias
