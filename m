Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75DC5CDB4F
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 07:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfJGFYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 01:24:12 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:51473 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726969AbfJGFYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 01:24:12 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 46mpn54SNXz9sPF; Mon,  7 Oct 2019 16:24:09 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1570425849;
        bh=+nDUnsn2OEvJDxwkh/6ttRI8cLc0LM8lRgaeTbgNVT0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FIOMvuqS9W15M7MpHqkdh90tamYMnqq+YsF2DBeCw4+5zjQNMb0QyJcYMHTBitwNR
         XHp+rMuWvsjOvIVXOF5HrYypnzu+jrrAs9ZxjVNF3msIIs73nLaGdTu9XI8/9EtNEL
         LenO+Qy7geH+Nfrnr9yOPdYhiRWLKLocAGeWPx2E=
Date:   Mon, 7 Oct 2019 16:22:44 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     lvivier@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, rkrcmar@redhat.com
Subject: Re: [PATCH] powerpc: Fix up RTAS invocation for new qemu versions
Message-ID: <20191007052244.GA18815@umbus.fritz.box>
References: <20191004103844.32590-1-david@gibson.dropbear.id.au>
 <a384c5e2-472a-32e5-2ee1-65c40da29840@redhat.com>
 <20191005081122.GB29310@umbus.fritz.box>
 <22526d83-737f-c4aa-2fd5-84eb91b285d6@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <22526d83-737f-c4aa-2fd5-84eb91b285d6@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 06, 2019 at 06:16:17PM +0200, Paolo Bonzini wrote:
> On 05/10/19 10:11, David Gibson wrote:
> > Fairly.  First, we'd have to not use -bios to replace the normal SLOF
> > firmware - that could significantly slow down tests, since SLOF itself
> > takes a little while to start up.
>=20
> Oh, I forgot that PPC kvm-unit-tests use -bios.  That makes
> everything moot.

Right.  I did consider putting a closer-to-conventional RTAS blob in
kbm-unit-tests' special "firmware" (which currently consists of a
single jump instruction).  It does help to build it BE which RTAS
expects.  On the other hand, I wasn't about to implement a full OF
client interface, so it would still have the main part of the tests
relying on finding the blob at some well known location.  And finding
a well known location that we can count on the tests proper not
clobbering is a bit of a pain as well.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl2ay6IACgkQbDjKyiDZ
s5IW0w/+IZ3cgyVadahvTFc8GfHh9GEhF5wJLWR7VIEIejAct+xqCxEH+HnupP6l
nOhbkY/HPSPi/T8sExD27CLV6tCFRVguG1hZkuDtoDLOTEDcoAQjaCigzU3pw0BQ
fZVqdz9rN2xe5e9r++2xHJj88+Jz/68HaZv2hF53JLAGceVwh/rC6MD8dl5GFAc3
GFUjWm+qYm81voUefaw44IJB+pDZMalxu/qoaey4wVq3j+kzICT8HtYcfnCE7/8k
n7pURicGpEaa7cm7O+jworWKyRL50o66OrG/6HsdODi2eDuJ3zNF8Tg7cDGYOomL
EAyS7gg/WLm9XMfwux4tQPgGH/bMnsG1KkTgF62vqrAHRUpxNaXAwainUmaX0iEJ
GM4sRmpmLKNtetk6/YJS+rosCzjea5iPVrM5itWCd5KId5i4dqmWRlcwfiiJm3ZU
NT/O4MacHa0Lo1O07j4YdzCATyKKIDWn+OVmcypXuwrlPsUzMdJqiKETXvkdFdmI
gaoHleLMIJrLgdsuuwbV2PbgevOvaTP9MsWViYYm/hprjbEISww8BOmrlf4v6Lce
nrk2nkHOCLLzeVp/DSqE7Nm93sZPUVtOWKFZiGQ/d/SXdUf2DuL2l8u2yLY4C7r8
YRn6rRAJLstxWvIPGutXJvYdY+xUY3+ezyfR0wXeGhBc9BDVznc=
=JjZ8
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
