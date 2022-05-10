Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C548520E9D
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 09:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237901AbiEJHhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 03:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239824AbiEJHQK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 03:16:10 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38D02983BE
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 00:12:11 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4Ky8P615m0z4xXS; Tue, 10 May 2022 17:12:10 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1652166730;
        bh=zMuUJGugRXHnNZGkMaxRqg6d4pu1Btb+JvtWZ93qrVc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PirfkBL4HAJ0ScYtH7vkb94Sgxw9FXCCK0aTFmAGA7+J/qt34vZIJqvVClms0HUva
         94DSiIKtUjqCgsNdibEY4xxSeoVqnAtrtfOMX0uEPPiJ3UnCUJ8LhxS9Y7nAAZzRUx
         AA4aEhWlQuSxK7pT6SbeXi+LE5GPpZHauSHFf3BE=
Date:   Tue, 10 May 2022 17:12:04 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Message-ID: <YnoQREfceIoLATDA@yekko>
References: <YmqqXHsCTxVb2/Oa@yekko>
 <20220428151037.GK8364@nvidia.com>
 <YmuDtPMksOj7NOEh@yekko>
 <20220429124838.GW8364@nvidia.com>
 <Ym+IfTvdD2zS6j4G@yekko>
 <20220505190728.GV49344@nvidia.com>
 <YnSxL5KxwJvQzd2Q@yekko>
 <20220506124837.GB49344@nvidia.com>
 <YniuUMCBjy0BaJC6@yekko>
 <20220509140041.GK49344@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nFv8YkIpKzhmM4mq"
Content-Disposition: inline
In-Reply-To: <20220509140041.GK49344@nvidia.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--nFv8YkIpKzhmM4mq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 09, 2022 at 11:00:41AM -0300, Jason Gunthorpe wrote:
> On Mon, May 09, 2022 at 04:01:52PM +1000, David Gibson wrote:
>=20
> > > The default iommu_domain that the iommu driver creates will be used
> > > here, it is up to the iommu driver to choose something reasonable for
> > > use by applications like DPDK. ie PPC should probably pick its biggest
> > > x86-like aperture.
> >=20
> > So, using the big aperture means a very high base IOVA
> > (1<<59)... which means that it won't work at all if you want to attach
> > any devices that aren't capable of 64-bit DMA.
>=20
> I'd expect to include the 32 bit window too..

I'm not entirely sure what you mean.  Are you working on the
assumption that we've extended to allowing multiple apertures, so we'd
default to advertising both a small/low aperture and a large/high
aperture?

> > Using the maximum possible window size would mean we either
> > potentially waste a lot of kernel memory on pagetables, or we use
> > unnecessarily large number of levels to the pagetable.
>=20
> All drivers have this issue to one degree or another. We seem to be
> ignoring it - in any case this is a micro optimization, not a
> functional need?

Ok, fair point.

> > More generally, the problem with the interface advertising limitations
> > and it being up to userspace to work out if those are ok or not is
> > that it's fragile.  It's pretty plausible that some future IOMMU model
> > will have some new kind of limitation that can't be expressed in the
> > query structure we invented now.
>=20
> The basic API is very simple - the driver needs to provide ranges of
> IOVA and map/unmap - I don't think we have a future problem here we
> need to try and guess and solve today.

Well.. maybe.  My experience of encountering hardware doing weird-arse
stuff makes me less sanguine.

> Even PPC fits this just fine, the open question for DPDK is more
> around optimization, not functional.
>=20
> > But if userspace requests the capabilities it wants, and the kernel
> > acks or nacks that, we can support the new host IOMMU with existing
> > software just fine.
>=20
> No, this just makes it fragile in the other direction because now
> userspace has to know what platform specific things to ask for *or it
> doesn't work at all*. This is not a improvement for the DPDK cases.

Um.. no.  The idea is that userspace requests *what it needs*, not
anything platform specific.  In the case of DPDK that would be nothing
more than the (minimum) aperture size.  Nothing platform specific
about that.

> Kernel decides, using all the kernel knowledge it has and tells the
> application what it can do - this is the basic simplified interface.
>=20
> > > The iommu-driver-specific struct is the "advanced" interface and
> > > allows a user-space IOMMU driver to tightly control the HW with full
> > > HW specific knowledge. This is where all the weird stuff that is not
> > > general should go.
> >=20
> > Right, but forcing anything more complicated than "give me some IOVA
> > region" to go through the advanced interface means that qemu (or any
> > hypervisor where the guest platform need not identically match the
> > host) has to have n^2 complexity to match each guest IOMMU model to
> > each host IOMMU model.
>=20
> I wouldn't say n^2, but yes, qemu needs to have a userspace driver for
> the platform IOMMU, and yes it needs this to reach optimal
> behavior. We already know this is a hard requirement for using nesting
> as acceleration, I don't see why apertures are so different.

