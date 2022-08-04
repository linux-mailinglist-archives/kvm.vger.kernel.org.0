Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB06A589DD5
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 16:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234776AbiHDOpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 10:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239825AbiHDOo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 10:44:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C02295A8
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 07:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659624293;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1xoIDuGyBXKEVu088HJARC4Hxu4Fhl/Q45ASGAGm74M=;
        b=LqmJsJuJvv7lO3Wmi9wJJco80hTO1UlUtxk8C4qDS0N21RIXgwoSNYRMsk+yFIZh9QDdNk
        WkPQuO4Yue+Wk03V+IWLJR5lo8qgud5l1jFaB4/1VOpu3SRme5tNbOBg9QRdYr7tZBzG0x
        yK/ryqyK47soiV4hplWYZ54Lcf8WKAM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-458-zlYGlG1DOCy46a7LJ1Y44A-1; Thu, 04 Aug 2022 10:44:52 -0400
X-MC-Unique: zlYGlG1DOCy46a7LJ1Y44A-1
Received: by mail-qk1-f200.google.com with SMTP id n15-20020a05620a294f00b006b5768a0ed0so15886755qkp.7
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 07:44:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=1xoIDuGyBXKEVu088HJARC4Hxu4Fhl/Q45ASGAGm74M=;
        b=8RH7Qdnh9FsqTkUDcX7AyLBQBfupEYrholfHZFMfKAGhV7wkEsZwZOKoCGV9KQl1C7
         NQILgnhl77VGeuhzpzOW3JcVMZ5eVGfvYlQOwyKKSOogHnC8+sz16UOe8gfeoIThg+u3
         g0F+7Lwc0e6Bl6zupbMMfmYntPWVt6b88fdbc4EeGZzuF4w7jl0tLiopJH83VutLXCQi
         ggzGaK6mcPQ2TPWkbCM9gdnHpvYu7d5qXGb2lxMkzUfrR//syjq96HBabdNioSNIdZX/
         55HwDXpod7T7iZ1zy0uS0yJOjDc93Sz3BLBefulqb7pw//yaKeTFTC/iFs2kag8A8it1
         4PJg==
X-Gm-Message-State: ACgBeo302d3qceBg3JF/4uT1triH0RTKuOcCAbRXZrgnbzp4hI2e7XqA
        hZh33PhNNc50b3wILWPiKX25F3SVj6ruIFYm4uY7ugyfKOCygEIe9QbR9aBECkPCqKE2mOiq711
        47a9O8uQ27LY2
X-Received: by 2002:a05:6214:d4c:b0:474:88a1:137c with SMTP id 12-20020a0562140d4c00b0047488a1137cmr1745471qvr.120.1659624291297;
        Thu, 04 Aug 2022 07:44:51 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6dq7MDnT1mJNssRXoBcx/6uOiUJ/U7E/YkguCtnL+d3gdnnyLHfV2F1SBlWU2IXMQYo+9Efw==
X-Received: by 2002:a05:6214:d4c:b0:474:88a1:137c with SMTP id 12-20020a0562140d4c00b0047488a1137cmr1745452qvr.120.1659624291065;
        Thu, 04 Aug 2022 07:44:51 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id g18-20020a05620a40d200b006b5f9b7ac87sm940093qko.26.2022.08.04.07.44.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 07:44:50 -0700 (PDT)
Message-ID: <00a09605-75d2-2a95-29dc-b5613a52a168@redhat.com>
Date:   Thu, 4 Aug 2022 16:44:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: eric.auger@redhat.com
Subject: Re: Add vfio-platform support for ONESHOT irq forwarding?
Content-Language: en-US
To:     "Liu, Rong L" <rong.l.liu@intel.com>,
        Dmytro Maluka <dmy@semihalf.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Cc:     Micah Morton <mortonm@chromium.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
