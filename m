Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1468F564C66
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 06:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbiGDEXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 00:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiGDEXq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 00:23:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71A40637B
        for <kvm@vger.kernel.org>; Sun,  3 Jul 2022 21:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656908622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+J8IuHAZhOhtfoepU61GtbLI7yGU25GkINeJFONqQQ4=;
        b=EdKGh68pQoAOWjldS+MoPNKqzE3CJ1Vq7UVfDivFrOyte3uaMiJVwIrBg6vKgtYR6mpx91
        mP/bBu5HXROQVcZgbQRKQCn/0EJKaSPGPEA0SmfSrYO6Vz1Xdq3kyTtGeC/ZHJxO+npx0D
        kQDA0vZkBe5NlHqNV72eEBX5M9+ocps=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-6Quydlr8PieBSsaVkTcp7g-1; Mon, 04 Jul 2022 00:23:41 -0400
X-MC-Unique: 6Quydlr8PieBSsaVkTcp7g-1
Received: by mail-lf1-f69.google.com with SMTP id p36-20020a05651213a400b004779d806c13so2566198lfa.10
        for <kvm@vger.kernel.org>; Sun, 03 Jul 2022 21:23:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+J8IuHAZhOhtfoepU61GtbLI7yGU25GkINeJFONqQQ4=;
        b=eLUOujxTabEG7XTYcklC+5PnUbjHjHOri7wVdEG/NNcxDEWPBb0mblJIi2fW5USNN7
         mmZ+wNbeZMk2qIJyP+UcA+Q9XL69c0KG98WP3H+YMSh3E5sg/JurBpR9OZibP4/UMvYA
         zughSAMlxlR3mxdih/e0GzUsgPn8M6GBgVahzd1MIkaVKxNK0fipQeSInnrCmKkgZeux
         zYPZDURrWAMLgvddZX8XCiXSx6UvpGKTczq7Wk5XEpFz3y4deys//QEQNl/WKXq4aMsL
         wDDtKFpC4Xq27I/ipBdc+doTtDiRX8xo1Du9Otxnwi5S2Y/t+k/YRA2dg4Qs2WvVOBbG
         VvSg==
X-Gm-Message-State: AJIora8BohPCjG7vihlhGw+q2KoS0dWIS3JRXPbYBBMuNFOPdmRJgjKm
        d8T6LHSotXU8PMMhcBA3Pe3XPmWtQdaSl5BxD3EcZHAQ/XJ+ohG3y8xftt8xVlE8NwCsmXLKgYr
        ygLqYCKFgL6dEUYCk+LjL9fBDvDgR
X-Received: by 2002:a05:6512:ba1:b0:47f:c0bd:7105 with SMTP id b33-20020a0565120ba100b0047fc0bd7105mr18078553lfv.641.1656908619420;
        Sun, 03 Jul 2022 21:23:39 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tIwVGKJJeYrqmJGVSmhYb+DHitJW9HgIiZ+IwbzBFZB2scn5RmymiqDX9wjNPR3RTtrI1iPTO9zTMvobFtQ2w=
X-Received: by 2002:a05:6512:ba1:b0:47f:c0bd:7105 with SMTP id
 b33-20020a0565120ba100b0047fc0bd7105mr18078535lfv.641.1656908619056; Sun, 03
 Jul 2022 21:23:39 -0700 (PDT)
MIME-Version: 1.0
References: <CACGkMEvcs+9_SHmO1s3nyzgU7oq7jhU2gircVVR3KDsGDikh5Q@mail.gmail.com>
 <20220628004614-mutt-send-email-mst@kernel.org> <CACGkMEsC4A+3WejLSOZoH3enXtai=+JyRNbxcpzK4vODYzhaFw@mail.gmail.com>
 <CACGkMEvu0D0XD7udz0ebVjNM0h5+K9Rjd-5ed=PY_+-aduzG2g@mail.gmail.com>
 <20220629022223-mutt-send-email-mst@kernel.org> <CACGkMEuwvzkbPUSFueCOjit7pRJ81v3-W3SZD+7jQJN8btEFdg@mail.gmail.com>
 <20220629030600-mutt-send-email-mst@kernel.org> <CACGkMEvnUj622FyROUftifSB47wytPg0YAdVO7fdRQmCE+WuBg@mail.gmail.com>
 <20220629044514-mutt-send-email-mst@kernel.org> <CACGkMEsW02a1LeiWwUgHfVmDEnC8i49h1L7qHmeoLyJyRS6-zA@mail.gmail.com>
 <20220630043219-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220630043219-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 4 Jul 2022 12:23:27 +0800
