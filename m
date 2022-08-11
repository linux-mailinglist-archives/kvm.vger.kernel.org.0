Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C462558FD06
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 15:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235536AbiHKNE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 09:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234114AbiHKNE5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 09:04:57 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C4960528
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 06:04:55 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id c17so25476656lfb.3
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 06:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=lXr89IDkw+ktTKDV+sDEOEuD7KYNLo0tZjjErcuTfFc=;
        b=uStlaxMm/a4qhkQMHVIw6C9ev1Be8vPNFIKJ1psO+KaMdO8Wt1SwZsfrfjrF6kvgZQ
         YnqFItNkK7SkOnhHvo0kAEvPC/7emWI6vTI5iVt7jk9aAWZQOiD5L3Q89e+SGqtBLK2v
         bYzzelAesW9kAoXnM91FffoZIwhEk1baNLQ1Zvef+0hve3hxCEdQ2/K0rR14Ne7E3goR
         IZ/saV8yc98j8GT3vtdfvIq7r2PfTNLgTBnMrEV9tQXan+lvLYmDH8eDp/VsKYbAIjE4
         YPDXLJmzWg5nSJg87wSukSSIzJrAoHPV+P7sDPAs6W2o0/jpjA9T5hxKmQ+tJkTgGh2G
         tZEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=lXr89IDkw+ktTKDV+sDEOEuD7KYNLo0tZjjErcuTfFc=;
        b=JZBtICqfFJQe436mcs76D3P58HVlVoeKz1TKzikbwGdP4+L9bDf0VNzQQk8aFgdBbs
         fDVLYQuN1LvtHqJiFVuwDcugk2U6kqPWVtyiezcpDaZcJKk/Ne0Ve6zQkT3dL3FlZAIb
         v3304Q/nW6Cw667rfvzan5vffl6eWdgqBb2bf8V49Ebt8KzW3ITyjq/RBxFNMOL83Lfw
         Rtrp2T6cFmW1jD4MpQd5gjBW4TAztYKZpdO30c5PD7IImL+I9sJ/7p2hqcjrq2GvLDYt
         upkG6MKkEDFTvLSz5q6hGHdpgHdvYvNJdFsStENReoS9xtCwYk0V479AAgxTPcVCXOBP
         /zHQ==
X-Gm-Message-State: ACgBeo1EWtLEiKIh4U3W0Ot0iKODI9YGUEPAianYaa/6wk4Hy+qgxKjI
        plT0TSH4A8/v2bSXA1i52ScEsw==
X-Google-Smtp-Source: AA6agR7MciQZGmM4st/9RDM4e1yKw3ve97E/n53Bue6Hzv5MklmVDGwS9anjmXULzEz1cjPMxMgbxg==
X-Received: by 2002:a05:6512:2349:b0:48c:ee14:7fc with SMTP id p9-20020a056512234900b0048cee1407fcmr6285826lfu.71.1660223094134;
        Thu, 11 Aug 2022 06:04:54 -0700 (PDT)
Received: from [10.43.1.253] ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id u18-20020ac258d2000000b0048af464559esm692795lfo.293.2022.08.11.06.04.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 06:04:50 -0700 (PDT)
Message-ID: <87e48081-19aa-006e-988d-42f9a83ed5e1@semihalf.com>
Date:   Thu, 11 Aug 2022 15:04:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     "Dong, Eddie" <eddie.dong@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
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
 <c5d8f537-5695-42f0-88a9-de80e21f5f4c@semihalf.com>
 <BL0PR11MB304213273FA9FAC4EBC70FF88A629@BL0PR11MB3042.namprd11.prod.outlook.com>
 <ef9ffbde-445e-f00f-23c1-27e23b6cca4f@semihalf.com>
 <87o7wsbngz.wl-maz@kernel.org>
 <3bdcda9f-ac2f-14df-2932-cf16912fe71b@semihalf.com>
 <87mtcbufdq.wl-maz@kernel.org>
From:   Dmytro Maluka <dmy@semihalf.com>
In-Reply-To: <87mtcbufdq.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
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

