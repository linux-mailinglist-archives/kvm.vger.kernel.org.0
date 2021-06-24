Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2D63B2693
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 06:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhFXEy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 00:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbhFXEyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 00:54:49 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A303C061574;
        Wed, 23 Jun 2021 21:52:31 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4G9SRT4N9jz9t0G; Thu, 24 Jun 2021 14:52:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1624510341;
        bh=IQ9z+FM1iAU3YGel/DdKjNbW4g2/iGQc7u1SOhwdQ0s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XrQJxQdJWPhjxVgCbCvSQiloi3rkVpfm2OknyTuLr5aJEyPSYbjaSQbwKTATK4Dh1
         a8jj2iFI0crcsm/IlvkPOx3yxN07wQw4ubXDYMVa3Ozx7AM41RbF2ER1ENOkGosarx
         VynjZgaWVK3oVxha+EdKVz8Phcc0ery4TQpvqyqE=
Date:   Thu, 24 Jun 2021 14:26:11 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
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
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <YNQJY2Ji+KOBYWbt@yekko>
References: <20210614140711.GI1002214@nvidia.com>
 <20210614102814.43ada8df.alex.williamson@redhat.com>
 <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615101215.4ba67c86.alex.williamson@redhat.com>
 <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210616133937.59050e1a.alex.williamson@redhat.com>
 <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210617151452.08beadae.alex.williamson@redhat.com>
 <20210618001956.GA1987166@nvidia.com>
 <MWHPR11MB1886A17124605251DF394E888C0D9@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BSFjbAhaUqNWeFX5"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886A17124605251DF394E888C0D9@MWHPR11MB1886.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--BSFjbAhaUqNWeFX5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 18, 2021 at 04:57:40PM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Friday, June 18, 2021 8:20 AM
> >=20
> > On Thu, Jun 17, 2021 at 03:14:52PM -0600, Alex Williamson wrote:
> >=20
> > > I've referred to this as a limitation of type1, that we can't put
> > > devices within the same group into different address spaces, such as
> > > behind separate vRoot-Ports in a vIOMMU config, but really, who cares?
> > > As isolation support improves we see fewer multi-device groups, this
> > > scenario becomes the exception.  Buy better hardware to use the devic=
es
> > > independently.
> >=20
> > This is basically my thinking too, but my conclusion is that we should
> > not continue to make groups central to the API.
> >=20
> > As I've explained to David this is actually causing functional
> > problems and mess - and I don't see a clean way to keep groups central
> > but still have the device in control of what is happening. We need
> > this device <-> iommu connection to be direct to robustly model all
> > the things that are in the RFC.
> >=20
> > To keep groups central someone needs to sketch out how to solve
> > today's mdev SW page table and mdev PASID issues in a clean
> > way. Device centric is my suggestion on how to make it clean, but I
> > haven't heard an alternative??
> >=20
> > So, I view the purpose of this discussion to scope out what a
> > device-centric world looks like and then if we can securely fit in the
> > legacy non-isolated world on top of that clean future oriented
> > API. Then decide if it is work worth doing or not.
> >=20
> > To my mind it looks like it is not so bad, granted not every detail is
> > clear, and no code has be sketched, but I don't see a big scary
> > blocker emerging. An extra ioctl or two, some special logic that
> > activates for >1 device groups that looks a lot like VFIO's current
> > logic..
> >=20
> > At some level I would be perfectly fine if we made the group FD part
> > of the API for >1 device groups - except that complexifies every user
> > space implementation to deal with that. It doesn't feel like a good
> > trade off.
> >=20
>=20
> Would it be an acceptable tradeoff by leaving >1 device groups=20
> supported only via legacy VFIO (which is anyway kept for backward=20
> compatibility), if we think such scenario is being deprecated over=20
> time (thus little value to add new features on it)? Then all new=20
> sub-systems including vdpa and new vfio only support singleton=20
> device group via /dev/iommu...

The case that worries me here is if you *thought* you had 1 device
groups, but then discover a hardware bug which means two things aren't
as isolated as you thought they were.  What do you do then?

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--BSFjbAhaUqNWeFX5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmDUCWMACgkQbDjKyiDZ
s5JgnBAAijxDul/b69WVeLvr273k1oikuFzryDz0SoUd6u2u3P7j6lAs+Dcv8JhT
1axAxKuR0AVeuXynUT+3495hpYmgk0oxgnVqv6aJN8mnClivsB8Np6X01ECSNvWE
sZCjNghU0iexB3mykPf3yNTT0GCOnLmSooAIuBd+EihcYCdMYWkCJlMzJFs5Q10f
BdHdbSft/nr+anGf7JNI5d+S5iZ/IadIU9/0Csz2jz52SmdYTTfp2aEPB8PTPcf+
+bF6xw1afgI+YvUn87Ortey5Vh1yvXWMoVNHD1YsY+/gtXeacONIYAewina44dim
nSzeeLRZH9lumHDaOl5Aa59cePtQ+1N5hSfSTTK9MNzutkVn7vmHivE9XugJ3lUO
NdrDbEhs5shVc/g4Te7yCagVc6F61z4onbsSCsJAw9s1IJcgqh9lytXPo91BoKM3
5RM/TV4Jp8Xege18mnEcv6rVcTp9FrBswbWR6cZG3gakVdF2KAvMFyqYHqzGRz9f
GaBPSkCddBxbghmHnDhCbU9nWZgoR2ieCCFEeqxj42vZj5sW9Jm5gVpzEQv1Wqem
vb4FjnRyiK14bx9P/mcZFwyWYcu8pZ/KZst6aKLB2mS62GzvnTJO8gnWzvHyer7s
Uw0G0wSCHLFFm4ubP01I7xv+Fa0h7R4hSrmUitr5aFYfMMF7bUY=
=v6Yg
-----END PGP SIGNATURE-----

--BSFjbAhaUqNWeFX5--
