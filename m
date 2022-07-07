Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E17B56A9D2
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 19:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236494AbiGGRk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 13:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235723AbiGGRkY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 13:40:24 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E44237F1
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 10:40:23 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id f39so32360125lfv.3
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 10:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=lWW5jPLO4GQNrggyQaGktB/iEPgbX+tQ+ploUMi1ZLg=;
        b=CWpdCCSd3uQBPallTC6dPaESCVcwT/F+NdWR/le0Am3tmtBmNHCWKZSDfaav3wfE/J
         WNla84Wjms24Y+nlhYL4eAOShON3y7xPOwEsRJ/r+MzYiFj+L1wTWEEvOepqZZVdiUJl
         Rhkb0ouhVf4BNUI0QCvXCwt4oLL02eB4TWTuUAKtdJHMmJNT/Xl72s6Y9BWMFsLHbXe6
         Jm2a8KSQSQYs7mUEPhsYatg1/jEqZIXXmsothCW4dq+uWqYW1FEIv9E9PxHLZy2n8hYX
         tjTpqDHCgTfBu+9z0IPNG7aa56lcJN2rIavNQz3BiBt+sYY8do51NSikJw+pxOc+AUBa
         ahyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lWW5jPLO4GQNrggyQaGktB/iEPgbX+tQ+ploUMi1ZLg=;
        b=pEfg7ECXwCrA+vYaBRBWcF1elgfw0zkWWb52lxX3mRBuRW7O6brP9bK/xB7MxKOjVl
         qIzymYmQ3zaPF1Wky4B0TbnTeB7C2AvkTlk+RPqBy/5zzosbafv2da+zz3peWl+amUta
         oWsn847j8pQzCiPjvC7iw/TQBqkiEmfgox6iA/MDiWECHsDieZZeNepqQH7dcS/r+Ayc
         Jj2b6LluiN7e0SEa2oVeUPBxWLR7yDKW54i6Du/puJeoPev+/3I+tjwUSi8m4UU0cnNG
         CEX7SUG4EdX3ky7EgX0Fmv9hV3gSjKYu61AGHtZXZB4K6uQT6r1UjuX7SHZCP4aRV7hJ
         h3Wg==
X-Gm-Message-State: AJIora8ch+7AmqQBF0p6g+wHyOydQuBryKv1cP5oUALCjjHAQIb7rIWV
        +013wX722kqi187LY9pNaemE8g==
X-Google-Smtp-Source: AGRyM1uX3xIMENy7RG9zZg1gOgIZhNiiPUttlPuDUP8osJhUfGyHdzTvMHBWltrF+ev4WLfquexxcw==
X-Received: by 2002:a05:6512:6d5:b0:480:fd16:42c5 with SMTP id u21-20020a05651206d500b00480fd1642c5mr28595172lff.183.1657215621478;
        Thu, 07 Jul 2022 10:40:21 -0700 (PDT)
Received: from [10.43.1.253] ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id t15-20020ac243af000000b0048295a41b0asm3252526lfl.302.2022.07.07.10.38.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jul 2022 10:39:26 -0700 (PDT)
Message-ID: <aaec2781-2983-6195-2216-bf4aeeb86d7f@semihalf.com>
Date:   Thu, 7 Jul 2022 19:38:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Add vfio-platform support for ONESHOT irq forwarding?
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Auger Eric <eric.auger@redhat.com>,
        Micah Morton <mortonm@chromium.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
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
From:   Dmytro Maluka <dmy@semihalf.com>
In-Reply-To: <Ysb09r+XXcVZyok4@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 7/7/22 17:00, Sean Christopherson wrote:
> On Thu, Jul 07, 2022, Dmytro Maluka wrote:
>> Hi Sean,
>>
>> On 7/6/22 10:39 PM, Sean Christopherson wrote:
>>> On Wed, Jul 06, 2022, Dmytro Maluka wrote:
>>>> This is not a problem on native, since for oneshot irq we keep the interrupt
>>>> masked until the thread exits, so that the EOI at the end of hardirq doesn't
>>>> result in immediate re-assert. In vfio + KVM case, however, the host doesn't
>>>> check that the interrupt is still masked in the guest, so
>>>> vfio_platform_unmask() is called regardless.
>>>
>>> Isn't not checking that an interrupt is unmasked the real bug?  Fudging around vfio
>>> (or whatever is doing the premature unmasking) bugs by delaying an ack notification
>>> in KVM is a hack, no?
>>
>> Yes, not checking that an interrupt is unmasked is IMO a bug, and my patch
>> actually adds this missing checking, only that it adds it in KVM, not in
>> VFIO. :)
>>
>> Arguably it's not a bug that VFIO is not checking the guest interrupt state
>> on its own, provided that the resample notification it receives is always a
>> notification that the interrupt has been actually acked. That is the
>> motivation behind postponing ack notification in KVM in my patch: it is to
>> ensure that KVM "ack notifications" are always actual ack notifications (as
>> the name suggests), not just "eoi notifications".
> 
> But EOI is an ACK.  It's software saying "this interrupt has been consumed".

Ok, I see we've had some mutual misunderstanding of the term "ack" here. 
EOI is an ACK in the interrupt controller sense, while I was talking 
about an ACK in the device sense, i.e. a device-specific action, done in 
a device driver's IRQ handler, which makes the device de-assert the IRQ 
line (so that the IRQ will not get re-asserted after an EOI or unmask).

So the problem I'm trying to fix stems from the peculiarity of "oneshot" 
interrupts: an ACK in the device sense is done in a threaded handler, 
i.e. after an ACK in the interrupt controller sense, not before it.

In the meantime I've realized one more reason why my patch is wrong. 
kvm_notify_acked_irq() is an internal KVM thing which is supposed to 
notify interested parts of KVM about an ACK rather in the interrupt 
controller sense, i.e. about an EOI as it is doing already.

VFIO, on the other hand, rather expects a notification about an ACK in 
the device sense. So it still seems a good idea to me to postpone 
sending notifications to VFIO until an IRQ gets unmasked, but this 
postponing should be done not for the entire kvm_notify_acked_irq() but 
only for eventfd_signal() on resamplefd in irqfd_resampler_ack().

Thanks for making me think about that.

>   
>> That said, your idea of checking the guest interrupt status in VFIO (or
>> whatever is listening on the resample eventfd) makes sense to me too. The
>> problem, though, is that it's KVM that knows the guest interrupt status, so
>> KVM would need to let VFIO/whatever know it somehow. (I'm assuming we are
>> focusing on the case of KVM kernel irqchip, not userspace or split irqchip.)
>> So do you have in mind adding something like "maskfd" and "unmaskfd" to KVM
>> IRQFD interface, in addition to resamplefd? If so, I'm actually in favor of
>> such an idea, as I think it would be also useful for other purposes,
>> regardless of oneshot interrupts.
> 
> Unless I'm misreading things, KVM already provides a mask notifier, irqfd just
> needs to be wired up to use kvm_(un)register_irq_mask_notifier().

Thanks for the tip. I'll take a look into implementing this idea.

It seems you agree that fixing this issue via a change in KVM (in irqfd, 
not in ioapic) seems to be the way to go.

An immediate problem I see with kvm_(un)register_irq_mask_notifier() is 
that it is currently available for x86 only. Also, mask notifiers are 
called under ioapic->lock (I'm not sure yet if that is good or bad news 
for us).

Thanks,
Dmytro

