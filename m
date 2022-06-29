Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E5755F877
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 09:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbiF2HEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 03:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232824AbiF2HEb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 03:04:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3BB493E0C0
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 00:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656486156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zdxtwKfDBaNyVyUEwFBhab9Yx2tZ8QjJF8+weaWqn/c=;
        b=ToTgXsZS671YGgIzo+dcwgyXjCHiPS+ugvC+cbTvhnwvAGl+DpoCnYKBp/5Fr1vWgYf27B
        oepz9xz9Sga5A3LWz4y/cu4Zbw3GJzNqTBZF09G3gZz7aEIoA4dLYeqaix2OhaPEzx90ad
        9S4WNyiOYuprCJwU2FZNqtUojhF4tW0=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-228-96LF4WrEMLGg5Yd4ygA4ZA-1; Wed, 29 Jun 2022 03:02:34 -0400
X-MC-Unique: 96LF4WrEMLGg5Yd4ygA4ZA-1
Received: by mail-lj1-f200.google.com with SMTP id be13-20020a05651c170d00b0025a917675dcso2028303ljb.0
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 00:02:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zdxtwKfDBaNyVyUEwFBhab9Yx2tZ8QjJF8+weaWqn/c=;
        b=HpdG2PDAFzHMfcZVxpZn0EjZngZjeERd40/lOe/Qxc3PpWUEsGeeFPbTxvcDYO3+dC
         ZephscIKKzoHJh2UCsy7C4y1CZfu8ibqJtqlHsWMeivZIdRhZs7eTe00sqtil2+H4b/F
         +36cfOP8gW4PWVK7s88QKe5c6uSlv/6HzLbz7j67TfCNuC5cckBy8m9xWPMwacGobTsc
         sAzfVyDxRm/94U6LKP+VBuJFd8UbnABPwEW9iGkMb79vmf9iyrUURGlKYZJlbYO4y7wM
         odcnZV9WFSStqI2ogdwpima/K4gYlRpt0vLeXu150+ejLr9a5btFINO6HhMxIFAv80td
         Jclw==
X-Gm-Message-State: AJIora/aDLgdtX7Gl6oOfy3H/hIBfdHJ+2hYnDMdxtnYQ9TIUkAA7j4v
        tOKQODq4K2b7r9CNpSUDnDwaGm6UpD6I1VsbTbmEzZ+vhLgn7h7A8/hnhsUM84rr+zk440h7Qf4
        w41vNaYfKLIkJm7VG6gLsAHpl9JFc
X-Received: by 2002:a05:6512:3b8e:b0:481:1a75:452 with SMTP id g14-20020a0565123b8e00b004811a750452mr1169823lfv.238.1656486152749;
        Wed, 29 Jun 2022 00:02:32 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vZYVJ8dgXlanmZRZNWXGOSQQbcBOcd+zGkkbRwdd51E4HcAcZqeVTN0dNu7SJ0sT6bRyeXCFd1XSnk5op1enA=
X-Received: by 2002:a05:6512:3b8e:b0:481:1a75:452 with SMTP id
 g14-20020a0565123b8e00b004811a750452mr1169793lfv.238.1656486152366; Wed, 29
 Jun 2022 00:02:32 -0700 (PDT)
MIME-Version: 1.0
References: <CACGkMEtJY2ioD0L8ifTrCPatG6-NqQ01V=d2L1FeoweKV74LaA@mail.gmail.com>
 <20220624022622-mutt-send-email-mst@kernel.org> <CACGkMEuurobpUWmDL8zmZ6T6Ygc0OEMx6vx2EDCSoGNnZQ0r-w@mail.gmail.com>
 <20220627024049-mutt-send-email-mst@kernel.org> <CACGkMEvrDXDN7FH1vKoYCob2rkxUsctE_=g61kzHSZ8tNNr6vA@mail.gmail.com>
 <20220627053820-mutt-send-email-mst@kernel.org> <CACGkMEvcs+9_SHmO1s3nyzgU7oq7jhU2gircVVR3KDsGDikh5Q@mail.gmail.com>
 <20220628004614-mutt-send-email-mst@kernel.org> <CACGkMEsC4A+3WejLSOZoH3enXtai=+JyRNbxcpzK4vODYzhaFw@mail.gmail.com>
 <CACGkMEvu0D0XD7udz0ebVjNM0h5+K9Rjd-5ed=PY_+-aduzG2g@mail.gmail.com> <20220629022223-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220629022223-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 29 Jun 2022 15:02:21 +0800
