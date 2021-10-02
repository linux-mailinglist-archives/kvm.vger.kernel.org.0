Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A66841FA08
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 08:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbhJBGPf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 02:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbhJBGPe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Oct 2021 02:15:34 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C99C061775;
        Fri,  1 Oct 2021 23:13:49 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HLxWC2h8Rz4xbR; Sat,  2 Oct 2021 16:13:43 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1633155223;
        bh=ClY2unyrJyQWFTOjfDEmqDjBYJTZcBwuvTppM9Pk0jQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g2RgXqUu61b7LKmEoAqOoux9n87/etpqXLqTujl4z/ZqNqo6ROa0ipnfuFY8R+fpb
         nXToxcUyv/vEC9BbMtsaFIuwBGjMyhjL5EapY121T8NrqtkuVWn+YN81MKbUrVR3Mk
         +KFej0UvUcP30Jy7cRcRAK7yk9IwZAXWrO09gC74=
Date:   Sat, 2 Oct 2021 14:21:38 +1000
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
Message-ID: <YVfeUkW7PWQeYFJQ@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com>
 <BN9PR11MB543362CEBDAD02DA9F06D8ED8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922140911.GT327412@nvidia.com>
 <YVaoamAaqayk1Hja@yekko>
 <20211001122505.GL964074@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="J9KDzT2u912KymBn"
Content-Disposition: inline
In-Reply-To: <20211001122505.GL964074@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--J9KDzT2u912KymBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 01, 2021 at 09:25:05AM -0300, Jason Gunthorpe wrote:
> On Fri, Oct 01, 2021 at 04:19:22PM +1000, david@gibson.dropbear.id.au wro=
te:
> > On Wed, Sep 22, 2021 at 11:09:11AM -0300, Jason Gunthorpe wrote:
> > > On Wed, Sep 22, 2021 at 03:40:25AM +0000, Tian, Kevin wrote:
> > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > Sent: Wednesday, September 22, 2021 1:45 AM
> > > > >=20
> > > > > On Sun, Sep 19, 2021 at 02:38:39PM +0800, Liu Yi L wrote:
> > > > > > This patch adds IOASID allocation/free interface per iommufd. W=
hen
> > > > > > allocating an IOASID, userspace is expected to specify the type=
 and
> > > > > > format information for the target I/O page table.
> > > > > >
> > > > > > This RFC supports only one type (IOMMU_IOASID_TYPE_KERNEL_TYPE1=
V2),
> > > > > > implying a kernel-managed I/O page table with vfio type1v2 mapp=
ing
> > > > > > semantics. For this type the user should specify the addr_width=
 of
> > > > > > the I/O address space and whether the I/O page table is created=
 in
> > > > > > an iommu enfore_snoop format. enforce_snoop must be true at thi=
s point,
> > > > > > as the false setting requires additional contract with KVM on h=
andling
> > > > > > WBINVD emulation, which can be added later.
> > > > > >
> > > > > > Userspace is expected to call IOMMU_CHECK_EXTENSION (see next p=
atch)
> > > > > > for what formats can be specified when allocating an IOASID.
> > > > > >
> > > > > > Open:
> > > > > > - Devices on PPC platform currently use a different iommu drive=
r in vfio.
> > > > > >   Per previous discussion they can also use vfio type1v2 as lon=
g as there
> > > > > >   is a way to claim a specific iova range from a system-wide ad=
dress space.
> > > > > >   This requirement doesn't sound PPC specific, as addr_width fo=
r pci
> > > > > devices
> > > > > >   can be also represented by a range [0, 2^addr_width-1]. This =
RFC hasn't
> > > > > >   adopted this design yet. We hope to have formal alignment in =
v1
> > > > > discussion
> > > > > >   and then decide how to incorporate it in v2.
> > > > >=20
> > > > > I think the request was to include a start/end IO address hint wh=
en
> > > > > creating the ios. When the kernel creates it then it can return t=
he
> > > >=20
> > > > is the hint single-range or could be multiple-ranges?
> > >=20
> > > David explained it here:
> > >=20
> > > https://lore.kernel.org/kvm/YMrKksUeNW%2FPEGPM@yekko/
> >=20
> > Apparently not well enough.  I've attempted again in this thread.
> >=20
> > > qeumu needs to be able to chooose if it gets the 32 bit range or 64
> > > bit range.
> >=20
> > No. qemu needs to supply *both* the 32-bit and 64-bit range to its
> > guest, and therefore needs to request both from the host.
>=20
> As I understood your remarks each IOAS can only be one of the formats
> as they have a different PTE layout. So here I ment that qmeu needs to
> be able to pick *for each IOAS* which of the two formats it is.

No.  Both windows are in the same IOAS.  A device could do DMA
simultaneously to both windows.  More realstically a 64-bit DMA
capable and a non-64-bit DMA capable device could be in the same group
and be doing DMAs to different windows simultaneously.

> > Or rather, it *might* need to supply both.  It will supply just the
> > 32-bit range by default, but the guest can request the 64-bit range
> > and/or remove and resize the 32-bit range via hypercall interfaces.
> > Vaguely recent Linux guests certainly will request the 64-bit range in
> > addition to the default 32-bit range.
>=20
> And this would result in two different IOAS objects

There might be two different IOAS objects for setup, but at some point
they need to be combined into one IOAS to which the device is actually
attached.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--J9KDzT2u912KymBn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFX3k8ACgkQbDjKyiDZ
s5LXKxAAgo51nOaQtxRDoMJ4C/l/AUYRxZ82OlaL1mT1g13qDkSlNTm6MMuWyhET
lQwij9zggi4g7sVBDBogYy7D7YdOFjmaIWjukC0X8pFs+WPxOSknYB5qFB15IqN1
RqhhdyxVspx5p4lhuME3BKqzKPRFoJTgBpG/FunT6EFQYBM4JoDPJ+whX7FOu0ZE
ixa3/UloLTbM7ieyykLS5HDH8pEJtgRAzl1pkl73lzJ1BTBD0i0ODC3ifqCscPUG
HR+5dguFw4Wf7RVZECi4VbRy23ebXAzS0V7gcNOAlZp3Ut+YS4AHtd8MxNv26Nzh
CTZzbmapeU1yHo5EEcv5o9nIE+wrUTt8cl2xew9g7h2X50c2qf+haEsxrEMYhW+v
ZOG4hx/buszpmppTOksqCiXVJ4X5t4FFuSPz9s8j68E759Qir1yI5SgqmFkOLfDj
n6tzwqJJkXfdPKNDHi2/7JTeFGQSTYAWJKoGsFli2OPOx0OjPZzbqxvPcUrk3COk
KhzX62baQjCtyQ5vKNIqeYOjUkvmrOTm7pPsJKCruEiOc+4hZcPBJZptDHy64VSv
PY3IT2z8jQMvIbO0sNWW4xBo6d7DJ0ERNcM6tI1uaM31SNTmjiUyUHqYU1xVuELb
1MpsSqYTBJdy38M8Qz0ANW6dqX4z3U8xOXzjIWZzrcYxSzl7XBg=
=amnN
-----END PGP SIGNATURE-----

--J9KDzT2u912KymBn--
