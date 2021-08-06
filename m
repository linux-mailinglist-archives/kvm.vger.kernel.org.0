Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0523E22E9
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 07:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243080AbhHFFdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 01:33:15 -0400
Received: from ozlabs.org ([203.11.71.1]:54219 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243050AbhHFFdO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 01:33:14 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4GgvJT60BHz9sX1; Fri,  6 Aug 2021 15:32:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1628227977;
        bh=gQFpsTSKxYiy9YNjHtkAUM5LWnSeyMow6ImKPR38sfE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FruikAjL6XJck5P18b0ckwSylnWUHR4bxgGMJdBLjT9WMMavATtT37v8hdAX68f2/
         Q+dqp59ifkAJPiajBJulLdTcPRbXLvH8AVBDMRlfwLWsdXi/lmZfV4jPHxYvIp9lO0
         cUqx9Lu+HIbRM3oNIDX5uSWGhtMTLtp30njvaosw=
Date:   Fri, 6 Aug 2021 14:45:26 +1000
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
Message-ID: <YQy+ZsCab6Ni/sN7@yekko>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YP4/KJoYfbaf5U94@yekko>
 <BN9PR11MB54332594B1B4003AE4B9238C8CEA9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YQig7EIVMAuzSgH4@yekko>
 <BN9PR11MB54338C2863EA94145710A1BA8CF09@BN9PR11MB5433.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OmR2m/upWzgV4r+h"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB54338C2863EA94145710A1BA8CF09@BN9PR11MB5433.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--OmR2m/upWzgV4r+h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 03, 2021 at 03:19:26AM +0000, Tian, Kevin wrote:
> > From: David Gibson <david@gibson.dropbear.id.au>
> > Sent: Tuesday, August 3, 2021 9:51 AM
> >=20
> > On Wed, Jul 28, 2021 at 04:04:24AM +0000, Tian, Kevin wrote:
> > > Hi, David,
> > >
> > > > From: David Gibson <david@gibson.dropbear.id.au>
> > > > Sent: Monday, July 26, 2021 12:51 PM
> > > >
> > > > On Fri, Jul 09, 2021 at 07:48:44AM +0000, Tian, Kevin wrote:
> > > > > /dev/iommu provides an unified interface for managing I/O page ta=
bles
> > for
> > > > > devices assigned to userspace. Device passthrough frameworks (VFI=
O,
> > > > vDPA,
> > > > > etc.) are expected to use this interface instead of creating thei=
r own
> > logic to
> > > > > isolate untrusted device DMAs initiated by userspace.
> > > > >
> > > > > This proposal describes the uAPI of /dev/iommu and also sample
> > > > sequences
> > > > > with VFIO as example in typical usages. The driver-facing kernel =
API
> > > > provided
> > > > > by the iommu layer is still TBD, which can be discussed after con=
sensus
> > is
> > > > > made on this uAPI.
> > > > >
> > > > > It's based on a lengthy discussion starting from here:
> > > > > 	https://lore.kernel.org/linux-
> > > > iommu/20210330132830.GO2356281@nvidia.com/
> > > > >
> > > > > v1 can be found here:
> > > > > 	https://lore.kernel.org/linux-
> > > >
> > iommu/PH0PR12MB54811863B392C644E5365446DC3E9@PH0PR12MB5481.n
> > > > amprd12.prod.outlook.com/T/
> > > > >
> > > > > This doc is also tracked on github, though it's not very useful f=
or v1->v2
> > > > > given dramatic refactoring:
> > > > > 	https://github.com/luxis1999/dev_iommu_uapi
> > > >
> > > > Thanks for all your work on this, Kevin.  Apart from the actual
> > > > semantic improvements, I'm finding v2 significantly easier to read =
and
> > > > understand than v1.
> > > >
> > > > [snip]
> > > > > 1.2. Attach Device to I/O address space
> > > > > +++++++++++++++++++++++++++++++++++++++
> > > > >
> > > > > Device attach/bind is initiated through passthrough framework uAP=
I.
> > > > >
> > > > > Device attaching is allowed only after a device is successfully b=
ound to
> > > > > the IOMMU fd. User should provide a device cookie when binding the
> > > > > device through VFIO uAPI. This cookie is used when the user queri=
es
> > > > > device capability/format, issues per-device iotlb invalidation and
> > > > > receives per-device I/O page fault data via IOMMU fd.
> > > > >
> > > > > Successful binding puts the device into a security context which =
isolates
> > > > > its DMA from the rest system. VFIO should not allow user to acces=
s the
> > > > > device before binding is completed. Similarly, VFIO should preven=
t the
> > > > > user from unbinding the device before user access is withdrawn.
> > > > >
> > > > > When a device is in an iommu group which contains multiple device=
s,
> > > > > all devices within the group must enter/exit the security context
> > > > > together. Please check {1.3} for more info about group isolation =
via
> > > > > this device-centric design.
> > > > >
> > > > > Successful attaching activates an I/O address space in the IOMMU,
> > > > > if the device is not purely software mediated. VFIO must provide =
device
> > > > > specific routing information for where to install the I/O page ta=
ble in
> > > > > the IOMMU for this device. VFIO must also guarantee that the atta=
ched
> > > > > device is configured to compose DMAs with the routing information
> > that
> > > > > is provided in the attaching call. When handling DMA requests, IO=
MMU
> > > > > identifies the target I/O address space according to the routing
> > > > > information carried in the request. Misconfiguration breaks DMA
> > > > > isolation thus could lead to severe security vulnerability.
> > > > >
> > > > > Routing information is per-device and bus specific. For PCI, it is
> > > > > Requester ID (RID) identifying the device plus optional Process A=
ddress
> > > > > Space ID (PASID). For ARM, it is Stream ID (SID) plus optional Su=
b-
> > Stream
> > > > > ID (SSID). PASID or SSID is used when multiple I/O address spaces=
 are
> > > > > enabled on a single device. For simplicity and continuity reason =
the
> > > > > following context uses RID+PASID though SID+SSID may sound a clea=
rer
> > > > > naming from device p.o.v. We can decide the actual naming when
> > coding.
> > > > >
> > > > > Because one I/O address space can be attached by multiple devices,
> > > > > per-device routing information (plus device cookie) is tracked un=
der
> > > > > each IOASID and is used respectively when activating the I/O addr=
ess
> > > > > space in the IOMMU for each attached device.
> > > > >
> > > > > The device in the /dev/iommu context always refers to a physical =
one
> > > > > (pdev) which is identifiable via RID. Physically each pdev can su=
pport
> > > > > one default I/O address space (routed via RID) and optionally mul=
tiple
> > > > > non-default I/O address spaces (via RID+PASID).
> > > > >
> > > > > The device in VFIO context is a logic concept, being either a phy=
sical
> > > > > device (pdev) or mediated device (mdev or subdev). Each vfio devi=
ce
> > > > > is represented by RID+cookie in IOMMU fd. User is allowed to crea=
te
> > > > > one default I/O address space (routed by vRID from user p.o.v) per
> > > > > each vfio_device. VFIO decides the routing information for this d=
efault
> > > > > space based on device type:
> > > > >
> > > > > 1)  pdev, routed via RID;
> > > > >
> > > > > 2)  mdev/subdev with IOMMU-enforced DMA isolation, routed via
> > > > >     the parent's RID plus the PASID marking this mdev;
> > > > >
> > > > > 3)  a purely sw-mediated device (sw mdev), no routing required i.=
e. no
> > > > >     need to install the I/O page table in the IOMMU. sw mdev just=
 uses
