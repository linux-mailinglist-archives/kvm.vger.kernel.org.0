Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02E055E0FD
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243619AbiF1Dtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 23:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243577AbiF1Dta (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 23:49:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A581205D1
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 20:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656388167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c9yCtS+drfAuIgO28s2jBKYE19OGa/tXTPZ1XT4r6wQ=;
        b=Rq2fBQEFlWT4F9rTPKKum15cE+VSEUHRaGs5MxWe/0I6TIgvTO2m2KEjfcEH+1UzeXQ21Y
        /2MJuFGjuyMouaZBbFTFBUJrYFT1gJhXWNrrbYFxBuRQscASkZXKf5X05Kqspx69oWblLR
        uj63+OeJhMUX5NESGmKH+a1M28VI0w0=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-I92e1A8PPAiOZRZRYQ7r8Q-1; Mon, 27 Jun 2022 23:49:25 -0400
X-MC-Unique: I92e1A8PPAiOZRZRYQ7r8Q-1
Received: by mail-lf1-f69.google.com with SMTP id f29-20020a19dc5d000000b004811c8d1918so1971310lfj.2
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 20:49:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c9yCtS+drfAuIgO28s2jBKYE19OGa/tXTPZ1XT4r6wQ=;
        b=MISq3AVMo5iU8tuq2zA5ZJ6NCg9RgrNVrreRWuNyG9cGeCtzyDgyBov07bTitF9Ei+
         07/3STNt/kQKI5qr67EJGfsDSDdF8fttWSxBksdZct37ezSRw3p5Up00J7+S6elADdHr
         8zZ59ntd9MENUbISYG4nN12Ot3NN3Khhtnh+/NggmdgWp62lFuzer8fCvLNdpSc1HoLl
         KQTfYKRO6SgmlJHFewnSxiOfBYC5tnTyv5GwXKVjZduwIMXxfnq6+5fHZ5lz//VHcFkw
         T7oDYQxgZWTQa1NKEETgSCxNeLxeQf9soo0HZ61Qlf9hcc6YxIs5pyvPr+KTimE4QL6p
         U+cw==
X-Gm-Message-State: AJIora+qZZFGlWNsCIqh/2d2Z8YdaNpi2njtSboyOSd8CvTwF54U2JlH
        jw+f5LaOiPs5B+8/c5FIToMJ/fK9TBb4L0CBujnv/P/jiGYPT7do7Ky5uvwFJQVIe1IN0DAVW1k
        tLhHiMTQPOTR4g03HmMDepkNIdul3
X-Received: by 2002:a05:6512:13a5:b0:47d:c1d9:dea8 with SMTP id p37-20020a05651213a500b0047dc1d9dea8mr10091786lfa.442.1656388163839;
        Mon, 27 Jun 2022 20:49:23 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1umr3Agu31nyCeIAKw/LnJ4iT6H6X6wKAUsqFLq9/ybr2sYEI7g08RoHACqL8Z+mo6fU+DBjnB4/Ejb1DTaVdI=
X-Received: by 2002:a05:6512:13a5:b0:47d:c1d9:dea8 with SMTP id
 p37-20020a05651213a500b0047dc1d9dea8mr10091766lfa.442.1656388163451; Mon, 27
 Jun 2022 20:49:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220622012940.21441-1-jasowang@redhat.com> <20220622025047-mutt-send-email-mst@kernel.org>
 <CACGkMEtJY2ioD0L8ifTrCPatG6-NqQ01V=d2L1FeoweKV74LaA@mail.gmail.com>
 <20220624022622-mutt-send-email-mst@kernel.org> <CACGkMEuurobpUWmDL8zmZ6T6Ygc0OEMx6vx2EDCSoGNnZQ0r-w@mail.gmail.com>
 <20220627024049-mutt-send-email-mst@kernel.org> <CACGkMEvrDXDN7FH1vKoYCob2rkxUsctE_=g61kzHSZ8tNNr6vA@mail.gmail.com>
 <20220627053820-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220627053820-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 28 Jun 2022 11:49:12 +0800
Message-ID: <CACGkMEvcs+9_SHmO1s3nyzgU7oq7jhU2gircVVR3KDsGDikh5Q@mail.gmail.com>
Subject: Re: [PATCH V3] virtio: disable notification hardening by default
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 27, 2022 at 5:52 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Jun 27, 2022 at 04:11:18PM +0800, Jason Wang wrote:
> > On Mon, Jun 27, 2022 at 3:33 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Mon, Jun 27, 2022 at 10:50:17AM +0800, Jason Wang wrote:
> > > > On Fri, Jun 24, 2022 at 2:31 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > >
> > > > > On Wed, Jun 22, 2022 at 03:09:31PM +0800, Jason Wang wrote:
> > > > > > On Wed, Jun 22, 2022 at 3:03 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > >
> > > > > > > On Wed, Jun 22, 2022 at 09:29:40AM +0800, Jason Wang wrote:
> > > > > > > > We try to harden virtio device notifications in 8b4ec69d7e09 ("virtio:
> > > > > > > > harden vring IRQ"). It works with the assumption that the driver or
> > > > > > > > core can properly call virtio_device_ready() at the right
> > > > > > > > place. Unfortunately, this seems to be not true and uncover various
> > > > > > > > bugs of the existing drivers, mainly the issue of using
> > > > > > > > virtio_device_ready() incorrectly.
> > > > > > > >
> > > > > > > > So let's having a Kconfig option and disable it by default. It gives
> > > > > > > > us a breath to fix the drivers and then we can consider to enable it
> > > > > > > > by default.
> > > > > > > >
> > > > > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > > >
> > > > > > >
> > > > > > > OK I will queue, but I think the problem is fundamental.
> > > > > >
> > > > > > If I understand correctly, you want some core IRQ work?
> > > > >
> > > > > Yes.
> > > > >
> > > > > > As discussed
> > > > > > before, it doesn't solve all the problems, we still need to do per
> > > > > > driver audit.
> > > > > >
> > > > > > Thanks
> > > > >
> > > > > Maybe, but we don't need to tie things to device_ready then.
> > > > > We can do
> > > > >
> > > > > - disable irqs
> > > > > - device ready
> > > > > - setup everything
> > > > > - enable irqs
> > > > >
> > > > >
> > > > > and this works for most things, the only issue is
> > > > > this deadlocks if "setup everything" waits for interrupts.
> > > > >
> > > > >
> > > > > With the current approach there's really no good time:
> > > > > 1.- setup everything
> > > > > - device ready
> > > > >
> > > > > can cause kicks before device is ready
> > > > >
> > > > > 2.- device ready
> > > > > - setup everything
> > > > >
> > > > > can cause callbacks before setup.
> > > > >
> > > > > So I prefer the 1. and fix the hardening in the core.
> > > >
> > > > So my question is:
> > > >
> > > > 1) do similar hardening like config interrupt
> > > > or
> > > > 2) per transport notification work (e.g for PCI core IRQ work)
> > > >
> > > > 1) seems easier and universal, but we pay little overhead which could
> > > > be eliminated by the config option.
> > >
> > > I doubt 1 is easy and I am not even sure core IRQ changes will help.
> >
> > Core IRQ won't help in 1), the changes are limited in the virtio.
> >
> > > My concern with adding overhead is that I'm not sure these are not just
> > > wasted CPU cycles.  We spent a bunch of time on irq hardening and so far
> > > we are still at the "all drivers need to be fixed" stage.
> >
> > It's not the fault of hardening but the drivers. The hardening just
> > expose those bugs.
>
> Heh. Yea sure. But things work fine for people. What is the chance
> your review found and fixed all driver bugs?

