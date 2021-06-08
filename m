Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4974839EBF1
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 04:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbhFHC1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 22:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbhFHC1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 22:27:48 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523A9C061789;
        Mon,  7 Jun 2021 19:25:56 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4FzYxn01lXz9sWD; Tue,  8 Jun 2021 12:25:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1623119149;
        bh=NE7+usqQ/norkxY9YOA2SirvU/XbC99t4zi6zDKs6fI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l5xQK55tG4fFOstusMEH5nVrLBK4ofIa7MChdPnoNlmO6puIFXbKBv4BQMnCh/qeL
         1AA2jQ0i8sBitMvTHtP5x7lrBh/CWfRRAI6K2JRx5QtBKyXpTNSvgzMSmXnPl0s84G
         EcXVcynJIkkcSXJXWbhlUwqaAJgDgZfBcSVU//N8=
Date:   Tue, 8 Jun 2021 11:15:01 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <YL7Elf3KwRarNfLx@yekko>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <bb6846bf-bd3c-3802-e0d7-226ec9b33384@metux.net>
 <20210602172424.GD1002214@nvidia.com>
 <bd0f485c-5f70-b087-2a5a-d2fe6e16817d@metux.net>
 <20210604123054.GL1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="T4guhZ6fptkEnI3K"
Content-Disposition: inline
In-Reply-To: <20210604123054.GL1002214@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--T4guhZ6fptkEnI3K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 04, 2021 at 09:30:54AM -0300, Jason Gunthorpe wrote:
> On Fri, Jun 04, 2021 at 12:44:28PM +0200, Enrico Weigelt, metux IT consul=
t wrote:
> > On 02.06.21 19:24, Jason Gunthorpe wrote:
> >=20
> > Hi,
> >=20
> > >> If I understand this correctly, /dev/ioasid is a kind of "common
> > supplier"
> > >> to other APIs / devices. Why can't the fd be acquired by the
> > >> consumer APIs (eg. kvm, vfio, etc) ?
> > >
> > > /dev/ioasid would be similar to /dev/vfio, and everything already
> > > deals with exposing /dev/vfio and /dev/vfio/N together
> > >
> > > I don't see it as a problem, just more work.
> >=20
> > One of the problems I'm seeing is in container environments: when
> > passing in an vfio device, we now also need to pass in /dev/ioasid,
> > thus increasing the complexity in container setup (or orchestration).
>=20
> Containers already needed to do this today. Container orchestration is
> hard.

Right to use VFIO a container already needs both /dev/vfio and one or
more /dev/vfio/NNN group devices.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--T4guhZ6fptkEnI3K
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmC+xJMACgkQbDjKyiDZ
s5JQuhAAxlzUDoVWUS7ZAU8E4fL0Z6TVV8A1LN3veamxiqHFJ6IIVtiV5g7Dy0II
T6GxA3x+7HaPcpMHbqv85GE3DBs7dm4P56B9rTtJU3OkDekISxcG2/IJtIiL0JtJ
BPWgnN6obAOeGlzl1uIxB9GQucvS1pp71jfxhW9BTFidOSg9UFWSu2IN6Hn0ODr0
siVRSG3V861K4yf3KH7GSR3mnrna6VUUclP2Bx8REmagVcPdMUqBNXU+4zg339+C
dwzoc+10bpSYPjgOI77bBCi1fyf5rPixRx3DVEfrWbqgR7AmPT5mrKcd7sL8/ta3
VmypRFa/+50D9qxBKYEFvqYWJHctQ56ZT1GMxIqd+aIY2Y4G1AeJs2lP0tHcfbV8
gQ2m+rpEFaRcN1C5aMVKQ2rs8xBUcbEPDQqpoCz3r8UwcuBC3SRNPEV2irfzJgbX
DaalbaoFGrb7O4Xl5yQ6suRBzr4w6sG9FCBJdzxj8sQgDhnIG2Vj1e+Ve7oqgf1S
WLZVU2GXIdBC3xn6ek5+37aHhsGenq08WQyX15J1q++TzKxba0fphS3qiKJHYGvI
8sTLwzIIRaFdhzXJ99gQyZMzRIwhjqFitlp36Ndc7CAoYtIDpt5iM5NY0RczQn2C
KwVAG28Qz7FdDd2BOeWPFm9CAQJkaJTaVNcNOJhscFENzTVoE2k=
=HWR1
-----END PGP SIGNATURE-----

--T4guhZ6fptkEnI3K--
