Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7623341E796
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 08:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352367AbhJAGcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 02:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352221AbhJAGc2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 02:32:28 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41ECC061774;
        Thu, 30 Sep 2021 23:30:44 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HLKxG5rp3z4xbY; Fri,  1 Oct 2021 16:30:42 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1633069842;
        bh=H1uXsEPf+n9R7M0SONIXcs2ex2FVuo8AJvH1kuhi3RQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U+0RYR17CCwg3X+PvJ6mnOgjsbc/Cn215Ym83b9EjFnj86kh0GidiDYNvkyFKXUHK
         0Wezo/RYB4iu7Uh58pgrYNJugg5lwAdVoRUwgMhZ7IXGax5sqDNbNXjjqZZYD3T58Q
         AddmiHAeqql9BilGLnJCrUjudEaiQIqjp31/F0AA=
Date:   Fri, 1 Oct 2021 16:26:40 +1000
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
Message-ID: <YVaqIB32MzppOcxl@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com>
 <BN9PR11MB543362CEBDAD02DA9F06D8ED8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922140911.GT327412@nvidia.com>
 <BN9PR11MB5433A47FFA0A8C51643AA33C8CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RaIhWQFJkl9r3qKT"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433A47FFA0A8C51643AA33C8CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--RaIhWQFJkl9r3qKT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 23, 2021 at 09:14:58AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, September 22, 2021 10:09 PM
> >=20
> > On Wed, Sep 22, 2021 at 03:40:25AM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Wednesday, September 22, 2021 1:45 AM
> > > >
> > > > On Sun, Sep 19, 2021 at 02:38:39PM +0800, Liu Yi L wrote:
> > > > > This patch adds IOASID allocation/free interface per iommufd. When
> > > > > allocating an IOASID, userspace is expected to specify the type a=
nd
> > > > > format information for the target I/O page table.
> > > > >
> > > > > This RFC supports only one type
> > (IOMMU_IOASID_TYPE_KERNEL_TYPE1V2),
> > > > > implying a kernel-managed I/O page table with vfio type1v2 mapping
> > > > > semantics. For this type the user should specify the addr_width of
> > > > > the I/O address space and whether the I/O page table is created in
> > > > > an iommu enfore_snoop format. enforce_snoop must be true at this
> > point,
> > > > > as the false setting requires additional contract with KVM on han=
dling
> > > > > WBINVD emulation, which can be added later.
> > > > >
> > > > > Userspace is expected to call IOMMU_CHECK_EXTENSION (see next
> > patch)
> > > > > for what formats can be specified when allocating an IOASID.
> > > > >
> > > > > Open:
> > > > > - Devices on PPC platform currently use a different iommu driver =
in vfio.
> > > > >   Per previous discussion they can also use vfio type1v2 as long =
as there
> > > > >   is a way to claim a specific iova range from a system-wide addr=
ess
> > space.
> > > > >   This requirement doesn't sound PPC specific, as addr_width for =
pci
> > > > devices
> > > > >   can be also represented by a range [0, 2^addr_width-1]. This RFC
> > hasn't
> > > > >   adopted this design yet. We hope to have formal alignment in v1
> > > > discussion
> > > > >   and then decide how to incorporate it in v2.
> > > >
> > > > I think the request was to include a start/end IO address hint when
> > > > creating the ios. When the kernel creates it then it can return the
> > >
> > > is the hint single-range or could be multiple-ranges?
> >=20
> > David explained it here:
> >=20
> > https://lore.kernel.org/kvm/YMrKksUeNW%2FPEGPM@yekko/
> >=20
> > qeumu needs to be able to chooose if it gets the 32 bit range or 64
> > bit range.
> >=20
> > So a 'range hint' will do the job
> >=20
> > David also suggested this:
> >=20
> > https://lore.kernel.org/kvm/YL6%2FbjHyuHJTn4Rd@yekko/
> >=20
> > So I like this better:
> >=20
> > struct iommu_ioasid_alloc {
> > 	__u32	argsz;
> >=20
> > 	__u32	flags;
> > #define IOMMU_IOASID_ENFORCE_SNOOP	(1 << 0)
> > #define IOMMU_IOASID_HINT_BASE_IOVA	(1 << 1)
> >=20
> > 	__aligned_u64 max_iova_hint;
> > 	__aligned_u64 base_iova_hint; // Used only if
> > IOMMU_IOASID_HINT_BASE_IOVA
> >=20
> > 	// For creating nested page tables
> > 	__u32 parent_ios_id;
> > 	__u32 format;
> > #define IOMMU_FORMAT_KERNEL 0
> > #define IOMMU_FORMAT_PPC_XXX 2
> > #define IOMMU_FORMAT_[..]
> > 	u32 format_flags; // Layout depends on format above
> >=20
> > 	__aligned_u64 user_page_directory;  // Used if parent_ios_id !=3D 0
> > };
> >=20
> > Again 'type' as an overall API indicator should not exist, feature
> > flags need to have clear narrow meanings.
>=20
> currently the type is aimed to differentiate three usages:
>=20
> - kernel-managed I/O page table
> - user-managed I/O page table
> - shared I/O page table (e.g. with mm, or ept)
>=20
> we can remove 'type', but is FORMAT_KENREL/USER/SHARED a good
> indicator? their difference is not about format.

