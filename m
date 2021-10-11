Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A90428789
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 09:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbhJKHVy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 03:21:54 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:52919 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234279AbhJKHVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 03:21:54 -0400
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HSVYP2X9Hz4xqQ; Mon, 11 Oct 2021 18:19:53 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1633936793;
        bh=6mTyoEeD81UgPE8G1mGEU//Fuq65qBZTt4bSRVKbg+w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ovs+Na8a2kRhJXcn14WcB4fglDHKqyAZ8/CQsxyOfabFSpI/zbbDZJwE3j7PULIlS
         dSMCuiyIYVrWVCN6zc9OEJcA/dKef95nQHaBuR+WNkA4MWDlTuX4a8DC6JODeDtI67
         hNoQ9jXaUTAluoawqk65gzodmZtswX8RetSUVLXg=
Date:   Mon, 11 Oct 2021 16:37:38 +1100
From:   "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Message-ID: <YWPNoknkNW55KQM4@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com>
 <BN9PR11MB543362CEBDAD02DA9F06D8ED8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922140911.GT327412@nvidia.com>
 <YVaoamAaqayk1Hja@yekko>
 <20211001122505.GL964074@nvidia.com>
 <YVfeUkW7PWQeYFJQ@yekko>
 <20211002122542.GW964074@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XAp8YQc7m504M8vp"
Content-Disposition: inline
In-Reply-To: <20211002122542.GW964074@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--XAp8YQc7m504M8vp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 02, 2021 at 09:25:42AM -0300, Jason Gunthorpe wrote:
> On Sat, Oct 02, 2021 at 02:21:38PM +1000, david@gibson.dropbear.id.au wro=
te:
>=20
> > > > No. qemu needs to supply *both* the 32-bit and 64-bit range to its
> > > > guest, and therefore needs to request both from the host.
> > >=20
> > > As I understood your remarks each IOAS can only be one of the formats
> > > as they have a different PTE layout. So here I ment that qmeu needs to
> > > be able to pick *for each IOAS* which of the two formats it is.
> >=20
> > No.  Both windows are in the same IOAS.  A device could do DMA
> > simultaneously to both windows. =20
>=20
> Sure, but that doesn't force us to model it as one IOAS in the
> iommufd. A while back you were talking about using nesting and 3
> IOAS's, right?
>=20
> 1, 2 or 3 IOAS's seems like a decision we can make.

Well, up to a point.  We can decide how such a thing should be
constructed.  However at some point there needs to exist an IOAS in
which both windows are mapped, whether it's directly or indirectly.
That's what the device will be attached to.

> PASID support will already require that a device can be multi-bound to
> many IOAS's, couldn't PPC do the same with the windows?

I don't see how that would make sense.  The device has no awareness of
multiple windows the way it does of PASIDs.  It just sends
transactions over the bus with the IOVAs it's told.  If those IOVAs
lie within one of the windows, the IOMMU picks them up and translates
them.  If they don't, it doesn't.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--XAp8YQc7m504M8vp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFjzaIACgkQbDjKyiDZ
s5LujA/+J+md5jc+nVRrvzZTN2GADL6m83rgNracoDm6uMvDRuCivgx8Gb61JAzj
4vdjATq7RrfNZK6OtwjU5TW4OPWr5Q6HltxUR7thLNZYgXdcquJZHtHz4VpddvVb
jbdydqJmo2pBy5lMenRlkZM4s8Yj1ERjPsRelh32pFWP4MGbFQaKDgxbypmWSVvT
T8eQfFlANqFI6nKKUt0C2vl4i+xHVMSxd+WFcsk1+xue7XI6KsnQ1pNOVJ2lB3Ai
+6RSwer5qMA001/lYRmFETyW6+eKZuIFR4RCiq1FdJuJnrcqZSofFErPj6IRDHL7
Dar99VlTQHgVgtrBmFxezRZeBHVQlAdJQgos3VVhL5+o+8KjmusWWxVAKi372cX3
pDGbUyurpqMrYinPewTVeyT0dDOHXfEnYDgGsj+v8SxtIYENPf92AziOx+KNBRlI
MCJkh6xQpfgEROvYp7bilA8RqymffYV+rz2sVoGDb8ZfIUeFuNJKqACKN3JIYlZS
6Hk+LH2QZjBwEw+i/hDrmdfYOLD2h0G1wRFJO6HdiVBgV4P+h08RFd874tU1skeR
LEYx8SoXpseZuyP45tSblYe7yvnE8cHIjLVHD8H/Aa6kvi4l6FCJeRTANYysWH4s
weFKjdEHPGNAi6vo19Hw5IaDJufGkPYq0jZA44jesTI0ejvBfqY=
=xnee
-----END PGP SIGNATURE-----

--XAp8YQc7m504M8vp--
