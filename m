Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8D3A55FAA7
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 10:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbiF2Ie6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 04:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232563AbiF2Ie4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 04:34:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6D183B3F8
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 01:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656491694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uQ1F1gvPgdv/PjO5a7Us1uAB+fd+j8i7Rmby0EI/UmM=;
        b=ZuC6hIFxs5gOTwXpXd4mXLBr3h4IcaQdD+AysCEPSAxpZj1sE/a9d85GoCFvRWO0qhOF9x
        +ewvuwwD97N0eAqMsNb3V5zmMV1y1nugpKQT2KT0EbVUuMTQdQI/CtaYRhlesKUs9QGzd4
        xRUbuhc0vTeY1IuTma/U3uDzzVhVzrY=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-2IZ64Rq3MuaK1gkHcSTnRQ-1; Wed, 29 Jun 2022 04:34:50 -0400
X-MC-Unique: 2IZ64Rq3MuaK1gkHcSTnRQ-1
Received: by mail-lj1-f197.google.com with SMTP id k6-20020a2e9206000000b0025a8ce1a22eso2087602ljg.9
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 01:34:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uQ1F1gvPgdv/PjO5a7Us1uAB+fd+j8i7Rmby0EI/UmM=;
        b=WEP7GMqSXts4//PmWpaLDMuUchjih4Ha6ffekpLZmH5MLQ/0zD933j5cLDCLD15/ls
         YKrNNOzed6PKRFjg0yob7I0Gi+81e9Q/1+97Tggth8wceLGtFqTPxoAw/7mTsE+X9JLL
         Z0rj1L9yR6W6ptr1nq4mEMpl9OYKXE4ayUaH9SQPpjFTxzln2wh0oEyZfqqbfS0N7LBI
         VltHuasDtwlcEMMKYsWpnsKXST0xa3MRcxJQLXHdq03MyP7a+i01KWaehPrc5v2sNcwk
         pWWPOVETTNcmQuXZUZfbpVaRhE7/HQIr1Zgas/llNp4PinFuGYusxOtPK0zkH/dvHdSp
         /Ulg==
X-Gm-Message-State: AJIora8KhPo0hKZ2x77IjYdvEEDjGYLYSVC+50USHts3d6DIXCjQon5o
        wikOlo7HBEfwLVnEYxsQNhJuuJukKaNuBRAO5gsADNSjYHBMcrbJqHKgw4NVjYSYF5CVfa5Rybt
        0U0ZMHcBs4DphtYc3iY/LCpK1dlxK
X-Received: by 2002:a2e:aaa5:0:b0:25b:ae57:4ad7 with SMTP id bj37-20020a2eaaa5000000b0025bae574ad7mr1062683ljb.323.1656491688553;
        Wed, 29 Jun 2022 01:34:48 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tj3mTezqE26Ub1hg4KnGKyN1R4dLBdYBw/oW4sihfiyNn6+28TEvxAhIEfmZcYsBQyr9V7tEc2W8R79JvvvZI=
X-Received: by 2002:a2e:aaa5:0:b0:25b:ae57:4ad7 with SMTP id
 bj37-20020a2eaaa5000000b0025bae574ad7mr1062675ljb.323.1656491688283; Wed, 29
 Jun 2022 01:34:48 -0700 (PDT)
MIME-Version: 1.0
References: <CACGkMEuurobpUWmDL8zmZ6T6Ygc0OEMx6vx2EDCSoGNnZQ0r-w@mail.gmail.com>
 <20220627024049-mutt-send-email-mst@kernel.org> <CACGkMEvrDXDN7FH1vKoYCob2rkxUsctE_=g61kzHSZ8tNNr6vA@mail.gmail.com>
 <20220627053820-mutt-send-email-mst@kernel.org> <CACGkMEvcs+9_SHmO1s3nyzgU7oq7jhU2gircVVR3KDsGDikh5Q@mail.gmail.com>
 <20220628004614-mutt-send-email-mst@kernel.org> <CACGkMEsC4A+3WejLSOZoH3enXtai=+JyRNbxcpzK4vODYzhaFw@mail.gmail.com>
 <CACGkMEvu0D0XD7udz0ebVjNM0h5+K9Rjd-5ed=PY_+-aduzG2g@mail.gmail.com>
 <20220629022223-mutt-send-email-mst@kernel.org> <CACGkMEuwvzkbPUSFueCOjit7pRJ81v3-W3SZD+7jQJN8btEFdg@mail.gmail.com>
 <20220629030600-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220629030600-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 29 Jun 2022 16:34:36 +0800
