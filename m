Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2449A6CECB3
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 17:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjC2PWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 11:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjC2PWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 11:22:40 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C7240E4
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 08:22:36 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id i9so16146344wrp.3
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 08:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680103355;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y7W75Aj1JXqUv94BCqVKnC108gOZ2Fxsu0cm3gW9pFs=;
        b=GL8f2yj1hc1NNG0cQmMNNwayIwIXAT4wAPfbwKJYHQIO/lcO0MZjlzTlZ7ESbHnzSc
         iXKSs/nnOXh45NqDJlNvsQPa0Wn4VLVFT30QzkpprwC+urI/bcMZHSeBEjs+uSfDl6HL
         KRwy6ugWvnCFTPzWQqgRQ9FSxl+72JbFnlPhw1EXFuMQi+W1TgzpOQ0pA6JFVOsCe5Q+
         wThUgxmXtEKpAqjIiRCJMuFxf5Rr/10B+tRsCNhKrjNLDc1wsjKomn7atpheDBauZ9uI
         ItV2x2S+fLbAHCgy+E8J8qSY7g7ADK/EWFJc+BNzXil+IE9nU2RnpC3Gz54HA/zY/Fn2
         p8Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680103355;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y7W75Aj1JXqUv94BCqVKnC108gOZ2Fxsu0cm3gW9pFs=;
        b=DS8a4k7A9N5nzaGw8CfAKlWh2bu/5RIDoQJ/3x6HKYMBJnQB18Z0HYkvl4r64QsBPq
         ecOjs4Ra1yDvaW2fz02f6Q2sg5nTbZleniU69LlsPf6AWCJ02HMMd/kHV7WZpU4PQq3V
         F4ywxEGUPKEau7IVH6jYAy2N9Bgtq/lU6jP2gBZ1C5VjpyKTigU0giszuN/6tjQCeW74
         1YmHVtEjcaZM85DBZZCdwyLq6doiW9iD8nnX8lzr8EP7HKE/AZ/V5kMzuHDuBCPLUFNx
         g8jxCWAhyI8SCi4lfgFiy5l7k4BMt+Wp5AP1HP6JqTJuYzqe2ylFGaY+b5Q/S0HYt/dG
         gjjg==
X-Gm-Message-State: AAQBX9cBN3n+WVnH+Eeg2WNTCeAk+hUMffxCZ5RwDN00XV7gOEfoNotE
        z8GDVPOZ2JCje0M8+vwy3tqQ/g==
X-Google-Smtp-Source: AKy350ar479T6qzw+Aok0p6f/N3mlt307jFW+rq/voMG52Vg38UBrWUOU8bBAQGbN5SMPEEcOuZozg==
X-Received: by 2002:adf:edcb:0:b0:2ce:a828:b248 with SMTP id v11-20020adfedcb000000b002cea828b248mr15531391wro.71.1680103355000;
        Wed, 29 Mar 2023 08:22:35 -0700 (PDT)
Received: from [192.168.2.107] ([79.115.63.91])
        by smtp.gmail.com with ESMTPSA id k16-20020a5d6d50000000b002cff0e213ddsm30412006wri.14.2023.03.29.08.22.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 08:22:34 -0700 (PDT)
Message-ID: <ff078de7-1af8-19fd-2d8c-7a02792245cd@linaro.org>
Date:   Wed, 29 Mar 2023 16:22:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 07/26] KVM: VMX: Move preemption timer <=> hrtimer
 dance to common x86
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Lee Jones <joneslee@google.com>
References: <20211208015236.1616697-1-seanjc@google.com>
 <20211208015236.1616697-8-seanjc@google.com>
 <1548c1a4-4681-4d98-ee43-44bc97b3bdee@linaro.org>
 <244097d2-3d14-6031-7733-62be75036d88@redhat.com>
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <244097d2-3d14-6031-7733-62be75036d88@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/29/23 14:47, Paolo Bonzini wrote:

Hi, Paolo!

> On 3/29/23 14:34, Tudor Ambarus wrote:
>> This patch fixes the bug reported at:
>> LINK:
>> https://syzkaller.appspot.com/bug?id=489beb3d76ef14cc6cd18125782dc6f86051a605
>>
>> One may find the strace at:
>> LINK:https://syzkaller.appspot.com/text?tag=CrashLog&x=1798b54ec80000
>> and the c reproducer at:
>> LINK:https://syzkaller.appspot.com/text?tag=ReproC&x=10365781c80000
>>
>> Since I've no experience with kvm, it would be helpful if one of you can
>> provide some guidance. Do you think it is worth to backport this patch
>> to stable (together with its prerequisite patches), or shall I try to
>> get familiar with the code and try to provide a less invasive fix?
> 
> I think it is enough to fix the conflicts in vmx_pre_block and
> vmx_post_block, there are no prerequisites:
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0718658268fe..895069038856 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7577,17 +7577,11 @@ static int vmx_pre_block(struct kvm_vcpu *vcpu)
>      if (pi_pre_block(vcpu))
>          return 1;
>  
> -    if (kvm_lapic_hv_timer_in_use(vcpu))
> -        kvm_lapic_switch_to_sw_timer(vcpu);
> -
>      return 0;
>  }
>  
>  static void vmx_post_block(struct kvm_vcpu *vcpu)
>  {
> -    if (kvm_x86_ops.set_hv_timer)
> -        kvm_lapic_switch_to_hv_timer(vcpu);
> -
>      pi_post_block(vcpu);
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fcfa3fedf84f..4eca3ec38afd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10022,12 +10022,28 @@ static int vcpu_enter_guest(struct kvm_vcpu
> *vcpu)
>  
>  static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>  {
> +    bool hv_timer;
> +
>      if (!kvm_arch_vcpu_runnable(vcpu) &&
>          (!kvm_x86_ops.pre_block || static_call(kvm_x86_pre_block)(vcpu)
> == 0)) {
> +        /*
> +         * Switch to the software timer before halt-polling/blocking as
> +         * the guest's timer may be a break event for the vCPU, and the
> +         * hypervisor timer runs only when the CPU is in guest mode.
> +         * Switch before halt-polling so that KVM recognizes an expired
> +         * timer before blocking.
> +         */
> +        hv_timer = kvm_lapic_hv_timer_in_use(vcpu);
> +        if (hv_timer)
> +            kvm_lapic_switch_to_sw_timer(vcpu);
> +
>          srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
>          kvm_vcpu_block(vcpu);
>          vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
>  
> +        if (hv_timer)
> +            kvm_lapic_switch_to_hv_timer(vcpu);
> +
>          if (kvm_x86_ops.post_block)
>              static_call(kvm_x86_post_block)(vcpu);
>  
> @@ -10266,6 +10282,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>              r = -EINTR;
>              goto out;
>          }
> +        /*
> +         * It should be impossible for the hypervisor timer to be in
> +         * use before KVM has ever run the vCPU.
> +         */
> +        WARN_ON_ONCE(kvm_lapic_hv_timer_in_use(vcpu));
>          kvm_vcpu_block(vcpu);
>          if (kvm_apic_accept_events(vcpu) < 0) {
>              r = 0;
> 
> The fix is due to the second "if" changing from
> kvm_x86_ops.set_hv_timer to hv_timer.
> 

Thanks for the prompt answer! I fixed the conflicts as per your
suggestion and tested the patch with the reproducer on top of
stable/linux-5.15.y and I confirm the reproducer is silenced. Sent the
patch proposal (with you in To:) at:
https://lore.kernel.org/all/20230329151747.2938509-1-tudor.ambarus@linaro.org/T/#u
Feel free to ACK/NACK it.

Cheers,
ta
