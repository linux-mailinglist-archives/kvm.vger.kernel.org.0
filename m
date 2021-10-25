Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12C1439C25
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 18:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbhJYQ7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 12:59:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60118 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234047AbhJYQ7E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 12:59:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635180999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gy/tPJm5wrnT5rvwJGt71DHUl6kk6qEeUFUy+P7Hr5k=;
        b=TCfeuvv57LqKyzmYoWGiBfJ4CDJTKtn3OapcC/ewBQO+F/6nEgK24VC/K9Kuh2uc6YHKEl
        pqhnyToR57DllhLS7lbO6HhQEvkQSSmEaSS0KihqhiC21o7OTioZiWKQoMI0YOUglaZOmi
        H3POn3/nIoaf8JNuaaUBDLwJaUozDVU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-Kkp5gGrFMQyd3J0qOxa3PQ-1; Mon, 25 Oct 2021 12:56:35 -0400
X-MC-Unique: Kkp5gGrFMQyd3J0qOxa3PQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5731318D6A2C;
        Mon, 25 Oct 2021 16:56:33 +0000 (UTC)
Received: from localhost (unknown [10.39.192.215])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC9945D9D5;
        Mon, 25 Oct 2021 16:56:13 +0000 (UTC)
Date:   Mon, 25 Oct 2021 17:56:12 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Elena <elena.ufimtseva@oracle.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, mst@redhat.com,
        john.g.johnson@oracle.com, dinechin@redhat.com, cohuck@redhat.com,
        jasowang@redhat.com, felipe@nutanix.com, jag.raman@oracle.com,
        eafanasova@gmail.com
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
Message-ID: <YXbhrJDTBu6AQsuF@stefanha-x1.localdomain>
References: <88ca79d2e378dcbfb3988b562ad2c16c4f929ac7.camel@gmail.com>
 <YWUeZVnTVI7M/Psr@heatpipe>
 <YXamUDa5j9uEALYr@stefanha-x1.localdomain>
 <20211025152122.GA25901@nuker>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="63SiROHZXyxNKkHV"
Content-Disposition: inline
In-Reply-To: <20211025152122.GA25901@nuker>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--63SiROHZXyxNKkHV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 25, 2021 at 08:21:22AM -0700, Elena wrote:
> On Mon, Oct 25, 2021 at 01:42:56PM +0100, Stefan Hajnoczi wrote:
> > On Mon, Oct 11, 2021 at 10:34:29PM -0700, elena wrote:
> > > On Wed, Nov 25, 2020 at 12:44:07PM -0800, Elena Afanasova wrote:
> > > > Hello,
> > > >
> > >=20
> > > Hi
> > >=20
> > > Sorry for top-posting, just wanted to provide a quik update.
> > > We are currently working on the support for ioregionfd in Qemu and wi=
ll
> > > be posting the patches soon. Plus the KVM patches will be posted based
> > > of the RFC v3 with some fixes if there are no objections from Elena's=
 side
> > > who originally posted KVM RFC patchset.
> >=20
> > Hi Elena,
>=20
> Hello Stefan.
>=20
> > I'm curious what approach you want to propose for QEMU integration. A
> > while back I thought about the QEMU API. It's possible to implement it
> > along the lines of the memory_region_add_eventfd() API where each
> > ioregionfd is explicitly added by device emulation code. An advantage of
> > this approach is that a MemoryRegion can have multiple ioregionfds, but
> > I'm not sure if that is a useful feature.
> >
>=20
> This is the approach that is currently in the works. Agree, I dont see
> much of the application here at this point to have multiple ioregions
> per MemoryRegion.
> I added Memory API/eventfd approach to the vfio-user as well to try
> things out.
>=20
> > An alternative is to cover the entire MemoryRegion with one ioregionfd.
> > That way the device emulation code can use ioregionfd without much fuss
> > since there is a 1:1 mapping between MemoryRegions, which are already
> > there in existing devices. There is no need to think deeply about which
> > ioregionfds to create for a device.
> >
> > A new API called memory_region_set_aio_context(MemoryRegion *mr,
> > AioContext *ctx) would cause ioregionfd (or a userspace fallback for
> > non-KVM cases) to execute the MemoryRegion->read/write() accessors from
> > the given AioContext. The details of ioregionfd are hidden behind the
> > memory_region_set_aio_context() API, so the device emulation code
> > doesn't need to know the capabilities of ioregionfd.
>=20
> >=20
> > The second approach seems promising if we want more devices to use
> > ioregionfd inside QEMU because it requires less ioregionfd-specific
> > code.
> >=20
> I like this approach as well.
> As you have mentioned, the device emulation code with first approach
> does have to how to handle the region accesses. The second approach will
> make things more transparent. Let me see how can I modify what there is
> there now and may ask further questions.

Thanks, I look forward to patches you are working on!

Stefan

--63SiROHZXyxNKkHV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmF24awACgkQnKSrs4Gr
c8hQAQf8DVrkwvoSkLStUhByGMfGnrHMpU8Sl0QH4rAmcfnvJ4RlKOLqN7uMAyjk
fEx9R20fRPP7Pd2lgt/7EuKMfQhluh24RvWtnZRaMoj5h2JkrYKeASK606LE4rhB
a0JYQZhcoqu07kAusyUEQ3KdAukHBLWaOG48LvrVSb4Bi1f6oijmsfJUlT242hgK
i07Z5I6ePVQuld0lrh/i6SExErO6f2giwq2QmujQKWVDKku59PE0BR6YgCTVuEoL
mKRKrq1+5W4bpOL5xaoM4xm2bWyy3EsFbPwJTyn0hVOyBgSxoaXpEYGtdsIvpWSF
L48OwyICKrG4JauEyK8I9lSFc+KgCQ==
=hHQl
-----END PGP SIGNATURE-----

--63SiROHZXyxNKkHV--