I don't/can't audit all bugs but the race between open/close against
ready/reset. It looks to me a good chance to fix them all but if you
think differently, let me know

> After two attempts
> I don't feel like hoping audit will fix all bugs.

I've started the auditing and have 15+ patches in the queue. (only
covers bluetooth, console, pmem, virtio-net and caif). Spotting the
issue is not hard but the testing, It would take at least the time of
one release to finalize I guess.

>
>
> > >
> > > The reason config was kind of easy is that config interrupt is rarely
> > > vital for device function so arbitrarily deferring that does not lead to
> > > deadlocks - what you are trying to do with VQ interrupts is
> > > fundamentally different. Things are especially bad if we just drop
> > > an interrupt but deferring can lead to problems too.
> >
> > I'm not sure I see the difference, disable_irq() stuffs also delay the
> > interrupt processing until enable_irq().
>
>
> Absolutely. I am not at all sure disable_irq fixes all problems.
>
> > >
> > > Consider as an example
> > >     virtio-net: fix race between ndo_open() and virtio_device_ready()
> > > if you just defer vq interrupts you get deadlocks.
> > >
> > >
> >
> > I don't see a deadlock here, maybe you can show more detail on this?
>
> What I mean is this: if we revert the above commit, things still
> work (out of spec, but still). If we revert and defer interrupts until
> device ready then ndo_open that triggers before device ready deadlocks.