For one thing, because we only care about optimal behaviour on the
host ~=3D guest KVM case.  That means it's not n^2, just (roughly) one
host driver for each matching guest driver.  I'm considering the
general X on Y case - we don't need to optimize it, but it would be
nice for it to work without considering every combination separately.

> > Errr.. how do you figure?  On ppc the ranges and pagesizes are
> > definitely negotiable.  I'm not really familiar with other models, but
> > anything which allows *any* variations in the pagetable structure will
> > effectively have at least some negotiable properties.
>=20
> As above, if you ask for the wrong thing then you don't get
> anything. If DPDK asks for something that works on ARM like 0 -> 4G
> then PPC and x86 will always fail. How is this improving anything to
> require applications to carefully ask for exactly the right platform
> specific ranges?

Hm, looks like I didn't sufficiently emphasize that the base address
would be optional for userspace to supply.  So userspace would request
a range *size* only, unless it needs a specific IOVA base address.  It
only requests the latter if it actually needs it - so failing in that
case is correct.  (Qemu, with or without an vIOMMU is the obvious case
for that, though I could also imagine it for a specialized driver for
some broken device which has weird limitations on what IOVA addresses
it can generate on the bus).

> It isn't like there is some hard coded value we can put into DPDK that
> will work on every platform. So kernel must pick for DPDK, IMHO. I
> don't see any feasible alternative.

Yes, hence *optionally specified* base address only.

> > Which is why I'm suggesting that the base address be an optional
> > request.  DPDK *will* care about the size of the range, so it just
> > requests that and gets told a base address.
>=20
> We've talked about a size of IOVA address space before, strictly as a
> hint, to possible optimize page table layout, or something, and I'm
> fine with that idea. But - we have no driver implementation today, so
> I'm not sure what we can really do with this right now..

You can check that the hardware aperture is at least as large as the
requested range.  Even on the pretty general x86 IOMMU, if the program
wants 2^62 bytes of aperture, I'm pretty sure you won't be able to
supply it.

> Kevin could Intel consume a hint on IOVA space and optimize the number
> of IO page table levels?
>=20
> > > and IMHO, qemu
> > > is fine to have a PPC specific userspace driver to tweak this PPC
> > > unique thing if the default windows are not acceptable.
> >=20
> > Not really, because it's the ppc *target* (guest) side which requires
> > the specific properties, but selecting the "advanced" interface
> > requires special knowledge on the *host* side.
>=20
> The ppc specific driver would be on the generic side of qemu in its
> viommu support framework. There is lots of host driver optimization
> possible here with knowledge of the underlying host iommu HW. It
> should not be connected to the qemu target.

Thinking through this...

So, I guess we could have basically the same logic I'm suggesting be
in the qemu backend iommu driver instead.  So the target side (machine
type, strictly speaking) would request of the host side the apertures
it needs, and the host side driver would see if it can do that, based
on both specific knowledge of that driver and the query reponses.

ppc on x86 should work with that.. at least if the x86 aperture is
large enough to reach up to ppc's high window.  I guess we'd have the
option here of using either the generic host driver or the
x86-specific driver.  The latter would mean qemu maintaining an
x86-format shadow of the io pagetables; mildly tedious, but doable.

x86-without-viommu on ppc could work in at least some cases if the ppc
host driver requests a low window large enough to cover guest memory.
Memory hotplug we can handle by creating a new IOAS using the ppc
specific interface with a new window covering the hotplugged region.

x86-with-viommu on ppc probably can't be done, since I don't think the
ppc low window can be extended far enough to allow for the guest's
expected IOVA range.. but there's probably no way around that.  Unless
there's some way of configuring / advertising a "crippled" version of
the x86 IOMMU with a more limited IOVA range.

Device hotplug is the remaining curly case.  We're set up happily,
then we hotplug a device.  The backend aperture shrinks, the host-side
qemu driver notices this and notices it longer covers the ranges that
the target-side expects.  So... is there any way of backing out of
this gracefully.  We could detach the device, but in the meantime
ongoing DMA maps from previous devices might have failed.  We could
pre-attach the new device to a new IOAS and check the apertures there
- but when we move it to the final IOAS is it guaranteed that the
apertures will be (at least) the intersection of the old and new
apertures, or is that just the probable outcome.  Or I guess we could
add a pre-attach-query operation of some sort in the kernel to check
what the effect will be before doing the attach for real.

Ok.. you convinced me.  As long as we have some way to handle the
device hotplug case, we can work with this.

