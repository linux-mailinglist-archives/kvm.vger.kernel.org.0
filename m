Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5B358D47E
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 09:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236913AbiHIHYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 03:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236139AbiHIHYf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 03:24:35 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26AF20F61
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 00:24:32 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id d14so15783920lfl.13
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 00:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=tTxM+7+FZK4rcvhtVun0/PJ+nOo+VMVRQjQ1dHG97U0=;
        b=gDVJfXB4D8sJ6RBnuq1AvXEE5d4tPDGrPdFA+CXJ/lj8Z77S5L25rxif8dSggGlzjs
         RrYsTkpPnhviTvP6yPRt55PcQClVI9czE5h4RVxiYVgfHeQOvJF998+JDrMNZL3Wdhpi
         5OGPXURct7ZKChNJhzk94a5MLOffXQ+XeCSSSbHue0+9UDOmZla1ZpgSt7r1m97+wx1k
         dmTDt/7j+/P3FAuGlKtJRHGAiuGT3Dq2wKRHnF9KDb0Tz3v8GJqAM4pGzn6X5FeIDkGC
         Ky+ODlwF7cYAPcv/eVSlY2eRQjq5HlAf8Mt1jUMvtZu02vjq0xZ9mjqYjShKAIXEEe41
         OHvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=tTxM+7+FZK4rcvhtVun0/PJ+nOo+VMVRQjQ1dHG97U0=;
        b=JKRvWru5xQo7ABnZJTxIhha8yWLP/GbjD/AAoj/+XQxkAQEvG3+o4htCpTf08hOGXQ
         N/GxbnDwQtps18WqjKr6wMYa8sPOFPUv1Lujj3/jTvzuEbAt15EUFrDr+iOwV/VACcvj
         UqEbwPxLADrOYHF5MngH0rc5o4+c/7QTwKyyOe0vo36JjkTX9VQMsIPQXHRL1jvRS+JX
         SPCy+fWAW9xSUKIiP1866vfSs3wmI/RVyXH5KJuOyKKARAAXIJR3GTpIGQdXK9xhOR8+
         62R5cupVJTU0HM+jmZ1GpL8ji509EnP2UGVDF9yf16FBBK86enpVi4Xv1EAvH2eu5tHX
         sChA==
X-Gm-Message-State: ACgBeo1yAqaS5b2rVuSjT0LJDw9ueAyszW2SQeTpkOaNz2S2J3P/Mngw
        RFY65vQgpU7ezguV843TzorjzAe08m43gpI2
X-Google-Smtp-Source: AA6agR6qAPyNpgqimh0JJNh6Fu2PX+u4s6pGBtxqx02kqH+0tyIkfb1j2BeEEp7jIRNOT1OCqZKzAA==
X-Received: by 2002:a05:6512:3b28:b0:48b:2071:e423 with SMTP id f40-20020a0565123b2800b0048b2071e423mr8231558lfv.434.1660029871039;
        Tue, 09 Aug 2022 00:24:31 -0700 (PDT)
Received: from ?IPv6:2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f? ([2a02:a31b:33d:9c00:463a:87e3:44fc:2b2f])
        by smtp.gmail.com with ESMTPSA id v5-20020a197405000000b0048a8b6914d2sm1656517lfe.155.2022.08.09.00.24.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 00:24:30 -0700 (PDT)
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
        Dmitry Torokhov <dtor@google.com>
References: <20220805193919.1470653-1-dmy@semihalf.com>
 <BL0PR11MB30429034B6D59253AF22BCE08A639@BL0PR11MB3042.namprd11.prod.outlook.com>
From:   Dmytro Maluka <dmy@semihalf.com>
Message-ID: <c5d8f537-5695-42f0-88a9-de80e21f5f4c@semihalf.com>
Date:   Tue, 9 Aug 2022 09:24:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <BL0PR11MB30429034B6D59253AF22BCE08A639@BL0PR11MB3042.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/9/22 1:26 AM, Dong, Eddie wrote:
>>
>> The existing KVM mechanism for forwarding of level-triggered interrupts using
>> resample eventfd doesn't work quite correctly in the case of interrupts that are
>> handled in a Linux guest as oneshot interrupts (IRQF_ONESHOT). Such an
>> interrupt is acked to the device in its threaded irq handler, i.e. later than it is
>> acked to the interrupt controller (EOI at the end of hardirq), not earlier. The
>> existing KVM code doesn't take that into account, which results in erroneous
>> extra interrupts in the guest caused by premature re-assert of an
>> unacknowledged IRQ by the host.
> 
> Interesting...  How it behaviors in native side? 

