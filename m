Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835C0568CAD
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 17:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbiGFPZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 11:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbiGFPZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 11:25:24 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4635D1031
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 08:25:20 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id a11so18891093ljb.5
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 08:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3DhmTeixM/0Xv2aFH90wXa5nOsizzuKAF+yD8aug0to=;
        b=kZatDZDmNphY8Hrttg3qb1FhsBIkLUQFWBCZHIqnN3XOjZhbfL2G+NNEqKu5o4CI5m
         /r/3dUOtKskoEufu3y71QXTDXDwpbMEXrvnbhKb2DbMQCa/R0HCe2tBaab1xUqYGh9Xu
         pEaBlwUnci6y0VevC95Tb/Bz0RiIVWAMk03W5MGtHPIHKvXHullh3oAZ1aSFhokeiHgC
         GScWmIlofQPhxjzLKm5fUTNggQan45uAN2mJtgJYatdX/RoVfIYinW1K5YQ8JO/lqiCZ
         Tb/QgBwMapp29EAo05Q5rD3QyeqeGYlCGbQ4wgIAQFvqaxoNglAXiJSEBu/Wgo2JuHME
         l8/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3DhmTeixM/0Xv2aFH90wXa5nOsizzuKAF+yD8aug0to=;
        b=QpAvas8odZcEbhNN3FWFc4MRbP1te7ZHkQLGV35wBSuHqLs6z74nSg9F0ZFXOquign
         dCByik7nCoMG5e8xx44586g56Z2+b/CWT5tGEUZqCf6cWKgqHNFdME3wQBNU1+PZh7Ze
         kxc/bpvqm3fZ6cINvFHkzQwKFGQafMBLw+uMomAJV7mnlEpCvCCrwLQMeDRMtJr2gcMa
         Sjp9kicAmzg3Aw0PjrP3nv361jFjU6KUVAVYNkTY5AzYvo482ppcPIkRYAjlo9XHdqMD
         dywXy/QYe+3FL3UQ+gk3XVQi1czYELdT7AwMLU61MTOMOyDR22vpIsqee4IPDd6aGVhi
         RPaA==
X-Gm-Message-State: AJIora8E/F4MPnAdNsYUdRvu7wBUFnAYXIjpyofboPW+FSyxNxivkRXM
        xZymhQ3T7IRLSd9ujrWe6FYL9A==
X-Google-Smtp-Source: AGRyM1tg2dVmN05HpJl0gseMSyvDqua+OWqtZnC21egVS12qaJp9WgkzpwsWvEloWII2bAEv1X8qEg==
X-Received: by 2002:a2e:9dc3:0:b0:25a:76e0:ce18 with SMTP id x3-20020a2e9dc3000000b0025a76e0ce18mr24560334ljj.451.1657121118453;
        Wed, 06 Jul 2022 08:25:18 -0700 (PDT)
Received: from [10.43.1.253] ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id o4-20020a056512050400b004785b66a9a4sm2636811lfb.126.2022.07.06.08.25.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 08:25:17 -0700 (PDT)
Message-ID: <31420943-8c5f-125c-a5ee-d2fde2700083@semihalf.com>
Date:   Wed, 6 Jul 2022 17:25:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Add vfio-platform support for ONESHOT irq forwarding?
Content-Language: en-US
To:     Auger Eric <eric.auger@redhat.com>,
        Micah Morton <mortonm@chromium.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
References: <CAJ-EccMWBJAzwECcJtFh9kXwtVVezWv_Zd0vcqPMPwKk=XFqYQ@mail.gmail.com>
 <20210125133611.703c4b90@omen.home.shazbot.org>
 <c57d94ca-5674-7aa7-938a-aa6ec9db2830@redhat.com>
 <CAJ-EccPf0+1N_dhNTGctJ7gT2GUmsQnt==CXYKSA-xwMvY5NLg@mail.gmail.com>
 <8ab9378e-1eb3-3cf3-a922-1c63bada6fd8@redhat.com>
 <CAJ-EccP=ZhCqjW3Pb06X0N=YCjexURzzxNjoN_FEx3mcazK3Cw@mail.gmail.com>
 <CAJ-EccNAHGHZjYvT8LV9h8oWvVe+YvcD0dwF7e5grxymhi5Pug@mail.gmail.com>
 <99d0e32c-e4eb-5223-a342-c5178a53b692@redhat.com>