Ok, I guess you meant on a hypervisor that is strictly written with spec.

>
>
> > >
> > > So, thinking about all this, how about a simple per vq flag meaning
> > > "this vq was kicked since reset"?
> >
> > And ignore the notification if vq is not kicked? It sounds like the
> > callback needs to be synchronized with the kick.
>
> Note we only need to synchronize it when it changes, which is
> only during initialization and reset.

Yes.

>
>
> > >
> > > If driver does not kick then it's not ready to get callbacks, right?
> > >
> > > Sounds quite clean, but we need to think through memory ordering
> > > concerns - I guess it's only when we change the value so
> > >         if (!vq->kicked) {
> > >                 vq->kicked = true;
> > >                 mb();
> > >         }
> > >
> > > will do the trick, right?
> >
> > There's no much difference with the existing approach:
> >
> > 1) your proposal implicitly makes callbacks ready in virtqueue_kick()
> > 2) my proposal explicitly makes callbacks ready via virtio_device_ready()
> >
> > Both require careful auditing of all the existing drivers to make sure
> > no kick before DRIVER_OK.
>
> Jason, kick before DRIVER_OK is out of spec, sure. But it is unrelated
> to hardening

Yes but with your proposal, it seems to couple kick with DRIVER_OK somehow.

> and in absence of config interrupts is generally easily
> fixed just by sticking virtio_device_ready early in initialization.

So if the kick is done before the subsystem registration, there's
still a window in the middle (assuming we stick virtio_device_ready()
early):

virtio_device_ready()
virtqueue_kick()
/* the window */
subsystem_registration()

And during remove(), we get another window:

subsysrem_unregistration()
/* the window */
virtio_device_reset()

if we do reset before, we may end up with other issues like deadlock.

So I think it's probably very hard to fix issues only at the virtio
core since we need subsystem specific knowledge to make sure
everything is synchronized.

> With the current approach one has to *also* not do virtio_device_ready
> too early - and it's really tricky.

Not sure how much we differ here, during the probe driver can just
place the virtio_device_ready() after the kick.

>
> With the proposal I think that we don't need to fix all drivers and
> in my eyes that is a huge advantage because frankly I'm fine with
> more work on strict spec compliance taking more than expected
> but I would like the hardening work to finally be done.

Ok, but what I meant is, with your proposal if a buggy drive kicks
before DRIVER_OK, it suppresses the effect of hardening?

> I am not sure the amount of effort expended on the hardening here is
> proportionate to the benefit it provides.

Probably, but we received those bug reports from the confidential
computing guys.

Or can we choose to go another way, let the kconfig option enabled for
TDX/SEV, and then fix the bugs only if it is reported?

>
>
>
> > >
> > > need to think about the reset path - it already synchronizes callbacks
> > > and already can lose interrupts so we just need to clear vq->kicked
> > > before that, right?
> >
> > Probably.
> >
> > >
> > >
> > > > 2) seems require more work in the IRQ core and it can not work for all
> > > > transports (e.g vDPA would be kind of difficult)
> > > >
> > > > Thanks
> > >
> > > Hmm I don't really get why would it be difficult.
> > > VDPA is mostly PCI isn't it? With PCI both level INT#x and edge MSI
> > > have interrupt masking support.
> >
> > Yes, but consider the case of mlx5_vdpa, PCI stuff was hidden under
> > the auxiliary bus. And that is the way another vendor will go.
> >
> > Thanks
>
> A bunch of callbacks will do it I guess.

Possible but looks like a layer violation, I think auxiliary stuff
wants to hide the underlayer architecture. That is why I tend to do it
in the virtio core. And actually, transport is freed to implement
another layer of those synchronization if it wants.

