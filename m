Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05CCD525AE4
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 06:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376935AbiEMEiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 00:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352463AbiEMEiM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 00:38:12 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD48A5E76B
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 21:38:07 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4Kzwqv0TPlz4xXS; Fri, 13 May 2022 14:38:03 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1652416683;
        bh=Dide6YGka/WEbbI7qkCikEDumjdcUQqTdjc8o2b9uDE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H1kI0XQLM/Sb4ihByK8TZMXnmimBQ+jx+hgehQpnCus1Tf3RvX5bfOEL1Z1dYIFiU
         2NoeFTEdMFEmKSP5ns3mFibv3WWXV9rYmsfqwMCOTCs8cXfaGlFpr+H/mktDYpK5Du
         oSU/FRiPAZAdDOUyOWzSATiaZM6OIiHRx+fVs8I0=
Date:   Fri, 13 May 2022 14:35:46 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Message-ID: <Yn3gIiGLyHB/5kN4@yekko>
References: <20220429124838.GW8364@nvidia.com>
 <Ym+IfTvdD2zS6j4G@yekko>
 <20220505190728.GV49344@nvidia.com>
 <YnSxL5KxwJvQzd2Q@yekko>
 <20220506124837.GB49344@nvidia.com>
 <YniuUMCBjy0BaJC6@yekko>
 <20220509140041.GK49344@nvidia.com>
 <YnoQREfceIoLATDA@yekko>
 <20220510190009.GO49344@nvidia.com>
 <BN9PR11MB52765D95C6172ABE43E236A38CC89@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="idTOIBXnjRvzu8WC"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52765D95C6172ABE43E236A38CC89@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--idTOIBXnjRvzu8WC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 11, 2022 at 03:15:22AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, May 11, 2022 3:00 AM
> >=20
> > On Tue, May 10, 2022 at 05:12:04PM +1000, David Gibson wrote:
> > > Ok... here's a revised version of my proposal which I think addresses
> > > your concerns and simplfies things.
> > >
> > > - No new operations, but IOAS_MAP gets some new flags (and IOAS_COPY
> > >   will probably need matching changes)
> > >
> > > - By default the IOVA given to IOAS_MAP is a hint only, and the IOVA
> > >   is chosen by the kernel within the aperture(s).  This is closer to
> > >   how mmap() operates, and DPDK and similar shouldn't care about
> > >   having specific IOVAs, even at the individual mapping level.
> > >
> > > - IOAS_MAP gets an IOMAP_FIXED flag, analagous to mmap()'s MAP_FIXED,
> > >   for when you really do want to control the IOVA (qemu, maybe some
> > >   special userspace driver cases)
> >=20
> > We already did both of these, the flag is called
> > IOMMU_IOAS_MAP_FIXED_IOVA - if it is not specified then kernel will
> > select the IOVA internally.
> >=20
> > > - ATTACH will fail if the new device would shrink the aperture to
> > >   exclude any already established mappings (I assume this is already
> > >   the case)
> >=20
> > Yes
> >=20
> > > - IOAS_MAP gets an IOMAP_RESERVE flag, which operates a bit like a
> > >   PROT_NONE mmap().  It reserves that IOVA space, so other (non-FIXED)
> > >   MAPs won't use it, but doesn't actually put anything into the IO
> > >   pagetables.
> > >     - Like a regular mapping, ATTACHes that are incompatible with an
> > >       IOMAP_RESERVEed region will fail
> > >     - An IOMAP_RESERVEed area can be overmapped with an IOMAP_FIXED
> > >       mapping
> >=20
> > Yeah, this seems OK, I'm thinking a new API might make sense because
> > you don't really want mmap replacement semantics but a permanent
> > record of what IOVA must always be valid.
> >=20
> > IOMMU_IOA_REQUIRE_IOVA perhaps, similar signature to
> > IOMMUFD_CMD_IOAS_IOVA_RANGES:
> >=20
> > struct iommu_ioas_require_iova {
> >         __u32 size;
> >         __u32 ioas_id;
> >         __u32 num_iovas;
> >         __u32 __reserved;
> >         struct iommu_required_iovas {
> >                 __aligned_u64 start;
> >                 __aligned_u64 last;
> >         } required_iovas[];
> > };
>=20
> As a permanent record do we want to enforce that once the required
> range list is set all FIXED and non-FIXED allocations must be within the
> list of ranges?

No, I don't think so.  In fact the way I was envisaging this,
non-FIXED mappings will *never* go into the reserved ranges.  This is
for the benefit of any use cases that need both mappings where they
don't care about the IOVA and those which do.

Essentially, reserving a region here is saying to the kernel "I want
to manage this IOVA space; make sure nothing else touches it".  That
means both that the kernel must disallow any hw associated changes
(like ATTACH) which would impinge on the reserved region, and also any
IOVA allocations that would take parts away from that space.

Whether we want to restrict FIXED mappings to the reserved regions is
an interesting question.  I wasn't thinking that would be necessary
(just as you can use mmap() MAP_FIXED anywhere).  However.. much as
MAP_FIXED is very dangerous to use if you don't previously reserve
address space, I think IOMAP_FIXED is dangerous if you haven't
previously reserved space.  So maybe it would make sense to only allow
FIXED mappings within reserved regions.

Strictly dividing the IOVA space into kernel managed and user managed
regions does make a certain amount of sense.

> If yes we can take the end of the last range as the max size of the iova
> address space to optimize the page table layout.
>=20
> otherwise we may need another dedicated hint for that optimization.

Right.  With the revised model where reserving windows is optional,
not required, I don't think we can quite re-use this for optimization
hints.  Which is a bit unfortunate.

