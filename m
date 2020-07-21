Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F0D227840
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 07:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgGUFjc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 01:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgGUFjc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 01:39:32 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033CEC061794;
        Mon, 20 Jul 2020 22:39:31 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4B9nTs3QKjz9sRk; Tue, 21 Jul 2020 15:39:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1595309969;
        bh=J4UScPRMK9eRPaOWcVp7O8JSp1ZFqU5+OaPm5aZhMDM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ew0jBvgEc77aF6Dzo8vZ0zTFSU7A/eVeUpwxMb7sc8LXPLmeZarmkdt6KXV+Ka23T
         gQ222dPYsavkOxvXGANiKRYnTqwypD2JaPcw1sT8K8dTEvdE8GrJ1dMr0WCP6p1Xw+
         RlZYTPrTuLm8dypOfPqV1qAwOf0AOOv5JTlQdjto=
Date:   Tue, 21 Jul 2020 15:39:25 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Use feature flag CPU_FTR_P9_TIDR
 when accessing TIDR
Message-ID: <20200721053925.GG215446@umbus.fritz.box>
References: <20200623165027.271215-1-clg@kaod.org>
 <20200721050445.GA3878639@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VSVNCtZB1QZ8vhj+"
Content-Disposition: inline
In-Reply-To: <20200721050445.GA3878639@thinks.paulus.ozlabs.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--VSVNCtZB1QZ8vhj+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 21, 2020 at 03:04:45PM +1000, Paul Mackerras wrote:
> On Tue, Jun 23, 2020 at 06:50:27PM +0200, C=E9dric Le Goater wrote:
> > The TIDR register is only available on POWER9 systems and code
> > accessing this register is not always protected by the CPU_FTR_P9_TIDR
> > flag. Fix that to make sure POWER10 systems won't use it as TIDR has
> > been removed.
>=20
> I'm concerned about what this patch would do if we are trying to
> migrate from a P9 guest to a guest on P10 in P9-compat mode, in that
> the destination QEMU would get an error on doing the SET_ONE_REG for
> the TIDR.  I don't think the lack of TIDR is worth failing the
> migration for given that TIDR only actually does anything if you are
> using an accelerator, and KVM has never supported use of accelerators
> in guests.  I'm cc'ing David Gibson for his comments on the
> compatibility and migration issues.

Having thought about this a bit more, I don't think it matters.  We're
going to have to update qemu to handle POWER10 anyway.  If this causes
a problem, this would just add one small thing to whatever we need to
fix there.

> In any case, given that both move to and move from TIDR will be no-ops
> on P10 (for privileged code), I don't think there is a great urgency
> for this patch.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--VSVNCtZB1QZ8vhj+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl8Wf40ACgkQbDjKyiDZ
s5JCnRAArfvURAa9KW/0ZAnUEfMKMLRmmu7PKrGrKHFHq9rx8k9ev5wtvdTWmx3r
Y/4O1NxzN0cwKQyYmSPANpA8BTM6YJEGeZaBN23apOCqbAlkde7drppm3MfmzbKm
FEx+LSIk55HMpB2wjUrQgjfBDsp3DwTOkgOIkZX8d8gxA0yJjPvUcpgUtmQY2L5E
H/x0EOSf4TOmIpDxO8smW/wTJoZWg/21pN7FZuAD9Fr0ZS0ypUGuUg0HFrTWpZ/r
Z2U87/X3VxZAr1lA6Dqx0SQG6aHWc2oGgonR+ZLRUoMhl9YZPyO28jeBHx98GTI1
eyTtpuQN2agWENpZwjMUNn1rCo+LcvmZYLg8acly0El6u1VKedV1fTTbUBcFSTru
HrsJlhWIQ/lxUpVPykLO7kDasjUkm2sFWCM4LwIj71rrHfPmgEmu0Ycfl2mXiIAy
aM28/OIYrfr6c7Ph5r0wcoNb69QYUpKFzP6j4jKSdIEB3McbbvX7jznv3kuSE49J
vLambU/hTlqPGVB78H9mhQwEWfGICiBY6hOqyqmobipe7txRC0LJ/n55r1MJwo3f
aTqfdCS9X81RgTOt5+Y/HSg2F6N7HLSeYlPsKSJjUEiUcgpBo7Sc9s0JNyXqh6FU
suMnXZGBOd2DcmKHcyOYgiqOh1T4I5S95rq1df6M0MnzjAPt/1I=
=S2la
-----END PGP SIGNATURE-----

--VSVNCtZB1QZ8vhj+--
