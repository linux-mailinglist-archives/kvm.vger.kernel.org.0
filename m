Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402E5275425
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 11:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgIWJOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 05:14:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36630 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726242AbgIWJOb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 05:14:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600852470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wHsRYwC30JIrbWlzcK3Pgf3/G4Enl84VFctA9JFCc0g=;
        b=MC9yNib0oTSI3F4y1z7sUiUaMaOEfYx3v84p4gIZjdoYpcQIAM7x2lDmoltGQY2G3RXgWv
        /222ouZXKmCSB7oVSWR3eTMwHBRPyEI9OCkckjoW5JbnDASnDPSqfRRaQB0SYBTRcA3rzn
        0OvqgYdivvI4VmlLec7A30Na9LO+zE4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-_PqHLbaiMC6IfjTHJ7cS1A-1; Wed, 23 Sep 2020 05:14:28 -0400
X-MC-Unique: _PqHLbaiMC6IfjTHJ7cS1A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8E191891E83;
        Wed, 23 Sep 2020 09:14:23 +0000 (UTC)
Received: from localhost (ovpn-114-98.ams2.redhat.com [10.36.114.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BFE345577A;
        Wed, 23 Sep 2020 09:14:08 +0000 (UTC)
Date:   Wed, 23 Sep 2020 10:14:07 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        sheepdog@lists.wpkg.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Yuval Shaia <yuval.shaia.ml@gmail.com>,
        Markus Armbruster <armbru@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Alberto Garcia <berto@igalia.com>,
        Sagar Karandikar <sagark@eecs.berkeley.edu>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Juan Quintela <quintela@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, Paul Durrant <paul@xen.org>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Huth <thuth@redhat.com>,
        =?iso-8859-1?Q?Marc-Andr=E9?= Lureau 
        <marcandre.lureau@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Stefan Weil <sw@weilnetz.de>, Peter Lieven <pl@kamp.de>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-s390x@nongnu.org, qemu-arm@nongnu.org,
        Liu Yuan <namei.unix@gmail.com>, qemu-riscv@nongnu.org,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        John Snow <jsnow@redhat.com>,
        Hailiang Zhang <zhang.zhanghailiang@huawei.com>,
        Richard Henderson <rth@twiddle.net>,
        Kevin Wolf <kwolf@redhat.com>, qemu-block@nongnu.org,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Max Reitz <mreitz@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        xen-devel@lists.xenproject.org,
        Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: [PATCH] qemu/atomic.h: prefix qemu_ to solve <stdatomic.h>
 collisions
Message-ID: <20200923091407.GC16268@stefanha-x1.localdomain>
References: <20200921162346.188997-1-stefanha@redhat.com>
 <c8892b73-6cee-9fd3-54b0-289149926041@redhat.com>
 <52b8a46e-ab9e-1645-163d-497122ece907@redhat.com>
 <8610ca0e-0b3f-6d95-43b9-e2e49571e311@redhat.com>
 <20200922081849.GD1989025@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200922081849.GD1989025@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/Uq4LBwYP4y1W6pO"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--/Uq4LBwYP4y1W6pO
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2020 at 09:18:49AM +0100, Daniel P. Berrang=E9 wrote:
> On Tue, Sep 22, 2020 at 08:56:06AM +0200, Paolo Bonzini wrote:
> > On 22/09/20 08:45, David Hildenbrand wrote:
> > >> It's certainly a good idea but it's quite verbose.
> > >>
> > >> What about using atomic__* as the prefix?  It is not very common in =
QEMU
> > >> but there are some cases (and I cannot think of anything better).
> > >
> > > aqomic_*, lol :)
> >=20
> > Actually qatomic_ would be a good one, wouldn't it?
>=20
> Yes, I think just adding a 'q' on the front of methods is more than
> sufficient (see also all the qcrypto_*, qio_* APIs I wrote). The
> only think a plain 'q' prefix is likely to clash with is the Qt
> library and that isn't something we're likely to link with (famous
> last words...).

This is why I didn't use "qatomic". "atomic" feels too common to prefix
with just a single letter.

But I grepped /usr/include and code searched GitHub. I can't find any
uses of "qatomic_" so it looks safe. FWIW Qt does have qatomic.h but
doesn't use the name for identifiers in the code.

Let's do it!

Stefan

--/Uq4LBwYP4y1W6pO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl9rEd8ACgkQnKSrs4Gr
c8hx6QgAmcq3iyL/5X+5ylXdiawWVoC4zV4zxgyO20rzguAaBuIPYnGrzO9/5k7b
rFywg6HbM8SPy+iaRqL1fbemPxvySlHdd3zOIrMQYrTk1HJoijxenSMZpnBWxIWx
sN3WONGXmgL54kx8RC6nTmmzXOtz9OLX4koU9c3YwNGWyQchI6+1yEuw0HjqMZmS
DfBOC/syGd7IbE9PoqGcLZMHujPpvCVK+y2CS3WLZZiZXDvqLwiyB8ZX1Bjp0qUG
MKOZYfE3t+SaqkHIF7lswCwQt+3gZf2zj2KUxOKFGcRgEOKekklzST8yHA1kYR4u
EfnQANnly2evsXyGBwQBzh15Isi/RA==
=jOfu
-----END PGP SIGNATURE-----

--/Uq4LBwYP4y1W6pO--

