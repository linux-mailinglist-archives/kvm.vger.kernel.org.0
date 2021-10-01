Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB5041E789
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 08:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352264AbhJAGca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 02:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352213AbhJAGc2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 02:32:28 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C25C061773;
        Thu, 30 Sep 2021 23:30:44 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HLKxG5QSDz4xbV; Fri,  1 Oct 2021 16:30:42 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1633069842;
        bh=QXuoR2zKvevRP0iYehyZS/4YMVevn4o8Cqh40BVOLxo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nRYDp0G6JuwG9TAbrdA+TvJszCgLcvtOtTNiXSzZlmbsyUqJWTVSX18M9/rPPOz+o
         AsC+tryI6JehZAJ0IX5Tk0pfsB0YxKZ/5c4s+SwlPT+fO/csGJHuPli6OxkM4PhKrJ
         mTx+qohuVLKIIqsVsyI9SCP1RnXWWuRjBgZHW0gA=
Date:   Fri, 1 Oct 2021 16:15:12 +1000
From:   "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
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
Message-ID: <YVancBGEEXInGt4y@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com>
 <BN9PR11MB543362CEBDAD02DA9F06D8ED8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LTo791FjS3phRBrr"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB543362CEBDAD02DA9F06D8ED8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--LTo791FjS3phRBrr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 22, 2021 at 03:40:25AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, September 22, 2021 1:45 AM
> >=20
> > On Sun, Sep 19, 2021 at 02:38:39PM +0800, Liu Yi L wrote:
> > > This patch adds IOASID allocation/free interface per iommufd. When
> > > allocating an IOASID, userspace is expected to specify the type and
> > > format information for the target I/O page table.
> > >
> > > This RFC supports only one type (IOMMU_IOASID_TYPE_KERNEL_TYPE1V2),
> > > implying a kernel-managed I/O page table with vfio type1v2 mapping
> > > semantics. For this type the user should specify the addr_width of
> > > the I/O address space and whether the I/O page table is created in
> > > an iommu enfore_snoop format. enforce_snoop must be true at this poin=
t,
> > > as the false setting requires additional contract with KVM on handling
> > > WBINVD emulation, which can be added later.
> > >
> > > Userspace is expected to call IOMMU_CHECK_EXTENSION (see next patch)
> > > for what formats can be specified when allocating an IOASID.
> > >
> > > Open:
> > > - Devices on PPC platform currently use a different iommu driver in v=
fio.
> > >   Per previous discussion they can also use vfio type1v2 as long as t=
here
> > >   is a way to claim a specific iova range from a system-wide address =
space.
> > >   This requirement doesn't sound PPC specific, as addr_width for pci
> > devices
> > >   can be also represented by a range [0, 2^addr_width-1]. This RFC ha=
sn't
> > >   adopted this design yet. We hope to have formal alignment in v1
> > discussion
> > >   and then decide how to incorporate it in v2.
> >=20
> > I think the request was to include a start/end IO address hint when
> > creating the ios. When the kernel creates it then it can return the
>=20
> is the hint single-range or could be multiple-ranges?
>=20
> > actual geometry including any holes via a query.
>=20
> I'd like to see a detail flow from David on how the uAPI works today with
> existing spapr driver and what exact changes he'd like to make on this
> proposed interface. Above info is still insufficient for us to think abou=
t the
> right solution.
>=20
> >=20
> > > - Currently ioasid term has already been used in the kernel
> > (drivers/iommu/
> > >   ioasid.c) to represent the hardware I/O address space ID in the wir=
e. It
> > >   covers both PCI PASID (Process Address Space ID) and ARM SSID (Sub-
> > Stream
> > >   ID). We need find a way to resolve the naming conflict between the
> > hardware
> > >   ID and software handle. One option is to rename the existing ioasid=
 to be
> > >   pasid or ssid, given their full names still sound generic. Apprecia=
te more
> > >   thoughts on this open!
> >=20
> > ioas works well here I think. Use ioas_id to refer to the xarray
> > index.
>=20
> What about when introducing pasid to this uAPI? Then use ioas_id
> for the xarray index and ioasid to represent pasid/ssid?

This is probably obsoleted by Jason's other comments, but definitely
don't use "ioas_id" and "ioasid" to mean different things.  Having
meaningfully different things distinguished only by an underscore is
not a good idea.

> At this point
> the software handle and hardware id are mixed together thus need
> a clear terminology to differentiate them.
>=20
>=20
> Thanks
> Kevin
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--LTo791FjS3phRBrr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFWp3AACgkQbDjKyiDZ
s5IYrBAA0YR4JIpISKFdhSW7/otGS+mBJCucE24Pk6zt5d9WTMHtiNhnfTxyrnzu
7gGj1EDxrZFRdmCa09sUffrueoKCIgCSs5QhmxYrj7IV3mlWyyVjyOjCXOCBQQLm
qrwXqF1tmTAv+mrbN1vuWX82cu/G+kwfEO/iT+DSW0efIyUpsd2uC35PdQILv6Ed
ur0CwObunhkA3rcq1Z60v97m4bSs4wZiR8vZC4JqnLnt5jmGXmCSyxcvgzZA1Wj0
CkQEzURUQe2SkHo1P+1cPcmB7raHZtFxIzmM2DjF4A6+2zbd8nYU6pw7d9LKA6Aa
r1LTfWNYCpnzlCKv2rYuJw9Lkpcu2uJ9Cj6HXS7JewQGD/vAX6XERlqtYGSgmIFI
gBiTfdbYtrclUXRGhiwhQDQNo0G/rxkdRp+K9TYse1QCUDJAZFeqRRxMWaOzjv7g
f/NnMeicrCJGd4Iv1d40OiOZQNDY6/yrqF7iVwGjXVApSspmOSWXEVoRJCdJDoy2
CZT0Nn1Ug4AO2Ih9Uj2ZwjKKEx0e0ik8WfV0hHeW3tsEM/+UFDzYecC1MdCcIGrT
mYq0nCiun4pPalGX5cTp+/kV47XWgnQ37S02V1MaHhp41ShYitdRnGrMxe8pW7ok
9mYIjVvW8nd7i4EsWqALagfmBJUkxORreV0gz8kDX6ALEGrH3Z4=
=2FOU
-----END PGP SIGNATURE-----

--LTo791FjS3phRBrr--
