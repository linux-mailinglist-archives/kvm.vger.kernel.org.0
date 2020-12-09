Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A392D4639
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 17:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729901AbgLIQAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 11:00:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50608 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727024AbgLIQAH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 11:00:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607529520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JBr32EfwjraHmhGUU1qWmpGQu6trXhEY+c3U2JTdT58=;
        b=Cae9WGaouIuQalqCvNagq8SRtMfMkFnpwJ1q+pltPZWHNpPKySvRtA/jpT4ycxocZXzq8N
        31kJgEo0SPGv4wO7YME+RBF1QuJZFs4cqAlZQ/WCaEfoSVSNc7xuLz5PaMW+cg3XE7tJpW
        eCENZzox7vazQiMgzoRvTYhV0B2mWh8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-2pOf97PaMRukBQZCgWs7BA-1; Wed, 09 Dec 2020 10:58:35 -0500
X-MC-Unique: 2pOf97PaMRukBQZCgWs7BA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADE23180DE10;
        Wed,  9 Dec 2020 15:57:31 +0000 (UTC)
Received: from localhost (ovpn-115-48.ams2.redhat.com [10.36.115.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD6786064B;
        Wed,  9 Dec 2020 15:57:30 +0000 (UTC)
Date:   Wed, 9 Dec 2020 15:57:29 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        qemu-devel@nongnu.org, Lars Ganrot <lars.ganrot@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Liran Alon <liralon@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Max Gurtovoy <maxgu14@gmail.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Jim Harford <jim.harford@broadcom.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Christophe Fontaine <cfontain@redhat.com>,
        vm <vmireyno@marvell.com>, Daniel Daly <dandaly0@gmail.com>,
        Michael Lilja <ml@napatech.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Nitin Shrivastav <nitin.shrivastav@broadcom.com>,
        Lee Ballard <ballle98@gmail.com>,
        Dmytro Kazantsev <dmytro.kazantsev@gmail.com>,
        Juan Quintela <quintela@redhat.com>, kvm@vger.kernel.org,
        Howard Cai <howard.cai@gmail.com>,
        Xiao W Wang <xiao.w.wang@intel.com>,
        Sean Mooney <smooney@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Siwei Liu <loseweigh@gmail.com>,
        Stephen Finucane <stephenfin@redhat.com>
Subject: Re: [RFC PATCH 00/27] vDPA software assisted live migration
Message-ID: <20201209155729.GB396498@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com>
 <20201208093715.GX203660@stefanha-x1.localdomain>
 <1410217602.34486578.1607506010536.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
In-Reply-To: <1410217602.34486578.1607506010536.JavaMail.zimbra@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JP+T4n/bALQSJXh8"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 09, 2020 at 04:26:50AM -0500, Jason Wang wrote:
> ----- Original Message -----
> > On Fri, Nov 20, 2020 at 07:50:38PM +0100, Eugenio P=E9rez wrote:
> > > This series enable vDPA software assisted live migration for vhost-ne=
t
> > > devices. This is a new method of vhost devices migration: Instead of
> > > relay on vDPA device's dirty logging capability, SW assisted LM
> > > intercepts dataplane, forwarding the descriptors between VM and devic=
e.
> >=20
> > Pros:
> > + vhost/vDPA devices don't need to implement dirty memory logging
> > + Obsoletes ioctl(VHOST_SET_LOG_BASE) and friends
> >=20
> > Cons:
> > - Not generic, relies on vhost-net-specific ioctls
> > - Doesn't support VIRTIO Shared Memory Regions
> >   https://github.com/oasis-tcs/virtio-spec/blob/master/shared-mem.tex
>=20
> I may miss something but my understanding is that it's the
> responsiblity of device to migrate this part?

Good point. You're right.

> > - Performance (see below)
> >=20
> > I think performance will be significantly lower when the shadow vq is
> > enabled. Imagine a vDPA device with hardware vq doorbell registers
> > mapped into the guest so the guest driver can directly kick the device.
> > When the shadow vq is enabled a vmexit is needed to write to the shadow
> > vq ioeventfd, then the host kernel scheduler switches to a QEMU thread
> > to read the ioeventfd, the descriptors are translated, QEMU writes to
> > the vhost hdev kick fd, the host kernel scheduler switches to the vhost
> > worker thread, vhost/vDPA notifies the virtqueue, and finally the
> > vDPA driver writes to the hardware vq doorbell register. That is a lot
> > of overhead compared to writing to an exitless MMIO register!
>=20
> I think it's a balance. E.g we can poll the virtqueue to have an
> exitless doorbell.
>=20
> >=20
> > If the shadow vq was implemented in drivers/vhost/ and QEMU used the
> > existing ioctl(VHOST_SET_LOG_BASE) approach, then the overhead would be
> > reduced to just one set of ioeventfd/irqfd. In other words, the QEMU
> > dirty memory logging happens asynchronously and isn't in the dataplane.
> >=20
> > In addition, hardware that supports dirty memory logging as well as
> > software vDPA devices could completely eliminate the shadow vq for even
> > better performance.
>=20
> Yes. That's our plan. But the interface might require more thought.
>=20
> E.g is the bitmap a good approach? To me reporting dirty pages via
> virqueue is better since it get less footprint and is self throttled.
>=20
> And we need an address space other than the one used by guest for
> either bitmap for virtqueue.
>=20
> >=20
> > But performance is a question of "is it good enough?". Maybe this
> > approach is okay and users don't expect good performance while dirty
> > memory logging is enabled.
>=20
> Yes, and actually such slow down may help for the converge of the
> migration.
>=20
> Note that the whole idea is try to have a generic solution for all
> types of devices. It's good to consider the performance but for the
> first stage, it should be sufficient to make it work and consider to
> optimize on top.

Moving the shadow vq to the kernel later would be quite a big change
requiring rewriting much of the code. That's why I mentioned this now
before a lot of effort is invested in a QEMU implementation.

> > I just wanted to share the idea of moving the
> > shadow vq into the kernel in case you like that approach better.
>=20
> My understanding is to keep kernel as simple as possible and leave the
> polices to userspace as much as possible. E.g it requires us to
> disable doorbell mapping and irq offloading, all of which were under
> the control of userspace.

If the performance is acceptable with the QEMU approach then I think
that's the best place to implement it. It looks high-overhead though so
maybe one of the first things to do is to run benchmarks to collect data
on how it performs?

Stefan

--JP+T4n/bALQSJXh8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/Q8+kACgkQnKSrs4Gr
c8gzgwf/R8XyRehTNARVsYQYQS8pC8vzoJcb4LMSB4/opM4DdNb2gIFzVOzHt7am
ibFu8Wyl3C2txGaFCh4YlGIwVkGTdAp++Dwhl9wWZaVA0vvjv/yxR/r82IIid7oR
tLb5LibQ19LXmVdFgAfGaT3dXSIkPG38RECJZwSk3QBrgXfsKclGZHRpnPGsK0B3
3PIQtGy3wjJIuVXoknfAXjThXpzXmwlc/EHQnBSajm9byvMVWzlHb2Kirc5PO0xP
Vrg2wdmUUwnVgSC2n9DgEjb1IRyVWEW9dsF+8QdmBnPtYSOJ74EekvFkn6fKWd2A
/NyM+ry+1zHgomC5WqzC9bKCp+KacQ==
=WM5k
-----END PGP SIGNATURE-----

--JP+T4n/bALQSJXh8--

