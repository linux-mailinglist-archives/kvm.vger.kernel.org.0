Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8C83E22EB
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 07:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243119AbhHFFdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 01:33:16 -0400
Received: from ozlabs.org ([203.11.71.1]:34203 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243069AbhHFFdO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 01:33:14 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4GgvJT5CmJz9sWl; Fri,  6 Aug 2021 15:32:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1628227977;
        bh=H07A1vmsG7/hmEZvTTKfG6W1Nqbvj1job+oTNmVUUFA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PwL5ZJgISfrA9Ti81rxOUK7eS71N98wp2QENeeQcD3uBMmUdAWCKV3aqowF6NZOXh
         XI8W9HWfT1skRy4PZRx6ZQAUDg0g2DIbGv5UrWp94sJS7NqcsU7UAViaxcPyoHHi0b
         L+XALLz8KF0a+k3IWu0mPt0P9+s9QVX4yrejWGZE=
Date:   Fri, 6 Aug 2021 14:24:28 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
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
Message-ID: <YQy5fBJkKHhuNUuP@yekko>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YP4/KJoYfbaf5U94@yekko>
 <20210730145123.GW1721383@nvidia.com>
 <YQii3g3plte4gT5Z@yekko>
 <20210804140742.GI1721383@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="waHxV1qIfKEUr127"
Content-Disposition: inline
In-Reply-To: <20210804140742.GI1721383@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--waHxV1qIfKEUr127
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 04, 2021 at 11:07:42AM -0300, Jason Gunthorpe wrote:
> On Tue, Aug 03, 2021 at 11:58:54AM +1000, David Gibson wrote:
> > > I'd rather deduce the endpoint from a collection of devices than the
> > > other way around...
> >=20
> > Which I think is confusing, and in any case doesn't cover the case of
> > one "device" with multiple endpoints.
>=20
> Well they are both confusing, and I'd prefer to focus on the common
> case without extra mandatory steps. Exposing optional endpoint sharing
> information seems more in line with where everything is going than
> making endpoint sharing a first class object.
>=20
> AFAIK a device with multiple endpoints where those endpoints are
> shared with other devices doesn't really exist/or is useful? Eg PASID
> has multiple RIDs by they are not shared.

No, I can't think of a (non-contrived) example where a device would
have *both* multiple endpoints and those endpoints are shared amongst
multiple devices.  I can easily think of examples where a device has
multiple (non shared) endpoints and where multiple devices share a
single endpoint.

The point is that making endpoints explicit separates the various
options here from the logic of the IOMMU layer itself.  New device
types with new possibilities here means new interfaces *on those
devices*, but not new interfaces on /dev/iommu.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--waHxV1qIfKEUr127
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmEMuXoACgkQbDjKyiDZ
s5Ll7RAAw19Bgqx4KAD/OEJN+VYXQEI6yg6Y78rk14ks5bjzQJ9Asq3t+HhsxCyx
EddzGgfqFGfkql9wXDEDbYFBVRMEZdcD0Zf0zFWVDqmoexXPQxCHQGTK87T1hb0f
qKbD3EP2dSv4cGNDejyHGghBcPK4PB+1DbRccJ0WV2a5FHeJ1dP4T3PF7ybRQps5
fHidQxDNkkv1b9AocsxpjXJ2c3LxXDbWGBN+5s/MmCP3ueYoH64MZEbM5EGZEo/g
8/XIDlrrCe3CXYvAxCjjafAw8+3dgrdLvkqmvtUVGb2vDWJgnFRrYP+KU89yT7H1
vZPKxV52nVaO7aM9EuN5bLatSQNgyiQwa02hXz6RbFPTQf5XOpja0Nm/TyNb1aol
7YxUWQpfiCydQdW+lzfa/7Em7rXZldwihDD/69VpKkinppathe2DoqzAr8hVkTFl
rwJyEWU5220p5tby5N9QHIQkajx7PvigbhmtLx/t7l3sgGb4wB3Lw2zSd0f739Kh
m6Qru1FOEVAW7ELEyD8b75upcT4tRnlDZfjbl5eHu/AyWt/lZoCVT8l9Syblrrl6
nYuzjCbzKGvkeD2wRfAuro7j3dh9VE+PIfUbGDvqmoKH27lJtWMLS2ek3zTEh95k
pvi1vc27W18oJ8bUdlpe9G5d6au5U/AhKuRFKkgNqltYjuTHwvU=
=o8eD
-----END PGP SIGNATURE-----

--waHxV1qIfKEUr127--
