Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD376105E1A
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 02:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfKVBSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 20:18:35 -0500
Received: from ozlabs.org ([203.11.71.1]:41155 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbfKVBSf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 20:18:35 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 47Jz8S3BbDz9sPc; Fri, 22 Nov 2019 12:18:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1574385512;
        bh=KdifFQ/CVA5FEDqGjslXCMovs4mIoW+xiz6Ia0QVjJc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WZ5445b3MQQphhzUfciMmBVcuA2w/zSfXilrZk9wb6sf6zMiieRNCVAF9Nxq6IZzk
         AKsOr5LFY176dFB++k572XGc29eEXwGltIGnt8WqrjZLv5iBiKDVjjJ5ahNmAkkBcF
         65tq5ixmm4kvLd+7la6xoSpYs/G4p96ElJWF2fFo=
Date:   Fri, 22 Nov 2019 12:18:24 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     clg@kaod.org, groug@kaod.org, philmd@redhat.com,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, Riku Voipio <riku.voipio@iki.fi>,
        =?iso-8859-1?Q?Marc-Andr=E9?= Lureau 
        <marcandre.lureau@redhat.com>
Subject: Re: [PATCH 0/5] vfio/spapr: Handle changes of master irq chip for
 VFIO devices
Message-ID: <20191122011824.GX5582@umbus.fritz.box>
References: <20191121005607.274347-1-david@gibson.dropbear.id.au>
 <20191121095738.71f90700@x1.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TSjqTFuQ28AYToVG"
Content-Disposition: inline
In-Reply-To: <20191121095738.71f90700@x1.home>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--TSjqTFuQ28AYToVG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 21, 2019 at 09:57:38AM -0700, Alex Williamson wrote:
> On Thu, 21 Nov 2019 11:56:02 +1100
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
> > Due to the way feature negotiation works in PAPR (which is a
> > paravirtualized platform), we can end up changing the global irq chip
> > at runtime, including it's KVM accelerate model.  That causes
> > complications for VFIO devices with INTx, which wire themselves up
> > directly to the KVM irqchip for performance.
> >=20
> > This series introduces a new notifier to let VFIO devices (and
> > anything else that needs to in the future) know about changes to the
> > master irqchip.  It modifies VFIO to respond to the notifier,
> > reconnecting itself to the new KVM irqchip as necessary.
> >=20
> > In particular this removes a misleading (though not wholly inaccurate)
> > warning that occurs when using VFIO devices on a pseries machine type
> > guest.
> >=20
> > Open question: should this go into qemu-4.2 or wait until 5.0?  It's
> > has medium complexity / intrusiveness, but it *is* a bugfix that I
> > can't see a simpler way to fix.  It's effectively a regression from
> > qemu-4.0 to qemu-4.1 (because that introduced XIVE support by
> > default), although not from 4.1 to 4.2.
>=20
> Looks reasonable to me for 4.2, the vfio changes are not as big as they
> appear.  If Paolo approves this week, I can send a pull request,
> otherwise I can leave my ack for someone else as I'll be on PTO/holiday
> next week.  Thanks,

I'm happy to take it through my tree, and expect to be sending a PR in
that timescale, so an ack sounds good.

I've pulled the series into my ppc-for-4.2 branch tentatively.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--TSjqTFuQ28AYToVG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl3XN2AACgkQbDjKyiDZ
s5Idrg//Zi3qN0NY13bJ7dayNXGDN0HmvV/p9pq189gpWGVrZZoONYrSOcIiiRUm
edRPMhyQfKFYpkIVpoU95cJKmLpzbYh25DsTWS8Q9iqlNbWlBJ2ER4q84NU719aK
LkSiwV35UCEWE+BJTmCRWhc3sw66+DgPJN3LiazovGySRu6JEk/obuxs2gKhx7IJ
kX69lF0Y2/hXjRcz0tb4yt/sAcPNO2/YPdbcgl0+W58s4MTYfvpZlgU5JaCC9qFJ
63bPkLNM/agyfhXOCsrptnU1uXwCatVEcNpQOwU2hCS8d+Akjg8Y7FSiZtE3E+D/
HeUNmulsav6SurXTLRvJo5m346b8BfgmwNOkV3SCaSGJYW1cz/LxG/y51v0A4gPt
6NU4ec7GGNQnCDIM9D3KHnuQAY9IJnLuGOV+zShXYacoYdAU3ZMSkq6JZyqTf2Jt
jBlYCCzku0wd3DQU/iUIp/ClMbnJNambcppim2HNQNp37JxFYw3Y2jzrnbNcIRvK
sOUrGGVNfKRz9GFbvXkD/tRvRdxP5y8mZ1qhh33X3w0PpXEKJ69G+FPzfMARCQlw
cZRDDAdHebQK+8ePplR5eH3hs8iX8o74Pdo2tXuVvRPU/7MCU924XFDIanG3yEsa
Zz1EKdxOA60JeeliL4ljQBBxSkvSBK3bRVcr25Gy3LH8y6gW1WQ=
=U4IZ
-----END PGP SIGNATURE-----

--TSjqTFuQ28AYToVG--