> > > > >     the metadata to assist its internal DMA isolation logic on to=
p of
> > > > >     the parent's IOMMU page table;
> > > > >
> > > > > In addition, VFIO may allow user to create additional I/O address
> > spaces
> > > > > on a vfio_device based on the hardware capability. In such case t=
he
> > user
> > > > > has its own view of the virtual routing information (vPASID) when
> > marking
> > > > > these non-default address spaces. How to virtualize vPASID is pla=
tform
> > > > > specific and device specific. Some platforms allow the user to fu=
lly
> > > > > manage the PASID space thus vPASIDs are directly used for routing=
 and
> > > > > even hidden from the kernel. Other platforms require the user to
> > > > > explicitly register the vPASID information to the kernel when att=
aching
> > > > > the vfio_device. In this case VFIO must figure out whether vPASID
> > should
> > > > > be directly used (pdev) or converted to a kernel-allocated pPASID=
 (mdev)
> > > > > for physical routing. Detail explanation about PASID virtualizati=
on can
> > > > > be found in {1.4}.
> > > > >
> > > > > For mdev both default and non-default I/O address spaces are rout=
ed
> > > > > via PASIDs. To better differentiate them we use "default PASID" (=
or
> > > > > defPASID) when talking about the default I/O address space on mde=
v.
> > > > When
> > > > > vPASID or pPASID is referred in PASID virtualization it's all abo=
ut the
> > > > > non-default spaces. defPASID and pPASID are always hidden from
> > > > userspace
> > > > > and can only be indirectly referenced via IOASID.
> > > >
> > > > That said, I'm still finding the various ways a device can attach to
> > > > an ioasid pretty confusing.  Here are some thoughts on some extra
> > > > concepts that might make it easier to handle [note, I haven't thoug=
ht
> > > > this all the way through so far, so there might be fatal problems w=
ith
> > > > this approach].
> > >
> > > Thanks for sharing your thoughts.
> > >
> > > >
> > > >  * DMA address type
> > > >
> > > >     This represents the format of the actual "over the wire" DMA
> > > >     address.  So far I only see 3 likely options for this 1) 32-bit,
> > > >     2) 64-bit and 3) PASID, meaning the 84-bit PASID+address
> > > >     combination.
> > > >
> > > >  * DMA identifier type
> > > >
> > > >     This represents the format of the "over the wire"
> > > >     device-identifying information that the IOMMU receives.  So "RI=
D",
> > > >     "RID+PASID", "SID+SSID" would all be DMA identifier types.  We
> > > >     could introduce some extra ones which might be necessary for
> > > >     software mdevs.
> > > >
> > > > So, every single DMA transaction has both DMA address and DMA
> > > > identifier information attached.  In some cases we get to choose how
> > > > we split the availble information between identifier and address, m=
ore
> > > > on that later.
> > > >
> > > >  * DMA endpoint
> > > >
> > > >     An endpoint would represent a DMA origin which is identifiable =
to
> > > >     the IOMMU.  I'm using the new term, because while this would
> > > >     sometimes correspond one to one with a device, there would be s=
ome
> > > >     cases where it does not.
> > > >
> > > >     a) Multiple devices could be a single DMA endpoint - this would
> > > >     be the case with non-ACS bridges or PCIe to PCI bridges where
> > > >     devices behind the bridge can't be distinguished from each othe=
r.
> > > >     Early versions might be able to treat all VFIO groups as single
> > > >     endpoints, which might simplify transition
> > > >
> > > >     b) A single device could supply multiple DMA endpoints, this wo=
uld
> > > >     be the case with PASID capable devices where you want to map
> > > >     different PASIDs to different IOASes.
> > > >
> > > >     **Caveat: feel free to come up with a better name than "endpoin=
t"
> > > >
> > > >     **Caveat: I'm not immediately sure how to represent these to
> > > >     userspace, and how we do that could have some important
> > > >     implications for managing their lifetime
> > > >
> > > > Every endpoint would have a fixed, known DMA address type and DMA
> > > > identifier type (though I'm not sure if we need/want to expose the =
DMA
> > > > identifier type to userspace).  Every IOAS would also have a DMA
> > > > address type fixed at IOAS creation.
> > > >
> > > > An endpoint can only be attached to one IOAS at a time.  It can only
> > > > be attached to an IOAS whose DMA address type matches the endpoint.
> > > >
> > > > Most userspace managed IO page formats would imply a particular DMA
> > > > address type, and also a particular DMA address type for their
> > > > "parent" IOAS.  I'd expect kernel managed IO page tables to be able=
 to