Thanks

>
> > >
> > >
> > > > >
> > > > >
> > > > > > >
> > > > > > >
> > > > > > > > ---
> > > > > > > > Changes since V2:
> > > > > > > > - Tweak the Kconfig help
> > > > > > > > - Add comment for the read_lock() pairing in virtio_ccw
> > > > > > > > ---
> > > > > > > >  drivers/s390/virtio/virtio_ccw.c |  9 ++++++++-
> > > > > > > >  drivers/virtio/Kconfig           | 13 +++++++++++++
> > > > > > > >  drivers/virtio/virtio.c          |  2 ++
> > > > > > > >  drivers/virtio/virtio_ring.c     | 12 ++++++++++++
> > > > > > > >  include/linux/virtio_config.h    |  2 ++
> > > > > > > >  5 files changed, 37 insertions(+), 1 deletion(-)
> > > > > > > >
> > > > > > > > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> > > > > > > > index 97e51c34e6cf..1f6a358f65f0 100644
> > > > > > > > --- a/drivers/s390/virtio/virtio_ccw.c
> > > > > > > > +++ b/drivers/s390/virtio/virtio_ccw.c
> > > > > > > > @@ -1136,8 +1136,13 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
> > > > > > > >                       vcdev->err = -EIO;
> > > > > > > >       }
> > > > > > > >       virtio_ccw_check_activity(vcdev, activity);
> > > > > > > > -     /* Interrupts are disabled here */
> > > > > > > > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > > > > > > > +     /*
> > > > > > > > +      * Paried with virtio_ccw_synchronize_cbs() and interrupts are
> > > > > > > > +      * disabled here.
> > > > > > > > +      */
> > > > > > > >       read_lock(&vcdev->irq_lock);
> > > > > > > > +#endif
> > > > > > > >       for_each_set_bit(i, indicators(vcdev),
> > > > > > > >                        sizeof(*indicators(vcdev)) * BITS_PER_BYTE) {
> > > > > > > >               /* The bit clear must happen before the vring kick. */
> > > > > > > > @@ -1146,7 +1151,9 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
> > > > > > > >               vq = virtio_ccw_vq_by_ind(vcdev, i);
> > > > > > > >               vring_interrupt(0, vq);
> > > > > > > >       }
> > > > > > > > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > > > > > > >       read_unlock(&vcdev->irq_lock);
> > > > > > > > +#endif
> > > > > > > >       if (test_bit(0, indicators2(vcdev))) {
> > > > > > > >               virtio_config_changed(&vcdev->vdev);
> > > > > > > >               clear_bit(0, indicators2(vcdev));
> > > > > > > > diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> > > > > > > > index b5adf6abd241..c04f370a1e5c 100644
> > > > > > > > --- a/drivers/virtio/Kconfig
> > > > > > > > +++ b/drivers/virtio/Kconfig
> > > > > > > > @@ -35,6 +35,19 @@ menuconfig VIRTIO_MENU
> > > > > > > >
> > > > > > > >  if VIRTIO_MENU
> > > > > > > >
> > > > > > > > +config VIRTIO_HARDEN_NOTIFICATION
> > > > > > > > +        bool "Harden virtio notification"
> > > > > > > > +        help
> > > > > > > > +          Enable this to harden the device notifications and suppress
> > > > > > > > +          those that happen at a time where notifications are illegal.
> > > > > > > > +
> > > > > > > > +          Experimental: Note that several drivers still have bugs that
> > > > > > > > +          may cause crashes or hangs when correct handling of
> > > > > > > > +          notifications is enforced; depending on the subset of
> > > > > > > > +          drivers and devices you use, this may or may not work.
> > > > > > > > +
> > > > > > > > +          If unsure, say N.
> > > > > > > > +
> > > > > > > >  config VIRTIO_PCI
> > > > > > > >       tristate "PCI driver for virtio devices"
> > > > > > > >       depends on PCI
> > > > > > > > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> > > > > > > > index ef04a96942bf..21dc08d2f32d 100644
> > > > > > > > --- a/drivers/virtio/virtio.c
> > > > > > > > +++ b/drivers/virtio/virtio.c
> > > > > > > > @@ -220,6 +220,7 @@ static int virtio_features_ok(struct virtio_device *dev)
> > > > > > > >   * */
> > > > > > > >  void virtio_reset_device(struct virtio_device *dev)
> > > > > > > >  {
> > > > > > > > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > > > > > > >       /*
> > > > > > > >        * The below virtio_synchronize_cbs() guarantees that any
> > > > > > > >        * interrupt for this line arriving after
> > > > > > > > @@ -228,6 +229,7 @@ void virtio_reset_device(struct virtio_device *dev)
> > > > > > > >        */
> > > > > > > >       virtio_break_device(dev);
> > > > > > > >       virtio_synchronize_cbs(dev);
> > > > > > > > +#endif
> > > > > > > >
> > > > > > > >       dev->config->reset(dev);
> > > > > > > >  }
> > > > > > > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > > > > > > > index 13a7348cedff..d9d3b6e201fb 100644
> > > > > > > > --- a/drivers/virtio/virtio_ring.c
> > > > > > > > +++ b/drivers/virtio/virtio_ring.c
> > > > > > > > @@ -1688,7 +1688,11 @@ static struct virtqueue *vring_create_virtqueue_packed(
> > > > > > > >       vq->we_own_ring = true;
> > > > > > > >       vq->notify = notify;
> > > > > > > >       vq->weak_barriers = weak_barriers;
> > > > > > > > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > > > > > > >       vq->broken = true;
> > > > > > > > +#else
> > > > > > > > +     vq->broken = false;
> > > > > > > > +#endif
> > > > > > > >       vq->last_used_idx = 0;
> > > > > > > >       vq->event_triggered = false;
> > > > > > > >       vq->num_added = 0;
> > > > > > > > @@ -2135,9 +2139,13 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
> > > > > > > >       }
> > > > > > > >
> > > > > > > >       if (unlikely(vq->broken)) {
> > > > > > > > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > > > > > > >               dev_warn_once(&vq->vq.vdev->dev,
> > > > > > > >                             "virtio vring IRQ raised before DRIVER_OK");
> > > > > > > >               return IRQ_NONE;
> > > > > > > > +#else
> > > > > > > > +             return IRQ_HANDLED;
> > > > > > > > +#endif
> > > > > > > >       }
> > > > > > > >
> > > > > > > >       /* Just a hint for performance: so it's ok that this can be racy! */
> > > > > > > > @@ -2180,7 +2188,11 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
> > > > > > > >       vq->we_own_ring = false;
> > > > > > > >       vq->notify = notify;
> > > > > > > >       vq->weak_barriers = weak_barriers;
> > > > > > > > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > > > > > > >       vq->broken = true;
> > > > > > > > +#else
> > > > > > > > +     vq->broken = false;
> > > > > > > > +#endif
> > > > > > > >       vq->last_used_idx = 0;
> > > > > > > >       vq->event_triggered = false;
> > > > > > > >       vq->num_added = 0;
> > > > > > > > diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> > > > > > > > index 9a36051ceb76..d15c3cdda2d2 100644
> > > > > > > > --- a/include/linux/virtio_config.h
> > > > > > > > +++ b/include/linux/virtio_config.h
> > > > > > > > @@ -257,6 +257,7 @@ void virtio_device_ready(struct virtio_device *dev)
> > > > > > > >
> > > > > > > >       WARN_ON(status & VIRTIO_CONFIG_S_DRIVER_OK);
> > > > > > > >
> > > > > > > > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > > > > > > >       /*
> > > > > > > >        * The virtio_synchronize_cbs() makes sure vring_interrupt()
> > > > > > > >        * will see the driver specific setup if it sees vq->broken
> > > > > > > > @@ -264,6 +265,7 @@ void virtio_device_ready(struct virtio_device *dev)
> > > > > > > >        */
> > > > > > > >       virtio_synchronize_cbs(dev);
> > > > > > > >       __virtio_unbreak_device(dev);
> > > > > > > > +#endif
> > > > > > > >       /*
> > > > > > > >        * The transport should ensure the visibility of vq->broken
> > > > > > > >        * before setting DRIVER_OK. See the comments for the transport
> > > > > > > > --
> > > > > > > > 2.25.1
> > > > > > >
> > > > >
> > >
>

