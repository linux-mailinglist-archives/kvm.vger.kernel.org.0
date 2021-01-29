Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53F3308DFF
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 21:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbhA2UCc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 15:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbhA2T6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 14:58:49 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618B6C061573
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 11:58:08 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id n6so11916602edt.10
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 11:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rsWUFGAQcjbF2Zy7tLFCKyCU4kymbDwjAyYr1vEofn0=;
        b=jteInWdP7YEWom75+kP2TYnCPOhrgtNj4Pbnu76zv9p+V70CNLu4EKLS2gy6E7y36D
         JBp+MRMlUfr8zPQa3MM8LtOzSGGx1SwQMI6OgOVyB8BTqcj3Zc5n7sx0QqnZDL6H6qsc
         8UA1WWdbdCx8rZ0O0hC67wpaBeF2Q+VjLluzo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rsWUFGAQcjbF2Zy7tLFCKyCU4kymbDwjAyYr1vEofn0=;
        b=jS+CsX0mhd83tK17F/zKRo9DIhfdnLepUsFd4im6/uL7u11Io8lTA5NQHGbG6ign79
         /nxYUDu3NMGGXpFnmEVGQe1ycQ2ssIdee3U1a3+CmbmgAJ6E0Qxt7MrydeHOscXUfgCp
         U4mYyZUCkYp6TTiUU4f/H6gr71B9/5FoudIhuAP/jBhJkQS3/oLA+xlm77gLsadxPAsD
         aEL2yH8KsccTcXYUpVF0r0DwJQh4YDyoWjWm/my86I97Ya+Y7FefRcdjbajqIGhvhYtE
         YXn2g9FuQ+SPLRkXgA+ivouUA8dXlibSAL7l0NNW5BmFIz0CGVXhlKgKSkrhv0lVtMqU
         t7lw==
X-Gm-Message-State: AOAM530KP+n713QIP6bInh5Bdi0DnCmFDVSCpXTmTJ1aPwj0qC1VXRiS
        Y9oEG8A1zyVLquNBXW0x9GmJJiLSpJeUVPsp5lSh2z5Pe1g=
X-Google-Smtp-Source: ABdhPJyZJtnR+yQFpgSE40VO51sKHuZiL7L1yGrHLR8efOzuhfuQHstLq9q6K24LRuSIL3yELI2Wg2tFhdY0Qh7uBis=
X-Received: by 2002:a05:6402:2211:: with SMTP id cq17mr6955752edb.167.1611950286990;
 Fri, 29 Jan 2021 11:58:06 -0800 (PST)
MIME-Version: 1.0
References: <CAJ-EccMWBJAzwECcJtFh9kXwtVVezWv_Zd0vcqPMPwKk=XFqYQ@mail.gmail.com>
 <20210125133611.703c4b90@omen.home.shazbot.org> <c57d94ca-5674-7aa7-938a-aa6ec9db2830@redhat.com>
 <CAJ-EccPf0+1N_dhNTGctJ7gT2GUmsQnt==CXYKSA-xwMvY5NLg@mail.gmail.com>
 <8ab9378e-1eb3-3cf3-a922-1c63bada6fd8@redhat.com> <CAJ-EccP=ZhCqjW3Pb06X0N=YCjexURzzxNjoN_FEx3mcazK3Cw@mail.gmail.com>