Message-ID: <CACGkMEuwvzkbPUSFueCOjit7pRJ81v3-W3SZD+7jQJN8btEFdg@mail.gmail.com>
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
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 29, 2022 at 2:31 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Jun 29, 2022 at 12:07:11PM +0800, Jason Wang wrote:
> > On Tue, Jun 28, 2022 at 2:17 PM Jason Wang <jasowang@redhat.com> wrote:
> > >
> > > On Tue, Jun 28, 2022 at 1:00 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Tue, Jun 28, 2022 at 11:49:12AM +0800, Jason Wang wrote:
> > > > > > Heh. Yea sure. But things work fine for people. What is the chance
> > > > > > your review found and fixed all driver bugs?
> > > > >
> > > > > I don't/can't audit all bugs but the race between open/close against
> > > > > ready/reset. It looks to me a good chance to fix them all but if you
> > > > > think differently, let me know
> > > > >
> > > > > > After two attempts
> > > > > > I don't feel like hoping audit will fix all bugs.
> > > > >
> > > > > I've started the auditing and have 15+ patches in the queue. (only
> > > > > covers bluetooth, console, pmem, virtio-net and caif). Spotting the
> > > > > issue is not hard but the testing, It would take at least the time of
> > > > > one release to finalize I guess.
> > > >
> > > > Absolutely. So I am looking for a way to implement hardening that does
> > > > not break existing drivers.
> > >
> > > I totally agree with you to seek a way without bothering the drivers.
> > > Just wonder if this is possbile.
> > >
> > > >
> > > >
> > > > > >
> > > > > >
> > > > > > > >
> > > > > > > > The reason config was kind of easy is that config interrupt is rarely
> > > > > > > > vital for device function so arbitrarily deferring that does not lead to
> > > > > > > > deadlocks - what you are trying to do with VQ interrupts is
> > > > > > > > fundamentally different. Things are especially bad if we just drop
> > > > > > > > an interrupt but deferring can lead to problems too.
> > > > > > >
> > > > > > > I'm not sure I see the difference, disable_irq() stuffs also delay the
> > > > > > > interrupt processing until enable_irq().
> > > > > >
> > > > > >
> > > > > > Absolutely. I am not at all sure disable_irq fixes all problems.
> > > > > >
> > > > > > > >
> > > > > > > > Consider as an example
> > > > > > > >     virtio-net: fix race between ndo_open() and virtio_device_ready()
> > > > > > > > if you just defer vq interrupts you get deadlocks.
> > > > > > > >
> > > > > > > >
> > > > > > >
> > > > > > > I don't see a deadlock here, maybe you can show more detail on this?
> > > > > >
> > > > > > What I mean is this: if we revert the above commit, things still
> > > > > > work (out of spec, but still). If we revert and defer interrupts until
> > > > > > device ready then ndo_open that triggers before device ready deadlocks.
> > > > >
> > > > > Ok, I guess you meant on a hypervisor that is strictly written with spec.
> > > >
> > > > I mean on hypervisor that starts processing queues after getting a kick
> > > > even without DRIVER_OK.
> > >
> > > Oh right.
> > >
> > > >
> > > > > >
> > > > > >
> > > > > > > >
> > > > > > > > So, thinking about all this, how about a simple per vq flag meaning
> > > > > > > > "this vq was kicked since reset"?
> > > > > > >
> > > > > > > And ignore the notification if vq is not kicked? It sounds like the
> > > > > > > callback needs to be synchronized with the kick.
> > > > > >
> > > > > > Note we only need to synchronize it when it changes, which is
> > > > > > only during initialization and reset.
> > > > >
> > > > > Yes.
> > > > >
> > > > > >
> > > > > >
> > > > > > > >
> > > > > > > > If driver does not kick then it's not ready to get callbacks, right?
> > > > > > > >
> > > > > > > > Sounds quite clean, but we need to think through memory ordering
> > > > > > > > concerns - I guess it's only when we change the value so
> > > > > > > >         if (!vq->kicked) {
> > > > > > > >                 vq->kicked = true;
> > > > > > > >                 mb();
> > > > > > > >         }
> > > > > > > >
> > > > > > > > will do the trick, right?
> > > > > > >
> > > > > > > There's no much difference with the existing approach:
> > > > > > >
> > > > > > > 1) your proposal implicitly makes callbacks ready in virtqueue_kick()
> > > > > > > 2) my proposal explicitly makes callbacks ready via virtio_device_ready()
> > > > > > >
> > > > > > > Both require careful auditing of all the existing drivers to make sure
> > > > > > > no kick before DRIVER_OK.
> > > > > >
> > > > > > Jason, kick before DRIVER_OK is out of spec, sure. But it is unrelated
> > > > > > to hardening
> > > > >
> > > > > Yes but with your proposal, it seems to couple kick with DRIVER_OK somehow.
> > > >
> > > > I don't see how - my proposal ignores DRIVER_OK issues.
> > >
> > > Yes, what I meant is, in your proposal, the first kick after rest is a
> > > hint that the driver is ok (but actually it could not).
> > >
> > > >
> > > > > > and in absence of config interrupts is generally easily
> > > > > > fixed just by sticking virtio_device_ready early in initialization.
> > > > >
> > > > > So if the kick is done before the subsystem registration, there's
> > > > > still a window in the middle (assuming we stick virtio_device_ready()
> > > > > early):
> > > > >
> > > > > virtio_device_ready()
> > > > > virtqueue_kick()
> > > > > /* the window */
> > > > > subsystem_registration()
> > > >
> > > > Absolutely, however, I do not think we really have many such drivers
> > > > since this has been known as a wrong thing to do since the beginning.
> > > > Want to try to find any?
> > >
> > > Yes, let me try and update.
> >
> > This is basically the device that have an RX queue, so I've found the
> > following drivers:
> >
> > scmi, mac80211_hwsim, vsock, bt, balloon.
>
> Looked and I don't see it yet. Let's consider
> ./net/vmw_vsock/virtio_transport.c for example. Assuming we block
> callbacks until the first kick, what is the issue with probe exactly?