To me "format" indicates how the IO translation information is
encoded.  We potentially have two different encodings: from userspace
to the kernel and from the kernel to the hardware.  But since this is
the userspace API, it's only the userspace to kernel one that matters
here.

In that sense, KERNEL, is a "format": we encode the translation
information as a series of IOMAP operations to the kernel, rather than
as an in-memory structure.

> > This does both of David's suggestions at once. If quemu wants the 1G
> > limited region it could specify max_iova_hint =3D 1G, if it wants the
> > extend 64bit region with the hole it can give either the high base or
> > a large max_iova_hint. format/format_flags allows a further
>=20
> Dave's links didn't answer one puzzle from me. Does PPC needs accurate
> range information or be ok with a large range including holes (then let
> the kernel to figure out where the holes locate)?

I need more specifics to answer that.  Are you talking from a
userspace PoV, a guest kernel's or the host kernel's?  In general I
think requiring userspace to locate and work aronud holes is a bad
idea.  If userspace requests a range, it should get *all* of that
range.

The ppc case is further complicated because there are multiple ranges
and each range could have separate IO page tables.  In practice
non-kernel managed IO pagetables are likely to be hard on ppc (or at
least rely on firmware/hypervisor interfaces which don't exist yet,
AFAIK).  But even then, the underlying hardware page table format can
affect the minimum pagesize of each range, which could be different.

How all of this interacts with PASIDs I really haven't figured out.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--RaIhWQFJkl9r3qKT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFWqiAACgkQbDjKyiDZ
s5L2nQ//QApXdxbmnKil2cF2UXibTus/87OZ+VoAVNEbp1ISlhEr5bme2TadAT2w
ufENtYSNpqO5pcPahh0ZqefYpAEa07sZEUsx2JaZ7WsrHO2hfHIwiH5H1wuQDVYn
CEK4yxUnzNv1YRWBEuh2FoLgOSeOFsGoCO/75YmMQcI4qeYtaecVVHdzjoec56hn
L34QCRo3IbalHLvzdRMBq51x9grNPEzE0JN3V1ElT3d0K7JFExNF7+OW7P7TmbnN
23B0SWZOmAP6IGIECGWbRm+2iCrLDKEfalvSrU4uLFi0/GxRRCQl9kLd0AChRvmk
bJdbKddyokZgDNX2937o3YzOZW14zZdQZtv0Culakr5n+T85Uqj3e7NzC/J+pd/F
0DgbHq92xOkBTS1qZfGL+s9NBCj8m0tZaya2aZfxRlU0RTh5B6yqzPgNwRDTqjDe
9JyyZPoR8HZ2jv9cOSKVpYSBRsDddyILdvZO6gp2/R8CPfRjnx90y0iIPuucAar6
+gXZP5c+3ooNt0iT5xHvO60s8i74fbXa8wAnkeWI3r/8I2b+uN+6po79Npgv3ks5
oLPoj/8tE+f3q1iQ+4NGkvov0ChQKpz1F+/gWPlccRmwnaUsfs5qaoheUM6HS204
qZ+8/XTdiwv0qBCsYMn8YQ0Im7OkhypIzXdfQaxPpZuekeHIJ1k=
=J9jC
-----END PGP SIGNATURE-----

--RaIhWQFJkl9r3qKT--
