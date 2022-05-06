Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F42D51D0A1
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 07:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389125AbiEFF3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 01:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389127AbiEFF3E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 01:29:04 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50BB64BEA
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 22:25:06 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4KvfCP2R5Nz4yT3; Fri,  6 May 2022 15:25:05 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1651814705;
        bh=0tXX0+K7FwnuImYYwHuoP2OK7Llzka07fdGHbbiUFWY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jBQOexOP9nKiqvggc7IsTzB1L+o6a8HlURuWbFkyCk70OsArRXQqA3aWJ6hYlXZFX
         Or0K+N+UYuaEVvTKzJ3EYl2946x1ukZFWbf0iXLzP7dZuZLwZlbIdwQrzAj2Vgd0DP
         CW206QDY2TLLfL/MYFc3GWb4qPdqNrjhneTdozmA=
Date:   Fri, 6 May 2022 15:25:03 +1000
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
Message-ID: <YnSxL5KxwJvQzd2Q@yekko>
References: <11-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323165125.5efd5976.alex.williamson@redhat.com>
 <20220324003342.GV11336@nvidia.com>
 <20220324160403.42131028.alex.williamson@redhat.com>
 <YmqqXHsCTxVb2/Oa@yekko>
 <20220428151037.GK8364@nvidia.com>
 <YmuDtPMksOj7NOEh@yekko>
 <20220429124838.GW8364@nvidia.com>
 <Ym+IfTvdD2zS6j4G@yekko>
 <20220505190728.GV49344@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BkX5oN17O9NuBnu2"
Content-Disposition: inline
In-Reply-To: <20220505190728.GV49344@nvidia.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--BkX5oN17O9NuBnu2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 05, 2022 at 04:07:28PM -0300, Jason Gunthorpe wrote:
> On Mon, May 02, 2022 at 05:30:05PM +1000, David Gibson wrote:
>=20
> > > It is a bit more CPU work since maps in the lower range would have to
> > > be copied over, but conceptually the model matches the HW nesting.
> >=20
> > Ah.. ok.  IIUC what you're saying is that the kernel-side IOASes have
> > fixed windows, but we fake dynamic windows in the userspace
> > implementation by flipping the devices over to a new IOAS with the new
> > windows.  Is that right?
>=20
> Yes
>=20
> > Where exactly would the windows be specified?  My understanding was
> > that when creating a back-end specific IOAS, that would typically be
> > for the case where you're using a user / guest managed IO pagetable,
> > with the backend specifying the format for that.  In the ppc case we'd
> > need to specify the windows, but we'd still need the IOAS_MAP/UNMAP
> > operations to manage the mappings.  The PAPR vIOMMU is
> > paravirtualized, so all updates come via hypercalls, so there's no
> > user/guest managed data structure.
>=20
> When the iommu_domain is created I want to have a
> iommu-driver-specific struct, so PPC can customize its iommu_domain
> however it likes.

This requires that the client be aware of the host side IOMMU model.
That's true in VFIO now, and it's nasty; I was really hoping we could
*stop* doing that.

Note that I'm talking here *purely* about the non-optimized case where
all updates to the host side IO pagetables are handled by IOAS_MAP /
IOAS_COPY, with no direct hardware access to user or guest managed IO
pagetables.  The optimized case obviously requires end-to-end
agreement on the pagetable format amongst other domain properties.

What I'm hoping is that qemu (or whatever) can use this non-optimized
as a fallback case where it does't need to know the properties of
whatever host side IOMMU models there are.  It just requests what it
needs based on the vIOMMU properties it needs to replicate and the
host kernel either can supply it or can't.

In many cases it should be perfectly possible to emulate a PPC style
vIOMMU on an x86 host, because the x86 IOMMU has such a colossal
aperture that it will encompass wherever the ppc apertures end
up. Similarly we could simulate an x86-style no-vIOMMU guest on a ppc
host (currently somewhere between awkward and impossible) by placing
the host apertures to cover guest memory.

