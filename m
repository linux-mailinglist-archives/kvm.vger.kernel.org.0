Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7774D55F695
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 08:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbiF2GbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 02:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiF2GbP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 02:31:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E9AF2A735
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 23:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656484273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I+9RF1q6D/YnV5nX1dRXvF5cHfzPeG8DFYB/pyH/RHQ=;
        b=IxZyt3GxVy0nYYFsur7j+23T2I8DRhfjzu/PA08cGkAysn5axhZlir+jkdYJrdAVn8/O1L
        2qBRSLbGQlnv3rFeI3IXJySE/CItgBUgjJzWqUvqvUFZwcPGrz9AgJymhU/vFy/KgfemPg
        peDjC00KKiYT2j9ZO7hmLdkBlhSJLgQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-81-slO7P9nPMw-UPBny46p7-Q-1; Wed, 29 Jun 2022 02:31:11 -0400
X-MC-Unique: slO7P9nPMw-UPBny46p7-Q-1
Received: by mail-wm1-f69.google.com with SMTP id o28-20020a05600c511c00b003a04f97f27aso2708331wms.9
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 23:31:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I+9RF1q6D/YnV5nX1dRXvF5cHfzPeG8DFYB/pyH/RHQ=;
        b=Ij73k45+s1CPCOXuK78brGU8fPdh3HYrY6tFmaDVIwVzhp5j1A1dBCm8uJwcsJYckf
         MfJjs59s62hZ3eYO1+EqPcVy5ayLzawtPMN8Hm9hmwqef6RcaR5Yr1BvsgHyi7vKQZAo
         kP/m9aLRjoUmtDiZM98ti1SneSDQpSRQxm9jS88XM6P71niyC2mX2nYpXKGogYiWHI+i
         FxKFTjnuWxWBO+vzTm+aTJ0w2PCFfTbv2M6J8M1jz/WNiOUhXNtGWENRfIxZHmaaJC+J
         gbMaKkvqJajxd9FNNbENiJcHvAXLjmrQFrpwp6wqCH3g+be33KOYZe/5S8zrnw8RGskR
         yCBA==
X-Gm-Message-State: AJIora8aIi/vXitOkF9oZWLs7mI9b02cx2Tn4Cfg4+iwNKeFaxPf3SKV
        kmbxK2sE2dXaMeYe/wsDcGXuRD5a3N/JedpAuId42+CgcxMQW6D68WppPUOc12WTP7j2vLD74Vv
        Kdnm9Z1mYMhB9
X-Received: by 2002:adf:ea09:0:b0:21d:2245:ab84 with SMTP id q9-20020adfea09000000b0021d2245ab84mr1359554wrm.542.1656484270139;
        Tue, 28 Jun 2022 23:31:10 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1swmf1jxmlPCLuJbv6FmUELagisBcAc6WrE9BmWf7vexeigm9UUyTGKSYWbKyWsf7t3JFfr6Q==
X-Received: by 2002:adf:ea09:0:b0:21d:2245:ab84 with SMTP id q9-20020adfea09000000b0021d2245ab84mr1359515wrm.542.1656484269797;
        Tue, 28 Jun 2022 23:31:09 -0700 (PDT)
Received: from redhat.com ([2.52.23.204])
        by smtp.gmail.com with ESMTPSA id o18-20020a05600c379200b003a033177655sm1853981wmr.29.2022.06.28.23.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 23:31:09 -0700 (PDT)
Date:   Wed, 29 Jun 2022 02:31:04 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
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
Subject: Re: [PATCH V3] virtio: disable notification hardening by default
Message-ID: <20220629022223-mutt-send-email-mst@kernel.org>
References: <CACGkMEtJY2ioD0L8ifTrCPatG6-NqQ01V=d2L1FeoweKV74LaA@mail.gmail.com>
 <20220624022622-mutt-send-email-mst@kernel.org>
 <CACGkMEuurobpUWmDL8zmZ6T6Ygc0OEMx6vx2EDCSoGNnZQ0r-w@mail.gmail.com>
 <20220627024049-mutt-send-email-mst@kernel.org>
 <CACGkMEvrDXDN7FH1vKoYCob2rkxUsctE_=g61kzHSZ8tNNr6vA@mail.gmail.com>
 <20220627053820-mutt-send-email-mst@kernel.org>
 <CACGkMEvcs+9_SHmO1s3nyzgU7oq7jhU2gircVVR3KDsGDikh5Q@mail.gmail.com>
 <20220628004614-mutt-send-email-mst@kernel.org>
 <CACGkMEsC4A+3WejLSOZoH3enXtai=+JyRNbxcpzK4vODYzhaFw@mail.gmail.com>
 <CACGkMEvu0D0XD7udz0ebVjNM0h5+K9Rjd-5ed=PY_+-aduzG2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEvu0D0XD7udz0ebVjNM0h5+K9Rjd-5ed=PY_+-aduzG2g@mail.gmail.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 29, 2022 at 12:07:11PM +0800, Jason Wang wrote:
> On Tue, Jun 28, 2022 at 2:17 PM Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Tue, Jun 28, 2022 at 1:00 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Tue, Jun 28, 2022 at 11:49:12AM +0800, Jason Wang wrote:
> > > > > Heh. Yea sure. But things work fine for people. What is the chance
> > > > > your review found and fixed all driver bugs?
> > > >
> > > > I don't/can't audit all bugs but the race between open/close against
> > > > ready/reset. It looks to me a good chance to fix them all but if you
> > > > think differently, let me know
> > > >
> > > > > After two attempts
> > > > > I don't feel like hoping audit will fix all bugs.
> > > >
> > > > I've started the auditing and have 15+ patches in the queue. (only
> > > > covers bluetooth, console, pmem, virtio-net and caif). Spotting the
> > > > issue is not hard but the testing, It would take at least the time of
> > > > one release to finalize I guess.
> > >
> > > Absolutely. So I am looking for a way to implement hardening that does
> > > not break existing drivers.
> >
> > I totally agree with you to seek a way without bothering the drivers.
> > Just wonder if this is possbile.
> >
> > >
> > >
> > > > >
> > > > >
> > > > > > >
> > > > > > > The reason config was kind of easy is that config interrupt is rarely
> > > > > > > vital for device function so arbitrarily deferring that does not lead to
> > > > > > > deadlocks - what you are trying to do with VQ interrupts is
> > > > > > > fundamentally different. Things are especially bad if we just drop
> > > > > > > an interrupt but deferring can lead to problems too.
> > > > > >
> > > > > > I'm not sure I see the difference, disable_irq() stuffs also delay the
> > > > > > interrupt processing until enable_irq().
> > > > >
> > > > >
> > > > > Absolutely. I am not at all sure disable_irq fixes all problems.
> > > > >
> > > > > > >
> > > > > > > Consider as an example
> > > > > > >     virtio-net: fix race between ndo_open() and virtio_device_ready()
> > > > > > > if you just defer vq interrupts you get deadlocks.
> > > > > > >
> > > > > > >
> > > > > >
> > > > > > I don't see a deadlock here, maybe you can show more detail on this?
> > > > >
> > > > > What I mean is this: if we revert the above commit, things still
> > > > > work (out of spec, but still). If we revert and defer interrupts until
> > > > > device ready then ndo_open that triggers before device ready deadlocks.
> > > >
> > > > Ok, I guess you meant on a hypervisor that is strictly written with spec.
> > >
> > > I mean on hypervisor that starts processing queues after getting a kick
> > > even without DRIVER_OK.
> >
> > Oh right.
> >
> > >
> > > > >
> > > > >
> > > > > > >
> > > > > > > So, thinking about all this, how about a simple per vq flag meaning
> > > > > > > "this vq was kicked since reset"?
> > > > > >
> > > > > > And ignore the notification if vq is not kicked? It sounds like the
> > > > > > callback needs to be synchronized with the kick.
> > > > >
> > > > > Note we only need to synchronize it when it changes, which is
> > > > > only during initialization and reset.
> > > >
> > > > Yes.
> > > >
> > > > >
> > > > >
> > > > > > >
> > > > > > > If driver does not kick then it's not ready to get callbacks, right?
> > > > > > >
> > > > > > > Sounds quite clean, but we need to think through memory ordering
> > > > > > > concerns - I guess it's only when we change the value so
> > > > > > >         if (!vq->kicked) {
> > > > > > >                 vq->kicked = true;
> > > > > > >                 mb();
> > > > > > >         }
> > > > > > >
> > > > > > > will do the trick, right?
> > > > > >
> > > > > > There's no much difference with the existing approach:
> > > > > >
> > > > > > 1) your proposal implicitly makes callbacks ready in virtqueue_kick()
> > > > > > 2) my proposal explicitly makes callbacks ready via virtio_device_ready()
> > > > > >
> > > > > > Both require careful auditing of all the existing drivers to make sure
> > > > > > no kick before DRIVER_OK.
> > > > >
> > > > > Jason, kick before DRIVER_OK is out of spec, sure. But it is unrelated
> > > > > to hardening
> > > >
> > > > Yes but with your proposal, it seems to couple kick with DRIVER_OK somehow.
> > >
> > > I don't see how - my proposal ignores DRIVER_OK issues.
> >
> > Yes, what I meant is, in your proposal, the first kick after rest is a
> > hint that the driver is ok (but actually it could not).
> >
> > >
> > > > > and in absence of config interrupts is generally easily
> > > > > fixed just by sticking virtio_device_ready early in initialization.
> > > >
> > > > So if the kick is done before the subsystem registration, there's
> > > > still a window in the middle (assuming we stick virtio_device_ready()
> > > > early):
> > > >
> > > > virtio_device_ready()
> > > > virtqueue_kick()
> > > > /* the window */
> > > > subsystem_registration()
> > >
> > > Absolutely, however, I do not think we really have many such drivers
> > > since this has been known as a wrong thing to do since the beginning.
> > > Want to try to find any?
> >
> > Yes, let me try and update.
> 
> This is basically the device that have an RX queue, so I've found the
> following drivers:
> 
> scmi, mac80211_hwsim, vsock, bt, balloon.

Looked and I don't see it yet. Let's consider
./net/vmw_vsock/virtio_transport.c for example. Assuming we block
callbacks until the first kick, what is the issue with probe exactly?


> >
> > >I couldn't ... except maybe bluetooth
> > > but that's just maintainer nacking fixes saying he'll fix it
> > > his way ...
> > >
> > > > And during remove(), we get another window:
> > > >
> > > > subsysrem_unregistration()
> > > > /* the window */
> > > > virtio_device_reset()
> > >
> > > Same here.
> 
> Basically for the drivers that set driver_ok before registration,

I don't see what does driver_ok have to do with it.

> so
> we have a lot:
> 
> blk, net, mac80211_hwsim, scsi, vsock, bt, crypto, gpio, gpu, i2c,
> iommu, caif, pmem, input, mem
> 
> So I think there's no easy way to harden the notification without
> auditing the driver one by one (especially considering the driver may
> use bh or workqueue). The problem is the notification hardening
> depends on a correct or race-free probe/remove. So we need to fix the
> issues in probe/remove then do the hardening on the notification.
> 
> Thanks

So if drivers kick but are not ready to get callbacks then let's fix
that first of all, these are racy with existing qemu even ignoring
spec compliance.


-- 
MST

