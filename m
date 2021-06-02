Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1CC3982F1
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 09:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhFBHbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 03:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbhFBHbC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 03:31:02 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E46C061756;
        Wed,  2 Jun 2021 00:29:18 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4Fw0yh4N0nz9sW4; Wed,  2 Jun 2021 17:29:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1622618956;
        bh=uGza2ambRaw52uUD6+0AHLe+nMsKVTQGJ2WrG5YyBgM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tjx74IuRulizpaNftVChf7BNNeGl+1EoQNhIlUofWpJQxeibH3wdkpHdG2F9SnY3M
         /+XTbp+kE+ukN9tHYbjk6ddIPAas4n4QjEsZOYxVxc7/4EeaRuhvn2Mb03GDarZYdi
         vRQ/ZSkrrqyNesAQVv650ekDxOUzfDCcA7V0Fxwg=
Date:   Wed, 2 Jun 2021 17:22:13 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
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
Message-ID: <YLcxpYDkT1h7hIbQ@yekko>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528233649.GB3816344@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="j/FYRtVn/XN5nkYp"
Content-Disposition: inline
In-Reply-To: <20210528233649.GB3816344@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--j/FYRtVn/XN5nkYp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 28, 2021 at 08:36:49PM -0300, Jason Gunthorpe wrote:
> On Thu, May 27, 2021 at 07:58:12AM +0000, Tian, Kevin wrote:
>=20
> > 2.1. /dev/ioasid uAPI
> > +++++++++++++++++
> >=20
> > /*
> >   * Check whether an uAPI extension is supported.=20
> >   *
> >   * This is for FD-level capabilities, such as locked page pre-registra=
tion.=20
> >   * IOASID-level capabilities are reported through IOASID_GET_INFO.
> >   *
> >   * Return: 0 if not supported, 1 if supported.
> >   */
> > #define IOASID_CHECK_EXTENSION	_IO(IOASID_TYPE, IOASID_BASE + 0)
>=20
> =20
> > /*
> >   * Register user space memory where DMA is allowed.
> >   *
> >   * It pins user pages and does the locked memory accounting so sub-
> >   * sequent IOASID_MAP/UNMAP_DMA calls get faster.
> >   *
> >   * When this ioctl is not used, one user page might be accounted
> >   * multiple times when it is mapped by multiple IOASIDs which are
> >   * not nested together.
> >   *
> >   * Input parameters:
> >   *	- vaddr;
> >   *	- size;
> >   *
> >   * Return: 0 on success, -errno on failure.
> >   */
> > #define IOASID_REGISTER_MEMORY	_IO(IOASID_TYPE, IOASID_BASE + 1)
> > #define IOASID_UNREGISTER_MEMORY	_IO(IOASID_TYPE, IOASID_BASE + 2)
>=20
> So VA ranges are pinned and stored in a tree and later references to
> those VA ranges by any other IOASID use the pin cached in the tree?
>=20
> It seems reasonable and is similar to the ioasid parent/child I
> suggested for PPC.
>=20
> IMHO this should be merged with the all SW IOASID that is required for
> today's mdev drivers. If this can be done while keeping this uAPI then
> great, otherwise I don't think it is so bad to weakly nest a physical
> IOASID under a SW one just to optimize page pinning.

Right, I think we can simplify the interface by modelling the
preregistration as a nesting layer.  Well, mostly.. the wrinkle is
that generally you can't do anything with an ioasid until you've
attached devices to it, but that doesn't really make sense for the
prereg layer.  I expect we can find some way to deal with that,
though.

Actually... to simplify that "weak nesting" concept I wonder if we
want to expand to 3 ways of specifying the pagetables for the ioasid:
  1) kernel managed (MAP/UNMAP)
  2) user managed (BIND/INVALIDATE)
  3) pass-though (IOVA=3D=3Dparent address)

Obviously pass-through wouldn't be allowed in all circumstances.

