Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A5451F472
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 08:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiEIGLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 02:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235687AbiEIGGN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 02:06:13 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC8316EC97
        for <kvm@vger.kernel.org>; Sun,  8 May 2022 23:02:20 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4KxVtw6rKNz4ySV; Mon,  9 May 2022 16:02:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1652076136;
        bh=PBptjewNToAaTV9RdFozshadEVw1bKLm+rIQcXiaVUw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HmGGxs4XFmZVTt8Ep8OiP4wBiTe1R4P2pRr1skEZizpSbBPP+yZYwTayso1RVp0ou
         kDVW4cFjUlslN/MyYx1lP9WDiNohh1uB5TjtczFRNVDzEWnnc6QKHPV+m3/ibcx+Lh
         2R64WgDzI7rs75QAvsFR9kRAZnj5tnade0G8DixE=
Date:   Mon, 9 May 2022 13:36:40 +1000
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
Message-ID: <YniMSMufMKCVJT8N@yekko>
References: <20220324003342.GV11336@nvidia.com>
 <20220324160403.42131028.alex.williamson@redhat.com>
 <YmqqXHsCTxVb2/Oa@yekko>
 <20220428151037.GK8364@nvidia.com>
 <YmuDtPMksOj7NOEh@yekko>
 <20220429124838.GW8364@nvidia.com>
 <Ym+IfTvdD2zS6j4G@yekko>
 <20220505190728.GV49344@nvidia.com>
 <YnSxL5KxwJvQzd2Q@yekko>
 <BN9PR11MB5276CACD8AB1EB092A333CC78CC59@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5dwwmhG1XdsI9y0Q"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276CACD8AB1EB092A333CC78CC59@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--5dwwmhG1XdsI9y0Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 06, 2022 at 10:42:21AM +0000, Tian, Kevin wrote:
> > From: David Gibson <david@gibson.dropbear.id.au>
> > Sent: Friday, May 6, 2022 1:25 PM
> >=20
> > >
> > > When the iommu_domain is created I want to have a
> > > iommu-driver-specific struct, so PPC can customize its iommu_domain
> > > however it likes.
> >=20
> > This requires that the client be aware of the host side IOMMU model.
> > That's true in VFIO now, and it's nasty; I was really hoping we could
> > *stop* doing that.
>=20
> that model is anyway inevitable when talking about user page table,

Right, but I'm explicitly not talking about the user managed page
table case.  I'm talking about the case where the IO pagetable is
still managed by the kernel and we update it via IOAS_MAP and similar
operations.

> i.e. when nesting is enabled.

I don't really follow the connection you're drawing between a user
managed table and nesting.

> > Note that I'm talking here *purely* about the non-optimized case where
> > all updates to the host side IO pagetables are handled by IOAS_MAP /
> > IOAS_COPY, with no direct hardware access to user or guest managed IO
> > pagetables.  The optimized case obviously requires end-to-end
> > agreement on the pagetable format amongst other domain properties.
> >=20
> > What I'm hoping is that qemu (or whatever) can use this non-optimized
> > as a fallback case where it does't need to know the properties of
> > whatever host side IOMMU models there are.  It just requests what it
> > needs based on the vIOMMU properties it needs to replicate and the
> > host kernel either can supply it or can't.
> >=20
> > In many cases it should be perfectly possible to emulate a PPC style
> > vIOMMU on an x86 host, because the x86 IOMMU has such a colossal
> > aperture that it will encompass wherever the ppc apertures end
> > up. Similarly we could simulate an x86-style no-vIOMMU guest on a ppc
> > host (currently somewhere between awkward and impossible) by placing
> > the host apertures to cover guest memory.
> >=20
> > Admittedly those are pretty niche cases, but allowing for them gives
> > us flexibility for the future.  Emulating an ARM SMMUv3 guest on an
> > ARM SMMU v4 or v5 or v.whatever host is likely to be a real case in
> > the future, and AFAICT, ARM are much less conservative that x86 about
> > maintaining similar hw interfaces over time.  That's why I think
> > considering these ppc cases will give a more robust interface for
> > other future possibilities as well.
>=20
> It's not niche cases. We already have virtio-iommu which can work
> on both ARM and x86 platforms, i.e. what current iommufd provides
> is already generic enough except on PPC.
>=20
> Then IMHO the key open here is:
>=20
> Can PPC adapt to the current iommufd proposal if it can be
> refactored to fit the standard iommu domain/group concepts?

Right...  and I'm still trying to figure out whether it can adapt to
either part of that.  We absolutely need to allow for multiple IOVA
apertures within a domain.  If we have that I *think* we can manage
(if suboptimally), but I'm trying to figure out the corner cases to
make sure I haven't missed something.

> If not, what is the remaining gap after PPC becomes a normal
> citizen in the iommu layer and is it worth solving it in the general
> interface or via iommu-driver-specific domain (given this will
> exist anyway)?
>=20
> to close that open I'm with Jason:
>=20
>    "Fundamentally PPC has to fit into the iommu standard framework of
>    group and domains, we can talk about modifications, but drifting too
>    far away is a big problem."
>=20
> Directly jumping to the iommufd layer for what changes might be
> applied to all platforms sounds counter-intuitive if we haven't tried=20
> to solve the gap in the iommu layer in the first place, as even
> there is argument that certain changes in iommufd layer can find
> matching concept on other platforms it still sort of looks redundant
> since those platforms already work with the current model.

I don't really follow what you're saying here.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--5dwwmhG1XdsI9y0Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEoULxWu4/Ws0dB+XtgypY4gEwYSIFAmJ4jEEACgkQgypY4gEw
YSKDehAAthdPOFuCvLlxqk0ViINmCAHiL4wIuVaK3blqCzpIjfxzM1H4N2Jlmd4t
pEDU36VZVygtfIzE4xHeDlIJ0pcZ6mK7NW6+dpVAnP+bKengkXNrHM6kAIUuAypH
LZWyz+C1MEoPjGTCbUHSbexhMkxF+haH6H5bN2nBOiS1m5dTAY4iJyNL4jWU69sh
9UyWiPjCvHdryAZnuHd4c8FKPyiPARG6RZmhX3Q3oyIpYAdWRvJrtYiXKHNQbnNF
1FkabFS9fWcsMcXcaNpl1UMgEX2Ou72UkHdNI/eT8J3ySbk+/X+Lqn7h3z8NFTbc
ACXoBVd669w6CfXy0vM2JvA/ExXcs0M9OySLTWz2UYPfqW4lHF5tkg+DHFaW/Q/D
Hpwb6vqfbZzu9U6gNlbNXkXKjqUHEkIPNPf8tLDz3IYul9ZBRwZ+iyyAbNZ87J5M
TOpwu+TBHJI2WYdyrYEPPJdxU/EctZD9gaJx9guDn1MbTS9JRtAbhVR5AUh4UwbO
VP4teh7E4AJSFaVYIcOVc2tNBXNvpsr52fr1cXoB5WcfeWb8+bGEhvpBqsGp6L0s
5702LRuwidu/rWNozF2fwqgBWNlULvchHT7PW/OTkzq1+mqIpjTQEfSiO3tdyXP2
zdFJHcCl544vPvH5eSpBWe5f+Az0Oytpa1lgj47ez2XDeIKnm/0=
=oy3W
-----END PGP SIGNATURE-----

--5dwwmhG1XdsI9y0Q--
