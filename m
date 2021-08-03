Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928363DE42D
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 03:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233304AbhHCB7x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 21:59:53 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:34303 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233208AbhHCB7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 21:59:52 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4Gdyjn1mCCz9sWS; Tue,  3 Aug 2021 11:59:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1627955981;
        bh=fq7sSDBueGfHLolaCZYUy66ypkaBpc90oupYp2B93Rw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iDj72gaV33fC9Nnrsg56AR8GKnL+w5o0IvkJzAo0IKwsmifbg4i7kW880Sewy+XG9
         MY8Rz0qNd5I0iL3UNQIXFIzc+08pD5Bzih+kvvTDZwva5a54ojDPoor8Wp+tt0CBq9
         lp8KridBkQjXWT8vOIafywN6ENb/0Saduht3FkD0=
Date:   Tue, 3 Aug 2021 11:50:36 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [RFC v2] /dev/iommu uAPI proposal
Message-ID: <YQig7EIVMAuzSgH4@yekko>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YP4/KJoYfbaf5U94@yekko>
 <BN9PR11MB54332594B1B4003AE4B9238C8CEA9@BN9PR11MB5433.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5IZa54qDMZ8MbAEA"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB54332594B1B4003AE4B9238C8CEA9@BN9PR11MB5433.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--5IZa54qDMZ8MbAEA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 28, 2021 at 04:04:24AM +0000, Tian, Kevin wrote:
> Hi, David,
>=20
> > From: David Gibson <david@gibson.dropbear.id.au>
> > Sent: Monday, July 26, 2021 12:51 PM
> >=20
> > On Fri, Jul 09, 2021 at 07:48:44AM +0000, Tian, Kevin wrote:
> > > /dev/iommu provides an unified interface for managing I/O page tables=
 for
> > > devices assigned to userspace. Device passthrough frameworks (VFIO,
> > vDPA,
> > > etc.) are expected to use this interface instead of creating their ow=
n logic to
> > > isolate untrusted device DMAs initiated by userspace.
> > >
> > > This proposal describes the uAPI of /dev/iommu and also sample
> > sequences
> > > with VFIO as example in typical usages. The driver-facing kernel API
> > provided
> > > by the iommu layer is still TBD, which can be discussed after consens=
us is
> > > made on this uAPI.
> > >
> > > It's based on a lengthy discussion starting from here:
> > > 	https://lore.kernel.org/linux-
> > iommu/20210330132830.GO2356281@nvidia.com/
> > >
> > > v1 can be found here:
> > > 	https://lore.kernel.org/linux-
> > iommu/PH0PR12MB54811863B392C644E5365446DC3E9@PH0PR12MB5481.n
> > amprd12.prod.outlook.com/T/
> > >
> > > This doc is also tracked on github, though it's not very useful for v=
1->v2
> > > given dramatic refactoring:
> > > 	https://github.com/luxis1999/dev_iommu_uapi
> >=20
> > Thanks for all your work on this, Kevin.  Apart from the actual
> > semantic improvements, I'm finding v2 significantly easier to read and
> > understand than v1.
> >=20
> > [snip]
> > > 1.2. Attach Device to I/O address space
> > > +++++++++++++++++++++++++++++++++++++++
> > >
> > > Device attach/bind is initiated through passthrough framework uAPI.
> > >
> > > Device attaching is allowed only after a device is successfully bound=
 to