References: <20210125133611.703c4b90@omen.home.shazbot.org>
 <c57d94ca-5674-7aa7-938a-aa6ec9db2830@redhat.com>
 <CAJ-EccPf0+1N_dhNTGctJ7gT2GUmsQnt==CXYKSA-xwMvY5NLg@mail.gmail.com>
 <8ab9378e-1eb3-3cf3-a922-1c63bada6fd8@redhat.com>
 <CAJ-EccP=ZhCqjW3Pb06X0N=YCjexURzzxNjoN_FEx3mcazK3Cw@mail.gmail.com>
 <CAJ-EccNAHGHZjYvT8LV9h8oWvVe+YvcD0dwF7e5grxymhi5Pug@mail.gmail.com>
 <99d0e32c-e4eb-5223-a342-c5178a53b692@redhat.com>
 <31420943-8c5f-125c-a5ee-d2fde2700083@semihalf.com>
 <YsXzGkRIVVYEQNE3@google.com>
 <94423bc0-a6d3-f19f-981b-9da113e36432@semihalf.com>
 <Ysb09r+XXcVZyok4@google.com>
 <aaec2781-2983-6195-2216-bf4aeeb86d7f@semihalf.com>
 <MW3PR11MB45544BF267FD3926F90A2158C7869@MW3PR11MB4554.namprd11.prod.outlook.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <MW3PR11MB45544BF267FD3926F90A2158C7869@MW3PR11MB4554.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
