Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE4458E3BF
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 01:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiHIXag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 19:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiHIXaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 19:30:35 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B0E491EC
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 16:30:34 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id bq11so19044403lfb.5
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 16:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=iZRwQQqJlrwLCsKGlbObwH22s/7VDIFNBtxo7IR0iGM=;
        b=phR66Nr/T+MuFGa2vBt/kFwbuJkQC6v36BuX7nbJpfOOFVL6bDB6NzutH535gBOgxG
         EJ6DsY13KJ/BobITbT+druSIqjWbJpVSOyiP0NSOQh/U+hPf/UaXLGgHxWhakaWZ/6/G
         O3eqhGdsvnOH6IhZEZeIUSYjAMCJDtRgDDCqfh7oStDhQJMlX4cfV7bnURNaCT4Bqhwx
         bYDUkyJWvVeB7kxY3xmrSxuVylGEMufLS78IXMI3EAYzewz9sqzVbxukFq54gZD7ZmQ4
         aZAB95yWTBYeYECyKhTfzZNJ3V1mrIdFyg2L+MEz9Gf0XjH6GP3ETbQ0jwF8fnOQ/vHa
         qfAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=iZRwQQqJlrwLCsKGlbObwH22s/7VDIFNBtxo7IR0iGM=;
        b=UCTWA9k1QuTm/VTefnbQhYS0H/EDrkh2WBoUvAhPqDy/bNNbNRZ8YJCUr3M7KY5pbg
         0mvAxhiwtSQ9k+ZgdJeyVhjDC4widSKEGLr30W8aQYq1TBy9MaXGdgL6FMmTlcHKLvvC
         VXhakf4/a48SqSmTsDdlptkjayUzKEtoc9VdgRkfO75m0DDNRlhQ+W9YSgk83xl4zsPw
         8rQuBMCh3pYTr6EDTjWF28gd1/qWqeazMNyCX9yvAy+xgNp549KB9yr20o8GRKOij+AX
         QYchx8UDurfqCjIUsnwrIkrpiDbWWz295saUSorIoWqnJ9USbRaK0x/kFza9+JCUcdzH
         zkkA==
X-Gm-Message-State: ACgBeo2yD44EP60CY5/CXu+FVgZvEBpzb2MV+2lqdJewKG61jHeraGCb
        GuaxO8UO0rnGRXjAPUngyNu5WQ==
X-Google-Smtp-Source: AA6agR4HXcuGe5cAqbmjBRAOeYTzCU2ft9E8H6Qi7D7Mpgg02VczWM5eOi8Ny7jylCnwcxCBE4aPaw==
X-Received: by 2002:ac2:4832:0:b0:48b:1899:b364 with SMTP id 18-20020ac24832000000b0048b1899b364mr8928921lft.534.1660087832351;
        Tue, 09 Aug 2022 16:30:32 -0700 (PDT)
Received: from ?IPv6:2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f? ([2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f])
        by smtp.gmail.com with ESMTPSA id be36-20020a05651c172400b0025e48907929sm156503ljb.23.2022.08.09.16.30.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 16:30:31 -0700 (PDT)
Subject: Re: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
To:     "Dong, Eddie" <eddie.dong@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Rong L" <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        "upstream@semihalf.com" <upstream@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>,
        Marc Zyngier <maz@kernel.org>
References: <20220805193919.1470653-1-dmy@semihalf.com>
 <BL0PR11MB30429034B6D59253AF22BCE08A639@BL0PR11MB3042.namprd11.prod.outlook.com>
 <c5d8f537-5695-42f0-88a9-de80e21f5f4c@semihalf.com>
 <BL0PR11MB304213273FA9FAC4EBC70FF88A629@BL0PR11MB3042.namprd11.prod.outlook.com>
