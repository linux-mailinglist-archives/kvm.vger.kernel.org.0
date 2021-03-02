Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787ED32A713
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449008AbhCBQDJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383262AbhCBL0g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 06:26:36 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0380AC061797
        for <kvm@vger.kernel.org>; Tue,  2 Mar 2021 03:22:12 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id o16so2323999wmh.0
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 03:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SDwUqaAsHA5FRvDlUqZl4ka6pBS2IXvTGOlaocG7Rho=;
        b=sv10Czd4L0vQ6micnkcf19rI0mCcFPFn8Y5QoydoJV8dI0WA24Lgwd6mfhvJQG1aEW
         CqHeCpsyLBiibSmcTKBh7b8s8nyZ3c/bhewvv5g1NXjO24BzzBHIVmXbBXGHTiOejGCk
         IzobSu0BOQWBPkD7aJB+O2Zc5GJow+9RAhfuCwXgRwZg0Du1Rel4f+lMfs0RX6elCAfG
         cwHJZWgkhReMQMyBOfvbBFVAL4c0M2p8icEqcSi8q6NQQYLZKXDIDZW9aguuGxB+sE+i
         Vgb/Hn3/2B8rSG5IqfwLDg0E+smTwKD/9Q9ch6VPj6xlPdk1WLZ8sBmAM6rKrcgRu23o
         jQQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SDwUqaAsHA5FRvDlUqZl4ka6pBS2IXvTGOlaocG7Rho=;
        b=aJzANi6TQUEMQGJ7lWyoEoZK05ttcg16lDV6/TtOM8E98sJzLHWKlR2dXaxsHt8U1Z
         LPq+VFMF/fMvtnff4000yyPEjyKPA6iGmryWpMnBRNRGgwJ4JYUf7Tj8cUpIZM8UBfDs
         7kJgrViKkiifejl4HUJ9jTnafzGbCpcWja2Y9eBBLOJ2LcvLGM3pu/9YPT8T1r1Nzh+K
         IACIKABrUYuhp+oTC8hANKEjV3m6XJWbxiOxp9/EobmFJuwFZIHPU7niP8GRpw7KRDHA
         Wz8h66a4EkvIn4HCHPwoCIKaf9gNGedfueeQ7BziJgy18mOd/HjiOAoICtQ1+FmpJeh3
         2E/Q==
X-Gm-Message-State: AOAM533f1W5W/X2pVPzeNw3dyemrO1Jzj9JEaa9UXz1kD1Juc7mYLtho
        b/iEKc9jAlgVdgu0D5TA85g=
X-Google-Smtp-Source: ABdhPJxBoa8cJ2IbS0S/eZriz7LjlVKByHkg9Xx/3eCothcBrCsfPOlCpZylm8aleY2O68wgjFVEng==
X-Received: by 2002:a7b:c214:: with SMTP id x20mr3546817wmi.186.1614684130734;
        Tue, 02 Mar 2021 03:22:10 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id o3sm2051119wmq.46.2021.03.02.03.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 03:22:09 -0800 (PST)
Date:   Tue, 2 Mar 2021 11:22:08 +0000
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     qemu-level <qemu-devel@nongnu.org>,
        Lars Ganrot <lars.ganrot@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Liran Alon <liralon@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Max Gurtovoy <maxgu14@gmail.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jim Harford <jim.harford@broadcom.com>,
        Jason Wang <jasowang@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Christophe Fontaine <cfontain@redhat.com>,
        vm <vmireyno@marvell.com>, Daniel Daly <dandaly0@gmail.com>,
        Michael Lilja <ml@napatech.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Nitin Shrivastav <nitin.shrivastav@broadcom.com>,
        Lee Ballard <ballle98@gmail.com>,
        Dmytro Kazantsev <dmytro.kazantsev@gmail.com>,
        Juan Quintela <quintela@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Howard Cai <howard.cai@gmail.com>,
        Xiao W Wang <xiao.w.wang@intel.com>,
        Sean Mooney <smooney@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Siwei Liu <loseweigh@gmail.com>,
        Stephen Finucane <stephenfin@redhat.com>