From:   Dmytro Maluka <dmy@semihalf.com>
In-Reply-To: <99d0e32c-e4eb-5223-a342-c5178a53b692@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

Hi,

Let me revive this discussion.

It seems last time the conclusion of this discussion was that the 
existing VFIO + KVM mechanism for interrupts forwarding should work just 
as fine for "oneshot" interrupts as for normal level-triggered 
interrupts. It seems, however, that in fact it doesn't work quite 
correctly for "oneshot" interrupts, and now we are observing some real 
problems caused by it (this time on x86, but I suspect that ARM is also 
subject to the same issue).

In short, KVM always sends ack notification at the moment of guest EOI, 
which is too early in the case of oneshot interrupts. Please see my 
comments below.

On 1/30/21 17:38, Auger Eric wrote:
> Hi Micah,
> 
> On 1/29/21 8:57 PM, Micah Morton wrote:
>> On Wed, Jan 27, 2021 at 10:58 AM Micah Morton <mortonm@chromium.org> wrote:
>>>
>>> On Tue, Jan 26, 2021 at 11:20 AM Auger Eric <eric.auger@redhat.com> wrote:
>>>>
>>>> Hi Micah,
>>>>
>>>> On 1/26/21 4:15 PM, Micah Morton wrote:
>>>>> On Tue, Jan 26, 2021 at 3:54 AM Auger Eric <eric.auger@redhat.com> wrote:
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> On 1/25/21 9:36 PM, Alex Williamson wrote:
>>>>>>> On Mon, 25 Jan 2021 10:46:47 -0500
>>>>>>> Micah Morton <mortonm@chromium.org> wrote:
>>>>>>>
>>>>>>>> Hi Eric,
>>>>>>>>
>>>>>>>> I was recently looking into some vfio-platform passthrough stuff and
>>>>>>>> came across a device I wanted to assign to a guest that uses a ONESHOT
>>>>>>>> type interrupt (these type of interrupts seem to be quite common, on
>>>>>>>> ARM at least). The semantics for ONESHOT interrupts are a bit
>>>>>>>> different from regular level triggered interrupts as I'll describe
>>>>>>>> here:
>>>>>>>>
>>>>>>>> The normal generic code flow for level-triggered interrupts is as follows:
>>>>>>>>
>>>>>>>> - regular type[1]: mask[2] the irq, then run the handler, then
>>>>>>>> unmask[3] the irq and done
>>>>>>>>
>>>>>>>> - fasteoi type[4]: run the handler, then eoi[5] the irq and done
>>>>>>>>
>>>>>>>> Note: IIUC the fasteoi type doesn't do any irq masking/unmasking
>>>>>>>> because that is assumed to be handled transparently by "modern forms
>>>>>>>> of interrupt handlers, which handle the flow details in hardware"
>>>>>>>>
>>>>>>>> ONESHOT type interrupts are a special case of the fasteoi type
>>>>>>>> described above. They rely on the driver registering a threaded
>>>>>>>> handler for the interrupt and assume the irq line will remain masked
>>>>>>>> until the threaded handler completes, at which time the line will be
>>>>>>>> unmasked. TL;DR:
>>>>>>>>
>>>>>>>> - mask[6] the irq, run the handler, and potentially eoi[7] the irq,
>>>>>>>> then unmask[8] later when the threaded handler has finished running.
>>>>>>>
>>>>>>> This doesn't seem quite correct to me, it skips the discussion of the
>>>>>>> hard vs threaded handler, where the "regular" type would expect the
>>>>>>> device interrupt to be masked in the hard handler, such that the
>>>>>>> controller line can be unmasked during execution of the threaded handler
>>>>>>> (if it exists).  It seems fasteoi is more transactional, ie. rather
>>>>>
>>>>> handle_irq_event() only waits for the hard handler to run, not the
>>>>> threaded handler. And then this comment
>>>>> (https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L622)
>>>>> implies that the "regular" type IRQs are not normally unmasked by the
>>>>> threaded handler but rather before that as part of handle_level_irq()
>>>>> after handle_irq_event() has returned (since cond_unmask_irq() is
>>>>> always called there and handle_irq_event() doesn't wait for the
>>>>> threaded handler to run before returning). I don't actually have first
>>>>> hand knowledge one way or another whether threaded handlers normally
>>>>> unmask the IRQ themselves -- just reading the generic IRQ code. Let me
>>>>> know if I'm missing something here.
>>>>>
>>>>>>> than masking around quiescing the device interrupt, we only need to
>>>>>>> send an eoi once we're ready for a new interrupt.  ONESHOT, OTOH, is a
>>>>>>> means of deferring all device handling to the threaded interrupt,
>>>>>>> specifically for cases such as an i2c device where the bus interaction
>>>>>>> necessitates non-IRQ-context handling.  Sound right?
>>>>>
>>>>> The rest of this matches my understanding.
>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>> For vfio-platform irq forwarding, there is no existing function in
>>>>>>>> drivers/vfio/platform/vfio_platform_irq.c[9] that is a good candidate
>>>>>>>> for registering as the threaded handler for a ONESHOT interrupt in the
>>>>>>>> case we want to request the ONESHOT irq with
>>>>>>>> request_threaded_irq()[10]. Moreover, we can't just register a
>>>>>>>> threaded function that simply immediately returns IRQ_HANDLED (as is
>>>>>>>> done in vfio_irq_handler()[11] and vfio_automasked_irq_handler()[12]),
>>>>>>>> since that would cause the IRQ to be unmasked[13] immediately, before
>>>>>>>> the userspace/guest driver has had any chance to service the
>>>>>>>> interrupt.
>>>>>>>
>>>>>>> Are you proposing servicing the device interrupt before it's sent to
>>>>>>> userspace?  A ONESHOT irq is going to eoi the interrupt when the thread
>>>>>
>>>>> No I wasn't thinking of doing any servicing before userspace gets it
>>>>>
>>>>>>> exits, before userspace services the interrupt, so this seems like a
>>>>>
>>>>> Yeah, although I would say unmask rather than eoi, since as Eric just
>>>>> pointed out IRQCHIP_EOI_THREADED is not supported by GIC. IOW, the GIC
>>>>> irqchip does not "require eoi() on unmask in threaded mode"
>>>>> (https://elixir.bootlin.com/linux/v5.10.7/source/include/linux/irq.h#L575).
>>>>> The unmask will happen after the thread exits, due to
>>>>> irq_finalize_oneshot() being called from irq_thread_fn()
>>>>>
>>>>>>> case where we'd need to mask the irq regardless of fasteoi handling so
>>>>>>> that it cannot re-assert before userspace manages the device.  Our
>>>>>>> existing autmasked for level triggered interrupts should handle this.

To Alex:
This doesn't seem true. For oneshot fasteoi irq we EOI the interrupt 
when the hardirq handler exits, just like for regular fasteoi irq. (Only 
if IRQCHIP_EOI_THREADED flag is set, EOI is postponed until the threaded 
handler exits. But IRQCHIP_EOI_THREADED is set only for a few exotic 
interrupt controllers, not for generic IO-APIC or GIC.)

This is not a problem on native, since for oneshot irq we keep the 
interrupt masked until the thread exits, so that the EOI at the end of 
hardirq doesn't result in immediate re-assert. In vfio + KVM case, 
however, the host doesn't check that the interrupt is still masked in 
the guest, so vfio_platform_unmask() is called regardless. Therefore, 
since the interrupt has not yet been acked in the guest's threaded 
handler, a new (unwanted) physical interrupt is generated in the host 
and queued for injection to the guest in vfio_automasked_irq_handler().

>>>>>
>>>>> Yeah that's what I want as well. The thing that was tripping me up is
>>>>> this description of irq_disable (disable_irq_nosync() as used in VFIO
>>>>> is a wrapper for irq_disable):
>>>>> https://elixir.bootlin.com/linux/v5.10.10/source/kernel/irq/chip.c#L371
>>>>> . This makes it seem like depending on irqchip internals (whether chip
>>>>> implements irq_disable() callback or not, and what that callback
>>>>> actually does), we may not be actually masking the irq at the irqchip
>>>>> level during the disable (although if the IRQ_DISABLE_UNLAZY flag is
>>>>> set then irq_disable() will lead to mask() being called in the case
>>>>> the irqchip doesn't implement the disable() callback. But in the
>>>>> normal case I think that flag is not set). So seemed to me with
>>>>> ONESHOT we would run the risk of an extra pending interrupt that was
>>>>> never intended by the hardware (i.e. "an interrupt happens, then the
>>>>> interrupt flow handler masks the line at the hardware level and marks
>>>>> it pending"). I guess if we know we are going to ignore this pending
>>>>> interrupt down the line after guest/userspace has finished with the
>>>>> interrupt injection then this isn't an issue.
>>>>
>>>> Here is my understanding.
>>>>
>>>> if the IRQ has been automasked by VFIO on entry in
>>>> vfio_automasked_irq_handler(), the corresponding SPI (shared peripheral
>>>> interrupt) has been disabled and cannot be triggered by the GIC anymore
>>>> (until corresponding unmask). The physical IRQ is deactivated (EOI)
>>>> after the host ISR by the host genirq code. So the active state of the
>>>> SPI is removed at this point. When the guest deactivates the vIRQ (so I
>>>> understand after the completion of the guest vIRQ thread), VFIO unmask
>>>> handler gets called, the physical SPI is re-enabled. At this point, the
>>>> GIC scans the physical line again and depending on its state triggers
>>>> the physical IRQ again.

To Eric:
Again, this doesn't seem to be true. Just as explained in my above reply 
to Alex, the guest deactivates (EOI) the vIRQ already after the 
completion of the vIRQ hardirq handler, not the vIRQ thread.

So VFIO unmask handler gets called too early, before the interrupt gets 
serviced and acked in the vIRQ thread.

>>>>
>>>> https://www.linux-kvm.org/images/a/a8/01x04-ARMdevice.pdf
>>>> slide 7 for the SPI states and slide 7 for the KVM/ARM forwarding flow
>>>
>>> Ok thanks for the explanation. Sounds like you and Alex are in
>>> agreement that there shouldn't be a problem with seeing extra
>>> erroneous pending interrupts upon calling vfio_platform_unmask() in
>>> the host when doing ONESHOT interrupt forwarding. I have some HW

To Micah:
It seems this is not what Eric and Alex were implying. Anyway, even if 
we are fine with those erroneous pending interrupts firing in the host, 
I believe we are not fine with propagating them to the guest.

There are at least 2 user-visible issues caused by those extra erroneous 
pending interrupts for oneshot irq in the guest:

1. System suspend aborted due to a pending wakeup interrupt from
   ChromeOS EC (drivers/platform/chrome/cros_ec.c):

     Abort: Last active Wakeup Source: GOOG0004:00
     PM: suspend exit

2. Annoying "invalid report id data" errors from ELAN0000 touchpad
   (drivers/input/mouse/elan_i2c_core.c), flooding the guest dmesg
   every time the touchpad is touched.

It seems the obvious fix is to postpone sending irq ack notifications in 
KVM from EOI to unmask (for oneshot interrupts only). Luckily, we don't 
need to provide KVM with the info that the given interrupt is oneshot. 
KVM can just find it out from the fact that the interrupt is masked at 
the time of EOI.

Actually I already have a patch implementing such a fix for KVM IO-APIC 
(see below). It makes both the above issues go away. I realize this 
patch is probably racy, since it assumes that dropping ioapic->lock in 
ioapic_write_indirect() is just as fine as doing it in 
kvm_ioapic_update_eoi_one(). I just haven't figured out yet how to 
rework it in a race-free way (BTW, I'd appreciate any suggestions).

Also I guess the same issue exists in KVM on non-x86 as well (since it 
looks like on arm and powerpc kvm_notify_acked_irq() is also always 
called at EOI), as well as in user-space IO-APIC implementations in QEMU 
and other VMMs.


Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
---
  arch/x86/kvm/ioapic.c | 43 +++++++++++++++++++++++++++++++------------
  arch/x86/kvm/ioapic.h |  1 +
  2 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 765943d7cfa5..f008cb5a2bcb 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -365,8 +365,16 @@ static void ioapic_write_indirect(struct kvm_ioapic 
*ioapic, u32 val)
  			e->fields.remote_irr = 0;

  		mask_after = e->fields.mask;
-		if (mask_before != mask_after)
+		if (mask_before != mask_after) {
  			kvm_fire_mask_notifiers(ioapic->kvm, KVM_IRQCHIP_IOAPIC, index, 
mask_after);
+			if (!mask_after && ioapic->ack_pending & (1 << index)) {
+				spin_unlock(&ioapic->lock);
+				kvm_notify_acked_irq(ioapic->kvm, KVM_IRQCHIP_IOAPIC, index);
+				spin_lock(&ioapic->lock);
+
+				ioapic->ack_pending &= ~(1 << index);
+			}
+		}
  		if (e->fields.trig_mode == IOAPIC_LEVEL_TRIG
  		    && ioapic->irr & (1 << index))
  			ioapic_service(ioapic, index, false);
@@ -505,17 +513,28 @@ static void kvm_ioapic_update_eoi_one(struct 
kvm_vcpu *vcpu,
  	struct kvm_lapic *apic = vcpu->arch.apic;
  	union kvm_ioapic_redirect_entry *ent = &ioapic->redirtbl[pin];

-	/*
-	 * We are dropping lock while calling ack notifiers because ack
-	 * notifier callbacks for assigned devices call into IOAPIC
-	 * recursively. Since remote_irr is cleared only after call
-	 * to notifiers if the same vector will be delivered while lock
-	 * is dropped it will be put into irr and will be delivered
-	 * after ack notifier returns.
-	 */
-	spin_unlock(&ioapic->lock);
-	kvm_notify_acked_irq(ioapic->kvm, KVM_IRQCHIP_IOAPIC, pin);
-	spin_lock(&ioapic->lock);
+	if (!ent->fields.mask) {
+		/*
+		 * We are dropping lock while calling ack notifiers because ack
+		 * notifier callbacks for assigned devices call into IOAPIC
+		 * recursively. Since remote_irr is cleared only after call
+		 * to notifiers if the same vector will be delivered while lock
+		 * is dropped it will be put into irr and will be delivered
+		 * after ack notifier returns.
+		 */
+		spin_unlock(&ioapic->lock);
+		kvm_notify_acked_irq(ioapic->kvm, KVM_IRQCHIP_IOAPIC, pin);
+		spin_lock(&ioapic->lock);
+	} else {
+		/*
+		 * If we get an EOI while the interrupt is masked, this is likely
+		 * a Linux guest's threaded oneshot interrupt which is not really
+		 * acked yet at the moment of EOI. In any case, EOI should not
+		 * trigger re-assertion as long as the interrupt is masked,
+		 * so postpone calling ack notifiers until the guest unmasks it.
+		 */
+		ioapic->ack_pending |= 1 << pin;
+	}

  	if (trigger_mode != IOAPIC_LEVEL_TRIG ||
  	    kvm_lapic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI)
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index 539333ac4b38..04a3e2e81b32 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -86,6 +86,7 @@ struct kvm_ioapic {
  	struct delayed_work eoi_inject;
  	u32 irq_eoi[IOAPIC_NUM_PINS];
  	u32 irr_delivered;
+	u32 ack_pending;
  };

  #ifdef DEBUG
-- 
2.37.0.rc0.161.g10f37bed90-goog


Thanks,
Dmytro

>>> devices that use ONESHOT interrupts that I have working in a guest VM,
>>> although I had used some of the hacks described in my original email
>>> to get things working. I'll go back and see if everything works well
>>> with none of these modifications to vfio-platform / guest driver.
>>
>> Looks like the HW I have that uses ONESHOT interrupts works fine with
>> vfio-platform IRQ forwarding out of the box. There were some bugs on
>> my end with kernel modules not being loaded that caused an interrupt
>> storm and for some reason I need to artificially force a call to
>> vfio_platform_unmask() for the unmask eventfd at the start of VM
>> execution since the first interrupt gets missed by the VM or
>> something. After that everything works normally though AFAICT.
>>
>> Thanks for the help.
> 
> You're welcome. Nice to read that ;-)
> 
> Thanks
> 
> Eric
>>
>>>
>>>>
>>>> Eric
>>>>>
>>>>>>
>>>>>> that's my understanding too. If we keep the current automasked level
>>>>>> sensitive vfio driver scheme and if the guest deactivates the vIRQ when
>>>>>> the guest irq thread has completed its job we should be good.
>>>>>
>>>>> So you're saying even if we get a pending interrupt VFIO will
>>>>> correctly ignore it? Or you're saying we won't get one since the IRQ
>>>>> will be masked (by some guarantee I don't yet understand)?
>>>>>
>>>>>>>
>>>>>>>> The most obvious way I see to handle this is to add a threaded handler
>>>>>>>> to vfio_platform_irq.c that waits until the userspace/guest driver has
>>>>>>>> serviced the interrupt and the unmask_handler[14] has been called, at
>>>>>>>> which point it returns IRQ_HANDLED so the generic IRQ code in the host
>>>>>>>> can finally unmask the interrupt.
>>>>>>>
>>>>>>> An interrupt thread with an indeterminate, user controlled runtime
>>>>>>> seems bad.  The fact that fasteoi will send an eoi doesn't also mean
>>>>>>> that it can't be masked.
>>>>>
>>>>> Yeah ok. And as mentioned above doesn't look like we're doing the eoi
>>>>> on ARM GIC anyway.
>>>>>
>>>>>>>
>>>>>>>> Does this sound like a reasonable approach and something you would be
>>>>>>>> fine with adding to vfio-platform? If so I could get started looking
>>>>>>>> at the implementation for how to sleep in the threaded handler in
>>>>>>>> vfio-platform until the unmask_handler is called. The most tricky/ugly
>>>>>>>> part of this is that DT has no knowledge of irq ONESHOT-ness, as it
>>>>>>>> only contains info regarding active-low vs active-high and edge vs
>>>>>>>> level trigger. That means that vfio-platform can't figure out that a
>>>>>>>> device uses a ONESHOT irq in a similar way to how it queries[15] the
>>>>>>>> trigger type, and by extension QEMU can't learn this information
>>>>>>>> through the VFIO_DEVICE_GET_IRQ_INFO ioctl, but must have another way
>>>>>>>> of knowing (i.e. command line option to QEMU).
>>>>>>>
>>>>>>> Seems like existing level handling w/ masking should handle this, imo.
>>>>>>>
>>>>>>>> I guess potentially another option would be to treat ONESHOT
>>>>>>>> interrupts like regular level triggered interrupts from the
>>>>>>>> perspective of vfio-platform, but somehow ensure the interrupt stays
>>>>>>>> masked during injection to the guest, rather than just disabled. I'm
>>>>>>>> not sure whether this could cause legitimate interrupts coming from
>>>>>>>> devices to be missed while the injection for an existing interrupt is
>>>>>>>> underway, but maybe this is a rare enough scenario that we wouldn't
>>>>>>>> care. The main issue with this approach is that handle_level_irq()[16]
>>>>>>>> will try to unmask the irq out from under us after we start the
>>>>>>>> injection (as it is already masked before
>>>>>>>> vfio_automasked_irq_handler[17] runs anyway). Not sure if masking at
>>>>>>>> the irqchip level supports nesting or not.
>>>>>>>
>>>>>>> I'd expect either an unmask at the controller or eoi to re-evaluate the
>>>>>>> interrupt condition and re-assert as needed.  The interrupt will need to
>>>>>>> be exclusive to the device so as not to starve other devices.
>>>>>> To me the physical IRQ pending state depends on the line level.
>>>>>> Depending on this line level, on the unmask the irqchip reevaluates
>>>>>> whether it should be fired.
>>>>>>
>>>>>> Thanks
>>>>>>
>>>>>> Eric
>>>>>>>
>>>>>>>> Let me know if you think either of these are viable options for adding
>>>>>>>> ONESHOT interrupt forwarding support to vfio-platform?
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Micah
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> Additional note about level triggered vs ONESHOT irq forwarding:
>>>>>>>> For the regular type of level triggered interrupt described above, the
>>>>>>>> vfio handler will call disable_irq_nosync()[18] before the
>>>>>>>> handle_level_irq() function unmasks the irq and returns. This ensures
>>>>>>>> if new interrupts come in on the line while the existing one is being
>>>>>>>> handled by the guest (and the irq is therefore disabled), that the
>>>>>>>> vfio_automasked_irq_handler() isn’t triggered again until the
>>>>>>>> vfio_platform_unmask_handler() function has been triggered by the
>>>>>>>> guest (causing the irq to be re-enabled[19]). In other words, the
>>>>>>>> purpose of the irq enable/disable that already exists in vfio-platform
>>>>>>>> is a higher level concept that delays handling of additional
>>>>>>>> level-triggered interrupts in the host until the current one has been
>>>>>>>> handled in the guest.
>>>>>>>
>>>>>>> I wouldn't say "delays", the interrupt condition is not re-evaluated
>>>>>>> until the interrupt is unmasked, by which point the user has had an
>>>>>>> opportunity to service the device, which could de-assert the interrupt
>>>>>>> such that there is no pending interrupt on unmask.  It therefore blocks
>>>>>
>>>>> No pending interrupt on unmask definitely seems like what we want for
>>>>> ONESHOT. You're saying we have that?
>>>>>
>>>>>>> further interrupts until user serviced and unmasked.
>>>>>>>
>>>>>>>> This means that the existing level triggered interrupt forwarding
>>>>>>>> logic in vfio/vfio-platform is not sufficient for handling ONESHOT
>>>>>>>> interrupts (i.e. we can’t just treat a ONESHOT interrupt like a
>>>>>>>> regular level triggered interrupt in the host and use the existing
>>>>>>>> vfio forwarding code). The masking that needs to happen for ONESHOT
>>>>>>>> interrupts is at the lower level of the irqchip mask/unmask in that
>>>>>>>> the ONESHOT irq needs to remain masked (not just disabled) until the
>>>>>>>> driver’s threaded handler has completed.
>>>>>>>
>>>>>>> I don't see that this is true, unmasking the irq should cause the
>>>>>>> controller to re-evaluate the irq condition on the device end and issue
>>>>>>> a new interrupt as necessary.  Right?  Thanks,
>>>>>> if the line is asserted,
>>>>>
>>>>> Yeah, my concern was that the re-evaluation would come to the wrong
>>>>> conclusion if the ONESHOT irq was lazily disabled without doing the
>>>>> mask at the irqchip HW level.
>>>>>
>>>>>>>
>>>>>>> Alex
>>>>>>>
>>>>>>
>>>>>
>>>>
>>
> 
