Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 276A627C45
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 13:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730369AbfEWL4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 07:56:45 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:34059 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729698AbfEWL4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 07:56:44 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 458nzF42Z1z9s4V; Thu, 23 May 2019 21:56:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1558612601;
        bh=YFHaKAHwSkkNV01pYtDLBmlGW8tDfBU5zHN14Jech/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cRTr4603N7N0NAWy9HE9tGd+GYfZOqgmMD/dAGxIN+xOaLn5TiiEqgmuMtaeBxTWk
         Yc4VNThu0g1ATCaZ5OIzXWEtm0D6Vaolly2lCmMPtRKwMis1DaQjphmpQSqx2jIxvl
         6XIWir3CMxvxaaiAnOcdzBf4ckpyBj7sd3+fkfqs=
Date:   Thu, 23 May 2019 16:27:15 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Greg Kurz <groug@kaod.org>
Cc:     =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: PPC: Book3S HV: XIVE: assorted fixes on vCPU
 and RAM limits
Message-ID: <20190523062715.GR30423@umbus.fritz.box>
References: <20190520071514.9308-1-clg@kaod.org>
 <20190522233043.GO30423@umbus.fritz.box>
 <20190523080123.6e700a1e@bahia.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BZziOT8Kz25R/m/E"
Content-Disposition: inline
In-Reply-To: <20190523080123.6e700a1e@bahia.lan>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--BZziOT8Kz25R/m/E
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 23, 2019 at 08:01:23AM +0200, Greg Kurz wrote:
> On Thu, 23 May 2019 09:30:43 +1000
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
> > On Mon, May 20, 2019 at 09:15:11AM +0200, C=E9dric Le Goater wrote:
> > > Hello,
> > >=20
> > > Here are a couple of fixes for issues in the XIVE KVM device when
> > > testing the limits : RAM size and number of vCPUS. =20
> >=20
> > How serious are the problems these patches fix?  I'm wondering if I
> > need to make a backport for RHEL8.1.
> >=20
>=20
> Patch 2/3 fixes a QEMU error when hot-unplugging a vCPU:
>=20
> qemu-system-ppc64: KVM_SET_DEVICE_ATTR failed: Group 4 attr 0x00000000000=
00046: Invalid argument
>=20
>=20
> Patch 3/3 fixes an issue where the guest freezes at some point when doing
> vCPU hot-plug/unplug in a loop.

Oh.. weird.  It's not clear to me how it would do that.

> Both issues have a BZ at IBM. They can be mirrored to RH if needed.

That would be helpful, thanks.




>=20
> > >=20
> > > Based on 5.2-rc1.
> > >=20
> > > Available on GitHub:
> > >=20
> > >     https://github.com/legoater/linux/commits/xive-5.2
> > >=20
> > > Thanks,
> > >=20
> > > C.=20
> > >=20
> > > C=E9dric Le Goater (3):
> > >   KVM: PPC: Book3S HV: XIVE: clear file mapping when device is releas=
ed
> > >   KVM: PPC: Book3S HV: XIVE: do not test the EQ flag validity when
> > >     reseting
> > >   KVM: PPC: Book3S HV: XIVE: fix the enforced limit on the vCPU
> > >     identifier
> > >=20
> > >  arch/powerpc/kvm/book3s_xive_native.c | 46 ++++++++++++++++---------=
--
> > >  1 file changed, 27 insertions(+), 19 deletions(-)
> > >  =20
> >=20
>=20



--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--BZziOT8Kz25R/m/E
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAlzmPUEACgkQbDjKyiDZ
s5IrWg/+OTY4FNwrBdELptmuvQZnFRtq5PGofd5x7xRrpjX/soyjsiUt+YPUIQvd
YGWbJcr8K+j2IYc1AxNmeXKyTZdLEha82ZkwigxIhpPKJj+xaOe5bWkseBU0TciM
t0tIb6HgHwUAjnkSg7eWyXXS0U+jo3/7QtxSSiWzJY8vLot5Bt41yOAIzCEvLtYp
cJYWmjXhAbxNJz/Fp5qiGyBlzzDmbc3nKd83VcOL8bTtEYtGSIMb724qaQqvDj7H
q0bIl1snxr35SleGBPWJUm1U0EemulNYAHcwZWco8tFl2MfPl92Y/9X5xEqqBLpD
hNBD+C1NwGLaegdVJTXcoAiSXO3o3dhMiMKTG5IJJVf6O77p2bWPN3PZXmNJL0bP
DNzLXHLxcDJa//dW1SW4WIpjFe9fJfRr9jot61kpCK64tRKiHvZWB0a7VN8zVuIJ
uKlNCQksU+Lj6kgmMVJFBXCSH6852NjqS04mUZfWiRopl4rv001KUw7Xlk2R/HNS
b2g2I9owivRLbL032tc7P2LmaOGk6Ty4nZdG4SgCxhBS84yg5JYvXyPSIhCU3v4a
VpVZvQtkNoBuXTRjKC0dsIGavvNi2Q5UOTMpFH4yT7T1Miy6pR1UoLufEZXcYdtd
m9BLwje58Lz1oaoRi3FI9cPnLw/YoRNW1IJPvYXTioQovok9dRk=
=0Y7N
-----END PGP SIGNATURE-----

--BZziOT8Kz25R/m/E--