Message-ID: <CACGkMEtgnHDEUOHQxqUFn2ngOpUGcVu4NSQBqfYYZRMPA2H2LQ@mail.gmail.com>
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
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 30, 2022 at 4:38 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, Jun 30, 2022 at 10:01:16AM +0800, Jason Wang wrote:
> > On Wed, Jun 29, 2022 at 4:52 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Wed, Jun 29, 2022 at 04:34:36PM +0800, Jason Wang wrote:
> > > > On Wed, Jun 29, 2022 at 3:15 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > >
> > > > > On Wed, Jun 29, 2022 at 03:02:21PM +0800, Jason Wang wrote:
> > > > > > On Wed, Jun 29, 2022 at 2:31 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > >
> > > > > > > On Wed, Jun 29, 2022 at 12:07:11PM +0800, Jason Wang wrote:
> > > > > > > > On Tue, Jun 28, 2022 at 2:17 PM Jason Wang <jasowang@redhat.com> wrote:
> > > > > > > > >
> > > > > > > > > On Tue, Jun 28, 2022 at 1:00 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > > >
> > > > > > > > > > On Tue, Jun 28, 2022 at 11:49:12AM +0800, Jason Wang wrote:
> > > > > > > > > > > > Heh. Yea sure. But things work fine for people. What is the chance
> > > > > > > > > > > > your review found and fixed all driver bugs?
> > > > > > > > > > >
> > > > > > > > > > > I don't/can't audit all bugs but the race between open/close against
> > > > > > > > > > > ready/reset. It looks to me a good chance to fix them all but if you
> > > > > > > > > > > think differently, let me know
> > > > > > > > > > >
> > > > > > > > > > > > After two attempts
> > > > > > > > > > > > I don't feel like hoping audit will fix all bugs.
> > > > > > > > > > >
> > > > > > > > > > > I've started the auditing and have 15+ patches in the queue. (only
> > > > > > > > > > > covers bluetooth, console, pmem, virtio-net and caif). Spotting the
> > > > > > > > > > > issue is not hard but the testing, It would take at least the time of
> > > > > > > > > > > one release to finalize I guess.
> > > > > > > > > >
> > > > > > > > > > Absolutely. So I am looking for a way to implement hardening that does
> > > > > > > > > > not break existing drivers.
> > > > > > > > >
> > > > > > > > > I totally agree with you to seek a way without bothering the drivers.
> > > > > > > > > Just wonder if this is possbile.
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > The reason config was kind of easy is that config interrupt is rarely
> > > > > > > > > > > > > > vital for device function so arbitrarily deferring that does not lead to
> > > > > > > > > > > > > > deadlocks - what you are trying to do with VQ interrupts is
> > > > > > > > > > > > > > fundamentally different. Things are especially bad if we just drop
> > > > > > > > > > > > > > an interrupt but deferring can lead to problems too.
> > > > > > > > > > > > >
> > > > > > > > > > > > > I'm not sure I see the difference, disable_irq() stuffs also delay the
> > > > > > > > > > > > > interrupt processing until enable_irq().
> > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > Absolutely. I am not at all sure disable_irq fixes all problems.
> > > > > > > > > > > >
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > Consider as an example
> > > > > > > > > > > > > >     virtio-net: fix race between ndo_open() and virtio_device_ready()
> > > > > > > > > > > > > > if you just defer vq interrupts you get deadlocks.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > >
> > > > > > > > > > > > >
> > > > > > > > > > > > > I don't see a deadlock here, maybe you can show more detail on this?
> > > > > > > > > > > >
> > > > > > > > > > > > What I mean is this: if we revert the above commit, things still
> > > > > > > > > > > > work (out of spec, but still). If we revert and defer interrupts until
> > > > > > > > > > > > device ready then ndo_open that triggers before device ready deadlocks.
> > > > > > > > > > >
> > > > > > > > > > > Ok, I guess you meant on a hypervisor that is strictly written with spec.
> > > > > > > > > >
> > > > > > > > > > I mean on hypervisor that starts processing queues after getting a kick
> > > > > > > > > > even without DRIVER_OK.
> > > > > > > > >
> > > > > > > > > Oh right.
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > So, thinking about all this, how about a simple per vq flag meaning
> > > > > > > > > > > > > > "this vq was kicked since reset"?
> > > > > > > > > > > > >
> > > > > > > > > > > > > And ignore the notification if vq is not kicked? It sounds like the
> > > > > > > > > > > > > callback needs to be synchronized with the kick.
> > > > > > > > > > > >
> > > > > > > > > > > > Note we only need to synchronize it when it changes, which is
> > > > > > > > > > > > only during initialization and reset.
> > > > > > > > > > >
> > > > > > > > > > > Yes.
> > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > If driver does not kick then it's not ready to get callbacks, right?
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > Sounds quite clean, but we need to think through memory ordering
> > > > > > > > > > > > > > concerns - I guess it's only when we change the value so
> > > > > > > > > > > > > >         if (!vq->kicked) {
> > > > > > > > > > > > > >                 vq->kicked = true;
> > > > > > > > > > > > > >                 mb();
> > > > > > > > > > > > > >         }
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > will do the trick, right?
> > > > > > > > > > > > >
> > > > > > > > > > > > > There's no much difference with the existing approach:
> > > > > > > > > > > > >
> > > > > > > > > > > > > 1) your proposal implicitly makes callbacks ready in virtqueue_kick()
> > > > > > > > > > > > > 2) my proposal explicitly makes callbacks ready via virtio_device_ready()
> > > > > > > > > > > > >
> > > > > > > > > > > > > Both require careful auditing of all the existing drivers to make sure
> > > > > > > > > > > > > no kick before DRIVER_OK.
> > > > > > > > > > > >
> > > > > > > > > > > > Jason, kick before DRIVER_OK is out of spec, sure. But it is unrelated
> > > > > > > > > > > > to hardening
> > > > > > > > > > >
> > > > > > > > > > > Yes but with your proposal, it seems to couple kick with DRIVER_OK somehow.
> > > > > > > > > >
> > > > > > > > > > I don't see how - my proposal ignores DRIVER_OK issues.
> > > > > > > > >
> > > > > > > > > Yes, what I meant is, in your proposal, the first kick after rest is a
> > > > > > > > > hint that the driver is ok (but actually it could not).
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > > > and in absence of config interrupts is generally easily
> > > > > > > > > > > > fixed just by sticking virtio_device_ready early in initialization.
> > > > > > > > > > >
> > > > > > > > > > > So if the kick is done before the subsystem registration, there's
> > > > > > > > > > > still a window in the middle (assuming we stick virtio_device_ready()
> > > > > > > > > > > early):
> > > > > > > > > > >
> > > > > > > > > > > virtio_device_ready()
> > > > > > > > > > > virtqueue_kick()
> > > > > > > > > > > /* the window */
> > > > > > > > > > > subsystem_registration()
> > > > > > > > > >
> > > > > > > > > > Absolutely, however, I do not think we really have many such drivers
> > > > > > > > > > since this has been known as a wrong thing to do since the beginning.
> > > > > > > > > > Want to try to find any?
> > > > > > > > >
> > > > > > > > > Yes, let me try and update.
> > > > > > > >
> > > > > > > > This is basically the device that have an RX queue, so I've found the
> > > > > > > > following drivers:
> > > > > > > >
> > > > > > > > scmi, mac80211_hwsim, vsock, bt, balloon.
> > > > > > >
> > > > > > > Looked and I don't see it yet. Let's consider
> > > > > > > ./net/vmw_vsock/virtio_transport.c for example. Assuming we block
> > > > > > > callbacks until the first kick, what is the issue with probe exactly?
> > > > > >
> > > > > > We need to make sure the callback can survive when it runs before sub
> > > > > > system registration.
> > > > >
> > > > > With my proposal no - only if we also kick before registration.
> > > > > So I do not see the issue yet.
> > > > >
> > > > > Consider ./net/vmw_vsock/virtio_transport.c
> > > > >
> > > > > kicks: virtio_transport_send_pkt_work,
> > > > > virtio_vsock_rx_fill, virtio_vsock_event_fill
> > > > >
> > > > > which of these triggers before we are ready to
> > > > > handle callbacks?
> > > >
> > > > So:
> > > >
> > > > virtio_vsock_vqs_init()
> > > >     virtio_device_ready()
> > > >     virtio_vsock_rx_fill() /* kick there */
> > > > rcu_assign_pointer(the_virtio_vsock, vsock)
> > > >
> > > > It means at least virtio_vsock_rx_done()/virtio_vsock_workqueue needs
> > > > to survive. I don't say it has a bug but we do need to audit the code
> > > > in this case. The implication is: the virtqueue callback should be
> > > > written with no assumption that the driver has registered in the
> > > > subsystem. We don't or can't assume all drivers are written in this
> > > > way.
> > >
> > >
> > > I thought you said you audited code and found bugs.
> > >
> > > My claim is that simply because qemu starts processing
> > > packets immediately upon kick, if bugs like this
> > > existed we would have noticed by now.
> >
> > This is true for a well behaved hypervisor. But what we want to deal
> > with is the buggy/malicious hypervisors.
>
>
>
>
> > >
> > > In this case the_virtio_vsock is used for xmit things,
> > > callbacks do not seem to use it at all.
> >
> > So the hypervisor can trigger the notification just after the kick and
> > the work function seems to be safe.
> >
> > One another example for this is in virtcons_probe():
> >
> >         spin_lock_init(&portdev->ports_lock);
> >         INIT_LIST_HEAD(&portdev->ports);
> >         INIT_LIST_HEAD(&portdev->list);
> >
> >         virtio_device_ready(portdev->vdev);
> >
> >         INIT_WORK(&portdev->config_work, &config_work_handler);
> >         INIT_WORK(&portdev->control_work, &control_work_handler);
> >
> > in control_intr() we had:
> >
> > static void control_intr(struct virtqueue *vq)
> > {
> >         struct ports_device *portdev;
> >
> >         portdev = vq->vdev->priv;
> >         schedule_work(&portdev->control_work);
> > }
> >
> > So we might crash if the notification is raised just after
> > virtio_device_ready().
>
> Yes! But this is not my proposal. This is yours.
> Your patches block interrupts until virtio_device_ready.
>
> My proposal is to block them until kick.
>
> In this case kick is in fill_queue after INIT_WORK.

