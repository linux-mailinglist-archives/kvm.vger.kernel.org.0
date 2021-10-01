Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3125C41E792
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 08:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352318AbhJAGce (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 02:32:34 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:50065 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352223AbhJAGc3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 02:32:29 -0400
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HLKxG63RSz4xbZ; Fri,  1 Oct 2021 16:30:42 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1633069842;
        bh=lR34utpaPRCNI/perdpBGfzIkAS0BNV6Vs/MdnmoqpQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gy+VlReRYd8SAM46lfmZR/ktoSy73PwBURgZBuyyfb16MyPR9LgF8g9STm4/0hZ0f
         KGVknRjzdBFqFsgzUp3mMhTDJhJkUvofB6SPqKUd6BEOrMGGumiZmuGWLJPUNS6Suu
         EMOJ2zGcOhnkF++aTF2sf1PuuGSi6CNYVJh8QKBA=
Date:   Fri, 1 Oct 2021 16:30:05 +1000
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
Message-ID: <YVaq7a5uzUMd9vVL@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com>
 <BN9PR11MB543362CEBDAD02DA9F06D8ED8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922140911.GT327412@nvidia.com>
 <BN9PR11MB5433A47FFA0A8C51643AA33C8CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923120653.GK964074@nvidia.com>
 <BN9PR11MB543309C4D55D628278B95E008CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lzq0sKp3RnTlTiJP"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB543309C4D55D628278B95E008CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--lzq0sKp3RnTlTiJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 23, 2021 at 12:22:23PM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, September 23, 2021 8:07 PM
> >=20
> > On Thu, Sep 23, 2021 at 09:14:58AM +0000, Tian, Kevin wrote:
> >=20
> > > currently the type is aimed to differentiate three usages:
> > >
> > > - kernel-managed I/O page table
> > > - user-managed I/O page table
> > > - shared I/O page table (e.g. with mm, or ept)
> >=20
> > Creating a shared ios is something that should probably be a different
> > command.
>=20
> why? I didn't understand the criteria here...
>=20
> >=20
> > > we can remove 'type', but is FORMAT_KENREL/USER/SHARED a good
> > > indicator? their difference is not about format.
> >=20
> > Format should be
> >=20
> > FORMAT_KERNEL/FORMAT_INTEL_PTE_V1/FORMAT_INTEL_PTE_V2/etc
>=20
> INTEL_PTE_V1/V2 are formats. Why is kernel-managed called a format?
>=20
> >=20
> > > Dave's links didn't answer one puzzle from me. Does PPC needs accurate
> > > range information or be ok with a large range including holes (then l=
et
> > > the kernel to figure out where the holes locate)?
> >=20
> > My impression was it only needed a way to select between the two
> > different cases as they are exclusive. I'd see this API as being a
> > hint and userspace should query the exact ranges to learn what was
> > actually created.
>=20
> yes, the user can query the permitted range using DEVICE_GET_INFO.
> But in the end if the user wants two separate regions, I'm afraid that=20
> the underlying iommu driver wants to know the exact info. iirc PPC
> has one global system address space shared by all devices.

I think certain POWER models do this, yes, there's *protection*
between DMAs from different devices, but you can't translate the same
address to different places for different devices.  I *think* that's a
firmware/hypervisor convention rather than a hardware limitation, but
I'm not entirely sure.  We don't do things this way when emulating the
POWER vIOMMU in POWER, but PowerVM might and we still have to deal
with that when running as a POWERVM guest.

> It is possible
> that the user may want to claim range-A and range-C, with range-B
> in-between but claimed by another user. Then simply using one hint
> range [A-lowend, C-highend] might not work.
>=20
> >=20
> > > > device-specific escape if more specific customization is needed and=
 is
> > > > needed to specify user space page tables anyhow.
> > >
> > > and I didn't understand the 2nd link. How does user-managed page
> > > table jump into this range claim problem? I'm getting confused...
> >=20
> > PPC could also model it using a FORMAT_KERNEL_PPC_X,
> > FORMAT_KERNEL_PPC_Y
> > though it is less nice..
>=20
> yes PPC can use different format, but I didn't understand why it is=20
> related user-managed page table which further requires nesting. sound
> disconnected topics here...
>=20
> >=20
> > > > Yes, ioas_id should always be the xarray index.
> > > >
> > > > PASID needs to be called out as PASID or as a generic "hw descripti=
on"
> > > > blob.
> > >
> > > ARM doesn't use PASID. So we need a generic blob, e.g. ioas_hwid?
> >=20
> > ARM *does* need PASID! PASID is the label of the DMA on the PCI bus,
> > and it MUST be exposed in that format to be programmed into the PCI
> > device itself.
>=20
> In the entire discussion in previous design RFC, I kept an impression that
> ARM-equivalent PASID is called SSID. If we can use PASID as a general
> term in iommufd context, definitely it's much better!
>=20
> >=20
> > All of this should be able to support a userspace, like DPDK, creating
> > a PASID on its own without any special VFIO drivers.
> >=20
> > - Open iommufd
> > - Attach the vfio device FD
> > - Request a PASID device id
> > - Create an ios against the pasid device id
> > - Query the ios for the PCI PASID #
> > - Program the HW to issue TLPs with the PASID
>=20
> this all makes me very confused, and completely different from what
> we agreed in previous v2 design proposal:
>=20
> - open iommufd
> - create an ioas
> - attach vfio device to ioasid, with vPASID info
> 	* vfio converts vPASID to pPASID and then call iommufd_device_attach_ioa=
sid()
> 	* the latter then installs ioas to the IOMMU with RID/PASID
>=20
> >=20
> > > and still we have both ioas_id (iommufd) and ioasid (ioasid.c) in the
> > > kernel. Do we want to clear this confusion? Or possibly it's fine bec=
ause
> > > ioas_id is never used outside of iommufd and iommufd doesn't directly
> > > call ioasid_alloc() from ioasid.c?
> >=20
> > As long as it is ioas_id and ioasid it is probably fine..
>=20
> let's align with others in a few hours.
>=20
> >=20
> > > > kvm's API to program the vPASID translation table should probably t=
ake
> > > > in a (iommufd,ioas_id,device_id) tuple and extract the IOMMU side
> > > > information using an in-kernel API. Userspace shouldn't have to
> > > > shuttle it around.
> > >
> > > the vPASID info is carried in VFIO_DEVICE_ATTACH_IOASID uAPI.
> > > when kvm calls iommufd with above tuple, vPASID->pPASID is
> > > returned to kvm. So we still need a generic blob to represent
> > > vPASID in the uAPI.
> >=20
> > I think you have to be clear about what the value is being used
> > for. Is it an IOMMU page table handle or is it a PCI PASID value?
> >=20
> > AFAICT I think it is the former in the Intel scheme as the "vPASID" is
> > really about presenting a consistent IOMMU handle to the guest across
> > migration, it is not the value that shows up on the PCI bus.
> >=20
>=20
> It's the former. But vfio driver needs to maintain vPASID->pPASID
> translation in the mediation path, since what guest programs is vPASID.
>=20
> Thanks
> Kevin
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--lzq0sKp3RnTlTiJP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFWqu0ACgkQbDjKyiDZ
s5L/4A/8Cn9Xa+7dGRlje4LCugxjf/YGtuwbSe+gdeSt0mR/aMa7c67dyHPzYg4y
fJNNQo/1Tzi6IdeBVY4edZ8zr52ovu+A59SlBISCM85AUe/vx3fD6obImquWsaFW
QXME9WCEIouqfP0p50UVeIl9Xp3mTrElPyMbA36B0QKl7t3kgMx3PFqlQiiiXktR
T9GPce+4GWSLL1aZKDDbMADpmd9+RwD97ZXtcJ+BmlXURFiYnkid+ZYHY3mJ7gFD
y4QFBZIeBxB/VHbAYXsXzEuEtAXKeiPXzf1nQMUdtmyM989H6FxwsPqgWs6mE8gt
FvklyPSmNeq78WeiU/DlTwXCzgbuAvhiNFpmXQMmGZn7X1+p2Bexv6rbCh9Dj9MU
5mKNcz/7g8mp+i5Ka08EHEqv1BKBPpn9TY6ftVRURg5XY5ZsPKWNzJCpRShs281l
xjjz8DAV9kkm8CGJtFkxFY55/xh3cz/xmwxMq8D1bMRTH5OqYizBsKVf1N2NgOF7
HKM80qtfTQi3QvaPJSaBlidR0CJR5o3ZvHj/XyL4Dogpa2+67q1BLWuIm1+gCuPZ
ghR1jaAtOazvIesBJWKR7XLxMDuV2lAU5yu3uh9ezQlGrdWP+j7mf6LKwplZeib4
o0hcfmwMtnmvLCWoF4w7Q7hCx9VVRTkFRbjo4mbWBZ1sH8HrAlQ=
=uDs1
-----END PGP SIGNATURE-----

--lzq0sKp3RnTlTiJP--
