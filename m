Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F3A6A52DC
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 07:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjB1GSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 01:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjB1GSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 01:18:01 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BBF526E
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 22:17:57 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id c1so9337234plg.4
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 22:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/cRfOxjnOQic8qa5ru9/ExDtQrBRoRhB7MZHIwUy9Vc=;
        b=1G5bQ204ZaZF3DUOerRugfFIqeRpjvcqBlW35XNGhHr/C7f2NPMAe0fYKYz5AbFUsx
         sr4oLOUmn0Ocs1Qba2tw1wmNKD8be1kYjNXOyqSgquXOksPwgIoJ8UL14arfJUOW/zPC
         y1IF1xatl8U3EkcgWIW9ladqVjgu4eREKGwZ74eRdmE4X2bXYu/TjE+cP8/rcBadyiVx
         kQdeXt+dl8MolERLnO/qvNIXklaWjHxg/dVNP8OSMvx5/MFSMl10dxB/SdzYKH7oE7qw
         +wjHLsUxNjndpHiFRO4QhXDfOAQiOoB9FugjTFMrvgFsbEDYphPn4WeQ2Dg7h/gdHcuE
         JTBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/cRfOxjnOQic8qa5ru9/ExDtQrBRoRhB7MZHIwUy9Vc=;
        b=vArKzm5DyUNlCFkmh13qrdJe7upk3iP1+HwZK2Ce2mwrGtzBc9mAIkjPMYh3ASkQtB
         SeCCwnuW6CK/f9D+zWKuc/9FcYLJQN4Jl/2Q1oxN6ITpuUAOHBSfrEkdIR9puTQ79qFG
         rEIC28EQfniismqvNmwoLKIswHi/LIRLVxyTxLrMQ2UkKJHJ+uQKopljrHDTuwmXlRXz
         9yqaoaAtRq1H1HYgOfzzugOu8WckH3nuvSrhdgs8oFW1QgeaLc/4Hs6Wf/U9zip47VSv
         VD9ThpBmNJMTj2tsYDFxGu5u3lMUBdjD185v9xP5vjeMsyA9z2d0DTlcPNGwub1BpRoC
         7Y7g==
X-Gm-Message-State: AO0yUKVxKN6rgkw3MWvY5m2oAUsqCXnk+p4rwEhurjDvHuC4/99rCEJN
        /TUT1X1TY+1mQ2IwLDCdNwcWfA==
X-Google-Smtp-Source: AK7set91eLfnYWpnagWuqlvQZl0uf0NSRElHGH6+9GAWSaiomFZg8XTuegmqdl0i2pM9agP/tcuO5w==
X-Received: by 2002:a17:90b:4d8e:b0:233:a6b7:3770 with SMTP id oj14-20020a17090b4d8e00b00233a6b73770mr2205684pjb.14.1677565076710;
        Mon, 27 Feb 2023 22:17:56 -0800 (PST)
Received: from [192.168.10.153] (ppp118-208-169-253.cbr-trn-nor-bras39.tpg.internode.on.net. [118.208.169.253])
        by smtp.gmail.com with ESMTPSA id s10-20020a17090a764a00b002371e2ac56csm5159432pjl.32.2023.02.27.22.17.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 22:17:56 -0800 (PST)
Message-ID: <1ccefa65-ed72-ba7a-158f-05b832cd5210@ozlabs.ru>
Date:   Tue, 28 Feb 2023 17:17:52 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:108.0) Gecko/20100101
 Thunderbird/108.0
Subject: Re: [PATCH kernel v4] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE support
 platform dependent
Content-Language: en-US
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm-riscv@lists.infradead.org, Anup Patel <anup@brainfault.org>,
        kvm-ppc@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org
References: <20221003235722.2085145-1-aik@ozlabs.ru>
 <7a790aa8-c643-1098-4d28-bd3b10399fcd@ozlabs.ru>
 <5178485f-60d8-0f16-558b-05207102a37e@ozlabs.ru>
 <cea59fc2-1052-53fd-42b0-ac53f5699aa9@ozlabs.ru>
In-Reply-To: <cea59fc2-1052-53fd-42b0-ac53f5699aa9@ozlabs.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Anyone, ping?

