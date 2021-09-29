Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D4141BF1F
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 08:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244357AbhI2G3b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 02:29:31 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:54775 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244100AbhI2G3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 02:29:30 -0400
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HK5yr30DVz4xZJ; Wed, 29 Sep 2021 16:27:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1632896868;
        bh=nW9WwB4krc4OXpzxcuXzAt9baC6o0ghnIlnPDB1Xd1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dzMvEezuJqaNXvc6p9R9PekRSEZPKDJLmyBFe5iPlbl7WM+U48X2/7TNxFUIJe0iT
         ZBH8X4JWaE9lnwOQmhvTPuRimhY7Ef7t3zCXnigRgV2cBvGwwsKzGQYiIjyRyXJqFL
         n3NyZ5fOSQeT7eoVP+Lyf1cA5NZWTAY29Fy+kLk8=
Date:   Wed, 29 Sep 2021 16:18:34 +1000
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
Subject: Re: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Message-ID: <YVQFOun0Ae3/V2Y4@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-11-yi.l.liu@intel.com>
 <20210921174049.GV327412@nvidia.com>
 <BN9PR11MB5433D26EFA94F59756AF91838CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922124150.GK327412@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9KkT761rRKdNuQHa"
Content-Disposition: inline
In-Reply-To: <20210922124150.GK327412@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--9KkT761rRKdNuQHa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 22, 2021 at 09:41:50AM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 22, 2021 at 03:30:09AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, September 22, 2021 1:41 AM
> > >=20
> > > On Sun, Sep 19, 2021 at 02:38:38PM +0800, Liu Yi L wrote:
> > > > After a device is bound to the iommufd, userspace can use this inte=
rface
> > > > to query the underlying iommu capability and format info for this d=
evice.
> > > > Based on this information the user then creates I/O address space i=
n a
> > > > compatible format with the to-be-attached devices.
> > > >
> > > > Device cookie which is registered at binding time is used to mark t=
he
> > > > device which is being queried here.
> > > >
> > > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > >  drivers/iommu/iommufd/iommufd.c | 68
> > > +++++++++++++++++++++++++++++++++
> > > >  include/uapi/linux/iommu.h      | 49 ++++++++++++++++++++++++
> > > >  2 files changed, 117 insertions(+)
> > > >
> > > > diff --git a/drivers/iommu/iommufd/iommufd.c
> > > b/drivers/iommu/iommufd/iommufd.c
> > > > index e16ca21e4534..641f199f2d41 100644
> > > > +++ b/drivers/iommu/iommufd/iommufd.c
> > > > @@ -117,6 +117,71 @@ static int iommufd_fops_release(struct inode
> > > *inode, struct file *filep)
> > > >  	return 0;
> > > >  }
> > > >
> > > > +static struct device *
> > > > +iommu_find_device_from_cookie(struct iommufd_ctx *ictx, u64
> > > dev_cookie)
> > > > +{
> > >=20
> > > We have an xarray ID for the device, why are we allowing userspace to
> > > use the dev_cookie as input?
> > >=20
> > > Userspace should always pass in the ID. The only place dev_cookie
> > > should appear is if the kernel generates an event back to
> > > userspace. Then the kernel should return both the ID and the
> > > dev_cookie in the event to allow userspace to correlate it.
> > >=20
> >=20
> > A little background.
> >=20
> > In earlier design proposal we discussed two options. One is to return
> > an kernel-allocated ID (label) to userspace. The other is to have user
> > register a cookie and use it in iommufd uAPI. At that time the two
> > options were discussed exclusively and the cookie one is preferred.
> >=20
> > Now you instead recommended a mixed option. We can follow it for
> > sure if nobody objects.
>=20
> Either or for the return is fine, I'd return both just because it is
> more flexable
>=20
> But the cookie should never be an input from userspace, and the kernel
> should never search for it. Locating the kernel object is what the ID
> and xarray is for.

Why do we need two IDs at all?  Can't we just use the cookie as the
sole ID?

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--9KkT761rRKdNuQHa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFUBTgACgkQbDjKyiDZ
s5K4CQ//ZP7Vd8mpipNUS/AWU7c4/szaCvt/v2he80AMrFlcUx0PojUtRabS9Rg2
2auIXhqeFqWUUyCVzQ60/f5L+v0VSosRphUA0yG0QZcVjvKeOFXScIBHadS1xELL
j6XaydocIV/EUeGlUkMC2bPeJpeEEu5oN4SBu28yw2cJdIDeI8mtLotdPtYEHtai
HSPjBt+38dmgUGGXlDpnBwrTs9sHb4BHgbMIM0ExcL8+GC0nzdWVxA0bV1C6Z4bD
vaDKQXGoj3Vjw69+tSAhLluI44nIHL7zcXeXols27ly2RP7XIeygkS6/6Jtx2zAv
dNBYSYWJ1KiGRF/5UrWmAOF9pWt4X+6seHSee60SKnb1sEl17i/MUZYMdE2cQSAe
R7L9aEagtEfTGaDLVL6O1MuP1uo+RFgUz83b+JawOe7K0d4G32rh6uqicsaVhh5E
k8hGjb7XdU+zqJmNj+eva5nuk/ocOsKoshp5nJ6dNwZB3og09ctk/6Yas6lO1t/1
vPi7Z6XsRUMsqvyc/D7Xzsira7wC6OkrR4aZGez5PjibC9WlLZyZ4XD1E/H2+rCY
u+W4Kvy2++kJZ5kBrU0li+DMQvuEy7uWwMYqmlsmqGLqRta2+Fdl7OpmBA7Lm0VK
sV/FGvMX1N5t7yNzChqAqDps4uSA6pHtKuIjJOcNuK3BAD6powQ=
=VX0E
-----END PGP SIGNATURE-----

--9KkT761rRKdNuQHa--