In native it behaves correctly, since Linux masks such a oneshot
interrupt at the beginning of hardirq, so that the EOI at the end of
hardirq doesn't result in its immediate re-assert, and then unmasks it
later, after its threaded irq handler completes.

In handle_fasteoi_irq():

	if (desc->istate & IRQS_ONESHOT)
		mask_irq(desc);

	handle_irq_event(desc);

	cond_unmask_eoi_irq(desc, chip);


and later in unmask_threaded_irq():

	unmask_irq(desc);

I also mentioned that in patch #3 description:
"Linux keeps such interrupt masked until its threaded handler finishes,
to prevent the EOI from re-asserting an unacknowledged interrupt.
However, with KVM + vfio (or whatever is listening on the resamplefd)
we don't check that the interrupt is still masked in the guest at the
moment of EOI. Resamplefd is notified regardless, so vfio prematurely
unmasks the host physical IRQ, thus a new (unwanted) physical interrupt
is generated in the host and queued for injection to the guest."

> 
>>
>> This patch series fixes this issue (for now on x86 only) by checking if the
>> interrupt is unmasked when we receive irq ack (EOI) and, in case if it's masked,
>> postponing resamplefd notify until the guest unmasks it.
>>
>> Patches 1 and 2 extend the existing support for irq mask notifiers in KVM,
>> which is a prerequisite needed for KVM irqfd to use mask notifiers to know
>> when an interrupt is masked or unmasked.
>>
>> Patch 3 implements the actual fix: postponing resamplefd notify in irqfd until
>> the irq is unmasked.
>>
>> Patches 4 and 5 just do some optional renaming for consistency, as we are now
>> using irq mask notifiers in irqfd along with irq ack notifiers.
>>
>> Please see individual patches for more details.
>>
>> v2:
>>   - Fixed compilation failure on non-x86: mask_notifier_list moved from
>>     x86 "struct kvm_arch" to generic "struct kvm".
>>   - kvm_fire_mask_notifiers() also moved from x86 to generic code, even
>>     though it is not called on other architectures for now.
>>   - Instead of kvm_irq_is_masked() implemented
>>     kvm_register_and_fire_irq_mask_notifier() to fix potential race
>>     when reading the initial IRQ mask state.
>>   - Renamed for clarity:
>>       - irqfd_resampler_mask() -> irqfd_resampler_mask_notify()
>>       - kvm_irq_has_notifier() -> kvm_irq_has_ack_notifier()
>>       - resampler->notifier -> resampler->ack_notifier
>>   - Reorganized code in irqfd_resampler_ack() and
>>     irqfd_resampler_mask_notify() to make it easier to follow.
>>   - Don't follow unwanted "return type on separate line" style for
>>     irqfd_resampler_mask_notify().
>>
>> Dmytro Maluka (5):
>>   KVM: x86: Move irq mask notifiers from x86 to generic KVM
>>   KVM: x86: Add kvm_register_and_fire_irq_mask_notifier()
>>   KVM: irqfd: Postpone resamplefd notify for oneshot interrupts
>>   KVM: irqfd: Rename resampler->notifier
>>   KVM: Rename kvm_irq_has_notifier()
>>
>>  arch/x86/include/asm/kvm_host.h |  17 +---
>>  arch/x86/kvm/i8259.c            |   6 ++
>>  arch/x86/kvm/ioapic.c           |   8 +-
>>  arch/x86/kvm/ioapic.h           |   1 +
>>  arch/x86/kvm/irq_comm.c         |  74 +++++++++++------
>>  arch/x86/kvm/x86.c              |   1 -
>>  include/linux/kvm_host.h        |  21 ++++-
>>  include/linux/kvm_irqfd.h       |  16 +++-
>>  virt/kvm/eventfd.c              | 136 ++++++++++++++++++++++++++++----
>>  virt/kvm/kvm_main.c             |   1 +
>>  10 files changed, 221 insertions(+), 60 deletions(-)
>>
>> --
>> 2.37.1.559.g78731f0fdb-goog
> 
