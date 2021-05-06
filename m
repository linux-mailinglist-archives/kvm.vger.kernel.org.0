Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CC3374D5E
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 04:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhEFCTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 22:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbhEFCTP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 22:19:15 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BB4C061574
        for <kvm@vger.kernel.org>; Wed,  5 May 2021 19:18:18 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4FbHLJ0L7mz9sW4; Thu,  6 May 2021 12:18:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1620267496;
        bh=WYlB70z+eVZIq1j3dLlNhnhyis7gJO8sepMb+y0/sTQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VCGtcRBGWJeV11yW5ubhxiYhOD6KpXQMvdcPs3tSJqg4LGbCl9FyKk8Xk8OLtCaPO
         dyCO+yoVFqC//REDbVEapPLR0wlHsy5JD5dGTVQ+71xC0AC+DBSidzABjkCBakSq07
         LfR1AWYQbuw6vAETyYht19C0yZKqK5JX8DPddVe4=
Date:   Thu, 6 May 2021 12:16:29 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, qemu-block@nongnu.org,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        qemu-ppc@nongnu.org, Gerd Hoffmann <kraxel@redhat.com>,
        =?iso-8859-1?Q?Marc-Andr=E9?= Lureau 
        <marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Greg Kurz <groug@kaod.org>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
Subject: Re: [PATCH 21/23] target/ppc/kvm: Avoid dynamic stack allocation
Message-ID: <YJNRfZOmH9NKB7EP@yekko>
References: <20210505211047.1496765-1-philmd@redhat.com>
 <20210505211047.1496765-22-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4nfXEX1oz+WC3sSD"
Content-Disposition: inline
In-Reply-To: <20210505211047.1496765-22-philmd@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--4nfXEX1oz+WC3sSD
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 05, 2021 at 11:10:45PM +0200, Philippe Mathieu-Daud=E9 wrote:
> Use autofree heap allocation instead of variable-length
> array on the stack.
>=20
> Signed-off-by: Philippe Mathieu-Daud=E9 <philmd@redhat.com>

Acked-by: David Gibson <david@gibson.dropbear.id.au>

> ---
>  target/ppc/kvm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index ae62daddf7d..90d0230eb86 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -2660,7 +2660,7 @@ int kvmppc_get_htab_fd(bool write, uint64_t index, =
Error **errp)
>  int kvmppc_save_htab(QEMUFile *f, int fd, size_t bufsize, int64_t max_ns)
>  {
>      int64_t starttime =3D qemu_clock_get_ns(QEMU_CLOCK_REALTIME);
> -    uint8_t buf[bufsize];
> +    g_autofree uint8_t *buf =3D g_malloc(bufsize);
>      ssize_t rc;
> =20
>      do {

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--4nfXEX1oz+WC3sSD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmCTUX0ACgkQbDjKyiDZ
s5J1Xg//fP1CCuNm/HXYPKD8uyQHwvtdILvGbw+HFXKQczWuXk0sjY8FFMtKSRzI
wJeYsZ2GmWAolWYLsVqquprjj4ciC2jjRW17ktQTI1BfvjossxiolQUpDFvRgW8m
ZLGcL9FzEKEJsN3izzKLlYtfmNt/VrPxl5+Oplp/TCyZmoGHyXDthBjss7+ShBss
Bb1y8XkpFyne5dL1pounzAMIhw1o7WPGDzWBhVxTpZeFUqlkRcUCl8cahxgFMcjf
YeJzjwS6on8wj32r3eoUQu8SPJDehkRI76HC/np5P6oWn15/F4Cq4hE3kQvidM1/
luCwRFY04TPHVL7BNDcnV1zyCjtJ/TvlqNbWIHIYhdpahi1uBkM2Qq91bdB1Ehg1
mJczNaXIJbqqT6/BIsbX4MXOCdSCxNCwdRHJupaqzZJGGM+GjmGkXeZmuhJHajh8
s2uAy02ZSqHn+ZBA+Q2lw18gEixs5//IjfEsJ+XE8Ju88ax/UMWr9TpfWcG1IGFu
yAw7CufbuLdF2yvqCvbfeCHbpaNQ0udUpIb8ZO2URtCvFY59s7q+RAg7hsBliYVH
L+iRuKLctjsxPut99eGq8dWaKLr31JmcnULc6t0Dicak5CVQIXye/vP0a9xIyqxT
mR2jrBRpg+rDTdKWGX03s3XO5u9a18DnmikjtMlpqmLPPHlQq9U=
=JU2c
-----END PGP SIGNATURE-----

--4nfXEX1oz+WC3sSD--