> > > > be able to handle most combinations.
> > > >
> > > > /dev/iommu would work entirely (or nearly so) in terms of endpoint
> > > > handles, not device handles.  Endpoints are what get bound to an IO=
AS,
> > > > and endpoints are what get the user chosen endpoint cookie.
> > > >
> > > > Getting endpoint handles from devices is handled on the VFIO/device
> > > > side.  The simplest transitional approach is probably for a VFIO pd=
ev
> > > > groups to expose just a single endpoint.  We can potentially make t=
hat
> > > > more flexible as a later step, and other subsystems might have other
> > > > needs.
> > >
> > > I wonder what is the real value of this endpoint concept. for SVA-cap=
able
> > > pdev case, the entire pdev is fully managed by the guest thus only the
> > > guest driver knows DMA endpoints on this pdev. vfio-pci doesn't know
> > > the presence of an endpoint until Qemu requests to do ioasid attaching
> > > after identifying an IOAS via vIOMMU.
> >=20
> > No.. that's not true.  vfio-pci knows it can generate a "RID"-type
> > endpoint for the device, and I assume the device will have a SVA
> > capability bit, which lets vfio know that the endpoint will generate
> > PASID+addr addresses, rather than plain 64-bit addresses.
> >=20
> > You can't construct RID+PASID endpoints with vfio's knowledge alone,
> > but that's ok - that style would be for mdevs or other cases where you
> > do have more information about the specific device.
>=20
> if vfio-pci cannot construct endpoint alone in all cases, then I worried
> we are just inventing unnecessary uAPI objects of which the role can=20
> be already fulfilled by device cookie+PASID in the proposed uAPI.