On 02/01/2023 11:43, Alexey Kardashevskiy wrote:
> Paolo, ping?
> 
> 
> On 06/12/2022 15:39, Alexey Kardashevskiy wrote:
>> Paolo, ping? :)
>>
>>
>> On 27/10/2022 18:38, Alexey Kardashevskiy wrote:
>>> Paolo, ping?
>>>
>>>
>>> On 04/10/2022 10:57, Alexey Kardashevskiy wrote:
>>>> When introduced, IRQFD resampling worked on POWER8 with XICS. However
>>>> KVM on POWER9 has never implemented it - the compatibility mode code
>>>> ("XICS-on-XIVE") misses the kvm_notify_acked_irq() call and the native
>>>> XIVE mode does not handle INTx in KVM at all.
>>>>
>>>> This moved the capability support advertising to platforms and stops
>>>> advertising it on XIVE, i.e. POWER9 and later.
>>>>
>>>> This should cause no behavioural change for other architectures.
>>>>
>>>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>>>> Acked-by: Nicholas Piggin <npiggin@gmail.com>
>>>> Acked-by: Marc Zyngier <maz@kernel.org>
>>>> ---
>>>> Changes:
>>>> v4:
>>>> * removed incorrect clause about changing behavoir on MIPS and RISCV
>>>>
>>>> v3:
>>>> * removed all ifdeferry
>>>> * removed the capability for MIPS and RISCV
>>>> * adjusted the commit log about MIPS and RISCV
>>>>
>>>> v2:
>>>> * removed ifdef for ARM64.
>>>> ---
>>>>   arch/arm64/kvm/arm.c       | 1 +
>>>>   arch/powerpc/kvm/powerpc.c | 6 ++++++
>>>>   arch/s390/kvm/kvm-s390.c   | 1 +
>>>>   arch/x86/kvm/x86.c         | 1 +
>>>>   virt/kvm/kvm_main.c        | 1 -
>>>>   5 files changed, 9 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>>> index 2ff0ef62abad..d2daa4d375b5 100644
>>>> --- a/arch/arm64/kvm/arm.c
>>>> +++ b/arch/arm64/kvm/arm.c
>>>> @@ -218,6 +218,7 @@ int kvm_vm_ioctl_check_extension(struct kvm 
>>>> *kvm, long ext)
>>>>       case KVM_CAP_VCPU_ATTRIBUTES:
>>>>       case KVM_CAP_PTP_KVM:
>>>>       case KVM_CAP_ARM_SYSTEM_SUSPEND:
>>>> +    case KVM_CAP_IRQFD_RESAMPLE:
>>>>           r = 1;
>>>>           break;
>>>>       case KVM_CAP_SET_GUEST_DEBUG2:
>>>> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
>>>> index fb1490761c87..908ce8bd91c9 100644
>>>> --- a/arch/powerpc/kvm/powerpc.c
>>>> +++ b/arch/powerpc/kvm/powerpc.c
>>>> @@ -593,6 +593,12 @@ int kvm_vm_ioctl_check_extension(struct kvm 
>>>> *kvm, long ext)
>>>>           break;
>>>>   #endif
>>>> +#ifdef CONFIG_HAVE_KVM_IRQFD
>>>> +    case KVM_CAP_IRQFD_RESAMPLE:
>>>> +        r = !xive_enabled();
>>>> +        break;
>>>> +#endif
>>>> +
>>>>       case KVM_CAP_PPC_ALLOC_HTAB:
>>>>           r = hv_enabled;
>>>>           break;
>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>> index edfd4bbd0cba..7521adadb81b 100644
>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>> @@ -577,6 +577,7 @@ int kvm_vm_ioctl_check_extension(struct kvm 
>>>> *kvm, long ext)
>>>>       case KVM_CAP_SET_GUEST_DEBUG:
>>>>       case KVM_CAP_S390_DIAG318:
>>>>       case KVM_CAP_S390_MEM_OP_EXTENSION:
>>>> +    case KVM_CAP_IRQFD_RESAMPLE:
>>>>           r = 1;
>>>>           break;
>>>>       case KVM_CAP_SET_GUEST_DEBUG2:
>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>> index 43a6a7efc6ec..2d6c5a8fdf14 100644
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -4395,6 +4395,7 @@ int kvm_vm_ioctl_check_extension(struct kvm 
>>>> *kvm, long ext)
>>>>       case KVM_CAP_VAPIC:
>>>>       case KVM_CAP_ENABLE_CAP:
>>>>       case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
>>>> +    case KVM_CAP_IRQFD_RESAMPLE:
>>>>           r = 1;
>>>>           break;
>>>>       case KVM_CAP_EXIT_HYPERCALL:
>>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>>> index 584a5bab3af3..05cf94013f02 100644
>>>> --- a/virt/kvm/kvm_main.c
>>>> +++ b/virt/kvm/kvm_main.c
>>>> @@ -4447,7 +4447,6 @@ static long 
>>>> kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>>>>   #endif
>>>>   #ifdef CONFIG_HAVE_KVM_IRQFD
>>>>       case KVM_CAP_IRQFD:
>>>> -    case KVM_CAP_IRQFD_RESAMPLE:
>>>>   #endif
>>>>       case KVM_CAP_IOEVENTFD_ANY_LENGTH:
>>>>       case KVM_CAP_CHECK_EXTENSION_VM:
>>>
>>
> 

-- 
Alexey