We need to make sure the callback can survive when it runs before sub
system registration.

>
>
> > >
> > > >I couldn't ... except maybe bluetooth
> > > > but that's just maintainer nacking fixes saying he'll fix it
> > > > his way ...
> > > >
> > > > > And during remove(), we get another window:
> > > > >
> > > > > subsysrem_unregistration()
> > > > > /* the window */
> > > > > virtio_device_reset()
> > > >
> > > > Same here.
> >
> > Basically for the drivers that set driver_ok before registration,
>
> I don't see what does driver_ok have to do with it.

I meant for those driver, in probe they do()

virtio_device_ready()
subsystem_register()

In remove() they do

subsystem_unregister()
virtio_device_reset()

for symmetry

>
> > so
> > we have a lot:
> >
> > blk, net, mac80211_hwsim, scsi, vsock, bt, crypto, gpio, gpu, i2c,
> > iommu, caif, pmem, input, mem
> >
> > So I think there's no easy way to harden the notification without
> > auditing the driver one by one (especially considering the driver may
> > use bh or workqueue). The problem is the notification hardening
> > depends on a correct or race-free probe/remove. So we need to fix the
> > issues in probe/remove then do the hardening on the notification.
> >
> > Thanks
>
> So if drivers kick but are not ready to get callbacks then let's fix
> that first of all, these are racy with existing qemu even ignoring
> spec compliance.

Yes, (the patches I've posted so far exist even with a well-behaved device).

Thanks

>
>
> --
> MST
>

