Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A512D594B
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 12:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389556AbgLJLdR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 06:33:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43410 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727007AbgLJLdD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 06:33:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607599897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0vpeFoxvipiFfHjrK3SmcHRfsuQ3JzQdub6tkzQBRZk=;
        b=Q6al0xrUQUAl2OiNHSpxbSaWIdcHwo6D06pJ84r3GgVqIi9Q3yE59sOJ5Yi2K0jRELBLQG
        d66Yl2oznFlA0vbQIOPEN0vwwhNFGI3VvESMpMqymT8nKoYw6KI10mhChHFjrUvY4Jy+yy
        e5WRxMCuPB2cIT9QU9HDUI+7cJT48HU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-IPyTpgFpPWuti1cYkS4kHA-1; Thu, 10 Dec 2020 06:31:33 -0500
X-MC-Unique: IPyTpgFpPWuti1cYkS4kHA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0353810CE7BC;
        Thu, 10 Dec 2020 11:30:53 +0000 (UTC)
Received: from localhost (ovpn-113-62.ams2.redhat.com [10.36.113.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 380665D9DD;
        Thu, 10 Dec 2020 11:30:52 +0000 (UTC)
Date:   Thu, 10 Dec 2020 11:30:51 +0000
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
Subject: Re: [RFC PATCH 05/27] vhost: Add hdev->dev.sw_lm_vq_handler
Message-ID: <20201210113051.GF416119@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com>
 <20201120185105.279030-6-eperezma@redhat.com>
 <20201207165216.GL203660@stefanha-x1.localdomain>
 <CAJaqyWfSUHD0MU=1yfU1N6pZ4TU7prxyoG6NY-VyNGt=MO9H4g@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJaqyWfSUHD0MU=1yfU1N6pZ4TU7prxyoG6NY-VyNGt=MO9H4g@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wtjvnLv0o8UUzur2"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--wtjvnLv0o8UUzur2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 09, 2020 at 04:02:56PM +0100, Eugenio Perez Martin wrote:
> On Mon, Dec 7, 2020 at 5:52 PM Stefan Hajnoczi <stefanha@gmail.com> wrote=
:
> > On Fri, Nov 20, 2020 at 07:50:43PM +0100, Eugenio P=E9rez wrote:
> > > diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
> > > index 9179013ac4..9a69ae3598 100644
> > > --- a/hw/net/virtio-net.c
> > > +++ b/hw/net/virtio-net.c
> > > @@ -2628,24 +2628,32 @@ static void virtio_net_tx_bh(void *opaque)
> > >      }
> > >  }
> > >
> > > -static void virtio_net_add_queue(VirtIONet *n, int index)
> > > +static void virtio_net_add_queue(VirtIONet *n, int index,
> > > +                                 VirtIOHandleOutput custom_handler)
> > >  {
> >
> > We talked about the possibility of moving this into the generic vhost
> > code so that devices don't need to be modified. It would be nice to hid=
e
> > this feature inside vhost.
>=20
> I'm thinking of tying it to VirtQueue, allowing the caller to override
> the handler knowing it is not going to be called (I mean, not offering
> race conditions protection, like before of starting processing
> notifications in qemu calling vhost_dev_disable_notifiers).

Yes, I can see how at least part of this belongs to VirtQueue.

Stefan

--wtjvnLv0o8UUzur2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/SBusACgkQnKSrs4Gr
c8iLwgf/aaGiY0DHn8I8FYdQGoreiYRr1SK+yJ4QWre7tvYsACl3EXz8Uq2PKZRo
+7NkNHIwhXEpcb1usOfH5PrUw4pRoMH78oQckxlnJtoQOdKiYi1SikAQKxOrooRs
Cn4E2SA9vVnDyCa0ZFs83GkRJyhnsLfs/AOYtWk/t2JdxzXWZhbewHgI3lUhy5qN
nLo/wINyWrndWt1HoI7HFbe82IDwhpwh5ACBxlb5579HaSwJsI/HX4k+jcHEJGAl
S7wSdufuVz9xzQ07r3fIWjTh9GsVJRJhHS3cfUcYmL/7CbmkGxYOiHPveHLEPogL
0G812OH8HJc+Hde+Ce/yAwlHGjXPFw==
=/sJb
-----END PGP SIGNATURE-----

--wtjvnLv0o8UUzur2--

