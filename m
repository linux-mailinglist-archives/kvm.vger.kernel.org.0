Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D5A34D4B4
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 18:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhC2QSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 12:18:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33806 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229502AbhC2QR5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 12:17:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617034675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=afFiru8tgewiCPEWvVuZJcoILIxwgOgjKVHcSX1Mu/I=;
        b=JqS8BPdOaTX5nWLeCsEEnvd382a/AACXD/ah7sYq3nJNofAcc6KUGtbnXzs86Qi0AOU9Gt
        uKmG6bhQA72ymrX187ukpkF49gIVxPvdOFGwY3eQmL0o7QUCmJiarn3sH+fLBKia8fgIwe
        bQd2gdsrKrGcrq7j0bUcUMC1fypfi4w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-TdxLCmguO12pLsLjNrScaw-1; Mon, 29 Mar 2021 12:17:39 -0400
X-MC-Unique: TdxLCmguO12pLsLjNrScaw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3DF91085943;
        Mon, 29 Mar 2021 16:17:38 +0000 (UTC)
Received: from localhost (ovpn-114-227.ams2.redhat.com [10.36.114.227])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 674B160C13;
        Mon, 29 Mar 2021 16:17:35 +0000 (UTC)
Date:   Mon, 29 Mar 2021 17:17:34 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        jag.raman@oracle.com, elena.ufimtseva@oracle.com,
        pbonzini@redhat.com, mst@redhat.com, cohuck@redhat.com,
        john.levon@nutanix.com
Subject: Re: [RFC v3 3/5] KVM: implement wire protocol
Message-ID: <YGH9niCJ9J1DiPtb@stefanha-x1.localdomain>
References: <cover.1613828726.git.eafanasova@gmail.com>
 <dad3d025bcf15ece11d9df0ff685e8ab0a4f2edd.1613828727.git.eafanasova@gmail.com>
 <f9b5c5cf-63a4-d085-8c99-8d03d29d3f58@redhat.com>
 <5c1c5682b29558a8d2053b4201fbb135e9a61790.camel@gmail.com>
 <24e7211c-e168-3f47-f789-5f1d743d79c5@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eSCY88W5gB26qvsn"
Content-Disposition: inline
In-Reply-To: <24e7211c-e168-3f47-f789-5f1d743d79c5@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--eSCY88W5gB26qvsn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 26, 2021 at 02:21:29PM +0800, Jason Wang wrote:
>=20
> =E5=9C=A8 2021/3/17 =E4=B8=8B=E5=8D=889:08, Elena Afanasova =E5=86=99=E9=
=81=93:
> > On Tue, 2021-03-09 at 14:19 +0800, Jason Wang wrote:
> > > On 2021/2/21 8:04 =E4=B8=8B=E5=8D=88, Elena Afanasova wrote:
> > > > Add ioregionfd blocking read/write operations.
> > > >=20
> > > > Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> > > > ---
> > > > v3:
> > > >    - change wire protocol license
> > > >    - remove ioregionfd_cmd info and drop appropriate macros
> > > >    - fix ioregionfd state machine
> > > >    - add sizeless ioregions support
> > > >    - drop redundant check in ioregion_read/write()
> > > >=20
> > > >    include/uapi/linux/ioregion.h |  30 +++++++
> > > >    virt/kvm/ioregion.c           | 162
> > > > +++++++++++++++++++++++++++++++++-
> > > >    2 files changed, 190 insertions(+), 2 deletions(-)
> > > >    create mode 100644 include/uapi/linux/ioregion.h
> > > >=20
> > > > diff --git a/include/uapi/linux/ioregion.h
> > > > b/include/uapi/linux/ioregion.h
> > > > new file mode 100644
> > > > index 000000000000..58f9b5ba6186
> > > > --- /dev/null
> > > > +++ b/include/uapi/linux/ioregion.h
> > > > @@ -0,0 +1,30 @@
> > > > +/* SPDX-License-Identifier: ((GPL-2.0-only WITH Linux-syscall-
> > > > note) OR BSD-3-Clause) */
> > > > +#ifndef _UAPI_LINUX_IOREGION_H
> > > > +#define _UAPI_LINUX_IOREGION_H
> > > > +
> > > > +/* Wire protocol */
> > > > +
> > > > +struct ioregionfd_cmd {
> > > > +	__u8 cmd;
> > > > +	__u8 size_exponent : 4;
> > > > +	__u8 resp : 1;
> > > > +	__u8 padding[6];
> > > > +	__u64 user_data;
> > > > +	__u64 offset;
> > > > +	__u64 data;
> > > > +};
> > > Sorry if I've asked this before. Do we need a id for each
> > > request/response? E.g an ioregion fd could be used by multiple
> > > vCPUS.
> > > VCPU needs to have a way to find which request belongs to itself or
> > > not?
> > >=20
> > I don=E2=80=99t think the id is necessary here since all requests/respo=
nses are
> > serialized.
>=20
>=20
> It's probably fine for the first version but it will degrate the performa=
nce
> e.g if the ioregionfd is used for multiple queues (e.g doorbell). The des=
ign
> should have the capability to allow the extension like this.

If there is only one doorbell register and one ioregionfd then trying to
process multiple queues in userspace is going to be slow. Adding cmd IDs
doesn't fix this because userspace won't be able to destribute cmds to
multiple queue threads efficiently.

Multiple queues should either use multiple doorbell registers or
ioregionfd needs something like datamatch to dispatch the MMIO/PIO
access to the appropriate queue's ioregionfd. In both cases cmd IDs
aren't necessary.

Can you think of a case where cmd IDs are needed?

Stefan

--eSCY88W5gB26qvsn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBh/Z0ACgkQnKSrs4Gr
c8hR0AgAx51ZwhqQhykMXbQny17AtdsipxDudNLuYdEtVUUV9JMipDnKnVBbU1gm
075DJpPu+BTVdhowv1SR7sVlzTxD3IsyLUj0+SCuiwOc6ecOmnVA3oLS+FWYQfR4
tGQYO4XDb+UWPRiYSBe8Rfo6Osy4qvPrZP/eX0cqUoqWChg7FDFZPPdPg40o8Beu
yJ8l5R3bAggCxFDtB95jdI9Os5VKArL0VOcuccXcqrHjQw4SFRY9d35LIZ4eQw5/
/gjuL04JrIMgj5qDdQUK/BcnNfMbMGZ0h01kD9VvC6lxI3N2ADwtBwbbaYHaIvI1
K67WOIwAGpFqKSnwrS8SQ1fMjW6eOA==
=KRTL
-----END PGP SIGNATURE-----

--eSCY88W5gB26qvsn--