> Either way this seems like a smart direction
>=20
> > /*
> >   * Allocate an IOASID.=20
> >   *
> >   * IOASID is the FD-local software handle representing an I/O address=
=20
> >   * space. Each IOASID is associated with a single I/O page table. User=
=20
> >   * must call this ioctl to get an IOASID for every I/O address space t=
hat is
> >   * intended to be enabled in the IOMMU.
> >   *
> >   * A newly-created IOASID doesn't accept any command before it is=20
> >   * attached to a device. Once attached, an empty I/O page table is=20
> >   * bound with the IOMMU then the user could use either DMA mapping=20
> >   * or pgtable binding commands to manage this I/O page table.
>=20
> Can the IOASID can be populated before being attached?

I don't think it reasonably can.  Until attached, you don't actually
know what hardware IOMMU will be backing it, and therefore you don't
know it's capabilities.  You can't really allow mappings if you don't
even know allowed IOVA ranges and page size.

> >   * Device attachment is initiated through device driver uAPI (e.g. VFI=
O)
> >   *
> >   * Return: allocated ioasid on success, -errno on failure.
> >   */
> > #define IOASID_ALLOC	_IO(IOASID_TYPE, IOASID_BASE + 3)
> > #define IOASID_FREE	_IO(IOASID_TYPE, IOASID_BASE + 4)
>=20
> I assume alloc will include quite a big structure to satisfy the
> various vendor needs?
>=20
> > /*
> >   * Get information about an I/O address space
> >   *
> >   * Supported capabilities:
> >   *	- VFIO type1 map/unmap;
> >   *	- pgtable/pasid_table binding
> >   *	- hardware nesting vs. software nesting;
> >   *	- ...
> >   *
> >   * Related attributes:
> >   * 	- supported page sizes, reserved IOVA ranges (DMA mapping);
> >   *	- vendor pgtable formats (pgtable binding);
> >   *	- number of child IOASIDs (nesting);
> >   *	- ...
> >   *
> >   * Above information is available only after one or more devices are
> >   * attached to the specified IOASID. Otherwise the IOASID is just a
> >   * number w/o any capability or attribute.
>=20
> This feels wrong to learn most of these attributes of the IOASID after
> attaching to a device.

Yes... but as above, we have no idea what the IOMMU's capabilities are
until devices are attached.

> The user should have some idea how it intends to use the IOASID when
> it creates it and the rest of the system should match the intention.
>=20
> For instance if the user is creating a IOASID to cover the guest GPA
> with the intention of making children it should indicate this during
> alloc.
>=20
> If the user is intending to point a child IOASID to a guest page table
> in a certain descriptor format then it should indicate it during
> alloc.
>=20
> device bind should fail if the device somehow isn't compatible with
> the scheme the user is tring to use.

[snip]
> > 2.2. /dev/vfio uAPI
> > ++++++++++++++++
>=20
> To be clear you mean the 'struct vfio_device' API, these are not
> IOCTLs on the container or group?
>=20
> > /*
> >    * Bind a vfio_device to the specified IOASID fd
> >    *
> >    * Multiple vfio devices can be bound to a single ioasid_fd, but a si=
ngle
> >    * vfio device should not be bound to multiple ioasid_fd's.
> >    *
> >    * Input parameters:
> >    *  - ioasid_fd;
> >    *
> >    * Return: 0 on success, -errno on failure.
> >    */
> > #define VFIO_BIND_IOASID_FD           _IO(VFIO_TYPE, VFIO_BASE + 22)
> > #define VFIO_UNBIND_IOASID_FD _IO(VFIO_TYPE, VFIO_BASE + 23)
>=20
> This is where it would make sense to have an output "device id" that
> allows /dev/ioasid to refer to this "device" by number in events and
> other related things.

The group number could be used for that, even if there are no group
fds.  You generally can't identify things more narrowly than group
anyway.


--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--j/FYRtVn/XN5nkYp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmC3MZ8ACgkQbDjKyiDZ
s5Lp5hAAruXb3NLVtuLjvyAaqaKjXI0hJf+T5aYV2GsPEuBFfL3eejzD0+HE4dI8
Ww0npi2zKzGpAmFoPvMvfpYsANsnmLH5MdHs2DJ9WxFPGvSF67gZLc44rx1XBc2T
7IboRgMjF5kcKo0HFI+M7pkuvkwMEkkzZzMj7LQtSGOdyFewTJO24aSQZPwTv+JR
/+MXWXQqI1zkfOIVm8kCHqtAcz5Z6IlXJ1JYeRxLBZou8j1JJqkq1Xt/pEXhI1oZ
uIuoQxBwBOEoqBtnlmvUWPYfZ8MI0LnJdMWvBAkqFwzMMgkzfqxM4+hV8OfVBRyh
R6ZIVtEyNT5EuoTVLz8HEPUMgdMNgu9xObrZBRXJpzv/+lV010P44354bz3VxEvi
sgwjcCNYH8ZXNq3LuJOs1ApKoSwrE+FDNxJe5RmHVNp0ORzRqVeZ33JZS+sSk/CI
aem0ComVy47umR3JTjjiq+mBhQDISCIh7efu4tYLZsLbE3zKeHEfq7s87v8yYVcG
tcUzKYNMUONch/X+ChfbmubBr4aVxpgZ1BU3UzfTmQUWybljRVTdMA5qOsBewNIY
g9AMwr4/JWlA74pERIu+EDqPLAXt4DRHf7kmiG/uKTlZenCopwn3QGs40W+dAF7Y
82Etp785d9v9Yg8v5JMKc4nNcY4MK2ilEd0QVB+sK3kX3Zea6CM=
=TTLB
-----END PGP SIGNATURE-----

--j/FYRtVn/XN5nkYp--
