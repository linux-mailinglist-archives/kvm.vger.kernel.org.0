Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34632653ABE
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 03:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiLVCnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 21:43:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiLVCnK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 21:43:10 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE7FAE6F
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 18:43:09 -0800 (PST)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4NcvkM2kCVz4xZ3; Thu, 22 Dec 2022 13:43:07 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1671676987;
        bh=CudkdyXg3Kzs84QGZmym5+9Cet4eXEofqXLDPdK0cUQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NcZ4WPkBvw0Ji2oKGF7VBdF4x6hTJ+jc9L9nhVKfNdPPW8TzmY1cKA/3LMkRsfRYu
         s5uau9ayGq4OF8DzuevEbcjzFb5IKlRe0F8aTZjYUVtJhX87mQooESyOoxp9mjipfU
         c8ZuEsf7r7/cq2LeHqUEVrPYTPO37xynE0fmixjQ=
Date:   Thu, 22 Dec 2022 12:57:44 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Daniel Henrique Barboza <danielhb413@gmail.com>
Cc:     =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Greg Kurz <groug@kaod.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Markus Armbruster <armbru@redhat.com>
Subject: Re: [PATCH-for-8.0 4/4] hw/ppc/spapr_ovec: Avoid target_ulong
 spapr_ovec_parse_vector()
Message-ID: <Y6O5mL60bGnwiHgO@yekko>
References: <20221213123550.39302-1-philmd@linaro.org>
 <20221213123550.39302-5-philmd@linaro.org>
 <c871b044-4241-2f02-ebd6-6b797663a140@gmail.com>
 <5f70da81-2854-766f-1804-59a037a605b8@kaod.org>
 <7c67f0e8-f7b7-8d0d-ba72-06cd2c8d29d3@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="e3Ed+WV8hTo8PG4H"
Content-Disposition: inline
In-Reply-To: <7c67f0e8-f7b7-8d0d-ba72-06cd2c8d29d3@gmail.com>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--e3Ed+WV8hTo8PG4H
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 21, 2022 at 10:26:51AM -0300, Daniel Henrique Barboza wrote:
>=20
>=20
> On 12/21/22 06:46, C=E9dric Le Goater wrote:
> > On 12/16/22 17:47, Daniel Henrique Barboza wrote:
> > >=20
> > >=20
> > > On 12/13/22 09:35, Philippe Mathieu-Daud=E9 wrote:
> > > > spapr_ovec.c is a device, but it uses target_ulong which is
> > > > target specific. The hwaddr type (declared in "exec/hwaddr.h")
> > > > better fits hardware addresses.
> > >=20
> > > As said by Harsh, spapr_ovec is in fact a data structure that stores =
platform
> > > options that are supported by the guest.
> > >=20
> > > That doesn't mean that I oppose the change made here. Aside from sema=
ntics - which
> > > I also don't have a strong opinion about it - I don't believe it matt=
ers that
> > > much - spapr is 64 bit only, so hwaddr will always be =3D=3D target_u=
long.
> > >=20
> > > Cedric/David/Greg, let me know if you have any restriction/thoughts a=
bout this.
> > > I'm inclined to accept it as is.
> >=20
> > Well, I am not sure.
> >=20
> > The vector table variable is the result of a ppc64_phys_to_real() conve=
rsion
> > of the CAS hcall parameter, which is a target_ulong, but ppc64_phys_to_=
real()
> > returns a uint64_t.
> >=20
> > The code is not consistent in another places :
> >=20
> >  =A0 hw/ppc/spapr_tpm_proxy.c uses a uint64_t
> >  =A0 hw/ppc/spapr_hcall.c, a target_ulong
> >  =A0 hw/ppc/spapr_rtas.c, a hwaddr
> >  =A0 hw/ppc/spapr_drc.c, a hwaddr indirectly
> >=20
> > Should we change ppc64_phys_to_real() to return an hwaddr (also) ?
>=20
> It makes sense to me a function called ppc64_phys_to_real() returning
> a hwaddr type.

Yes, I also think that makes sense.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--e3Ed+WV8hTo8PG4H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEoULxWu4/Ws0dB+XtgypY4gEwYSIFAmOjuZEACgkQgypY4gEw
YSJDeA//ZjZ49AyGlSmymeaAd5ZDdavOON2pCJ11rEOOVppGLLDZBFLVdOO/sG2t
BPQ5j0Du2t8wtNu6ELojxewz7be36Ga9svFHq+O4xOXFUWW7ENNcOBM4ecwZfAp0
FfVgbjttVDHBzCDbGy/mEXC62KeR+RdbbOFExQ97ZPPKc9Mo937X9/L9/2W/QzL1
hnToe2VrdDt9XAUMMynnLDut3G/W1SeqWT5IFFKJI0smglpeGFEVNHnnSy0jkxh7
itSPeOMsXrX6LNI5LaADinMcquKwqfK2J9poWr7WaeOJkC2aru9cbGKN998DqBAe
e6MYkGHrLgwXNL1x4deNXpT2Iho5B2N1gaAjv/dBi2fhbAeJFYo6Y873Zw0CRAEy
pwcruBjNLjJaAh2/0N4LpXpKoVatbY8W3aHvhD9eqa1IUGwxxy69tn7EFtOo9mjy
zvcAwwXjWM6GfYOuscmcRMf2llS6/Xr3/Udz6iIO/BUlEDd0X3ywAEmNn7ka+V+i
5cLF6T/tmUJ7gjmH/EW9Et5C24P0c/BuOakeA7g91EDHzU0BGRja04BrgciaE2/x
VqC2rHbm07N/h+RIbk8S1tye2pXaxex5kmFvxF4HB+42CDQlUvKeXTyYjIZbxBpi
R3RBdRPqVqMjSWt4Mh5I3LFtve9njSDa5F7nN/Bn5CA4oNIezfs=
=fANF
-----END PGP SIGNATURE-----

--e3Ed+WV8hTo8PG4H--
