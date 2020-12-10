Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7D42D59DB
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 12:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730400AbgLJL5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 06:57:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20476 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728919AbgLJL5X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 06:57:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607601357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MucEp2q9Z+8tlAqhqnNq4svdhUxR95XxXhNV9vCD9Kw=;
        b=AawT2yy4bTD/g7BDeMAD9KP7DrXk+Jk3Z2yXX2+HXptsD3HHElzuB28dd39JtOHzAPD8BG
        C2QTgL9ha5rolB3lUk2aJ9/XVfOhS7/44Nx3w6DT6+qzUVxclBxhBsvzR0tDd7n6MHj1ac
        GmWv9JMwxKhoi3LumUUq5WI6gLY9eY0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-Iu-oSkLwM9qwB-9bm14vaA-1; Thu, 10 Dec 2020 06:55:55 -0500
X-MC-Unique: Iu-oSkLwM9qwB-9bm14vaA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14D46100C605;
        Thu, 10 Dec 2020 11:55:52 +0000 (UTC)
Received: from localhost (ovpn-113-62.ams2.redhat.com [10.36.113.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 568F419C78;
        Thu, 10 Dec 2020 11:55:48 +0000 (UTC)
Date:   Thu, 10 Dec 2020 11:55:47 +0000
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
Subject: Re: [RFC PATCH 13/27] vhost: Send buffers to device
Message-ID: <20201210115547.GH416119@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com>
 <20201120185105.279030-14-eperezma@redhat.com>
 <20201208081621.GR203660@stefanha-x1.localdomain>
 <CAJaqyWf13ta5MtzmTUz2N5XnQ+ebqFPYAivdggL64LEQAf=y+A@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJaqyWf13ta5MtzmTUz2N5XnQ+ebqFPYAivdggL64LEQAf=y+A@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="y0Ed1hDcWxc3B7cn"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--y0Ed1hDcWxc3B7cn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 09, 2020 at 07:41:23PM +0100, Eugenio Perez Martin wrote:
> On Tue, Dec 8, 2020 at 9:16 AM Stefan Hajnoczi <stefanha@gmail.com> wrote=
:
> > On Fri, Nov 20, 2020 at 07:50:51PM +0100, Eugenio P=E9rez wrote:
> > > +        while (true) {
> > > +            int r;
> > > +            if (virtio_queue_full(vq)) {
> > > +                break;
> > > +            }
> >
> > Why is this check necessary? The guest cannot provide more descriptors
> > than there is ring space. If that happens somehow then it's a driver
> > error that is already reported in virtqueue_pop() below.
> >
>=20
> It's just checked because virtqueue_pop prints an error on that case,
> and there is no way to tell the difference between a regular error and
> another caused by other causes. Maybe the right thing to do is just to
> not to print that error? Caller should do the error printing in that
> case. Should we return an error code?

The reason an error is printed today is because it's a guest error that
never happens with correct guest drivers. Something is broken and the
user should know about it.

Why is "virtio_queue_full" (I already forgot what that actually means,
it's not clear whether this is referring to avail elements or used
elements) a condition that should be silently ignored in shadow vqs?

Stefan

--y0Ed1hDcWxc3B7cn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/SDMMACgkQnKSrs4Gr
c8g6rQgAoyNP4PVcZp9IjF/ZpHcUkbIw8vq2zHMVYynE086IcL4SufcLEwnibkyk
6zkRHz9diZrDtE8JiVVDCgd335nP1fB5Gc6QtuTy6TP03GFD7jRCBtFuWZz0zPNJ
EhBn7yQGyh2MI6U5qE4cIZso2KQO0KxgU/TGSMcwY5dErD/LvDh+WZBIUVqpJvem
5/uSCeSkVXyHIwMzsTYV770Ja7yiiOeNSsODlonzy7GfBg05wnh7SCtVbyiKcvTF
n4KEqDQyurGvMZg4tExPxNL04bu9AAPvdK1QGjAfPdufdAPllV4xfiUEI5sOM9l1
N3hvUjX/foOV3ccIX3dyrNyRIa/mgA==
=x9KI
-----END PGP SIGNATURE-----

--y0Ed1hDcWxc3B7cn--