> > > the IOMMU fd. User should provide a device cookie when binding the
> > > device through VFIO uAPI. This cookie is used when the user queries
> > > device capability/format, issues per-device iotlb invalidation and
> > > receives per-device I/O page fault data via IOMMU fd.
> > >
> > > Successful binding puts the device into a security context which isol=
ates
> > > its DMA from the rest system. VFIO should not allow user to access the
> > > device before binding is completed. Similarly, VFIO should prevent the
> > > user from unbinding the device before user access is withdrawn.
> > >
> > > When a device is in an iommu group which contains multiple devices,
> > > all devices within the group must enter/exit the security context
> > > together. Please check {1.3} for more info about group isolation via
> > > this device-centric design.
> > >
> > > Successful attaching activates an I/O address space in the IOMMU,
> > > if the device is not purely software mediated. VFIO must provide devi=
ce
> > > specific routing information for where to install the I/O page table =
in
> > > the IOMMU for this device. VFIO must also guarantee that the attached
> > > device is configured to compose DMAs with the routing information that
> > > is provided in the attaching call. When handling DMA requests, IOMMU
> > > identifies the target I/O address space according to the routing
> > > information carried in the request. Misconfiguration breaks DMA
> > > isolation thus could lead to severe security vulnerability.
> > >
> > > Routing information is per-device and bus specific. For PCI, it is
> > > Requester ID (RID) identifying the device plus optional Process Addre=
ss
> > > Space ID (PASID). For ARM, it is Stream ID (SID) plus optional Sub-St=
ream
> > > ID (SSID). PASID or SSID is used when multiple I/O address spaces are
> > > enabled on a single device. For simplicity and continuity reason the
> > > following context uses RID+PASID though SID+SSID may sound a clearer
> > > naming from device p.o.v. We can decide the actual naming when coding.
> > >
> > > Because one I/O address space can be attached by multiple devices,
> > > per-device routing information (plus device cookie) is tracked under
> > > each IOASID and is used respectively when activating the I/O address
> > > space in the IOMMU for each attached device.
> > >
> > > The device in the /dev/iommu context always refers to a physical one
> > > (pdev) which is identifiable via RID. Physically each pdev can support
> > > one default I/O address space (routed via RID) and optionally multiple
> > > non-default I/O address spaces (via RID+PASID).
> > >
> > > The device in VFIO context is a logic concept, being either a physical
> > > device (pdev) or mediated device (mdev or subdev). Each vfio device
> > > is represented by RID+cookie in IOMMU fd. User is allowed to create
> > > one default I/O address space (routed by vRID from user p.o.v) per
> > > each vfio_device. VFIO decides the routing information for this defau=
lt
> > > space based on device type:
> > >
> > > 1)  pdev, routed via RID;
> > >
> > > 2)  mdev/subdev with IOMMU-enforced DMA isolation, routed via
> > >     the parent's RID plus the PASID marking this mdev;
> > >
> > > 3)  a purely sw-mediated device (sw mdev), no routing required i.e. no
> > >     need to install the I/O page table in the IOMMU. sw mdev just uses
> > >     the metadata to assist its internal DMA isolation logic on top of
> > >     the parent's IOMMU page table;
> > >
> > > In addition, VFIO may allow user to create additional I/O address spa=
ces
> > > on a vfio_device based on the hardware capability. In such case the u=
ser
> > > has its own view of the virtual routing information (vPASID) when mar=
king
> > > these non-default address spaces. How to virtualize vPASID is platform
> > > specific and device specific. Some platforms allow the user to fully
> > > manage the PASID space thus vPASIDs are directly used for routing and
> > > even hidden from the kernel. Other platforms require the user to
> > > explicitly register the vPASID information to the kernel when attachi=
ng
> > > the vfio_device. In this case VFIO must figure out whether vPASID sho=
uld
> > > be directly used (pdev) or converted to a kernel-allocated pPASID (md=
ev)
> > > for physical routing. Detail explanation about PASID virtualization c=
an
> > > be found in {1.4}.
> > >
> > > For mdev both default and non-default I/O address spaces are routed
> > > via PASIDs. To better differentiate them we use "default PASID" (or
> > > defPASID) when talking about the default I/O address space on mdev.
> > When
> > > vPASID or pPASID is referred in PASID virtualization it's all about t=
he
> > > non-default spaces. defPASID and pPASID are always hidden from
> > userspace
> > > and can only be indirectly referenced via IOASID.
> >=20
> > That said, I'm still finding the various ways a device can attach to
> > an ioasid pretty confusing.  Here are some thoughts on some extra
> > concepts that might make it easier to handle [note, I haven't thought
> > this all the way through so far, so there might be fatal problems with
> > this approach].
>=20
> Thanks for sharing your thoughts.
>=20
> >=20
> >  * DMA address type
> >=20
> >     This represents the format of the actual "over the wire" DMA
> >     address.  So far I only see 3 likely options for this 1) 32-bit,
> >     2) 64-bit and 3) PASID, meaning the 84-bit PASID+address
> >     combination.
> >=20
> >  * DMA identifier type
> >=20
> >     This represents the format of the "over the wire"
> >     device-identifying information that the IOMMU receives.  So "RID",
> >     "RID+PASID", "SID+SSID" would all be DMA identifier types.  We
> >     could introduce some extra ones which might be necessary for
> >     software mdevs.
> >=20
> > So, every single DMA transaction has both DMA address and DMA
> > identifier information attached.  In some cases we get to choose how
> > we split the availble information between identifier and address, more
> > on that later.
> >=20
> >  * DMA endpoint
> >=20
> >     An endpoint would represent a DMA origin which is identifiable to
> >     the IOMMU.  I'm using the new term, because while this would
> >     sometimes correspond one to one with a device, there would be some
> >     cases where it does not.
> >=20
> >     a) Multiple devices could be a single DMA endpoint - this would
> >     be the case with non-ACS bridges or PCIe to PCI bridges where
> >     devices behind the bridge can't be distinguished from each other.
> >     Early versions might be able to treat all VFIO groups as single
> >     endpoints, which might simplify transition
> >=20
> >     b) A single device could supply multiple DMA endpoints, this would
> >     be the case with PASID capable devices where you want to map
> >     different PASIDs to different IOASes.
> >=20
> >     **Caveat: feel free to come up with a better name than "endpoint"
> >=20
> >     **Caveat: I'm not immediately sure how to represent these to
> >     userspace, and how we do that could have some important
> >     implications for managing their lifetime
> >=20
> > Every endpoint would have a fixed, known DMA address type and DMA
> > identifier type (though I'm not sure if we need/want to expose the DMA
> > identifier type to userspace).  Every IOAS would also have a DMA
> > address type fixed at IOAS creation.
> >=20
> > An endpoint can only be attached to one IOAS at a time.  It can only
> > be attached to an IOAS whose DMA address type matches the endpoint.
> >=20
> > Most userspace managed IO page formats would imply a particular DMA
> > address type, and also a particular DMA address type for their
> > "parent" IOAS.  I'd expect kernel managed IO page tables to be able to
> > be able to handle most combinations.
> >=20
> > /dev/iommu would work entirely (or nearly so) in terms of endpoint
> > handles, not device handles.  Endpoints are what get bound to an IOAS,
> > and endpoints are what get the user chosen endpoint cookie.
> >=20
> > Getting endpoint handles from devices is handled on the VFIO/device
> > side.  The simplest transitional approach is probably for a VFIO pdev
> > groups to expose just a single endpoint.  We can potentially make that
> > more flexible as a later step, and other subsystems might have other
> > needs.
>=20
> I wonder what is the real value of this endpoint concept. for SVA-capable=
=20
> pdev case, the entire pdev is fully managed by the guest thus only the=20
> guest driver knows DMA endpoints on this pdev. vfio-pci doesn't know
> the presence of an endpoint until Qemu requests to do ioasid attaching
> after identifying an IOAS via vIOMMU.