From:   Dmytro Maluka <dmy@semihalf.com>
Message-ID: <ef9ffbde-445e-f00f-23c1-27e23b6cca4f@semihalf.com>
Date:   Wed, 10 Aug 2022 01:30:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <BL0PR11MB304213273FA9FAC4EBC70FF88A629@BL0PR11MB3042.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/9/22 10:01 PM, Dong, Eddie wrote:
> 
> 
>> -----Original Message-----
>> From: Dmytro Maluka <dmy@semihalf.com>
>> Sent: Tuesday, August 9, 2022 12:24 AM
>> To: Dong, Eddie <eddie.dong@intel.com>; Christopherson,, Sean
>> <seanjc@google.com>; Paolo Bonzini <pbonzini@redhat.com>;
>> kvm@vger.kernel.org
>> Cc: Thomas Gleixner <tglx@linutronix.de>; Ingo Molnar <mingo@redhat.com>;
>> Borislav Petkov <bp@alien8.de>; Dave Hansen <dave.hansen@linux.intel.com>;
>> x86@kernel.org; H. Peter Anvin <hpa@zytor.com>; linux-
>> kernel@vger.kernel.org; Eric Auger <eric.auger@redhat.com>; Alex
>> Williamson <alex.williamson@redhat.com>; Liu, Rong L <rong.l.liu@intel.com>;
>> Zhenyu Wang <zhenyuw@linux.intel.com>; Tomasz Nowicki
>> <tn@semihalf.com>; Grzegorz Jaszczyk <jaz@semihalf.com>;
>> upstream@semihalf.com; Dmitry Torokhov <dtor@google.com>
>> Subject: Re: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
>>
>> On 8/9/22 1:26 AM, Dong, Eddie wrote:
>>>>
>>>> The existing KVM mechanism for forwarding of level-triggered
>>>> interrupts using resample eventfd doesn't work quite correctly in the
>>>> case of interrupts that are handled in a Linux guest as oneshot
>>>> interrupts (IRQF_ONESHOT). Such an interrupt is acked to the device
>>>> in its threaded irq handler, i.e. later than it is acked to the
>>>> interrupt controller (EOI at the end of hardirq), not earlier. The
>>>> existing KVM code doesn't take that into account, which results in
>>>> erroneous extra interrupts in the guest caused by premature re-assert of an
>> unacknowledged IRQ by the host.
>>>
>>> Interesting...  How it behaviors in native side?
>>
>> In native it behaves correctly, since Linux masks such a oneshot interrupt at the
>> beginning of hardirq, so that the EOI at the end of hardirq doesn't result in its
>> immediate re-assert, and then unmasks it later, after its threaded irq handler
>> completes.
>>
>> In handle_fasteoi_irq():
>>
>> 	if (desc->istate & IRQS_ONESHOT)
>> 		mask_irq(desc);
>>
>> 	handle_irq_event(desc);
>>
>> 	cond_unmask_eoi_irq(desc, chip);
>>
>>
>> and later in unmask_threaded_irq():
>>
>> 	unmask_irq(desc);
>>
>> I also mentioned that in patch #3 description:
>> "Linux keeps such interrupt masked until its threaded handler finishes, to
>> prevent the EOI from re-asserting an unacknowledged interrupt.
> 
> That makes sense. Can you include the full story in cover letter too?

Ok, I will.

> 
> 
>> However, with KVM + vfio (or whatever is listening on the resamplefd) we don't
>> check that the interrupt is still masked in the guest at the moment of EOI.
>> Resamplefd is notified regardless, so vfio prematurely unmasks the host
>> physical IRQ, thus a new (unwanted) physical interrupt is generated in the host
>> and queued for injection to the guest."
>>
> 
> Emulation of level triggered IRQ is a pain point ☹
> I read we need to emulate the "level" of the IRQ pin (connecting from device to IRQchip, i.e. ioapic here).
> Technically, the guest can change the polarity of vIOAPIC, which will lead to a new  virtual IRQ 
> even w/o host side interrupt.  

Thanks, interesting point. Do you mean that this behavior (a new vIRQ as
a result of polarity change) may already happen with the existing KVM code?