Yes.

>
>
> > This is not an exact example of when a callback is not ready after
> > kick, but it demonstrates that the callback could have assumed that
> > all setup has been done when it is called.
> >
> > Thanks
>
> So if there are not examples of callbacks not ready after kick
> then let us block callbacks until first kick. That is my idea.

Ok, let me try. I need to drain my queue of fixes first.

Thanks

>
>
> > >
> > > > >
> > > > >
> > > > > > >
> > > > > > >
> > > > > > > > >
> > > > > > > > > >I couldn't ... except maybe bluetooth
> > > > > > > > > > but that's just maintainer nacking fixes saying he'll fix it
> > > > > > > > > > his way ...
> > > > > > > > > >
> > > > > > > > > > > And during remove(), we get another window:
> > > > > > > > > > >
> > > > > > > > > > > subsysrem_unregistration()
> > > > > > > > > > > /* the window */
> > > > > > > > > > > virtio_device_reset()
> > > > > > > > > >
> > > > > > > > > > Same here.
> > > > > > > >
> > > > > > > > Basically for the drivers that set driver_ok before registration,
> > > > > > >
> > > > > > > I don't see what does driver_ok have to do with it.
> > > > > >
> > > > > > I meant for those driver, in probe they do()
> > > > > >
> > > > > > virtio_device_ready()
> > > > > > subsystem_register()
> > > > > >
> > > > > > In remove() they do
> > > > > >
> > > > > > subsystem_unregister()
> > > > > > virtio_device_reset()
> > > > > >
> > > > > > for symmetry
> > > > >
> > > > > Let's leave remove alone for now. I am close to 100% sure we have *lots*
> > > > > of issues around it, but while probe is unavoidable remove can be
> > > > > avoided by blocking hotplug.
> > > >
> > > > Unbind can trigger this path as well.
> > > >
> > > > >
> > > > >
> > > > > > >
> > > > > > > > so
> > > > > > > > we have a lot:
> > > > > > > >
> > > > > > > > blk, net, mac80211_hwsim, scsi, vsock, bt, crypto, gpio, gpu, i2c,
> > > > > > > > iommu, caif, pmem, input, mem
> > > > > > > >
> > > > > > > > So I think there's no easy way to harden the notification without
> > > > > > > > auditing the driver one by one (especially considering the driver may
> > > > > > > > use bh or workqueue). The problem is the notification hardening
> > > > > > > > depends on a correct or race-free probe/remove. So we need to fix the
> > > > > > > > issues in probe/remove then do the hardening on the notification.
> > > > > > > >
> > > > > > > > Thanks
> > > > > > >
> > > > > > > So if drivers kick but are not ready to get callbacks then let's fix
> > > > > > > that first of all, these are racy with existing qemu even ignoring
> > > > > > > spec compliance.
> > > > > >
> > > > > > Yes, (the patches I've posted so far exist even with a well-behaved device).
> > > > > >
> > > > > > Thanks
> > > > >
> > > > > patches you posted deal with DRIVER_OK spec compliance.
> > > > > I do not see patches for kicks before callbacks are ready to run.
> > > >
> > > > Yes.
> > > >
> > > > Thanks
> > > >
> > > > >
> > > > > > >
> > > > > > >
> > > > > > > --
> > > > > > > MST
> > > > > > >
> > > > >
> > >
>