On 7/12/22 18:02, Liu, Rong L wrote:
> Hi Sean and Dmytro,
>
>> -----Original Message-----
>> From: Dmytro Maluka <dmy@semihalf.com>
>> Sent: Thursday, July 7, 2022 10:39 AM
>> To: Christopherson,, Sean <seanjc@google.com>
>> Cc: Auger Eric <eric.auger@redhat.com>; Micah Morton
>> <mortonm@chromium.org>; Alex Williamson
>> <alex.williamson@redhat.com>; kvm@vger.kernel.org; Paolo Bonzini
>> <pbonzini@redhat.com>; Liu, Rong L <rong.l.liu@intel.com>; Tomasz
>> Nowicki <tn@semihalf.com>; Grzegorz Jaszczyk <jaz@semihalf.com>;
>> Dmitry Torokhov <dtor@google.com>
>> Subject: Re: Add vfio-platform support for ONESHOT irq forwarding?
>>
>> On 7/7/22 17:00, Sean Christopherson wrote:
>>> On Thu, Jul 07, 2022, Dmytro Maluka wrote:
>>>> Hi Sean,
>>>>
>>>> On 7/6/22 10:39 PM, Sean Christopherson wrote:
>>>>> On Wed, Jul 06, 2022, Dmytro Maluka wrote:
>>>>>> This is not a problem on native, since for oneshot irq we keep the
>>>>>> interrupt masked until the thread exits, so that the EOI at the end
>>>>>> of hardirq doesn't result in immediate re-assert. In vfio + KVM
>>>>>> case, however, the host doesn't check that the interrupt is still
>>>>>> masked in the guest, so
>>>>>> vfio_platform_unmask() is called regardless.
>>>>> Isn't not checking that an interrupt is unmasked the real bug?
>>>>> Fudging around vfio (or whatever is doing the premature unmasking)
>>>>> bugs by delaying an ack notification in KVM is a hack, no?
>>>> Yes, not checking that an interrupt is unmasked is IMO a bug, and my
>>>> patch actually adds this missing checking, only that it adds it in
>>>> KVM, not in VFIO. :)
>>>>
>>>> Arguably it's not a bug that VFIO is not checking the guest interrupt
>>>> state on its own, provided that the resample notification it receives
>>>> is always a notification that the interrupt has been actually acked.
>>>> That is the motivation behind postponing ack notification in KVM in
>>>> my patch: it is to ensure that KVM "ack notifications" are always
>>>> actual ack notifications (as the name suggests), not just "eoi
>> notifications".
>>> But EOI is an ACK.  It's software saying "this interrupt has been
>> consumed".
>>
>> Ok, I see we've had some mutual misunderstanding of the term "ack"
>> here.
>> EOI is an ACK in the interrupt controller sense, while I was talking about
>> an ACK in the device sense, i.e. a device-specific action, done in a device
>> driver's IRQ handler, which makes the device de-assert the IRQ line (so
>> that the IRQ will not get re-asserted after an EOI or unmask).
>>
>> So the problem I'm trying to fix stems from the peculiarity of "oneshot"
>> interrupts: an ACK in the device sense is done in a threaded handler, i.e.
>> after an ACK in the interrupt controller sense, not before it.
>>
>> In the meantime I've realized one more reason why my patch is wrong.
>> kvm_notify_acked_irq() is an internal KVM thing which is supposed to
>> notify interested parts of KVM about an ACK rather in the interrupt
>> controller sense, i.e. about an EOI as it is doing already.
>>
>> VFIO, on the other hand, rather expects a notification about an ACK in the
>> device sense. So it still seems a good idea to me to postpone sending
>> notifications to VFIO until an IRQ gets unmasked, but this postponing
>> should be done not for the entire kvm_notify_acked_irq() but only for
>> eventfd_signal() on resamplefd in irqfd_resampler_ack().
>>
>> Thanks for making me think about that.
>>
>>>> That said, your idea of checking the guest interrupt status in VFIO
>>>> (or whatever is listening on the resample eventfd) makes sense to me
>>>> too. The problem, though, is that it's KVM that knows the guest
>>>> interrupt status, so KVM would need to let VFIO/whatever know it
>>>> somehow. (I'm assuming we are focusing on the case of KVM kernel
>>>> irqchip, not userspace or split irqchip.) So do you have in mind
>>>> adding something like "maskfd" and "unmaskfd" to KVM IRQFD
>> interface,
>>>> in addition to resamplefd? If so, I'm actually in favor of such an
>>>> idea, as I think it would be also useful for other purposes, regardless
>> of oneshot interrupts.
>>> Unless I'm misreading things, KVM already provides a mask notifier,
>>> irqfd just needs to be wired up to use
>> kvm_(un)register_irq_mask_notifier().
>>
> Interesting...  I initially thought that kvm doesn't "trap" on ioapic's mmio
> write.  However, I just traced kvm/ioapic.c and it turns out
> ioapic_write_indirect() was called many times.   Does trapping on ioapic's mmio
> write cause vmexit on edge-triggered interrupt exit?  It seems the case because
> IOREGSEL and IOWIN of IOAPIC are memory mapped but not the redirection entry
> register for each IRQ (that is why the name indirect_write), in order to unmask
> redirection entry register on the exit of each interrupt (edge-triggered or
> level-triggered), kernel needs to write to IORESEL, which means vmexit if kvm
> traps on ioapic's mmio write.  However, for pass-thru device which uses
> edge-triggered interrupt (handled by vfio or something similar),  interrupt
> (pIRQ) is enabled by vfio and it seems unnecessary to cause a vmexit when guest
> updates virtual ioapic.  I think the situation is similar for level-triggered
> interrupt.  So 2 vmexits for each level-triggered interrupt completion, one for
> EOI on lapic and another for unmask of IOAPIC register.  Does this sound right? 
> I thought with vfio (or similar architecture), there is no vmexit necessary on
> edge-triggered interrupt completion and only one vmexit for level triggered
> interrupt completion, except the caveats of oneshot interrupt.  Maybe I
> misunderstand something?
Currently, no vmexit for edge-sensitive and 1 vmexit for level-sensitive
is what happens on ARM shared peripheral interrupts at least.
Note there is one setup that could remove the need for the vmexit on
vEOI: irq_bypass mode
(https://www.linux-kvm.org/images/a/a8/01x04-ARMdevice.pdf slide 12-14):
on GIC you have a mode that allows automatic completion of the physical
IRQ when the corresponding vIRQ is completed. This mode would not be
compatible with oneshort_irq.
At some point we worked on this enablement but given the lack of
vfio-platform customers this work was paused so we still have the
mask/unmask vfio dance.

Thanks

Eric

>
>> Thanks for the tip. I'll take a look into implementing this idea.
>>
>> It seems you agree that fixing this issue via a change in KVM (in irqfd, not
>> in ioapic) seems to be the way to go.
>>
>> An immediate problem I see with kvm_(un)register_irq_mask_notifier()
>> is that it is currently available for x86 only. Also, mask notifiers are called
>> under ioapic->lock (I'm not sure yet if that is good or bad news for us).
>>
>> Thanks,
>> Dmytro