Subject: Re: [RFC PATCH 06/27] virtio: Add virtio_queue_get_used_notify_split
Message-ID: <YD4f4KEIYRlTUP4/@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com>
 <20201120185105.279030-7-eperezma@redhat.com>
 <20201207165848.GM203660@stefanha-x1.localdomain>
 <CAJaqyWc4oLzL02GKpPSwEGRxK+UxjOGBAPLzrgrgKRZd9C81GA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AuODnRtc/rPJimRT"
Content-Disposition: inline
In-Reply-To: <CAJaqyWc4oLzL02GKpPSwEGRxK+UxjOGBAPLzrgrgKRZd9C81GA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--AuODnRtc/rPJimRT
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 12, 2021 at 07:21:27PM +0100, Eugenio Perez Martin wrote:
> On Mon, Dec 7, 2020 at 5:58 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
> >
> > On Fri, Nov 20, 2020 at 07:50:44PM +0100, Eugenio P=E9rez wrote:
> > > This function is just used for a few commits, so SW LM is developed
> > > incrementally, and it is deleted after it is useful.
> > >
> > > For a few commits, only the events (irqfd, eventfd) are forwarded.
> >
> > s/eventfd/ioeventfd/ (irqfd is also an eventfd)
> >
>=20
> Oops, will fix, thanks!
>=20
> > > +bool virtio_queue_get_used_notify_split(VirtQueue *vq)
> > > +{
> > > +    VRingMemoryRegionCaches *caches;
> > > +    hwaddr pa =3D offsetof(VRingUsed, flags);
> > > +    uint16_t flags;
> > > +
> > > +    RCU_READ_LOCK_GUARD();
> > > +
> > > +    caches =3D vring_get_region_caches(vq);
> > > +    assert(caches);
> > > +    flags =3D virtio_lduw_phys_cached(vq->vdev, &caches->used, pa);
> > > +    return !(VRING_USED_F_NO_NOTIFY & flags);
> > > +}
> >
> > QEMU stores the notification status:
> >
> > void virtio_queue_set_notification(VirtQueue *vq, int enable)
> > {
> >     vq->notification =3D enable; <---- here
> >
> >     if (!vq->vring.desc) {
> >         return;
> >     }
> >
> >     if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
> >         virtio_queue_packed_set_notification(vq, enable);
> >     } else {
> >         virtio_queue_split_set_notification(vq, enable);
> >
> > I'm wondering why it's necessary to fetch from guest RAM instead of
> > using vq->notification? It also works for both split and packed
> > queues so the code would be simpler.
>=20
> To use vq->notification makes sense at the end of the series.
>=20
> However, at this stage (just routing notifications, not descriptors),
> vhost device is the one updating that flag, not qemu. Since we cannot
> just migrate used ring memory to qemu without migrating descriptors
> ring too, qemu needs to check guest's memory looking for vhost device
> updates on that flag.
>=20
> I can see how that deserves better documentation or even a better
> name. Also, this function should be in the shadow vq file, not
> virtio.c.

I can't think of a reason why QEMU needs to know the flag value that the
vhost device has set. This flag is a hint to the guest driver indicating
whether the device wants to receive notifications.

Can you explain why QEMU needs to look at the value of the flag?

Stefan

--AuODnRtc/rPJimRT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmA+H+AACgkQnKSrs4Gr
c8gsbQf+JXl+yqTOrys6EIAZbWGHPCn6AVKZFnl2apaGoJ99aVfZDz6Sv4YyZLdy
iHkI0sm2SF1Rayw+zwIFz1+90/AljnxphtCNcbJNoaZlc/9LtT/RVHtm/jmlfc9L
jjhhDnKd1t5npLKuDXLD5ZWftIyYbjNzPfESx1KH/DszkP0/e6mqB6sjFXpIdcgq
6lfV8Ms0Ml5Uq+SeSvh/ainTIjtnuZC9qqOkmDvy9SPhBjaWWGwZccWsFwoNGQwX
fIzs1RV+BJUynOmhyGfj3NTsHn/paqnidefPifMGnXEt+nqXvFL1G42lur/jfkoc
E0hyTf78g2P48flKMInd7AW3G84DLg==
=IHvW
-----END PGP SIGNATURE-----

--AuODnRtc/rPJimRT--
