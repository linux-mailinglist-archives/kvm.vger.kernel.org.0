Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420073BE9D3
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 16:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbhGGOhR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 10:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbhGGOhR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 10:37:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD0AC061574
        for <kvm@vger.kernel.org>; Wed,  7 Jul 2021 07:34:36 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m18dF-0007hh-4J; Wed, 07 Jul 2021 16:34:33 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m18dD-0002Z6-VN; Wed, 07 Jul 2021 16:34:31 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m18dD-0005wT-UH; Wed, 07 Jul 2021 16:34:31 +0200
Date:   Wed, 7 Jul 2021 16:34:31 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Vineeth Vijayan <vneethv@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-kernel@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kernel@pengutronix.de, Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: [PATCH v2 1/4] s390/cio: Make struct css_driver::remove return
 void
Message-ID: <20210707143431.g2wigjypoah4nrlz@pengutronix.de>
References: <20210706154803.1631813-1-u.kleine-koenig@pengutronix.de>
 <20210706154803.1631813-2-u.kleine-koenig@pengutronix.de>
 <87zguzfn8e.fsf@redhat.com>
 <20210706160543.3qfekhzalwsrtahv@pengutronix.de>
 <ccc9c098-504d-4fd4-43a9-ccb3fa2a2232@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vnzs5fahmp3vlhnz"
Content-Disposition: inline
In-Reply-To: <ccc9c098-504d-4fd4-43a9-ccb3fa2a2232@linux.ibm.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--vnzs5fahmp3vlhnz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Vineeth,

On Wed, Jul 07, 2021 at 01:28:11PM +0200, Vineeth Vijayan wrote:
> Thank you. I will use the modified description. This will be picked up by
> Vasily/Heiko to the s390-tree.
>=20
> Also Acked-by: Vineeth Vijayan <vneethv@linux.ibm.com>
>=20
> One question, is this patchset supposed to have 4 patches ? Are we missing
> one ?

Yes, the fourth patch[1] has the following shortstat:

	80 files changed, 83 insertions(+), 219 deletions(-)

and the affected files are distributed over the whole source tree.

Given that this fourth patch is the actual motivation for the first
three, and I'd like to get this in during the next merge window, I would
prefer if these patches were taken together. (Well unless the first
three make it into 5.14-rc1 of course.)

Best regards
Uwe

[1] https://lore.kernel.org/lkml/20210706154803.1631813-5-u.kleine-koenig@p=
engutronix.de/
--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--vnzs5fahmp3vlhnz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmDlu28ACgkQwfwUeK3K
7AlBPAf/XO55E0eVCLLauzDOU9CUTt9drGLfUM6ri/Q4zws/6fmISjMk741mObqH
g5AIxnIXTELIujuHOF9YF7gEuUKu7oCeiEQM9CdGWpE4/tIIYRDRbDYHbW+jJ/6V
3dIjBHRU174l5Mcrqi23uVk+ZDzSL6GbzzvNeBDGfGKwPRrKDfzxwj/w9TzNcrfv
YVnenWw42NXzfB6v6Sh2A1OkG0E1ffpCUq6p2oGNomkIAooxbcbvHkWyBewECsPS
zF8I1FEh0iuvqtolQ33Hdb0bjjokonnwstshIb7aL9Lt6sSO8XHQesfZi/x1i2iH
oDFG1/vAg+f5TzwwxNV5WoYIqerXhg==
=wleT
-----END PGP SIGNATURE-----

--vnzs5fahmp3vlhnz--