Admittedly those are pretty niche cases, but allowing for them gives
us flexibility for the future.  Emulating an ARM SMMUv3 guest on an
ARM SMMU v4 or v5 or v.whatever host is likely to be a real case in
the future, and AFAICT, ARM are much less conservative that x86 about
maintaining similar hw interfaces over time.  That's why I think
considering these ppc cases will give a more robust interface for
other future possibilities as well.

> > That should work from the point of view of the userspace and guest
> > side interfaces.  It might be fiddly from the point of view of the
> > back end.  The ppc iommu doesn't really have the notion of
> > configurable domains - instead the address spaces are the hardware or
> > firmware fixed PEs, so they have a fixed set of devices.  At the bare
> > metal level it's possible to sort of do domains by making the actual
> > pagetable pointers for several PEs point to a common place.
>=20
> I'm not sure I understand this - a domain is just a storage container
> for an IO page table, if the HW has IOPTEs then it should be able to
> have a domain?
>=20
> Making page table pointers point to a common IOPTE tree is exactly
> what iommu_domains are for - why is that "sort of" for ppc?

Ok, fair enough, it's only "sort of" in the sense that the hw specs /
docs don't present any equivalent concept.

> > However, in the future, nested KVM under PowerVM is likely to be the
> > norm.  In that situation the L1 as well as the L2 only has the
> > paravirtualized interfaces, which don't have any notion of domains,
> > only PEs.  All updates take place via hypercalls which explicitly
> > specify a PE (strictly speaking they take a "Logical IO Bus Number"
> > (LIOBN), but those generally map one to one with PEs), so it can't use
> > shared pointer tricks either.
>=20
> How does the paravirtualized interfaces deal with the page table? Does
> it call a map/unmap hypercall instead of providing guest IOPTEs?

Sort of.  The main interface is H_PUT_TCE ("TCE" - Translation Control
Entry - being IBMese for an IOPTE). This takes an LIOBN (which selects
which PE and aperture), an IOVA and a TCE value - which is a guest
physical address plus some permission bits.  There are some variants
for performance that can set a batch of IOPTEs from a buffer, or clear
a range of IOPTEs, but they're just faster ways of doing the same
thing as a bunch of H_PUT_TCE calls.  H_PUT_TCE calls.

You can consider that a map/unmap hypercall, but the size of the
mapping is fixed (the IO pagesize which was previously set for the
aperture).

> Assuming yes, I'd expect that:
>=20
> The iommu_domain for nested PPC is just a log of map/unmap hypervsior
> calls to make. Whenever a new PE is attached to that domain it gets
> the logged map's replayed to set it up, and when a PE is detached the
> log is used to unmap everything.

And likewise duplicate every H_PUT_TCE to all the PEs in the domain.
Sure.  It means the changes won't be atomic across the domain, but I
guess that doesn't matter.  I guess you could have the same thing on a
sufficiently complex x86 or ARM system, if you put two devices into
the IOAS that were sufficiently far from each other in the bus
topology that they use a different top-level host IOMMU.

> It is not perfectly memory efficient - and we could perhaps talk about
> a API modification to allow re-use of the iommufd datastructure
> somehow, but I think this is a good logical starting point.

Because the map size is fixed, a "replay log" is effectively
equivalent to a mirror of the entire IO pagetable.

> The PE would have to be modeled as an iommu_group.

Yes, they already are.

> > So, here's an alternative set of interfaces that should work for ppc,
> > maybe you can tell me whether they also work for x86 and others:
>=20
> Fundamentally PPC has to fit into the iommu standard framework of
> group and domains, we can talk about modifications, but drifting too
> far away is a big problem.

Well, what I'm trying to do here is to see how big a change to the
model this really requires.  If it's not too much, we gain flexibility
for future unknown IOMMU models as well as for the admittedly niche
ppc case.

> >   * Each domain/IOAS has a concept of one or more IOVA windows, which
> >     each have a base address, size, pagesize (granularity) and optional=
ly
> >     other flags/attributes.
> >       * This has some bearing on hardware capabilities, but is
> >         primarily a software notion
>=20
> iommu_domain has the aperture, PPC will require extending this to a
> list of apertures since it is currently only one window.

Yes, that's needed as a minimum.

> Once a domain is created and attached to a group the aperture should
> be immutable.

