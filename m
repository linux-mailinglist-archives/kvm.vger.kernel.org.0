Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4EA2F26D0
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 04:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbhALDu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 22:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbhALDu2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 22:50:28 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1025AC061575
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 19:49:47 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DFGmS0mCjz9sXb; Tue, 12 Jan 2021 14:49:43 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610423384;
        bh=btmVH3UE3ShVXpQ3NbbiNduitqKhghwHg9P22JeqMZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J263AgD7rwcibc8HJ+ZqsDGjtMjb/cdAjxrJWOLQMxO68SMyASi1nOa3utfRUK5ao
         Dkq5HFDlmk/65X9E5GSBD7aI+37hiF9DAhLZRb2QIOH4t/m9PocoSK7JH+O5Mou//E
         lOv+AsEMns0PYhUwvI9AxPRV6D+RbKEgzjssFwrI=
Date:   Tue, 12 Jan 2021 14:02:30 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc:     pair@us.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        brijesh.singh@amd.com, dgilbert@redhat.com, qemu-devel@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-ppc@nongnu.org,
        rth@twiddle.net, thuth@redhat.com, mdroth@linux.vnet.ibm.com,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        borntraeger@de.ibm.com, cohuck@redhat.com, kvm@vger.kernel.org,
        qemu-s390x@nongnu.org, pasic@linux.ibm.com
Subject: Re: [for-6.0 v5 00/13] Generalize memory encryption models
Message-ID: <20210112030230.GJ3051@yekko.fritz.box>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
 <20201204095005.GB3056135@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DesjdUuHQDwS2t4N"
Content-Disposition: inline
In-Reply-To: <20201204095005.GB3056135@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--DesjdUuHQDwS2t4N
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 04, 2020 at 09:50:05AM +0000, Daniel P. Berrang=E9 wrote:
> On Fri, Dec 04, 2020 at 04:44:02PM +1100, David Gibson wrote:
> > A number of hardware platforms are implementing mechanisms whereby the
> > hypervisor does not have unfettered access to guest memory, in order
> > to mitigate the security impact of a compromised hypervisor.
> >=20
> > AMD's SEV implements this with in-cpu memory encryption, and Intel has
> > its own memory encryption mechanism.  POWER has an upcoming mechanism
> > to accomplish this in a different way, using a new memory protection
> > level plus a small trusted ultravisor.  s390 also has a protected
> > execution environment.
> >=20
> > The current code (committed or draft) for these features has each
> > platform's version configured entirely differently.  That doesn't seem
> > ideal for users, or particularly for management layers.
> >=20
> > AMD SEV introduces a notionally generic machine option
> > "machine-encryption", but it doesn't actually cover any cases other
> > than SEV.
> >=20
> > This series is a proposal to at least partially unify configuration
> > for these mechanisms, by renaming and generalizing AMD's
> > "memory-encryption" property.  It is replaced by a
> > "securable-guest-memory" property pointing to a platform specific
> > object which configures and manages the specific details.
>=20
> There's no docs updated or added in this series.
>=20
> docs/amd-memory-encryption.txt needs an update at least, and
> there ought to be a doc added describing how this series is
> to be used for s390/ppc

Fair point, I've made a bunch of doc updates for the next spin.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--DesjdUuHQDwS2t4N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl/9EUQACgkQbDjKyiDZ
s5JzAQ//SvrT3nuK8XyVRauAL7EhoV1epcnrl2exKWQteytnpnCW3Mw0x95IfC6w
ukVrdcGbN84Xt6YcsXj+ajhi3G97MFMt675PUourF18qBgoPzlXTTEIJQ99z3kOm
ZARhaxGen02w0TiuZjdvxoG9b7EJYOb9Ie8gSgb7twgDImB64xiXqnh3iDSFoxLr
Ia90xBQMLPg8fg/7yxj4TkHqnRwDyTUrWH5A0b5i5cBI4YSy8855x5tA0Xp6VVPw
tzY5Ky8qSPcTKr6lL3y/sU+pk47KqcwgFvqgUWU0+IUBZ0/Ntl/ECTVSBhgRexlo
XF+duybxFoQ172mz/IW7psAhHpBs245BZ8vycB6FPEfbl4rUAJujulzgmBgSib2g
d5g4j8uIpnpoJrp+x1OrofvrSdNicC/2YWlwMmmybBW6V8UAoV+Dpx9LnNIlHzjI
5r9NBMDr0gf74UGS93DSgrkcq1rn/TiISIeZu6/QKStInGptChZcXjFaOlKTMYu8
LDNwF+ihad2N8lacXIl+6tjHViTUH0IXJJEatLhGj2G7GwIQHCYgjo5bkls4guBT
n7umTEIFCPlICEUfZi6zCsc+z/NInlGhF2E56bR1XCtLJpidF7xoORYkcz5qZfZc
g5SwJwo9gLSRqZgDnMhgdKgL49E9jdhqUw0DzYdXub6Ty0iH8Us=
=4wXi
-----END PGP SIGNATURE-----

--DesjdUuHQDwS2t4N--
