Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBA5430E8D
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 06:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhJREQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 00:16:14 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:56183 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbhJREQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 00:16:13 -0400
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HXk5j5s6Dz4xd8; Mon, 18 Oct 2021 15:14:01 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1634530441;
        bh=LRKhCx62a8FylBa2igF2cBSiVauxjdJGZXJ54N9UUEI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CK3WSFHOUcDld4zE8yNAbqC4FyrTxzjVPfpA0zyCBUJMVp/le3OFTrYzrTlBoVQzh
         fXlROTKB0lSqJV5mx/U5GpTOASEgdS9niggv8iq/2N2ypTus31h0JEGlksaBT41awn
         zTaAZeSbIf9ckhrJ7VJNbj//fwPRZPbQN6A5//Zk=
Date:   Mon, 18 Oct 2021 14:40:54 +1100
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
Message-ID: <YWzsxlr10ejE2E7f@yekko>
References: <BN9PR11MB543362CEBDAD02DA9F06D8ED8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922140911.GT327412@nvidia.com>
 <YVaoamAaqayk1Hja@yekko>
 <20211001122505.GL964074@nvidia.com>
 <YVfeUkW7PWQeYFJQ@yekko>
 <20211002122542.GW964074@nvidia.com>
 <YWPNoknkNW55KQM4@yekko>
 <20211011171748.GA92207@nvidia.com>
 <YWezEY+CJBRY7uLj@yekko>
 <20211014150610.GS2744544@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NfLXu0kVKdtqKGuK"
Content-Disposition: inline
In-Reply-To: <20211014150610.GS2744544@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--NfLXu0kVKdtqKGuK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 14, 2021 at 12:06:10PM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 14, 2021 at 03:33:21PM +1100, david@gibson.dropbear.id.au wro=
te:
>=20
> > > If the HW can attach multiple non-overlapping IOAS's to the same
> > > device then the HW is routing to the correct IOAS by using the address
> > > bits. This is not much different from the prior discussion we had
> > > where we were thinking of the PASID as an 80 bit address
> >=20
> > Ah... that might be a workable approach.  And it even helps me get my
> > head around multiple attachment which I was struggling with before.
> >=20
> > So, the rule would be that you can attach multiple IOASes to a device,
> > as long as none of them overlap.  The non-overlapping could be because
> > each IOAS covers a disjoint address range, or it could be because
> > there's some attached information - such as a PASID - to disambiguate.
>=20
> Right exactly - it is very parallel to PASID
>=20
> And obviously HW support is required to have multiple page table
> pointers per RID - which sounds like PPC does (high/low pointer?)

Hardware support is require *in the IOMMU*.  Nothing (beyond regular
64-bit DMA support) is required in the endpoint devices.  That's not
true of PASID.

> > What remains a question is where the disambiguating information comes
> > from in each case: does it come from properties of the IOAS,
> > propertues of the device, or from extra parameters supplied at attach
> > time.  IIUC, the current draft suggests it always comes at attach time
> > for the PASID information.  Obviously the more consistency we can have
> > here the better.
>=20
> From a generic view point I'd say all are fair game. It is up to the
> IOMMU driver to take the requested set of IOAS's, the "at attachment"
> information (like PASID) and decide what to do, or fail.

Ok, that's a model that makes sense to me.

> > I can also see an additional problem in implementation, once we start
> > looking at hot-adding devices to existing address spaces. =20
>=20
> I won't pretend to guess how to implement this :) Just from a modeling
> perspective is something that works logically. If the kernel
> implementation is too hard then PPC should do one of the other ideas.
>=20
> Personally I'd probably try for a nice multi-domain attachment model
> like PASID and not try to create/destroy domains.

I don't really follow what you mean by that.

> As I said in my last email I think it is up to each IOMMU HW driver to
> make these decisions, the iommufd framework just provides a
> standardized API toward the attaching driver that the IOMMU HW must
> fit into.
>=20
> Jason
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--NfLXu0kVKdtqKGuK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFs7MQACgkQbDjKyiDZ
s5I36BAAtYQDHfUUrAAR+l1Nr+R/rx7GXp/8R6KR+CE1dfsCsiwzcMldNS97f68g
KxmxUoteQOeNn6s92JZ3MjvQS73SBD0n58JnUmdbjK6KmKn1yURJ7c01qI9/u8mG
f/F2nmTTtnbGNizIWVOcT3v+rVOpriok8+PVrzYLPZdwINIwGu9BvGTRX5rUH7dz
ebxBx708ex+y8Xjgahp6lN6TcpH4kZMe+7EihSh+94g2qqrjF1O4NG1E+nj0KA9a
AZohwPPqYfY2wq1ymxzEjbXHbfxoYMJGD0AdMGQoYeA4DYwokqUPcZbYCROl/EN2
hIMMjGkSLshVpla4Gswb0hIzZNyj4y6OwlnUHaCt99H64n35A14TZP+nB792qRyo
VdfYNa7bt2gyCVMJvIYjyIkT2GcsI6cUJY4xX6InPSU1cNwGH+hWiLyJ2uWz12zD
bOItcIEZFWX240UW8q0SOqfC/Yv18Z+hHtMWmv+Blwjq7E7qDGQTp9EvOga/VqsQ
bGlHugTZpZNnx0FsRQWva6RiyU+wvcQi49Uw565KotIqNkxE02PfcMOW4xTeKu39
p4LEMCw9ZdiGNF/vjSbpTBW+m1JvLpILLAi/xyqymcFBZbwxpUn+nMl2RcDJy35C
lBD9bu0MRYmWCcIm6B72rMnYR1+/zd/mVRZ2TdEJ3syDKgdGeAo=
=y6hM
-----END PGP SIGNATURE-----

--NfLXu0kVKdtqKGuK--