Message-ID: <CACGkMEvnUj622FyROUftifSB47wytPg0YAdVO7fdRQmCE+WuBg@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 29, 2022 at 3:15 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Jun 29, 2022 at 03:02:21PM +0800, Jason Wang wrote:
> > On Wed, Jun 29, 2022 at 2:31 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Wed, Jun 29, 2022 at 12:07:11PM +0800, Jason Wang wrote:
> > > > On Tue, Jun 28, 2022 at 2:17 PM Jason Wang <jasowang@redhat.com> wrote:
> > > > >
> > > > > On Tue, Jun 28, 2022 at 1:00 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Tue, Jun 28, 2022 at 11:49:12AM +0800, Jason Wang wrote:
> > > > > > > > Heh. Yea sure. But things work fine for people. What is the chance
> > > > > > > > your review found and fixed all driver bugs?
> > > > > > >
> > > > > > > I don't/can't audit all bugs but the race between open/close against
> > > > > > > ready/reset. It looks to me a good chance to fix them all but if you
> > > > > > > think differently, let me know
> > > > > > >
> > > > > > > > After two attempts
> > > > > > > > I don't feel like hoping audit will fix all bugs.
> > > > > > >
> > > > > > > I've started the auditing and have 15+ patches in the queue. (only
> > > > > > > covers bluetooth, console, pmem, virtio-net and caif). Spotting the
> > > > > > > issue is not hard but the testing, It would take at least the time of
> > > > > > > one release to finalize I guess.
> > > > > >
> > > > > > Absolutely. So I am looking for a way to implement hardening that does
> > > > > > not break existing drivers.
> > > > >
> > > > > I totally agree with you to seek a way without bothering the drivers.
> > > > > Just wonder if this is possbile.
> > > > >
> > > > > >
> > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > > >
> > > > > > > > > > The reason config was kind of easy is that config interrupt is rarely
> > > > > > > > > > vital for device function so arbitrarily deferring that does not lead to
> > > > > > > > > > deadlocks - what you are trying to do with VQ interrupts is
> > > > > > > > > > fundamentally different. Things are especially bad if we just drop
> > > > > > > > > > an interrupt but deferring can lead to problems too.
> > > > > > > > >
> > > > > > > > > I'm not sure I see the difference, disable_irq() stuffs also delay the
> > > > > > > > > interrupt processing until enable_irq().
> > > > > > > >
> > > > > > > >
> > > > > > > > Absolutely. I am not at all sure disable_irq fixes all problems.
> > > > > > > >
> > > > > > > > > >
> > > > > > > > > > Consider as an example
> > > > > > > > > >     virtio-net: fix race between ndo_open() and virtio_device_ready()
> > > > > > > > > > if you just defer vq interrupts you get deadlocks.
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > I don't see a deadlock here, maybe you can show more detail on this?
> > > > > > > >
> > > > > > > > What I mean is this: if we revert the above commit, things still
> > > > > > > > work (out of spec, but still). If we revert and defer interrupts until
> > > > > > > > device ready then ndo_open that triggers before device ready deadlocks.
> > > > > > >
> > > > > > > Ok, I guess you meant on a hypervisor that is strictly written with spec.
> > > > > >
> > > > > > I mean on hypervisor that starts processing queues after getting a kick
> > > > > > even without DRIVER_OK.
> > > > >
> > > > > Oh right.
> > > > >
> > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > > >
> > > > > > > > > > So, thinking about all this, how about a simple per vq flag meaning
> > > > > > > > > > "this vq was kicked since reset"?
> > > > > > > > >
> > > > > > > > > And ignore the notification if vq is not kicked? It sounds like the
> > > > > > > > > callback needs to be synchronized with the kick.
> > > > > > > >
> > > > > > > > Note we only need to synchronize it when it changes, which is
> > > > > > > > only during initialization and reset.
> > > > > > >
> > > > > > > Yes.
> > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > > >
> > > > > > > > > > If driver does not kick then it's not ready to get callbacks, right?
> > > > > > > > > >
> > > > > > > > > > Sounds quite clean, but we need to think through memory ordering
> > > > > > > > > > concerns - I guess it's only when we change the value so
> > > > > > > > > >         if (!vq->kicked) {
> > > > > > > > > >                 vq->kicked = true;
> > > > > > > > > >                 mb();
> > > > > > > > > >         }
> > > > > > > > > >
> > > > > > > > > > will do the trick, right?
> > > > > > > > >
> > > > > > > > > There's no much difference with the existing approach:
> > > > > > > > >
> > > > > > > > > 1) your proposal implicitly makes callbacks ready in virtqueue_kick()
> > > > > > > > > 2) my proposal explicitly makes callbacks ready via virtio_device_ready()
> > > > > > > > >
> > > > > > > > > Both require careful auditing of all the existing drivers to make sure
> > > > > > > > > no kick before DRIVER_OK.
> > > > > > > >
> > > > > > > > Jason, kick before DRIVER_OK is out of spec, sure. But it is unrelated
> > > > > > > > to hardening
> > > > > > >
> > > > > > > Yes but with your proposal, it seems to couple kick with DRIVER_OK somehow.
> > > > > >
> > > > > > I don't see how - my proposal ignores DRIVER_OK issues.
> > > > >
> > > > > Yes, what I meant is, in your proposal, the first kick after rest is a
> > > > > hint that the driver is ok (but actually it could not).
> > > > >
> > > > > >
> > > > > > > > and in absence of config interrupts is generally easily
> > > > > > > > fixed just by sticking virtio_device_ready early in initialization.
> > > > > > >
> > > > > > > So if the kick is done before the subsystem registration, there's
> > > > > > > still a window in the middle (assuming we stick virtio_device_ready()
> > > > > > > early):
> > > > > > >
> > > > > > > virtio_device_ready()
> > > > > > > virtqueue_kick()
> > > > > > > /* the window */
> > > > > > > subsystem_registration()
> > > > > >
> > > > > > Absolutely, however, I do not think we really have many such drivers
> > > > > > since this has been known as a wrong thing to do since the beginning.
> > > > > > Want to try to find any?
> > > > >
> > > > > Yes, let me try and update.
> > > >
> > > > This is basically the device that have an RX queue, so I've found the
> > > > following drivers:
> > > >
> > > > scmi, mac80211_hwsim, vsock, bt, balloon.
> > >
> > > Looked and I don't see it yet. Let's consider
> > > ./net/vmw_vsock/virtio_transport.c for example. Assuming we block
> > > callbacks until the first kick, what is the issue with probe exactly?
> >
> > We need to make sure the callback can survive when it runs before sub
> > system registration.
>
> With my proposal no - only if we also kick before registration.
> So I do not see the issue yet.
>
> Consider ./net/vmw_vsock/virtio_transport.c
>
> kicks: virtio_transport_send_pkt_work,
> virtio_vsock_rx_fill, virtio_vsock_event_fill
>
> which of these triggers before we are ready to
> handle callbacks?

