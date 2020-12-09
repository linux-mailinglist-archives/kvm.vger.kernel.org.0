Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F7D2D4673
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 17:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbgLIQKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 11:10:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43354 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730136AbgLIQKg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 11:10:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607530149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fOS/4HJ6CdAMgJzGnNDCHYvTBIuYNCc44EVO6kOzhSI=;
        b=QpVzMEyaZoFXM7BxJMYaC6G2RW+tkfN/N8ksGbLtOCLl8bpE2pLIdlhEa/Ick6/J9yc4pU
        4nTXarJIgLEtxxlhI1VBJx2kxEnJ0gsABvwo24EmrdCXxT3nTNNPvx57+1IqjR8U5CSvbC
        X3fjNqYbQWUNrgc1CDzyal63bzBIwWo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-rVoJ1VpoO0KvyhUnBjsi5w-1; Wed, 09 Dec 2020 11:09:05 -0500
X-MC-Unique: rVoJ1VpoO0KvyhUnBjsi5w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 127241005504;
        Wed,  9 Dec 2020 16:09:02 +0000 (UTC)
Received: from localhost (ovpn-115-48.ams2.redhat.com [10.36.115.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3AC6B60BF1;
        Wed,  9 Dec 2020 16:08:58 +0000 (UTC)
Date:   Wed, 9 Dec 2020 16:08:57 +0000
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
Subject: Re: [RFC PATCH 04/27] vhost: add vhost_kernel_set_vring_enable
Message-ID: <20201209160857.GC396498@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com>
 <20201120185105.279030-5-eperezma@redhat.com>
 <20201207164323.GK203660@stefanha-x1.localdomain>
 <CAJaqyWd5oAJ4kJOhyDz+1KNvwzqJi3NO+5Z7X6W5ju2Va=LTMQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJaqyWd5oAJ4kJOhyDz+1KNvwzqJi3NO+5Z7X6W5ju2Va=LTMQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Bu8it7iiRSEf40bY"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Bu8it7iiRSEf40bY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 09, 2020 at 01:00:19PM +0100, Eugenio Perez Martin wrote:
> On Mon, Dec 7, 2020 at 5:43 PM Stefan Hajnoczi <stefanha@gmail.com> wrote=
:
> >
> > On Fri, Nov 20, 2020 at 07:50:42PM +0100, Eugenio P=E9rez wrote:
> > > Signed-off-by: Eugenio P=E9rez <eperezma@redhat.com>
> > > ---
> > >  hw/virtio/vhost-backend.c | 29 +++++++++++++++++++++++++++++
> > >  1 file changed, 29 insertions(+)
> > >
> > > diff --git a/hw/virtio/vhost-backend.c b/hw/virtio/vhost-backend.c
> > > index 222bbcc62d..317f1f96fa 100644
> > > --- a/hw/virtio/vhost-backend.c
> > > +++ b/hw/virtio/vhost-backend.c
> > > @@ -201,6 +201,34 @@ static int vhost_kernel_get_vq_index(struct vhos=
t_dev *dev, int idx)
> > >      return idx - dev->vq_index;
> > >  }
> > >
> > > +static int vhost_kernel_set_vq_enable(struct vhost_dev *dev, unsigne=
d idx,
> > > +                                      bool enable)
> > > +{
> > > +    struct vhost_vring_file file =3D {
> > > +        .index =3D idx,
> > > +    };
> > > +
> > > +    if (!enable) {
> > > +        file.fd =3D -1; /* Pass -1 to unbind from file. */
> > > +    } else {
> > > +        struct vhost_net *vn_dev =3D container_of(dev, struct vhost_=
net, dev);
> > > +        file.fd =3D vn_dev->backend;
> > > +    }
> > > +
> > > +    return vhost_kernel_net_set_backend(dev, &file);
> >
> > This is vhost-net specific even though the function appears to be
> > generic. Is there a plan to extend this to all devices?
> >
>=20
> I expected each vhost backend to enable-disable in its own terms, but
> I think it could be 100% virtio-device generic with something like the
> device state capability:
> https://lists.oasis-open.org/archives/virtio-comment/202012/msg00005.html
> .

Great, thanks for the link!

> > > +}
> > > +
> > > +static int vhost_kernel_set_vring_enable(struct vhost_dev *dev, int =
enable)
> > > +{
> > > +    int i;
> > > +
> > > +    for (i =3D 0; i < dev->nvqs; ++i) {
> > > +        vhost_kernel_set_vq_enable(dev, i, enable);
> > > +    }
> > > +
> > > +    return 0;
> > > +}
> >
> > I suggest exposing the per-vq interface (vhost_kernel_set_vq_enable())
> > in VhostOps so it follows the ioctl interface.
>=20
> It was actually the initial plan, I left as all-or-nothing to make less c=
hanges.
>=20
> > vhost_kernel_set_vring_enable() can be moved to vhost.c can loop over
> > all vqs if callers find it convenient to loop over all vqs.
>=20
> I'm ok with it. Thinking out loud, I don't know if it is easier for
> some devices to enable/disable all of it (less syscalls? less downtime
> somehow?) but I find more generic and useful the per-virtqueue
> approach.

That's an interesting question, the ability to enable/disable specific
virtqueues seems like it could be useful. For example, guests with vCPU
hotplug may want to enable/disable virtqueues so that multi-queue
adapts as the number of vCPUs changes. A per-vq interface is needed for
that.

I'm a little worried that some device types might not cope well with
quiescing individual vqs. Here "quiesce" means to complete in flight
requests. This would be where two or more vqs have a relationship and
disabling one vq could cause a deadlock when trying to disable the other
one. However, I can't think of a case where this happens.

virtio-vsock is the closest example but luckily we don't need complete
in flight requests, we can just stop the vq immediately. So although
there is a dependency on the other vq it won't deadlock in this case.

Stefan

--Bu8it7iiRSEf40bY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/Q9pkACgkQnKSrs4Gr
c8iMSwgAuQkVy+8P+reUkH3zK4kRMJP39XJyEVGBk4XKwPzrKZMdOaUjfCdmtrS5
8mdhYb/M4pl2/kvGRgIMZFL/6fF+FqPl2awpYD7fWDQvMuUmg6Ky2czgPERekkjy
awjY044CskD0euoaLLbF8NawY+5/vkm65diOPvwhSVu9w/2ZPhAmEX8I+kL1w/8H
RfFdptKdp8+U24zVbF/Deb8i0aTC0SCpOlkdMzhXuK+KIVtz71I68T/bFgIgkThM
J/SvDM0FkIxRP4+BKY5fkxgNidAqWA3CnNZZxLNBZEhFeApizydASnYZyur+asYH
2WuQ+zP5DcEQTL5ehLWnwkSYdndt9A==
=VK9G
-----END PGP SIGNATURE-----

--Bu8it7iiRSEf40bY--