It doesn't seem so to me. AFAICT, KVM completely ignores the vIOAPIC
polarity bit, in particular it doesn't handle change of the polarity by
the guest (i.e. doesn't update the virtual IRR register, and so on), so
it shouldn't result in a new interrupt.

Since commit 100943c54e09 ("kvm: x86: ignore ioapic polarity") there
seems to be an assumption that KVM interpretes the IRQ level value as
active (asserted) vs inactive (deasserted) rather than high vs low, i.e.
the polarity doesn't matter to KVM.

So, since both sides (KVM emulating the IOAPIC, and vfio/whatever
emulating an external interrupt source) seem to operate on a level of
abstraction of "asserted" vs "de-asserted" interrupt state regardless of
the polarity, and that seems not a bug but a feature, it seems that we
don't need to emulate the IRQ level as such. Or am I missing something?

OTOH, I guess this means that the existing KVM's emulation of
level-triggered interrupts is somewhat limited (a guest may legitimately
expect an interrupt fired as a result of polarity change, and that case
is not supported by KVM). But that is rather out of scope of the oneshot
interrupts issue addressed by this patchset.

> "pending" field of kvm_kernel_irqfd_resampler in patch 3 means more an event rather than an interrupt level.
> 
> 
>>>
>>>>
>>>> This patch series fixes this issue (for now on x86 only) by checking
>>>> if the interrupt is unmasked when we receive irq ack (EOI) and, in
>>>> case if it's masked, postponing resamplefd notify until the guest unmasks it.
>>>>
>>>> Patches 1 and 2 extend the existing support for irq mask notifiers in
>>>> KVM, which is a prerequisite needed for KVM irqfd to use mask
>>>> notifiers to know when an interrupt is masked or unmasked.
>>>>
>>>> Patch 3 implements the actual fix: postponing resamplefd notify in
>>>> irqfd until the irq is unmasked.
>>>>
>>>> Patches 4 and 5 just do some optional renaming for consistency, as we
>>>> are now using irq mask notifiers in irqfd along with irq ack notifiers.
>>>>
>>>> Please see individual patches for more details.
>>>>
>>>> v2:
>>>>   - Fixed compilation failure on non-x86: mask_notifier_list moved from
>>>>     x86 "struct kvm_arch" to generic "struct kvm".
>>>>   - kvm_fire_mask_notifiers() also moved from x86 to generic code, even
>>>>     though it is not called on other architectures for now.
>>>>   - Instead of kvm_irq_is_masked() implemented
>>>>     kvm_register_and_fire_irq_mask_notifier() to fix potential race
>>>>     when reading the initial IRQ mask state.
>>>>   - Renamed for clarity:
>>>>       - irqfd_resampler_mask() -> irqfd_resampler_mask_notify()
>>>>       - kvm_irq_has_notifier() -> kvm_irq_has_ack_notifier()
>>>>       - resampler->notifier -> resampler->ack_notifier
>>>>   - Reorganized code in irqfd_resampler_ack() and
>>>>     irqfd_resampler_mask_notify() to make it easier to follow.
>>>>   - Don't follow unwanted "return type on separate line" style for
>>>>     irqfd_resampler_mask_notify().
>>>>
>>>> Dmytro Maluka (5):
>>>>   KVM: x86: Move irq mask notifiers from x86 to generic KVM
>>>>   KVM: x86: Add kvm_register_and_fire_irq_mask_notifier()
>>>>   KVM: irqfd: Postpone resamplefd notify for oneshot interrupts
>>>>   KVM: irqfd: Rename resampler->notifier
>>>>   KVM: Rename kvm_irq_has_notifier()
>>>>
>>>>  arch/x86/include/asm/kvm_host.h |  17 +---
>>>>  arch/x86/kvm/i8259.c            |   6 ++
>>>>  arch/x86/kvm/ioapic.c           |   8 +-
>>>>  arch/x86/kvm/ioapic.h           |   1 +
>>>>  arch/x86/kvm/irq_comm.c         |  74 +++++++++++------
>>>>  arch/x86/kvm/x86.c              |   1 -
>>>>  include/linux/kvm_host.h        |  21 ++++-
>>>>  include/linux/kvm_irqfd.h       |  16 +++-
>>>>  virt/kvm/eventfd.c              | 136 ++++++++++++++++++++++++++++----
>>>>  virt/kvm/kvm_main.c             |   1 +
>>>>  10 files changed, 221 insertions(+), 60 deletions(-)
>>>>
>>>> --
>>>> 2.37.1.559.g78731f0fdb-goog
>>>