No.. that's not true.  vfio-pci knows it can generate a "RID"-type
endpoint for the device, and I assume the device will have a SVA
capability bit, which lets vfio know that the endpoint will generate
PASID+addr addresses, rather than plain 64-bit addresses.

You can't construct RID+PASID endpoints with vfio's knowledge alone,
but that's ok - that style would be for mdevs or other cases where you
do have more information about the specific device.

> If we want to build /dev/iommu
> uAPI around endpoint, probably vfio has to provide an uAPI for user to=20
> request creating an endpoint in the fly before doing the attaching call.
> but what goodness does it bring with additional complexity, given what=20
> we require is just the RID or RID+PASID routing info which can be already=
=20
> dig out by vfio driver w/o knowing any endpoint concept...

It more clearly delineates who's responsible for what.  The driver
(VFIO, mdev, vDPA, whatever) supplies endpoints.  Depending on the
type of device it could be one endpoint per device, a choice of
several different endpoints for a device, several simultaneous
endpoints for the device, or one endpoint for several devices.  But
whatever it is that's all on the device side.  Once you get an
endpoint, it's always binding exactly one endpoint to exactly one IOAS
so the point at which the device side meets the IOMMU side becomes
much simpler.

If we find a new device type or bus with a new way of doing DMA
addressing, it's just adding some address/id types; we don't need new
ways of binding these devices to the IOMMU.

> In concept I feel the purpose of DMA endpoint is equivalent to the routin=
g=20
> info in this proposal.

Maybe?  I'm afraid I never quite managed to understand the role of the
routing info in your proposal.

> But making it explicitly in uAPI doesn't sound bring=20
> more value...
>=20
> Thanks
> Kevin
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--5IZa54qDMZ8MbAEA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmEIoOkACgkQbDjKyiDZ
s5IxWA/+Kt5O6syPedIi8aylqabyK/AhNnijrfEWG16a5flMqnuWqiP15lqzNqTE
5hhx20FzYhkcFWcSc9efulHafPmmpR6zq+WysV7YjeLNamVZ44AivsmqjQUJFs1q
Bjm0CUViD2An3dzrc31xZ8pobqw7k5PyJsgx5i+WUKXxc7ODUZvtvjhbVt4Oku8W
BqeUz2FVtuR41L7Iuucj87oB4bTAO+Jyh10VtPigA2oHARslvK4Xch9I/0vSSSr6
5caqMgmgqcQnRaKnzQHv5jvCpa2wr8yG84FTt6hIwqRvpOUo7E/Vux5yz9HK/dJg
PDVjLnDn0JHmtV2ozU8lE4tBEi56CRw6NUW+5z96WA53Hkw4BxRVyPz/b2if+5SL
zOAtKmcchs4gN6Qkuo7QeEVAAATiSq5nlQKOZiHcaBLmzsovoVQxBA4NzEogjNBe
bgKES9p/n0tq4faHr6xXviSWv62IagIrubEJ+NROX0AKypS1hlV4hoDcp44Qtw83
ip/TomdL8L8b5bw0LJFLGdg7onrgpn8EcdafjOzITLA7eSXTarQq9PCdx7hSwAlM
8pW+TCBESf86qO1Qo2Z5mVz3okzXisYhwflj7p69fXo3tBAYACJ087caKopRIl7s
k6AwbelJDAGI4AJPm8nnabKfQ61HSvEtfILn4fZpibH4Wv5meTY=
=kt71
-----END PGP SIGNATURE-----

--5IZa54qDMZ8MbAEA--