I don't see that the device cookie is relevant here - AIUI that's
*assigned* by the user, so it doesn't really address the original
identification of the device.  In my proposal you'd instead assign a
cookie to an endpoint, since that's the identifiable object.

The problem with "device+PASID" is that it only makes sense for some
versions of "device".  For mdevs that are implemented by using
one-PASID of a pdev, then the PASID is included already in the
"device" so adding a PASID makes no sense.  For devices that aren't
SVA capable, "device+PASID" is meaningful (sort of) but useless.

So, you have to know details of the type of device in order to use the
IOMMU APIs.  You have to know what kinds of devices an IOAS can
accomodate, and what kinds of binding to that IOAS it can accomodate.
Can a device be bound to multiple IOASes or not?  If you want to bind
it to multiple IOASes, does it need a specific kind of binding?

And that's before we even consider what some new bus revision might do
and what new possibilities that might add.

With endpoints it's simply "does this endpoint have the same address
type as the IOAS".

> > > If we want to build /dev/iommu
> > > uAPI around endpoint, probably vfio has to provide an uAPI for user to
> > > request creating an endpoint in the fly before doing the attaching ca=
ll.
> > > but what goodness does it bring with additional complexity, given what
> > > we require is just the RID or RID+PASID routing info which can be alr=
eady
> > > dig out by vfio driver w/o knowing any endpoint concept...
> >=20
> > It more clearly delineates who's responsible for what.  The driver
> > (VFIO, mdev, vDPA, whatever) supplies endpoints.  Depending on the
> > type of device it could be one endpoint per device, a choice of
> > several different endpoints for a device, several simultaneous
> > endpoints for the device, or one endpoint for several devices.  But
> > whatever it is that's all on the device side.  Once you get an
> > endpoint, it's always binding exactly one endpoint to exactly one IOAS
> > so the point at which the device side meets the IOMMU side becomes
> > much simpler.
>=20
> Sticking to iommu semantics {device, pasid} are clear enough for=20
> the user to build the connection between IOAS and device.

I don't really agree, it's certainly confusing to me.  Again the
problem is that "device" can cover a bunch of different meanings (PCI
device, mdev, kernel device).  Endpoint means, explicitly, "a thing
that can be bound to a single DMA address space at a time".

> This=20
> also matches the vIOMMU part which just understands vRID and=20
> vPASID, without any concept of endpoint. anyway RID+PASID (or=20
> SID+SSID) is what is defined in the bus to tag an IOAS. Forcing=20
> vIOMMU to fake an endpoint (via vfio) per PASID before doing=20
> attach just adds unnecessary confusion.

