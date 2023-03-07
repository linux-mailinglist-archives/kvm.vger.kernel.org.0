Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCC16AD344
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 01:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjCGAY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 19:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCGAY0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 19:24:26 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF6D3CE0B
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 16:24:23 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id kb15so11629862pjb.1
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 16:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112; t=1678148663;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ORApElYXBJhizAlL5jXFhZZesg5iwjC1RJkWhGTSxuk=;
        b=rBZD7SSzB5wAuZAZExbfgJPFa2XLLqLy19ZfoAP2Nu+NaZZO9F5txZXUJLOvaA7+yk
         LcP12upECXmLLADDzvM33goipum/xJDprvNbwnG91wMIxMwzeMZvv5rt715bSp5g8lnh
         0XbxYw63b20Op9U6yHhErRmsen+MPW+B8kUVrRh1gTLZTiwH1uieN/RwcKneDv/R9yHs
         Sx0GAiWEtd7OPDPrS+hHgyrRnkC4Ct23HPRO0iT266WowFdex536FQScJ55QrSx5lf/C
         x0oX0E1zu93cu9vMkHbvV8SWLO7S2+yLEFTj1oJ8963UeB1JbassTd6UWj37sEN+bTj0
         E54w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678148663;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ORApElYXBJhizAlL5jXFhZZesg5iwjC1RJkWhGTSxuk=;
        b=dtiztOFB2wwFD1Id/xzCOKVgUtIwcNyyOPNQxVqaLnSc1Peb/ZRRJHc7LEbmbYPZof
         Hh2/vKrppaoueqAUwR8sKBMzqYkHOOfVyaPXvXuE3k9zxUFwK1e+uaemvXzLKoyAzeIh
         RnwLTq8k3WzJ1vdd+PGXlt1XfvKJ/iBc94QNa3ZTKeje5tK8iNXcFZuysxI1ZS7zh3J7
         AzfY6dOrJz+WEK+3DyXIsip0dKayBiWWlTkA7PmpaeukgkOqXuLk2HQ7+WyhPXK4KWHC
         +VMx/kpeEmmFWDZLPaM0qdGZY4ZMiucZASPLoHw3WN2q9ZRezw10mEktiJ7sitrBVDeG
         wfiw==
X-Gm-Message-State: AO0yUKUWYFirnSF6ImaZynjQnbzZt2NLC4poeq/YvI9t16QoZpuW0uoY
        /hpwlAPmIluTkvp8iVNBhyONyA==
X-Google-Smtp-Source: AK7set/Mp+lYUxcFZddjP9Win9o1SCUxxhh25DVgGsEwEmyYCuwEZ2VIAWK5pGutq+KP3t+jwSi3eg==
X-Received: by 2002:a17:902:db11:b0:19d:7a4:4063 with SMTP id m17-20020a170902db1100b0019d07a44063mr14885920plx.46.1678148663034;
        Mon, 06 Mar 2023 16:24:23 -0800 (PST)
Received: from [192.168.10.153] (ppp118-208-169-253.cbr-trn-nor-bras39.tpg.internode.on.net. [118.208.169.253])
        by smtp.gmail.com with ESMTPSA id la16-20020a170902fa1000b0019cb8ffd209sm7262914plb.229.2023.03.06.16.24.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 16:24:22 -0800 (PST)
Message-ID: <7a38ddcb-9819-b9f4-a58e-ac21511aa7c3@ozlabs.ru>
Date:   Tue, 7 Mar 2023 11:24:16 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:108.0) Gecko/20100101
 Thunderbird/108.0
Subject: Re: [PATCH kernel v4] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE support
 platform dependent
Content-Language: en-US
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm-riscv@lists.infradead.org, Anup Patel <anup@brainfault.org>,
        kvm-ppc@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org
References: <20221003235722.2085145-1-aik@ozlabs.ru>
 <7a790aa8-c643-1098-4d28-bd3b10399fcd@ozlabs.ru>
 <5178485f-60d8-0f16-558b-05207102a37e@ozlabs.ru>
 <cea59fc2-1052-53fd-42b0-ac53f5699aa9@ozlabs.ru>
 <1ccefa65-ed72-ba7a-158f-05b832cd5210@ozlabs.ru>
In-Reply-To: <1ccefa65-ed72-ba7a-158f-05b832cd5210@ozlabs.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean, can you help please with this? Thanks,


