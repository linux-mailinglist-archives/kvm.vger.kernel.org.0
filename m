Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7C222418C
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 19:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgGQRLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 13:11:15 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42707 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726205AbgGQRLP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Jul 2020 13:11:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595005874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2AMU7kXgsmroj3OkjSJnDrsJrfXNO1FrxQl3btc5KCM=;
        b=eL2UpPp99vO0v1aRE52LpfywLvN+SnvyhBb5O3Ncaf3+YzlQeQPJbrAaQgytde6Mxx3d7Q
        os8T2krAPyghpU+42HHlBQ8iromTg1/Mf/ezIiiL+thM1k+mqgif1MXOMhmc3ecZvr7tRZ
        6eECofhhec1F7STldPBz2Wln0pfbFus=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-XkE7hKg1OgSv7w8CgJlhmg-1; Fri, 17 Jul 2020 13:11:03 -0400
X-MC-Unique: XkE7hKg1OgSv7w8CgJlhmg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B04D08014D7;
        Fri, 17 Jul 2020 17:11:01 +0000 (UTC)
Received: from localhost (ovpn-114-107.ams2.redhat.com [10.36.114.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81E8375559;
        Fri, 17 Jul 2020 17:10:55 +0000 (UTC)
Date:   Fri, 17 Jul 2020 18:10:54 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Nikos Dragazis <ndragazis@arrikto.com>
Cc:     Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        "John G. Johnson" <john.g.johnson@oracle.com>,
        Andra-Irina Paraschiv <andraprs@amazon.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, qemu-devel@nongnu.org,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        Alexander Graf <graf@amazon.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>
Subject: Re: Inter-VM device emulation (call on Mon 20th July 2020)
Message-ID: <20200717171054.GA136776@stefanha-x1.localdomain>
References: <86d42090-f042-06a1-efba-d46d449df280@arrikto.com>
 <20200715112342.GD18817@stefanha-x1.localdomain>
 <deb5788e-c828-6996-025d-333cf2bca7ab@siemens.com>
 <20200715153855.GA47883@stefanha-x1.localdomain>
 <87y2nkwwvy.fsf@linaro.org>
 <b3efd773-c07e-8095-c1ca-5ffb894ac2ac@arrikto.com>
MIME-Version: 1.0
In-Reply-To: <b3efd773-c07e-8095-c1ca-5ffb894ac2ac@arrikto.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 17, 2020 at 11:58:40AM +0300, Nikos Dragazis wrote:
> On 15/7/20 7:44 =CE=BC.=CE=BC., Alex Benn=C3=A9e wrote:
>=20
> > Stefan Hajnoczi <stefanha@redhat.com> writes:
> >=20
> > > On Wed, Jul 15, 2020 at 01:28:07PM +0200, Jan Kiszka wrote:
> > > > On 15.07.20 13:23, Stefan Hajnoczi wrote:
> > > > > Let's have a call to figure out:
> > > > >=20
> > > > > 1. What is unique about these approaches and how do they overlap?
> > > > > 2. Can we focus development and code review efforts to get someth=
ing
> > > > >     merged sooner?
> > > > >=20
> > > > > Jan and Nikos: do you have time to join on Monday, 20th of July a=
t 15:00
> > > > > UTC?
> > > > > https://www.timeanddate.com/worldclock/fixedtime.html?iso=3D20200=
720T1500
> > > > >=20
> > > > Not at that slot, but one hour earlier or later would work for me (=
so far).
> > > Nikos: Please let us know which of Jan's timeslots works best for you=
.
> > I'm in - the earlier slot would be preferential for me to avoid clashin=
g with
> > family time.
> >=20
>=20
> I'm OK with all timeslots.

Great, let's do 16:00 UTC.

I have a meeting at 14:00 UTC so I can't make the earlier slot and it
sounds like Andra-Irina and Alexander Graf do too. Sorry, Alex (Benn=C3=A9e=
),
not optimal but it's hard to find a slot that is perfect for everyone.

Stefan

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8R254ACgkQnKSrs4Gr
c8grAAgAi2wVUmRLdx6YA+VLULX0iVZjWcEwN4qqjvrwXwEHSz5q3MRzkbZCcRI4
xvlY9ZHk279PCt2CBx8317aupxADZFUAv3N4zz+9XZnOi1A8JfOTjq40D8/9ECZG
5so8TZrZxjLo5+zXbRlwXPYTMYTbAgLy3EH/Qbj5v1oTavSVO8WcOtsGdWQo+oQm
Re/KMrIrR+vjPjO9gBuQm9+qtfEIX4W5UfLw0fPVbQeExq2sBG5JkcUA6FGoni9w
PT6hvOS50YwEbFuEgAY7zkQ0eEziBotU/5V+p6cOoBJq/JKOLXA6b9AxhnLkD+Ee
gakArk5I1uxEpq/6laYT+DqMTB102A==
=HI4C
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--

