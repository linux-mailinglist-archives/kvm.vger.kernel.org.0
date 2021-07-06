Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539C13BDAE3
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 18:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhGFQIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 12:08:42 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41293 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbhGFQIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jul 2021 12:08:42 -0400
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m0na9-0001Xn-Na; Tue, 06 Jul 2021 18:05:57 +0200
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m0na9-0007ty-5i; Tue, 06 Jul 2021 18:05:57 +0200
Date:   Tue, 6 Jul 2021 18:05:43 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>,
        kernel@pengutronix.de, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-kernel@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: [PATCH v2 1/4] s390/cio: Make struct css_driver::remove return
 void
Message-ID: <20210706160543.3qfekhzalwsrtahv@pengutronix.de>
References: <20210706154803.1631813-1-u.kleine-koenig@pengutronix.de>
 <20210706154803.1631813-2-u.kleine-koenig@pengutronix.de>
 <87zguzfn8e.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bqb4qgmhkapjyrom"
Content-Disposition: inline
In-Reply-To: <87zguzfn8e.fsf@redhat.com>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--bqb4qgmhkapjyrom
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 06, 2021 at 05:58:25PM +0200, Cornelia Huck wrote:
> On Tue, Jul 06 2021, Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de> =
wrote:
>=20
> > The driver core ignores the return value of css_remove()
> > (because there is only little it can do when a device disappears) and
> > there are no pci_epf_drivers with a remove callback.
>=20
> s/pci_epf/css/

Argh, too much copy&paste. I make this:

	The driver core ignores the return value of css_remove()
	(because there is only little it can do when a device
	disappears) and all callbacks return 0 anyhow.

to make this actually correct.

> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

Thanks
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--bqb4qgmhkapjyrom
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmDkf1MACgkQwfwUeK3K
7AnBiQf8D47hxJyNZj9iLEgV5cF5XI5NaUQkYuyP8DFRJsSKUmmHVkpbjebqvShn
IsZyUlhkVZMz/+sm7b7WLx8flFcRwktqMzF4qVveu3oj+VU6gENlMhWWzhjLaRp/
GpoUGx4Wb5WowhHxemhm6pQ5xl67Ybx6AWwZdpgmwfBbjOEepqcp5CJKUMFxrPSq
eKputuI68l7SRfCkN5WfCsWcU++tBYiFeuI9b5txBJ+J2uf6sTX+5qHnJ+xj9H+M
xHog8O2wezn8Mia+0VNwsnyEx1uuivH1qXcLEvEjQCqOAjmwLiQfrUbt0cHMqYL2
6IHjEFCLSb4UWm1t4CaI7HFLcJPdOg==
=upS2
-----END PGP SIGNATURE-----

--bqb4qgmhkapjyrom--