I can't immediately see a way to tweak this which handles both more
neatly, but I like the idea if we can figure out a way.

> > > So, for DPDK the sequence would be:
> > >
> > > 1. Create IOAS
> > > 2. ATTACH devices
> > > 3. IOAS_MAP some stuff
> > > 4. Do DMA with the IOVAs that IOAS_MAP returned
> > >
> > > (Note, not even any need for QUERY in simple cases)
> >=20
> > Yes, this is done already
> >=20
> > > For (unoptimized) qemu it would be:
> > >
> > > 1. Create IOAS
> > > 2. IOAS_MAP(IOMAP_FIXED|IOMAP_RESERVE) the valid IOVA regions of
> > the
> > >    guest platform
> > > 3. ATTACH devices (this will fail if they're not compatible with the
> > >    reserved IOVA regions)
> > > 4. Boot the guest
>=20
> I suppose above is only the sample flow for PPC vIOMMU. For non-PPC
> vIOMMUs regular mappings are required before booting the guest and
> reservation might be done but not mandatory (at least not what current
> Qemu vfio can afford as it simply replays valid ranges in the CPU address
> space).

That was a somewhat simplified description.  When we look in more
detail, I think the ppc and x86 models become more similar.  So, in
more detail, I think it would look like this:

1. Create base IOAS
2. Map guest memory into base IOAS so that IOVA=3D=3DGPA
3. Create IOASes for each vIOMMU domain
4. Reserve windows in domain IOASes where the vIOMMU will allow
   mappings by default
5. ATTACH devices to appropriate IOASes (***)
6. Boot the guest

  On guest map/invalidate:
        Use IOAS_COPY to take mappings from base IOAS and put them
	into the domain IOAS
  On memory hotplug:
        IOAS_MAP new memory block into base IOAS
  On dev hotplug: (***)
        ATTACH devices to appropriate IOAS
  On guest reconfiguration of vIOMMU domains (x86 only):
        DETACH device from base IOAS, attach to vIOMMU domain IOAS
  On guest reconfiguration of vIOMMU apertures (ppc only):
        Alter reserved regions to match vIOMMU

The difference between ppc and x86 is at the places marked (***):
which IOAS each device gets attached to and when. For x86 all devices
live in the base IOAS by default, and only get moved to domain IOASes
when those domains are set up in the vIOMMU.  For POWER each device
starts in a domain IOAS based on its guest PE, and never moves.

[This is still a bit simplified.  In practice, I imagine you'd
 optimize to only create the domain IOASes at the point
 they're needed - on boot for ppc, but only when the vIOMMU is
 configured for x86.  I don't think that really changes the model,
 though.]

A few aspects of the model interact quite nicely here.  Mapping a
large memory guest with IOVA=3D=3DGPA would probably fail on a ppc host
IOMMU.  But if both guest and host are ppc, then no devices get
attached to that base IOAS, so its apertures don't get restricted by
the host hardware.  That way we get a common model, and the benefits
of GUP sharing via IOAS_COPY, without it failing in the ppc-on-ppc
case.

x86-on-ppc and ppc-on-x86 will probably only work in limited cases
where the various sizes and windows line up, but the possibility isn't
precluded by the model or interfaces.

> > >   (on guest map/invalidate) -> IOAS_MAP(IOMAP_FIXED) to overmap part
> > of
> > >                                the reserved regions
> > >   (on dev hotplug) -> ATTACH (which might fail, if it conflicts with =
the
> > >                       reserved regions)
> > >   (on vIOMMU reconfiguration) -> UNMAP/MAP reserved regions as
> > >                                  necessary (which might fail)
> >=20
> > OK, I will take care of it
> >=20
> > Thanks,
> > Jason
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--idTOIBXnjRvzu8WC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEoULxWu4/Ws0dB+XtgypY4gEwYSIFAmJ94BsACgkQgypY4gEw
YSLK1hAAuRtE44lGB/3a85CJaQgS6UYt1HgVR941flEFi3XvsVP4yrxTYgy6gKrC
/BHwoAptrle09axXsaLGlaUOA4C/MaI5c6SdDV86NMGQYAdi2UtZieewDrDAHv8F
lxU8OtI6AMvuBFclkupUsYYJZSb7MXZoCLHsdc9FbWMWHQqXNCrcE1AF69+vOaNB
rBWmYtZ05+VGp8Qv0MgcHPY3JVToPUxyy53pbJ39jn9nLuDRzRmeP1fkbXhxB7Xr
+KdT08+TR/xN83fjUOSQcGejTAoCNH9oRdfrax42Y56VibiUkwjcaTpI4ViVv6nc
W3Mt16MwGKI6rq8a3f1M3RywofSowvgpSTgCDeD6gcNhns09Sr178aj6Rx2U7QYF
MITCzU0gSDI4zqAXrmAblmXmWy8GXg9Cng7NKczklafMwnTlS7eCJso4E983HNwT
FTtMFOJXiG/b09MuFeqrz3mtfNXBGAdMSktzZhTRWaJxdoPRaRdtl9bCImvIWrHm
7rkP7eB16UF+M4YjZdS827tSQmrOES0dn2h6IaJGdBPLTNOYruhTEEJt9jPd79j9
myRbQQUUloTnp0AGb7gcOunZZM/cxSqSPt+Jf1WoBMQvSC6rLtdXYGjcY4bUXLxs
TVTurHRMI7EmTWWCC0AwA9j+bbOP35Xu/TMfUZH3GSXZLrqsp+0=
=/Uho
-----END PGP SIGNATURE-----

--idTOIBXnjRvzu8WC--