On 28/02/2023 17:17, Alexey Kardashevskiy wrote:
> Anyone, ping?
> 
> On 02/01/2023 11:43, Alexey Kardashevskiy wrote:
>> Paolo, ping?
>>
>>
>> On 06/12/2022 15:39, Alexey Kardashevskiy wrote:
>>> Paolo, ping? :)
>>>
>>>
>>> On 27/10/2022 18:38, Alexey Kardashevskiy wrote:
>>>> Paolo, ping?
>>>>
>>>>
>>>> On 04/10/2022 10:57, Alexey Kardashevskiy wrote:
>>>>> When introduced, IRQFD resampling worked on POWER8 with XICS. However
>>>>> KVM on POWER9 has never implemented it - the compatibility mode code
>>>>> ("XICS-on-XIVE") misses the kvm_notify_acked_irq() call and the native
>>>>> XIVE mode does not handle INTx in KVM at all.
>>>>>
>>>>> This moved the capability support advertising to platforms and stops
>>>>> advertising it on XIVE, i.e. POWER9 and later.
>>>>>
>>>>> This should cause no behavioural change for other architectures.
>>>>>
>>>>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>>>>> Acked-by: Nicholas Piggin <npiggin@gmail.com>
>>>>> Acked-by: Marc Zyngier <maz@kernel.org>
>>>>> ---
>>>>> Changes:
>>>>> v4:
>>>>> * removed incorrect clause about changing behavoir on MIPS and RISCV
>>>>>
>>>>> v3:
>>>>> * removed all ifdeferry
>>>>> * removed the capability for MIPS and RISCV
>>>>> * adjusted the commit log about MIPS and RISCV
>>>>>
>>>>> v2:
>>>>> * removed ifdef for ARM64.
>>>>> ---
>>>>>   arch/arm64/kvm/arm.c       | 1 +
>>>>>   arch/powerpc/kvm/powerpc.c | 6 ++++++
>>>>>   arch/s390/kvm/kvm-s390.c   | 1 +
>>>>>   arch/x86/kvm/x86.c         | 1 +
>>>>>   virt/kvm/kvm_main.c        | 1 -
>>>>>   5 files changed, 9 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>>>> index 2ff0ef62abad..d2daa4d375b5 100644
>>>>> --- a/arch/arm64/kvm/arm.c
>>>>> +++ b/arch/arm64/kvm/arm.c
>>>>> @@ -218,6 +218,7 @@ int kvm_vm_ioctl_check_extension(struct kvm 
>>>>> *kvm, long ext)
>>>>>       case KVM_CAP_VCPU_ATTRIBUTES:
>>>>>       case KVM_CAP_PTP_KVM:
>>>>>       case KVM_CAP_ARM_SYSTEM_SUSPEND:
>>>>> +    case KVM_CAP_IRQFD_RESAMPLE:
>>>>>           r = 1;
>>>>>           break;
>>>>>       case KVM_CAP_SET_GUEST_DEBUG2:
>>>>> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
>>>>> index fb1490761c87..908ce8bd91c9 100644
>>>>> --- a/arch/powerpc/kvm/powerpc.c
>>>>> +++ b/arch/powerpc/kvm/powerpc.c
>>>>> @@ -593,6 +593,12 @@ int kvm_vm_ioctl_check_extension(struct kvm 
>>>>> *kvm, long ext)
>>>>>           break;
>>>>>   #endif
>>>>> +#ifdef CONFIG_HAVE_KVM_IRQFD
>>>>> +    case KVM_CAP_IRQFD_RESAMPLE:
>>>>> +        r = !xive_enabled();
>>>>> +        break;
>>>>> +#endif
>>>>> +
>>>>>       case KVM_CAP_PPC_ALLOC_HTAB:
>>>>>           r = hv_enabled;
>>>>>           break;
>>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>>> index edfd4bbd0cba..7521adadb81b 100644
>>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>>> @@ -577,6 +577,7 @@ int kvm_vm_ioctl_check_extension(struct kvm 
>>>>> *kvm, long ext)
>>>>>       case KVM_CAP_SET_GUEST_DEBUG:
>>>>>       case KVM_CAP_S390_DIAG318:
>>>>>       case KVM_CAP_S390_MEM_OP_EXTENSION:
>>>>> +    case KVM_CAP_IRQFD_RESAMPLE:
>>>>>           r = 1;
>>>>>           break;
>>>>>       case KVM_CAP_SET_GUEST_DEBUG2:
>>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>>> index 43a6a7efc6ec..2d6c5a8fdf14 100644
>>>>> --- a/arch/x86/kvm/x86.c
>>>>> +++ b/arch/x86/kvm/x86.c
>>>>> @@ -4395,6 +4395,7 @@ int kvm_vm_ioctl_check_extension(struct kvm 
>>>>> *kvm, long ext)
>>>>>       case KVM_CAP_VAPIC:
>>>>>       case KVM_CAP_ENABLE_CAP:
>>>>>       case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
>>>>> +    case KVM_CAP_IRQFD_RESAMPLE:
>>>>>           r = 1;
>>>>>           break;
>>>>>       case KVM_CAP_EXIT_HYPERCALL:
>>>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>>>> index 584a5bab3af3..05cf94013f02 100644
>>>>> --- a/virt/kvm/kvm_main.c
>>>>> +++ b/virt/kvm/kvm_main.c
>>>>> @@ -4447,7 +4447,6 @@ static long 
>>>>> kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>>>>>   #endif
>>>>>   #ifdef CONFIG_HAVE_KVM_IRQFD
>>>>>       case KVM_CAP_IRQFD:
>>>>> -    case KVM_CAP_IRQFD_RESAMPLE:
>>>>>   #endif
>>>>>       case KVM_CAP_IOEVENTFD_ANY_LENGTH:
>>>>>       case KVM_CAP_CHECK_EXTENSION_VM:
>>>>
>>>
>>
> 

-- 
Alexey
