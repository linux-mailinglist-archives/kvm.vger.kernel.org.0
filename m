Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39BB627326
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 02:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbfEWAMf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 20:12:35 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:33071 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727790AbfEWAMe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 20:12:34 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 458VLm50z9z9s1c; Thu, 23 May 2019 10:12:32 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1558570352;
        bh=dEFSRRK6x3J1fbxwCbrJv4H0uXynvhKzsQwjaW77KF4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cLxPptZ24fYDXsQYhK6nAlH+hQT3XfI8gKjXSIZ1HPkwil4fnNd7BL6oRDHZYAu+2
         BGAbD5rgaCwm0w1oguktzZs5TXALgknFPJCra8IBUIDnW8fPGCYoUcUtafD4onoxM1
         c/PhVr/4L8kDorWMPHIuvxy/fXNHBWTn1GbmyPw4=
Date:   Thu, 23 May 2019 09:30:43 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: PPC: Book3S HV: XIVE: assorted fixes on vCPU
 and RAM limits
Message-ID: <20190522233043.GO30423@umbus.fritz.box>
References: <20190520071514.9308-1-clg@kaod.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="p2pkNiL1PnZBJ6Nr"
Content-Disposition: inline
In-Reply-To: <20190520071514.9308-1-clg@kaod.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--p2pkNiL1PnZBJ6Nr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 20, 2019 at 09:15:11AM +0200, C=E9dric Le Goater wrote:
> Hello,
>=20
> Here are a couple of fixes for issues in the XIVE KVM device when
> testing the limits : RAM size and number of vCPUS.

How serious are the problems these patches fix?  I'm wondering if I
need to make a backport for RHEL8.1.

>=20
> Based on 5.2-rc1.
>=20
> Available on GitHub:
>=20
>     https://github.com/legoater/linux/commits/xive-5.2
>=20
> Thanks,
>=20
> C.=20
>=20
> C=E9dric Le Goater (3):
>   KVM: PPC: Book3S HV: XIVE: clear file mapping when device is released
>   KVM: PPC: Book3S HV: XIVE: do not test the EQ flag validity when
>     reseting
>   KVM: PPC: Book3S HV: XIVE: fix the enforced limit on the vCPU
>     identifier
>=20
>  arch/powerpc/kvm/book3s_xive_native.c | 46 ++++++++++++++++-----------
>  1 file changed, 27 insertions(+), 19 deletions(-)
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--p2pkNiL1PnZBJ6Nr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAlzl26MACgkQbDjKyiDZ
s5Kizg/+M0gnZlRTGg6UiTXSNFHRE5LAFKwsthsukXOg6JYSQqjTO9ZQncNmgOiD
lookGUyfl74NCAWOBl81KtM3buphvnjHvSeknRh6JfN4uXgMx4r36KmaHvm3lR2s
VQXhilkN1+gcUCAKUiEx/eVupW8+EQ4sI1xI/xraLwPRR3tWRH4n/ZrU2QR4U3Vg
8TO/h20Qrrm1KqpvYcWbQi+bW2v8o8brSNy/BNRgA38lq6k/GHgv3J19so416wE9
b3RWH63YT16Aa+1vrATLhsj2CCISyAuzjNBQKaE+knInQ4+PaZORr3NqgykJIOCR
aKyGIPRDM7dwxTqFZj9IfKV1md9mSrpo+siRKv4JsvdQ7LmXoZrdSb2ETe83ehN+
gtiOcIINuc973wU2Yy6zvbrm3AGfDeFCYzFNXYNyA4mFdRfRkm9GqChd/bZ7VDjx
xhZSMn41gFtAMGr3uvarL2u3C7j8EK6FsZE5poOzplOkvsbGIEzDsMBnQGHOoTgu
VUWH1rrXz51GUcdjfMaM+XlNZQdawfPlxiWBLwKPjxmwk4n1AWA2HTUchpTFIUO7
eBpQBoHTsnAPJpSjJdLH5i6ZWdwQPVcCEBSlz5+q0qP7hEK6uzLdjMY2LvUi6w9I
myqqLLpjCrSkDuqr8t3XQjR5na0/EksL2ralkXX4+DRVwd4gqW0=
=Q3mK
-----END PGP SIGNATURE-----

--p2pkNiL1PnZBJ6Nr--