In-Reply-To: <CAJ-EccP=ZhCqjW3Pb06X0N=YCjexURzzxNjoN_FEx3mcazK3Cw@mail.gmail.com>
From:   Micah Morton <mortonm@chromium.org>
Date:   Fri, 29 Jan 2021 14:57:55 -0500
Message-ID: <CAJ-EccNAHGHZjYvT8LV9h8oWvVe+YvcD0dwF7e5grxymhi5Pug@mail.gmail.com>
Subject: Re: Add vfio-platform support for ONESHOT irq forwarding?
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 27, 2021 at 10:58 AM Micah Morton <mortonm@chromium.org> wrote:
>
> On Tue, Jan 26, 2021 at 11:20 AM Auger Eric <eric.auger@redhat.com> wrote=
:
> >
> > Hi Micah,
> >
> > On 1/26/21 4:15 PM, Micah Morton wrote:
> > > On Tue, Jan 26, 2021 at 3:54 AM Auger Eric <eric.auger@redhat.com> wr=
ote:
> > >>
> > >> Hi,
> > >>
> > >> On 1/25/21 9:36 PM, Alex Williamson wrote:
> > >>> On Mon, 25 Jan 2021 10:46:47 -0500
> > >>> Micah Morton <mortonm@chromium.org> wrote:
> > >>>
> > >>>> Hi Eric,
> > >>>>
> > >>>> I was recently looking into some vfio-platform passthrough stuff a=
nd
> > >>>> came across a device I wanted to assign to a guest that uses a ONE=
SHOT
> > >>>> type interrupt (these type of interrupts seem to be quite common, =
on
> > >>>> ARM at least). The semantics for ONESHOT interrupts are a bit
> > >>>> different from regular level triggered interrupts as I'll describe
> > >>>> here:
> > >>>>
> > >>>> The normal generic code flow for level-triggered interrupts is as =
follows:
> > >>>>
> > >>>> - regular type[1]: mask[2] the irq, then run the handler, then
> > >>>> unmask[3] the irq and done
> > >>>>
> > >>>> - fasteoi type[4]: run the handler, then eoi[5] the irq and done
> > >>>>
> > >>>> Note: IIUC the fasteoi type doesn't do any irq masking/unmasking
> > >>>> because that is assumed to be handled transparently by "modern for=
ms
> > >>>> of interrupt handlers, which handle the flow details in hardware"
> > >>>>
> > >>>> ONESHOT type interrupts are a special case of the fasteoi type
> > >>>> described above. They rely on the driver registering a threaded
> > >>>> handler for the interrupt and assume the irq line will remain mask=
ed
> > >>>> until the threaded handler completes, at which time the line will =
be
> > >>>> unmasked. TL;DR:
> > >>>>
> > >>>> - mask[6] the irq, run the handler, and potentially eoi[7] the irq=
,
> > >>>> then unmask[8] later when the threaded handler has finished runnin=
g.
> > >>>
> > >>> This doesn't seem quite correct to me, it skips the discussion of t=
he
> > >>> hard vs threaded handler, where the "regular" type would expect the
> > >>> device interrupt to be masked in the hard handler, such that the
> > >>> controller line can be unmasked during execution of the threaded ha=
ndler
> > >>> (if it exists).  It seems fasteoi is more transactional, ie. rather
> > >
> > > handle_irq_event() only waits for the hard handler to run, not the
> > > threaded handler. And then this comment
> > > (https://elixir.bootlin.com/linux/v5.10.7/source/kernel/irq/chip.c#L6=
22)
> > > implies that the "regular" type IRQs are not normally unmasked by the
> > > threaded handler but rather before that as part of handle_level_irq()
> > > after handle_irq_event() has returned (since cond_unmask_irq() is
> > > always called there and handle_irq_event() doesn't wait for the
> > > threaded handler to run before returning). I don't actually have firs=
t
> > > hand knowledge one way or another whether threaded handlers normally
> > > unmask the IRQ themselves -- just reading the generic IRQ code. Let m=
e
> > > know if I'm missing something here.
> > >
> > >>> than masking around quiescing the device interrupt, we only need to
> > >>> send an eoi once we're ready for a new interrupt.  ONESHOT, OTOH, i=
s a
> > >>> means of deferring all device handling to the threaded interrupt,
> > >>> specifically for cases such as an i2c device where the bus interact=
ion
> > >>> necessitates non-IRQ-context handling.  Sound right?
> > >
> > > The rest of this matches my understanding.
> > >
> > >>>
> > >>>>
> > >>>> For vfio-platform irq forwarding, there is no existing function in
> > >>>> drivers/vfio/platform/vfio_platform_irq.c[9] that is a good candid=
ate
> > >>>> for registering as the threaded handler for a ONESHOT interrupt in=
 the
> > >>>> case we want to request the ONESHOT irq with
> > >>>> request_threaded_irq()[10]. Moreover, we can't just register a
> > >>>> threaded function that simply immediately returns IRQ_HANDLED (as =
is
> > >>>> done in vfio_irq_handler()[11] and vfio_automasked_irq_handler()[1=
2]),
> > >>>> since that would cause the IRQ to be unmasked[13] immediately, bef=
ore
> > >>>> the userspace/guest driver has had any chance to service the
> > >>>> interrupt.
> > >>>
> > >>> Are you proposing servicing the device interrupt before it's sent t=
o
> > >>> userspace?  A ONESHOT irq is going to eoi the interrupt when the th=
read
> > >
> > > No I wasn't thinking of doing any servicing before userspace gets it
> > >
> > >>> exits, before userspace services the interrupt, so this seems like =
a
> > >
> > > Yeah, although I would say unmask rather than eoi, since as Eric just
> > > pointed out IRQCHIP_EOI_THREADED is not supported by GIC. IOW, the GI=
C
> > > irqchip does not "require eoi() on unmask in threaded mode"
> > > (https://elixir.bootlin.com/linux/v5.10.7/source/include/linux/irq.h#=
L575).
> > > The unmask will happen after the thread exits, due to
> > > irq_finalize_oneshot() being called from irq_thread_fn()
> > >
> > >>> case where we'd need to mask the irq regardless of fasteoi handling=
 so