> It is not so different from today where qemu has to know about ppc's
> special vfio interface generically even to emulate x86.

Well, yes, and that's a horrible aspect of the current vfio interface.
It arose because of (partly) *my* mistake, for not realizing at the
time that we could reasonably extend the type1 interface to work for
ppc as well.  I'm hoping iommufd doesn't repeat my mistake.

> > > IMHO it is no different from imagining an Intel specific userspace
> > > driver that is using userspace IO pagetables to optimize
> > > cross-platform qemu vIOMMU emulation.
> >=20
> > I'm not quite sure what you have in mind here.  How is it both Intel
> > specific and cross-platform?
>=20
> It is part of the generic qemu iommu interface layer. For nesting qemu
> would copy the guest page table format to the host page table format
> in userspace and trigger invalidation - no pinning, no kernel
> map/unmap calls. It can only be done with detailed knowledge of the
> host iommu since the host iommu io page table format is exposed
> directly to userspace.

Ok, I see.  That can certainly be done.  I was really hoping we could
have a working, though non-optimized, implementation using just the
generic interface.

> > Note however, that having multiple apertures isn't really ppc specific.
> > Anything with an IO hole effectively has separate apertures above and
> > below the hole.  They're much closer together in address than POWER's
> > two apertures, but I don't see that makes any fundamental difference
> > to the handling of them.
>=20
> In the iommu core it handled the io holes and things through the group
> reserved IOVA list - there isn't actualy a limit in the iommu_domain,
> it has a flat pagetable format - and in cases like PASID/SVA the group
> reserved list doesn't apply at all.

Sure, but how it's implemented internally doesn't change the user
visible fact: some IOVAs can't be used, some can.  Userspace needs to
know which is which in order to operate correctly, and the only
reasonable way for it to get them is to be told by the kernel.  We
should advertise that in a common way, not have different ways for
"holes" versus "windows".  We can choose either one; I think "windows"
rather than "holes" makes more sense, but it doesn't really matter.
Whichever one we choose, we need more than one of them for both ppc
and x86:

    - x86 has a "window" from 0 to the bottom IO hole, and a window
      from the top of the IO hole to the maximum address describable
      in the IO page table.
    - x86 has a hole for the IO hole (duh), and another hole from the
      maximum IO pagetable address to 2^64-1 (you could call it the
      "out of bounds hole", I guess)

    - ppc has a "window" at 0 to a configurable maximum, and another
      "window" from 2^59 to a configurable maximum
    - ppc has a hole between the two windows, and another from the end
      of the high window to 2^64-1

So either representation, either arch, it's 2 windows, 2 holes.  There
may be other cases that only need 1 of each (SVA, ancient ppc without
the high window, probably others).  Point is there are common cases
that require more than 1.

> > Another approach would be to give the required apertures / pagesizes
> > in the initial creation of the domain/IOAS.  In that case they would
> > be static for the IOAS, as well as the underlying iommu_domains: any
> > ATTACH which would be incompatible would fail.
>=20
> This is the device-specific iommu_domain creation path. The domain can
> have information defining its aperture.

But that also requires managing the pagetables yourself; I think tying
these two concepts together is inflexible.

> > That makes life hard for the DPDK case, though.  Obviously we can
> > still make the base address optional, but for it to be static the
> > kernel would have to pick it immediately, before we know what devices
> > will be attached, which will be a problem on any system where there
> > are multiple IOMMUs with different constraints.
>=20
> Which is why the current scheme is fully automatic and we rely on the
> iommu driver to automatically select something sane for DPDK/etc
> today.

But the cost is that the allowable addresses can change implicitly
with every ATTACH.

> > > In general I have no issue with limiting the IOVA allocator in the
> > > kernel, I just don't have a use case of an application that could use
> > > the IOVA allocator (like DPDK) and also needs a limitation..
> >=20
> > Well, I imagine DPDK has at least the minimal limitation that it needs
> > the aperture to be a certain minimum size (I'm guessing at least the
> > size of its pinned hugepage working memory region).  That's a
> > limitation that's unlikely to fail on modern hardware, but it's there.
>=20
> Yes, DPDK does assume there is some fairly large available aperture,
> that should be the driver default behavior, IMHO.

Well, sure, but "fairly large" tends to change meaning over time.  The
idea is to ensure that the app's idea of "fairly large" matches the
kernel's idea of "fairly large".

> > > That breaks what I'm
> > > trying to do to make DPDK/etc portable and dead simple.
> >=20
> > It doesn't break portability at all.  As for simplicity, yes it adds
> > an extra required step, but the payoff is that it's now impossible to
> > subtly screw up by failing to recheck your apertures after an ATTACH.
> > That is, it's taking a step which was implicitly required and
> > replacing it with one that's explicitly required.
>=20
> Again, as above, it breaks portability because apps have no hope to
> know what window range to ask for to succeed. It cannot just be a hard
> coded range.