So:

virtio_vsock_vqs_init()
    virtio_device_ready()
    virtio_vsock_rx_fill() /* kick there */
rcu_assign_pointer(the_virtio_vsock, vsock)

It means at least virtio_vsock_rx_done()/virtio_vsock_workqueue needs
to survive. I don't say it has a bug but we do need to audit the code
in this case. The implication is: the virtqueue callback should be
written with no assumption that the driver has registered in the
subsystem. We don't or can't assume all drivers are written in this
way.

>
>
> > >
> > >
> > > > >
> > > > > >I couldn't ... except maybe bluetooth
> > > > > > but that's just maintainer nacking fixes saying he'll fix it
> > > > > > his way ...
> > > > > >
> > > > > > > And during remove(), we get another window:
> > > > > > >
> > > > > > > subsysrem_unregistration()
> > > > > > > /* the window */
> > > > > > > virtio_device_reset()
> > > > > >
> > > > > > Same here.
> > > >
> > > > Basically for the drivers that set driver_ok before registration,
> > >
> > > I don't see what does driver_ok have to do with it.
> >
> > I meant for those driver, in probe they do()
> >
> > virtio_device_ready()
> > subsystem_register()
> >
> > In remove() they do
> >
> > subsystem_unregister()
> > virtio_device_reset()
> >
> > for symmetry
>
> Let's leave remove alone for now. I am close to 100% sure we have *lots*
> of issues around it, but while probe is unavoidable remove can be
> avoided by blocking hotplug.

Unbind can trigger this path as well.

>
>
> > >
> > > > so
> > > > we have a lot:
> > > >
> > > > blk, net, mac80211_hwsim, scsi, vsock, bt, crypto, gpio, gpu, i2c,
> > > > iommu, caif, pmem, input, mem
> > > >
> > > > So I think there's no easy way to harden the notification without
> > > > auditing the driver one by one (especially considering the driver may
> > > > use bh or workqueue). The problem is the notification hardening
> > > > depends on a correct or race-free probe/remove. So we need to fix the
> > > > issues in probe/remove then do the hardening on the notification.
> > > >
> > > > Thanks
> > >
> > > So if drivers kick but are not ready to get callbacks then let's fix
> > > that first of all, these are racy with existing qemu even ignoring
> > > spec compliance.
> >
> > Yes, (the patches I've posted so far exist even with a well-behaved device).
> >
> > Thanks
>
> patches you posted deal with DRIVER_OK spec compliance.
> I do not see patches for kicks before callbacks are ready to run.

Yes.

Thanks

>
> > >
> > >
> > > --
> > > MST
> > >
>

