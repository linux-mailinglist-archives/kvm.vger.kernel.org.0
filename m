Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC44541BD64
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 05:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243927AbhI2D3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 23:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243941AbhI2D3n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 23:29:43 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5752C061745;
        Tue, 28 Sep 2021 20:28:02 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HK1zN6cnQz4xbT; Wed, 29 Sep 2021 13:28:00 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1632886080;
        bh=qzQIQZ4QRhIcmilmBeomTPiSlLs3WETVdIoKH8ljR5I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p5e2lRrXkAIwbSxkG3qdFSqNl4eS0ICYpOq4Hcu5VnMPhSadYB0m7dyvRiC++N3Lg
         8arvLC3O7qOMZjze+SPIHfiKcZWeSnfEeejTsR98qNOzIYVzQKTVZTraACX8JjPnVJ
         bBLKwH+HMNsXDmQWOS8SMuMsqAS3TnSMGTxZrasU=
Date:   Wed, 29 Sep 2021 12:46:14 +1000
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
Subject: Re: [RFC 03/20] vfio: Add vfio_[un]register_device()
Message-ID: <YVPTdqWw6or3mK/h@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-4-yi.l.liu@intel.com>
 <20210921160108.GO327412@nvidia.com>
 <BN9PR11MB54330421CA825F5CAA44BAC98CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922010014.GE327412@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="M1+gRInfuzVDe7lG"
Content-Disposition: inline
In-Reply-To: <20210922010014.GE327412@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--M1+gRInfuzVDe7lG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 21, 2021 at 10:00:14PM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 22, 2021 at 12:54:02AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, September 22, 2021 12:01 AM
> > >=20
> > > >  One open about how to organize the device nodes under
> > > /dev/vfio/devices/.
> > > > This RFC adopts a simple policy by keeping a flat layout with mixed
> > > devname
> > > > from all kinds of devices. The prerequisite of this model is that d=
evnames
> > > > from different bus types are unique formats:
> > >=20
> > > This isn't reliable, the devname should just be vfio0, vfio1, etc
> > >=20
> > > The userspace can learn the correct major/minor by inspecting the
> > > sysfs.
> > >=20
> > > This whole concept should disappear into the prior patch that adds the
> > > struct device in the first place, and I think most of the code here
> > > can be deleted once the struct device is used properly.
> > >=20
> >=20
> > Can you help elaborate above flow? This is one area where we need
> > more guidance.
> >=20
> > When Qemu accepts an option "-device vfio-pci,host=3DDDDD:BB:DD.F",
> > how does Qemu identify which vifo0/1/... is associated with the specifi=
ed=20
> > DDDD:BB:DD.F?=20
>=20
> When done properly in the kernel the file:
>=20
> /sys/bus/pci/devices/DDDD:BB:DD.F/vfio/vfioX/dev
>=20
> Will contain the major:minor of the VFIO device.
>=20
> Userspace then opens the /dev/vfio/devices/vfioX and checks with fstat
> that the major:minor matches.
>=20
> in the above pattern "pci" and "DDDD:BB:DD.FF" are the arguments passed
> to qemu.

I thought part of the appeal of the device centric model was less
grovelling around in sysfs for information.  Using type/address
directly in /dev seems simpler than having to dig around matching
things here.

Note that this doesn't have to be done in kernel: you could have the
kernel just call them /dev/vfio/devices/vfio0, ... but add udev rules
that create symlinks from say /dev/vfio/pci/DDDD:BB:SS.F - >
=2E./devices/vfioXX based on the sysfs information.

>=20
> You can look at this for some general over engineered code to handle
> opening from a sysfs handle like above:
>=20
> https://github.com/linux-rdma/rdma-core/blob/master/util/open_cdev.c
>=20
> Jason
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--M1+gRInfuzVDe7lG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFT03YACgkQbDjKyiDZ
s5L5+RAA2E2lYOOD4bTHuC/PsiWELLG1eQQa3Jb4G+sT+fOVdbBmt8zME8lEAiXb
iKIx7FlKDY1YCkr3fHedUDTXNRKphIvtkJYkHS43zI2KaRkqn20pxvps6kjA0MvV
IMdk+8ZiUyA806bldQ6iEYhk7K888zeHPhSBhdZ6tSiWi5Yg6llD0A+WTGVmI9vx
pm6Cu3r80UouuTm2JY37yyYamFsGAGs0iVNiFxA/zhtGjJ5soKUOcqZSx4P8MfHD
2GOsiRGlwRx2peP+yrqAw9CutaR4jphP2ehVoqjyKq4wzMZ7PQCkuoUiFo3fNFjs
J8lUiY9PxisD+0rStds1WF1oPHocq2B/ALXzDlHPxFTitdH/OiDKZ0p86jHZcNVN
QdqipuJH4bXo4iyqWg0ksf3ECdekPJo0xfN4aMmDLHst4mhjSslQz/0WPZlQJKCe
cOiG2I6akTADkQR65q1bKyr2gZR0fZTZp0AwBGQ6Nj1I2iHKHOI05+/pQC9NCVkn
pkWc6WL12WGybyo/GyDblf5h1bfZTDJFLxS16uymh/MT+LPjGtik1I4KQezl1IA5
rAy5LpQ11dBOizN6dCO7XhmGLeRGXLXGxhe676t9fix+bibSYU0pvZUnffYHOxZw
pOv6wsRFvaM4ZhTBIB8PcbgNZHreiWAoFGdvfjHVRVR1Xl9Kx2A=
=JS/Z
-----END PGP SIGNATURE-----

--M1+gRInfuzVDe7lG--
