Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18C42DCC49
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 07:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgLQGBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 01:01:11 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:58565 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbgLQGBK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 01:01:10 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4CxLvJ0mf8z9sRR; Thu, 17 Dec 2020 17:00:28 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1608184828;
        bh=f053HisAC8PbxoKtjnMPlGENN+/doGlZH5baP74TMbE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=goDpN05Yaa6hPcLfAQxWGknmnLRAIx9dvSty7LP942NkqwJDSbl1l1gCeaik6AVnU
         q7+W9AdIz4JdBanf8T8hEa2JNDmr00ZTTBhoY5HQNPLP15BXKfI+BkEVZ+8rhRZpiR
         xMokVghWz98FATiuUksdhbwutN4OZpJTukHfrSLI=
Date:   Thu, 17 Dec 2020 16:53:38 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        pair@us.ibm.com, brijesh.singh@amd.com, frankja@linux.ibm.com,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, david@redhat.com,
        dgilbert@redhat.com, Eduardo Habkost <ehabkost@redhat.com>,
        qemu-devel@nongnu.org, qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        berrange@redhat.com, thuth@redhat.com, pbonzini@redhat.com,
        rth@twiddle.net, mdroth@linux.vnet.ibm.com
Subject: Re: [for-6.0 v5 12/13] securable guest memory: Alter virtio default
 properties for protected guests
Message-ID: <20201217055338.GI310465@yekko.fritz.box>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
 <20201204054415.579042-13-david@gibson.dropbear.id.au>
 <d739cae2-9197-76a5-1c19-057bfe832187@de.ibm.com>
 <20201204091706.4432dc1e.cohuck@redhat.com>
 <038214d1-580d-6692-cd1e-701cd41b5cf8@de.ibm.com>
 <20201204154310.158b410e.pasic@linux.ibm.com>
 <20201208015403.GB2555@yekko.fritz.box>
 <20201208112829.0f8fcdf4.pasic@linux.ibm.com>
 <20201208135005.100d56fb.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cVp8NMj01v+Em8Se"
Content-Disposition: inline
In-Reply-To: <20201208135005.100d56fb.cohuck@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--cVp8NMj01v+Em8Se
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 08, 2020 at 01:50:05PM +0100, Cornelia Huck wrote:
> On Tue, 8 Dec 2020 11:28:29 +0100
> Halil Pasic <pasic@linux.ibm.com> wrote:
>=20
> > On Tue, 8 Dec 2020 12:54:03 +1100
> > David Gibson <david@gibson.dropbear.id.au> wrote:
> >=20
> > > > > >>> +         * Virtio devices can't count on directly accessing =
guest
> > > > > >>> +         * memory, so they need iommu_platform=3Don to use n=
ormal DMA
> > > > > >>> +         * mechanisms.  That requires also disabling legacy =
virtio
> > > > > >>> +         * support for those virtio pci devices which allow =
it.
> > > > > >>> +         */
> > > > > >>> +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable=
-legacy",
> > > > > >>> +                                   "on", true);
> > > > > >>> +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iomm=
u_platform",
> > > > > >>> +                                   "on", false);     =20
> > > > > >>
> > > > > >> I have not followed all the history (sorry). Should we also se=
t iommu_platform
> > > > > >> for virtio-ccw? Halil?
> > > > > >>   =20
> > > > > >=20
> > > > > > That line should add iommu_platform for all virtio devices, sho=
uldn't
> > > > > > it?   =20
> > > > >=20
> > > > > Yes, sorry. Was misreading that with the line above.=20
> > > > >    =20
> > > >=20
> > > > I believe this is the best we can get. In a sense it is still a
> > > > pessimization,   =20
> > >=20
> > > I'm not really clear on what you're getting at here. =20
> >=20
> > By pessimiziation, I mean that we are going to indicate
> > _F_PLATFORM_ACCESS even if it isn't necessary, because the guest never
> > opted in for confidential/memory protection/memory encryption. We have
> > discussed this before, and I don't see a better solution that works for
> > everybody.
>=20
> If you consider specifying the secure guest option as a way to tell
> QEMU to make everything ready for running a secure guest, I'd certainly
> consider it necessary. If you do not want to force it, you should not
> do the secure guest preparation setup.

Right, that's my feeling as well.

I'm also of the opinion that !F_PLATFORM_ACCESS is kind of a nasty
hack that has some other problems (e.g. it means an L1 can't safely
pass the device into an L2).

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--cVp8NMj01v+Em8Se
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl/a8mIACgkQbDjKyiDZ
s5JiQxAArukILcLSGnwHWTNQEamXCCRO2x3cVi/gp2M/5nIJG1s1uvIsiG0LzGNE
awUDnvRiK72sQSaclAeXA7mf/B7GLmbdgY2zh9TaheNhOEjtSJ2gPs54s/5iaPgh
BqiwZt+O54Zec5WmloAUWB+N8mk+6TJGYWWSyenP9VUEN0pbRZs9KNs2wyPGhAQc
NPZAkZWZ4tS6U2JLxj4AN6Z6J4J2D8cPFJA+3+yPM8ECL2O5oJweI/XsKEwnDgQW
UTg970vC4eE50fhyLvZO4YW7xKx1saoHXRJ3257mo7yIPpBPGLva4b6dVpnKH4SD
Tb5KRV8DmuKh9lLMSJCcnfyBfj/hjh2EExJUIokj25Le81s0mnahbL4X1PnWyovn
MM2o+DNPEsoizEiVF129iOwSr2vOcZKT4jvvVw5pAazhmjXO8ozi6sSI96PVkqvb
NwRrMBaOp/ZfijiD5ZkJ3PUkQ0o6UfehAmvsAXfFGlh4tu495S1ZzviWy4+cTuGx
UG0pXX/8Tp0a7YSMRKWI2PD1R4L4GTqcjJnW0sbSs+TaSaysC2tKn35OJC51gRtb
2gFNvvM+a+j+CymRYu1uwE/jX6rlnARt4QQBub5AqY1M0ejulI9+FJqz7a36DbJy
0mrWyQrzeIiDd/UVG0KED6P80aBcIwqQolUCrHrUxd+9rRrbhbk=
=PR0/
-----END PGP SIGNATURE-----

--cVp8NMj01v+Em8Se--
