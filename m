Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178DA330BA9
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 11:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhCHKrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 05:47:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58414 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231215AbhCHKqg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 05:46:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615200395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g1tKnkjJWrSFbX4H2YOn29SnfSqXEzlO7Rs0c3HSYCg=;
        b=eYcIL57gScdWXohrDN+VVPKG0N2M7p3l/zeMHqPtrG5MqF9f7TC5L7+cdOub2SRkHrzDbz
        PcK/F3BptMEH5ynnZBNQTLOYY+pRmGKKEjwnfdCeejqpgakuiQp6lm13lBD69GwmepMFoz
        k43l7bbXsq/lltleafSHEk0yOI05J4k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-_B9xZ328Mo-9eLTY_ectPQ-1; Mon, 08 Mar 2021 05:46:24 -0500
X-MC-Unique: _B9xZ328Mo-9eLTY_ectPQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7ED641005D4A;
        Mon,  8 Mar 2021 10:46:21 +0000 (UTC)
Received: from localhost (ovpn-114-104.ams2.redhat.com [10.36.114.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D14719715;
        Mon,  8 Mar 2021 10:46:16 +0000 (UTC)
Date:   Mon, 8 Mar 2021 10:46:16 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>,
        qemu-level <qemu-devel@nongnu.org>,
        Lars Ganrot <lars.ganrot@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Liran Alon <liralon@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Max Gurtovoy <maxgu14@gmail.com>,
        Alex Barba <alex.barba@broadcom.com>,
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
Message-ID: <YEYAeGasxYD6ZheE@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com>
 <20201120185105.279030-7-eperezma@redhat.com>
 <20201207165848.GM203660@stefanha-x1.localdomain>
 <CAJaqyWc4oLzL02GKpPSwEGRxK+UxjOGBAPLzrgrgKRZd9C81GA@mail.gmail.com>
 <YD4f4KEIYRlTUP4/@stefanha-x1.localdomain>
 <CAJaqyWd0iRUUW5Hu=U3mwQ4f43kA=bse3EkN4+QauFR4BJwObQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wt/k06bIHv2D9AK7"
Content-Disposition: inline
In-Reply-To: <CAJaqyWd0iRUUW5Hu=U3mwQ4f43kA=bse3EkN4+QauFR4BJwObQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--wt/k06bIHv2D9AK7
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 02, 2021 at 07:34:20PM +0100, Eugenio Perez Martin wrote:
> On Tue, Mar 2, 2021 at 12:22 PM Stefan Hajnoczi <stefanha@gmail.com> wrot=
e:
> >
> > On Tue, Jan 12, 2021 at 07:21:27PM +0100, Eugenio Perez Martin wrote:
> > > On Mon, Dec 7, 2020 at 5:58 PM Stefan Hajnoczi <stefanha@gmail.com> w=
rote:
> > > >
> > > > On Fri, Nov 20, 2020 at 07:50:44PM +0100, Eugenio P=E9rez wrote:
> > > > > This function is just used for a few commits, so SW LM is develop=
ed
> > > > > incrementally, and it is deleted after it is useful.
> > > > >
> > > > > For a few commits, only the events (irqfd, eventfd) are forwarded.
> > > >
> > > > s/eventfd/ioeventfd/ (irqfd is also an eventfd)
> > > >
> > >
> > > Oops, will fix, thanks!
> > >
> > > > > +bool virtio_queue_get_used_notify_split(VirtQueue *vq)
> > > > > +{
> > > > > +    VRingMemoryRegionCaches *caches;
> > > > > +    hwaddr pa =3D offsetof(VRingUsed, flags);
> > > > > +    uint16_t flags;
> > > > > +
> > > > > +    RCU_READ_LOCK_GUARD();
> > > > > +
> > > > > +    caches =3D vring_get_region_caches(vq);
> > > > > +    assert(caches);
> > > > > +    flags =3D virtio_lduw_phys_cached(vq->vdev, &caches->used, p=
a);
> > > > > +    return !(VRING_USED_F_NO_NOTIFY & flags);
> > > > > +}
> > > >
> > > > QEMU stores the notification status:
> > > >
> > > > void virtio_queue_set_notification(VirtQueue *vq, int enable)
> > > > {
> > > >     vq->notification =3D enable; <---- here
> > > >
> > > >     if (!vq->vring.desc) {
> > > >         return;
> > > >     }
> > > >
> > > >     if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
> > > >         virtio_queue_packed_set_notification(vq, enable);
> > > >     } else {
> > > >         virtio_queue_split_set_notification(vq, enable);
> > > >
> > > > I'm wondering why it's necessary to fetch from guest RAM instead of
> > > > using vq->notification? It also works for both split and packed
> > > > queues so the code would be simpler.
> > >
> > > To use vq->notification makes sense at the end of the series.
> > >
> > > However, at this stage (just routing notifications, not descriptors),
> > > vhost device is the one updating that flag, not qemu. Since we cannot
> > > just migrate used ring memory to qemu without migrating descriptors
> > > ring too, qemu needs to check guest's memory looking for vhost device
> > > updates on that flag.
> > >
> > > I can see how that deserves better documentation or even a better
> > > name. Also, this function should be in the shadow vq file, not
> > > virtio.c.
> >
> > I can't think of a reason why QEMU needs to know the flag value that the
> > vhost device has set. This flag is a hint to the guest driver indicating
> > whether the device wants to receive notifications.
> >
> > Can you explain why QEMU needs to look at the value of the flag?
> >
> > Stefan
>=20
> My bad, "need" is not the right word: SVQ could just forward the
> notification at this point without checking the flag. Taking into
> account that it's not used in later series, and it's even removed in
> patch 14/27 of this series, I can see that it just adds noise to the
> entire patchset
>=20
> This function just allows svq to re-check the flag after the guest
> sends the notification. This way svq is able to drop the kick as a
> (premature?) optimization in case the device sets it just after the
> guest sends the kick.
>=20
> Until patch 13/27, only notifications are forwarded, not buffers. VM
> guest's drivers and vhost device still read and write at usual
> addresses, but ioeventfd and kvmfd are intercepted by qemu. This
> allows us to test if the notification forwarding part is doing ok.
> From patch 14 of this series, svq offers a new vring to the device in
> qemu's VAS, so the former does not need to check the guest's memory
> anymore, and this function can be dropped.
>=20
> Is it clearer now? Please let me know if I should add something else.

Thanks for explaining. You could drop it to simplify the code. If you
leave it in, please include a comment explaining the purpose.

Thanks,
Stefan

--wt/k06bIHv2D9AK7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBGAHcACgkQnKSrs4Gr
c8hQIwgAtbmbXALP3b9YRiQjKcricWBmsnBRSrhFbwUMD9mB9CRdPsN8E0ylmqeD
vms6J1x3x93RXeeasCEJqrB6dhiy5d2b6PG0Lyab+vFnmygg6sBdLkGx5BErKIup
UpCWmxSJ9LtdFQYrjPQNH/wrBmQkOLp3uRpuYX3JIyNK+F/ReWcxPtAyjbGdFyaq
VN0yyFYI1EB/t+8E2W9YhhJxI8e5Vp1KL+tB6PpYMWGYBJ+OjbEGktQGEBCZhnrA
jBE2MmBNlE1tH3hvBplQotx1GMryQ49BoQ70IqVSw+gvdo6RJWZ20r37tgl0trk7
rCsji9cO4l8Fr1K5gJBDzJtYVuSBvw==
=Tm0W
-----END PGP SIGNATURE-----

--wt/k06bIHv2D9AK7--