There's no faking here - the endpoint is a real thing, and you don't
need to have an endpoint per PASID.  As noted in one of the examples
and SVA capable device can be treated as single endpoint, with address
type "PASID+address".  The *possibility* of single-PASID endpoints
exists, so that a) single-PASID mdevs can expose themselves that way
and b) because for some user spacve drivers it might be more
convenient to=20

> > If we find a new device type or bus with a new way of doing DMA
> > addressing, it's just adding some address/id types; we don't need new
> > ways of binding these devices to the IOMMU.
>=20
> We just need define a better name to cover pasid, ssid, or other ids.=20
> regardless of the bus type, it's always the device cookie to identify=20
> the default I/O address space plus a what-ever id to tag other I/O=20
> address spaces targeted by the device.

Well, that's kind of what I'm doing.  PCI currently has the notion of
"default" address space for a RID, but there's no guarantee that other
buses (or even future PCI extensions) will.  The idea is that
"endpoint" means exactly the (RID, PASID) or (SID, SSID) or whatever
future variations are on that.  It can also then accomodate both
non-SVA PCI devices with simply a (RID) =3D=3D (RID, DEFAULT_PASID), a
case where you want to manage multiple PASIDs within a single IOMMU
table, again as just (RID), but with a complex address type.

> > > In concept I feel the purpose of DMA endpoint is equivalent to the ro=
uting
> > > info in this proposal.
> >=20
> > Maybe?  I'm afraid I never quite managed to understand the role of the
> > routing info in your proposal.
> >=20
>=20
> the IOMMU routes incoming DMA packets to a specific I/O page table,
> according to RID or RID+PASID carried in the packet. RID or RID+PASID
> is the routing information (represented by device cookie +PASID in
> proposed uAPI) and what the iommu driver really cares when activating=20
> the I/O page table in the iommu.

Ok, so yes, endpoint is roughly equivalent to that.  But my point is
that the IOMMU layer really only cares about that (device+routing)
combination, not other aspects of what the device is.  So that's the
concept we should give a name and put front and center in the API.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--OmR2m/upWzgV4r+h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmEMvmQACgkQbDjKyiDZ
s5KIrBAApHPKd+Skwh1Zlv1uaUV5PDvSHluMr17bFZ5rK5hyJU08e/2mVGIUyeM/
uSv1qg75LdYMXbPi1ffUCsuW1RS8/95l7QiAtlfeeGGKQngylQyY3gqwPx6Jz0d7
Ixakeagw3fuvmqYw3RSSBBqq8QHw+jB7pmjoOR4PEYQEYkICYvZnq12Ll+7fGDLi
RCl/O3PNV+reIkKNBOFJiLq2t3ZnU+vIMhoWII0GvzL7f+4Grd54tT6StuGQaN8C
k0gbN8w60pzMsyi4SS/HFRxLWSfEQDzGmm15/ov4e4TRP1/p9snB1wgTRwzBc+5d
TEzFEW6w5oitxnPF+zH4yyrey8TEYkQYZ9I3tg5QA4MOPWFlvxTho4zgqNvZ6KHX
H4Mzq8sSVGifeoawNxhTYDVSbrAqBOoCKF396zsb3aUacmf0rE7GteeT430G3iya
/KAJj7dxlFMB+E8JawO2TNbUEPJdVF8rE4qaYo+t1FlmDH4KHqlRFjbygAt5BZAD
4jUZROWJDnKOqDhETENA0kxx2gcKsYjA6mQm5TGAB4BLxvY38dS38/WPOMVFn9jI
6lUkW5uFFxbkH78138sLEN1d5CIoI29tDGD+H2H1e8msk5exYGWtVXjAd2IAuuva
TGIhNGToRhgqDT7HIN2s1u5Nzd9JJi+TbPYzn/dqT/z0efg9MIw=
=KS9v
-----END PGP SIGNATURE-----

--OmR2m/upWzgV4r+h--