On 8/11/22 14:35, Marc Zyngier wrote:
> On Wed, 10 Aug 2022 18:06:53 +0100,
> Dmytro Maluka <dmy@semihalf.com> wrote:
>>
>> Hi Marc,
>>
>> On 8/10/22 8:51 AM, Marc Zyngier wrote:
>>> On Wed, 10 Aug 2022 00:30:29 +0100,
>>> Dmytro Maluka <dmy@semihalf.com> wrote:
>>>>
>>>> On 8/9/22 10:01 PM, Dong, Eddie wrote:
>>>>>
>>>>>
>>>>>> -----Original Message-----
>>>>>> From: Dmytro Maluka <dmy@semihalf.com>
>>>>>> Sent: Tuesday, August 9, 2022 12:24 AM
>>>>>> To: Dong, Eddie <eddie.dong@intel.com>; Christopherson,, Sean
>>>>>> <seanjc@google.com>; Paolo Bonzini <pbonzini@redhat.com>;
>>>>>> kvm@vger.kernel.org
>>>>>> Cc: Thomas Gleixner <tglx@linutronix.de>; Ingo Molnar <mingo@redhat.com>;
>>>>>> Borislav Petkov <bp@alien8.de>; Dave Hansen <dave.hansen@linux.intel.com>;
>>>>>> x86@kernel.org; H. Peter Anvin <hpa@zytor.com>; linux-
>>>>>> kernel@vger.kernel.org; Eric Auger <eric.auger@redhat.com>; Alex
>>>>>> Williamson <alex.williamson@redhat.com>; Liu, Rong L <rong.l.liu@intel.com>;
>>>>>> Zhenyu Wang <zhenyuw@linux.intel.com>; Tomasz Nowicki
>>>>>> <tn@semihalf.com>; Grzegorz Jaszczyk <jaz@semihalf.com>;
>>>>>> upstream@semihalf.com; Dmitry Torokhov <dtor@google.com>
>>>>>> Subject: Re: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
>>>>>>
>>>>>> On 8/9/22 1:26 AM, Dong, Eddie wrote:
>>>>>>>>
>>>>>>>> The existing KVM mechanism for forwarding of level-triggered
>>>>>>>> interrupts using resample eventfd doesn't work quite correctly in the
>>>>>>>> case of interrupts that are handled in a Linux guest as oneshot
>>>>>>>> interrupts (IRQF_ONESHOT). Such an interrupt is acked to the device
>>>>>>>> in its threaded irq handler, i.e. later than it is acked to the
>>>>>>>> interrupt controller (EOI at the end of hardirq), not earlier. The
>>>>>>>> existing KVM code doesn't take that into account, which results in
>>>>>>>> erroneous extra interrupts in the guest caused by premature re-assert of an
>>>>>> unacknowledged IRQ by the host.
>>>>>>>
>>>>>>> Interesting...  How it behaviors in native side?
>>>>>>
>>>>>> In native it behaves correctly, since Linux masks such a oneshot interrupt at the
>>>>>> beginning of hardirq, so that the EOI at the end of hardirq doesn't result in its
>>>>>> immediate re-assert, and then unmasks it later, after its threaded irq handler
>>>>>> completes.
>>>>>>
>>>>>> In handle_fasteoi_irq():
>>>>>>
>>>>>> 	if (desc->istate & IRQS_ONESHOT)
>>>>>> 		mask_irq(desc);
>>>>>>
>>>>>> 	handle_irq_event(desc);
>>>>>>
>>>>>> 	cond_unmask_eoi_irq(desc, chip);
>>>>>>
>>>>>>
>>>>>> and later in unmask_threaded_irq():
>>>>>>
>>>>>> 	unmask_irq(desc);
>>>>>>
>>>>>> I also mentioned that in patch #3 description:
>>>>>> "Linux keeps such interrupt masked until its threaded handler finishes, to
>>>>>> prevent the EOI from re-asserting an unacknowledged interrupt.
>>>>>
>>>>> That makes sense. Can you include the full story in cover letter too?
>>>>
>>>> Ok, I will.
>>>>
>>>>>
>>>>>
>>>>>> However, with KVM + vfio (or whatever is listening on the resamplefd) we don't
>>>>>> check that the interrupt is still masked in the guest at the moment of EOI.
>>>>>> Resamplefd is notified regardless, so vfio prematurely unmasks the host
>>>>>> physical IRQ, thus a new (unwanted) physical interrupt is generated in the host
>>>>>> and queued for injection to the guest."
>>>
>>> Sorry to barge in pretty late in the conversation (just been Cc'd on
>>> this), but why shouldn't the resamplefd be notified? If there has been
>>> an EOI, a new level must be made visible to the guest interrupt
>>> controller, no matter what the state of the interrupt masking is.
>>>
>>> Whether this new level is actually *presented* to a vCPU is another
>>> matter entirely, and is arguably a problem for the interrupt
>>> controller emulation.
>>>
>>> For example on arm64, we expect to be able to read the pending state
>>> of an interrupt from the guest irrespective of the masking state of
>>> that interrupt. Any change to the interrupt flow should preserve this.
>>
>> I'd like to understand the problem better, so could you please give some
>> examples of cases where it is required/useful/desirable to read the
>> correct pending state of a guest interrupt?
> 
> I'm not sure I understand the question. It is *always* desirable to
> present the correct information to the guest.
> 
> For example, a guest could periodically poll the pending interrupt
> registers and only enable interrupts that are pending. Is it a good
> idea? No. Is it expected to work? Absolutely.
> 
> And yes, we go out of our way to make sure these things actually work,
> because one day or another, you'll find a guest that does exactly
> that.

Ah indeed, thanks. Somehow I was thinking only about using this
information internally in KVM or perhaps presenting it to the host
userspace via some ioctl. Whereas indeed, the guest itself may well read
those registers and rely on this information.

> 
> Thanks,
> 
> 	M.
> 