I see the problem if you have an app where there's a difference
between the smallest window it can cope with versus the largest window
it can take advantage of.  Not sure if that's likely in pratice.
AFAIK, DPDK will alway require it's hugepage memory pool mapped, can't
deal with less, can't benefit from more.  But maybe there's some use
case for this I haven't thought of.


Ok... here's a revised version of my proposal which I think addresses
your concerns and simplfies things.

- No new operations, but IOAS_MAP gets some new flags (and IOAS_COPY
  will probably need matching changes)

- By default the IOVA given to IOAS_MAP is a hint only, and the IOVA
  is chosen by the kernel within the aperture(s).  This is closer to
  how mmap() operates, and DPDK and similar shouldn't care about
  having specific IOVAs, even at the individual mapping level.

- IOAS_MAP gets an IOMAP_FIXED flag, analagous to mmap()'s MAP_FIXED,
  for when you really do want to control the IOVA (qemu, maybe some
  special userspace driver cases)

- ATTACH will fail if the new device would shrink the aperture to
  exclude any already established mappings (I assume this is already
  the case)

- IOAS_MAP gets an IOMAP_RESERVE flag, which operates a bit like a
  PROT_NONE mmap().  It reserves that IOVA space, so other (non-FIXED)
  MAPs won't use it, but doesn't actually put anything into the IO
  pagetables.
    - Like a regular mapping, ATTACHes that are incompatible with an
      IOMAP_RESERVEed region will fail
    - An IOMAP_RESERVEed area can be overmapped with an IOMAP_FIXED
      mapping

So, for DPDK the sequence would be:

1. Create IOAS
2. ATTACH devices
3. IOAS_MAP some stuff
4. Do DMA with the IOVAs that IOAS_MAP returned

(Note, not even any need for QUERY in simple cases)

For (unoptimized) qemu it would be:

1. Create IOAS
2. IOAS_MAP(IOMAP_FIXED|IOMAP_RESERVE) the valid IOVA regions of the
   guest platform
3. ATTACH devices (this will fail if they're not compatible with the
   reserved IOVA regions)
4. Boot the guest

  (on guest map/invalidate) -> IOAS_MAP(IOMAP_FIXED) to overmap part of
                               the reserved regions
  (on dev hotplug) -> ATTACH (which might fail, if it conflicts with the
                      reserved regions)
  (on vIOMMU reconfiguration) -> UNMAP/MAP reserved regions as
                                 necessary (which might fail)

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--nFv8YkIpKzhmM4mq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEoULxWu4/Ws0dB+XtgypY4gEwYSIFAmJ6EDAACgkQgypY4gEw
YSJrew//QdXXVcRPoEaU74iAZ/bJYiFn5gc6abSljmQSFQpbpcnmJvqBoz9jD7uA
UKshFD6cYXtJYfSk5QtyftIXnMdBOSdADhjPknj49ICoOuQJhwD/h2iqHFh5ETRK
QURXJfhvJTQdmgI78RfryyouJ5dd/aE6RB2BIT60YcqM9T/o+7X6DAlVi7vqWbfZ
FSEDlsv2fD24Sj3igK/bhhbYDsB/vM3TCLtBDW+E4YJxP6wk6Ps0rpcUryu3F3vX
dGzgDghLoRFMvfhdkdIIonJoW9FX7ixEAc7pmEDrKbg4GBxK8QbAlx9vx/TL4jg9
5WdSpR7o5uv9ZFJ7taPUdBR6BHBBo6fdQF41AnDaEue/ipM/DE5eVWUYxnVYhB48
qPDswSxIO2J9D1lBsVgyRaHggHJo7orHVVkZD9qkLAr0cPa5gSWTJS8zE4AnwgTo
MoOgnZgWSZ3YpoutvZ8k//eMplyVWe3Vdgiu/Ompv6d5jav42Jx8ye2sHf2lsCBv
Kx1QfbCt42kGAV31hvFuUs1yfQjXoGCFDLVmlwQghBf3BpJTrFx+kKjU0R1ceAgf
0VUfVVLK/W4GLRKdj3cD9YrWPQPsC3ulxSG+UHUlvNPWBCsJnSNluSxLGMH48t2q
MfxlIp15Q2hg/et62cOACyg5EvbfUullRFaoxFpFqHiuHpMiNt0=
=xXpd
-----END PGP SIGNATURE-----

--nFv8YkIpKzhmM4mq--