> > >>> that it cannot re-assert before userspace manages the device.  Our
> > >>> existing autmasked for level triggered interrupts should handle thi=
s.
> > >
> > > Yeah that's what I want as well. The thing that was tripping me up is
> > > this description of irq_disable (disable_irq_nosync() as used in VFIO
> > > is a wrapper for irq_disable):
> > > https://elixir.bootlin.com/linux/v5.10.10/source/kernel/irq/chip.c#L3=
71
> > > . This makes it seem like depending on irqchip internals (whether chi=
p
> > > implements irq_disable() callback or not, and what that callback
> > > actually does), we may not be actually masking the irq at the irqchip
> > > level during the disable (although if the IRQ_DISABLE_UNLAZY flag is
> > > set then irq_disable() will lead to mask() being called in the case
> > > the irqchip doesn't implement the disable() callback. But in the
> > > normal case I think that flag is not set). So seemed to me with
> > > ONESHOT we would run the risk of an extra pending interrupt that was
> > > never intended by the hardware (i.e. "an interrupt happens, then the
> > > interrupt flow handler masks the line at the hardware level and marks
> > > it pending"). I guess if we know we are going to ignore this pending
> > > interrupt down the line after guest/userspace has finished with the
> > > interrupt injection then this isn't an issue.
> >
> > Here is my understanding.
> >
> > if the IRQ has been automasked by VFIO on entry in
> > vfio_automasked_irq_handler(), the corresponding SPI (shared peripheral
> > interrupt) has been disabled and cannot be triggered by the GIC anymore
> > (until corresponding unmask). The physical IRQ is deactivated (EOI)
> > after the host ISR by the host genirq code. So the active state of the
> > SPI is removed at this point. When the guest deactivates the vIRQ (so I
> > understand after the completion of the guest vIRQ thread), VFIO unmask
> > handler gets called, the physical SPI is re-enabled. At this point, the
> > GIC scans the physical line again and depending on its state triggers
> > the physical IRQ again.
> >
> > https://www.linux-kvm.org/images/a/a8/01x04-ARMdevice.pdf
> > slide 7 for the SPI states and slide 7 for the KVM/ARM forwarding flow
>
> Ok thanks for the explanation. Sounds like you and Alex are in
> agreement that there shouldn't be a problem with seeing extra
> erroneous pending interrupts upon calling vfio_platform_unmask() in
> the host when doing ONESHOT interrupt forwarding. I have some HW
> devices that use ONESHOT interrupts that I have working in a guest VM,
> although I had used some of the hacks described in my original email
> to get things working. I'll go back and see if everything works well
> with none of these modifications to vfio-platform / guest driver.

Looks like the HW I have that uses ONESHOT interrupts works fine with
vfio-platform IRQ forwarding out of the box. There were some bugs on
my end with kernel modules not being loaded that caused an interrupt
storm and for some reason I need to artificially force a call to
vfio_platform_unmask() for the unmask eventfd at the start of VM
execution since the first interrupt gets missed by the VM or
something. After that everything works normally though AFAICT.

Thanks for the help.

>
> >
> > Eric
> > >
> > >>
> > >> that's my understanding too. If we keep the current automasked level
> > >> sensitive vfio driver scheme and if the guest deactivates the vIRQ w=
hen
> > >> the guest irq thread has completed its job we should be good.
> > >
> > > So you're saying even if we get a pending interrupt VFIO will
> > > correctly ignore it? Or you're saying we won't get one since the IRQ
> > > will be masked (by some guarantee I don't yet understand)?
> > >
> > >>>
> > >>>> The most obvious way I see to handle this is to add a threaded han=
dler
> > >>>> to vfio_platform_irq.c that waits until the userspace/guest driver=
 has
> > >>>> serviced the interrupt and the unmask_handler[14] has been called,=
 at
> > >>>> which point it returns IRQ_HANDLED so the generic IRQ code in the =
host
> > >>>> can finally unmask the interrupt.
> > >>>
> > >>> An interrupt thread with an indeterminate, user controlled runtime
> > >>> seems bad.  The fact that fasteoi will send an eoi doesn't also mea=
n
> > >>> that it can't be masked.
> > >
> > > Yeah ok. And as mentioned above doesn't look like we're doing the eoi
> > > on ARM GIC anyway.
> > >
> > >>>
> > >>>> Does this sound like a reasonable approach and something you would=
 be
> > >>>> fine with adding to vfio-platform? If so I could get started looki=
ng
> > >>>> at the implementation for how to sleep in the threaded handler in
> > >>>> vfio-platform until the unmask_handler is called. The most tricky/=
ugly
> > >>>> part of this is that DT has no knowledge of irq ONESHOT-ness, as i=
t
> > >>>> only contains info regarding active-low vs active-high and edge vs
> > >>>> level trigger. That means that vfio-platform can't figure out that=
 a
> > >>>> device uses a ONESHOT irq in a similar way to how it queries[15] t=
he
> > >>>> trigger type, and by extension QEMU can't learn this information
> > >>>> through the VFIO_DEVICE_GET_IRQ_INFO ioctl, but must have another =
way
> > >>>> of knowing (i.e. command line option to QEMU).
> > >>>
> > >>> Seems like existing level handling w/ masking should handle this, i=
mo.
> > >>>
> > >>>> I guess potentially another option would be to treat ONESHOT
> > >>>> interrupts like regular level triggered interrupts from the
> > >>>> perspective of vfio-platform, but somehow ensure the interrupt sta=
ys
> > >>>> masked during injection to the guest, rather than just disabled. I=
'm
> > >>>> not sure whether this could cause legitimate interrupts coming fro=
m
> > >>>> devices to be missed while the injection for an existing interrupt=
 is
> > >>>> underway, but maybe this is a rare enough scenario that we wouldn'=
t
> > >>>> care. The main issue with this approach is that handle_level_irq()=
[16]
> > >>>> will try to unmask the irq out from under us after we start the
> > >>>> injection (as it is already masked before
> > >>>> vfio_automasked_irq_handler[17] runs anyway). Not sure if masking =
at
> > >>>> the irqchip level supports nesting or not.
> > >>>
> > >>> I'd expect either an unmask at the controller or eoi to re-evaluate=
 the
> > >>> interrupt condition and re-assert as needed.  The interrupt will ne=
ed to
> > >>> be exclusive to the device so as not to starve other devices.
> > >> To me the physical IRQ pending state depends on the line level.
> > >> Depending on this line level, on the unmask the irqchip reevaluates
> > >> whether it should be fired.
> > >>
> > >> Thanks
> > >>
> > >> Eric
> > >>>
> > >>>> Let me know if you think either of these are viable options for ad=
ding
> > >>>> ONESHOT interrupt forwarding support to vfio-platform?
> > >>>>
> > >>>> Thanks,
> > >>>> Micah
> > >>>>
> > >>>>
> > >>>>
> > >>>>
> > >>>> Additional note about level triggered vs ONESHOT irq forwarding:
> > >>>> For the regular type of level triggered interrupt described above,=
 the
> > >>>> vfio handler will call disable_irq_nosync()[18] before the
> > >>>> handle_level_irq() function unmasks the irq and returns. This ensu=
res
> > >>>> if new interrupts come in on the line while the existing one is be=
ing
> > >>>> handled by the guest (and the irq is therefore disabled), that the
> > >>>> vfio_automasked_irq_handler() isn=E2=80=99t triggered again until =
the
> > >>>> vfio_platform_unmask_handler() function has been triggered by the
> > >>>> guest (causing the irq to be re-enabled[19]). In other words, the
> > >>>> purpose of the irq enable/disable that already exists in vfio-plat=
form
> > >>>> is a higher level concept that delays handling of additional
> > >>>> level-triggered interrupts in the host until the current one has b=
een
> > >>>> handled in the guest.
> > >>>
> > >>> I wouldn't say "delays", the interrupt condition is not re-evaluate=
d
> > >>> until the interrupt is unmasked, by which point the user has had an
> > >>> opportunity to service the device, which could de-assert the interr=
upt
> > >>> such that there is no pending interrupt on unmask.  It therefore bl=
ocks
> > >
> > > No pending interrupt on unmask definitely seems like what we want for
> > > ONESHOT. You're saying we have that?
> > >
> > >>> further interrupts until user serviced and unmasked.
> > >>>
> > >>>> This means that the existing level triggered interrupt forwarding
> > >>>> logic in vfio/vfio-platform is not sufficient for handling ONESHOT
> > >>>> interrupts (i.e. we can=E2=80=99t just treat a ONESHOT interrupt l=
ike a
> > >>>> regular level triggered interrupt in the host and use the existing
> > >>>> vfio forwarding code). The masking that needs to happen for ONESHO=
T
> > >>>> interrupts is at the lower level of the irqchip mask/unmask in tha=
t
> > >>>> the ONESHOT irq needs to remain masked (not just disabled) until t=
he
> > >>>> driver=E2=80=99s threaded handler has completed.
> > >>>
> > >>> I don't see that this is true, unmasking the irq should cause the
> > >>> controller to re-evaluate the irq condition on the device end and i=
ssue
> > >>> a new interrupt as necessary.  Right?  Thanks,
> > >> if the line is asserted,
> > >
> > > Yeah, my concern was that the re-evaluation would come to the wrong
> > > conclusion if the ONESHOT irq was lazily disabled without doing the
> > > mask at the irqchip HW level.
> > >
> > >>>
> > >>> Alex
> > >>>
> > >>
> > >
> >