I realize that's the model right now, but is there a strong rationale
for that immutability?

Come to that, IIUC that's true for the iommu_domain at the lower
level, but not for the IOAS at a higher level.  You've stated that's
*not* immutable, since it can shrink as new devices are added to the
IOAS.  So I guess in that case the IOAS must be mapped by multiple
iommu_domains?

> >   * MAP/UNMAP operations are only permitted within an existing IOVA
> >     window (and with addresses aligned to the window's pagesize)
> >       * This is enforced by software whether or not it is required by
> >         the underlying hardware
> >   * Likewise IOAS_COPY operations are only permitted if the source and
> >     destination windows have compatible attributes
>=20
> Already done, domain's aperture restricts all the iommufd operations

Right but that aperture is coming only from the hardware.  What I'm
suggesting here is that userspace can essentially opt into a *smaller*
aperture (or apertures) than the hardware permits.  The value of this
is that if the effective hardware aperture shrinks due to adding
devices, the kernel has the information it needs to determine if this
will be a problem for the userspace client or not.

> >   * A newly created kernel-managed IOAS has *no* IOVA windows
>=20
> Already done, the iommufd IOAS has no iommu_domains inside it at
> creation time.

That.. doesn't seem like the same thing at all.  If there are no
domains, there are no restrictions from the hardware, so there's
effectively an unlimited aperture.

> >   * A CREATE_WINDOW operation is added
> >       * This takes a size, pagesize/granularity, optional base address
> >         and optional additional attributes=20
> >       * If any of the specified attributes are incompatible with the
> >         underlying hardware, the operation fails
>=20
> iommu layer has nothing called a window. The closest thing is a
> domain.

Maybe "window" is a bad name.  You called it "aperture" above (and
I've shifted to that naming) and implied it *was* part of the IOMMU
domain.  That said, it doesn't need to be at the iommu layer - as I
said I'm consdiering this primarily a software concept and it could be
at the IOAS layer.  The linkage would be that every iommufd operation
which could change either the user-selected windows or the effective
hardware apertures must ensure that all the user windows (still) lie
within the hardware apertures.

> I really don't want to try to make a new iommu layer object that is so
> unique and special to PPC - we have to figure out how to fit PPC into
> the iommu_domain model with reasonable extensions.

So, I'm probably conflating things between the iommu layer and the
iommufd/IOAS layer because it's a been a while since I looked at this
code. I'm primarily interested in the interfaces at the iommufd layer,
I don't much care at what layer it's implemented.

Having the iommu layer only care about the hw limitations (let's call
those "apertures") and the iommufd/IOAS layer care about the software
chosen limitations (let's call those "windows") makes reasonable sense
to me: HW advertises apertures according to its capabilities, SW
requests windows according to its needs.  The iommufd layer does its
best to accomodate SW's operations while maintaining the invariant
that the windows must always lie within the apertures.

At least.. that's the model on x86 and most other hosts.  For a ppc
host, we'd need want to have attempts to create windows also attempt
to create apertures on the hardware (or next level hypervisor).  But
with this model, that doesn't require userspace to do anything
different, so that can be localized to the ppc host backend.

> > > > > Maybe every device gets a copy of the error notification?
> > > >=20
> > > > Alas, it's harder than that.  One of the things that can happen on =
an
> > > > EEH fault is that the entire PE gets suspended (blocking both DMA a=
nd
> > > > MMIO, IIRC) until the proper recovery steps are taken. =20
> > >=20
> > > I think qemu would have to de-duplicate the duplicated device
> > > notifications and then it can go from a device notifiation to the
> > > device's iommu_group to the IOAS to the vPE?
> >=20
> > It's not about the notifications.=20
>=20
> The only thing the kernel can do is rely a notification that something
> happened to a PE. The kernel gets an event on the PE basis, I would
> like it to replicate it to all the devices and push it through the
> VFIO device FD.

Again: it's not about the notifications (I don't even really know how
those work in EEH).  The way EEH is specified, the expectation is that
when an error is tripped, the whole PE goes into an error state,
blocking IO for every device in the PE.  Something working with EEH
expects that to happen at the (virtual) hardware level.  So if a guest
trips an error on one device, it expects IO to stop for every other
device in the PE.  But if hardware's notion of the PE is smaller than
the guest's the host hardware won't accomplish that itself.

So the kernel would somehow have to replicate the error state in one
host PE to the other host PEs within the domain.  I think it's
theoretically possible, but it's really fiddly. It has to maintain
that replicated state on every step of the recovery process as
well. At last count trying to figure out how to do this correctly has
burnt out 3 or more separate (competent) developers at IBM so they
either just give up and run away, or procrastinate/avoid it until they
got a different job.

Bear in mind that in this scenario things are already not working
quite right at the hw level (or there wouldn't be an error in the
first place), so different results from the same recovery/injection
steps on different host PEs is a very real possibility.  We can't
present that that back to the guest running the recovery, because the
interface only allows for a single result.  So every operation's error
path becomes a nightmare of trying to resychronize the state across
the domain, which involves steps that themselves could fail, meaning
more resync... and so on.

> qemu will de-duplicate the replicates and recover exactly the same
> event the kernel saw, delivered at exactly the same time.

qemu's not doing the recovery, the guest is.  So we can't choose the
interfaces, we just have what PAPR specifies (and like most PAPR
interfaces, it's pretty crap).

> If instead you want to have one event per-PE then all that changes in
> the kernel is one event is generated instead of N, and qemu doesn't
> have to throw away the duplicates.
>=20
> With either method qemu still gets the same PE centric event,
> delivered at the same time, with the same races.
>=20
> This is not a general mechanism, it is some PPC specific thing to
> communicate a PPC specific PE centric event to userspace. I just
> prefer it in VFIO instead of iommufd.

Oh, yes, this one (unlike the multi-aperture stuff, where I'm not yet
convinced) is definitely ppc specific.  And I'm frankly not convinced
it's of any value even on ppc.  Given I'm not sure anyone has ever
used this in anger, I think a better approach is to just straight up
fail any attempt to do any EEH operation if there's not a 1 to 1
mapping from guest PE (domain) to host PE (group).

Or just ignore it entirely and count on no-one noticing.  EEH is
a largely irrelevant tangent to the actual interface issues I'm
interested in.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--BkX5oN17O9NuBnu2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEoULxWu4/Ws0dB+XtgypY4gEwYSIFAmJ0sRwACgkQgypY4gEw
YSKnMg/9GHrvRERNNcb1UnOyMoiTZWsf577XjM98MAgaKd949ei2zeMySq1vJxcl
K/86LeF6tLsXiZv1sNx461f5AT+OVVN4NQNDWFKKcl4R5unn9a2n5bX9472SHvCq
MOP1zSB40EIOcVA9H9CK+IGnea2LMFQm4Fqvq9CotuvowsA5KhvegnYJX82BSpZC
RTigkaW5ifqGHwcC/DwimVvaXODGM7m58EnVFDDhroe5ZU3GsEF5vNLiEcs+Fnh1
CmHWiDFbSfHCiPOMwtDTwROjS8ToBvynu35qzuqhE9CbBf9y8N5qSJklwkO5YtnE
pe2nOq5FYt+O/5WVGxjGO+ojhZjlrHkXQsGlS9CF3n20+qboRwqtWn/7eKZJQ3u+
fylBKg32myslOMKIguvCKHcQHG90dPR+tFXYpG9+baWQdjN1ve5xOGbIGtSJY6oB
Z+QrOoK4ttcwL0yK0Fdn37PihnHdPdosrU/tmAf+QoBLk/L5dm/sX2EMQfx5/Bl3
Zi9Mg94lUpivLbfGozRJ+VAQfboxbdJ/vuYaUVg9kLh+89m6edWNLHwmYjk0Ojea
+5LiNjZmy5DHcCxXOEepJYdf+XH1eIMqqVBkdYnUyYfEvvwqdpnM/OCbb+OT8F3/
U7MAc839CLi0x1sfcgzn7+fJCmnP0tXCCbqQv0UfyEVbXGTPvzQ=
=uyEz
-----END PGP SIGNATURE-----

--BkX5oN17O9NuBnu2--
