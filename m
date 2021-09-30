Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C42C41D22D
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 06:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347601AbhI3EVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 00:21:09 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:59909 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhI3EVI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 00:21:08 -0400
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HKg4C5nsLz4xbV; Thu, 30 Sep 2021 14:19:23 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1632975563;
        bh=oJ/ULXJCpB8pZh9T0MC+PCyhdj4ADzZWfm4oxAJ5hbY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LM/WDccNAofElIUqx6ZSzy4soq7R3iooZrZoPHFK9etndOX/erqv/SW6o9FymLCNI
         tTpH+gwM3y2hOXEZgck6bohGnynQmN84E9dCHZcEehqsNUyTDuVdDj4GCqMVfwdhER
         nJ+komzTd8XM+LZLEYtqysl90/1pUYmdKaXIjvcc=
Date:   Thu, 30 Sep 2021 13:12:00 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>, "hch@lst.de" <hch@lst.de>,
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
Subject: Re: [RFC 08/20] vfio/pci: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <YVUrAC7j0zYecxzY@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-9-yi.l.liu@intel.com>
 <YVQBFgOa4fQRpwqN@yekko>
 <BN9PR11MB54331D06D97B4FC975D8D23B8CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="r8hKFivqxBOeSqL3"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB54331D06D97B4FC975D8D23B8CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--r8hKFivqxBOeSqL3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 29, 2021 at 06:41:00AM +0000, Tian, Kevin wrote:
> > From: David Gibson <david@gibson.dropbear.id.au>
> > Sent: Wednesday, September 29, 2021 2:01 PM
> >=20
> > On Sun, Sep 19, 2021 at 02:38:36PM +0800, Liu Yi L wrote:
> > > This patch adds VFIO_DEVICE_BIND_IOMMUFD for userspace to bind the
> > vfio
> > > device to an iommufd. No VFIO_DEVICE_UNBIND_IOMMUFD interface is
> > provided
> > > because it's implicitly done when the device fd is closed.
> > >
> > > In concept a vfio device can be bound to multiple iommufds, each host=
ing
> > > a subset of I/O address spaces attached by this device.
> >=20
> > I really feel like this many<->many mapping between devices is going
> > to be super-confusing, and therefore make it really hard to be
> > confident we have all the rules right for proper isolation.
>=20
> Based on new discussion on group ownership part (patch06), I feel this
> many<->many relationship will disappear. The context fd (either container
> or iommufd) will uniquely mark the ownership on a physical device and
> its group. With this design it's impractical to have one device bound
> to multiple iommufds. Actually I don't think this is a compelling usage
> in reality. The previous rationale was that no need to impose such restri=
ction
> if no special reason... and now we have a reason. =F0=9F=98=8A
>=20
> Jason, are you OK with this simplification?
>=20
> >=20
> > That's why I was suggesting a concept like endpoints, to break this
> > into two many<->one relationships.  I'm ok if that isn't visible in
> > the user API, but I think this is going to be really hard to keep
> > track of if it isn't explicit somewhere in the internals.
> >=20
>=20
> I think this endpoint concept is represented by ioas_device_info in
> patch14:
>=20
> +/*
> + * An ioas_device_info object is created per each successful attaching
> + * request. A list of objects are maintained per ioas when the address
> + * space is shared by multiple devices.
> + */
> +struct ioas_device_info {
> +	struct iommufd_device *idev;
> +	struct list_head next;
>  };
>=20
> currently it's 1:1 mapping before this object and iommufd_device,=20
> because no pasid support yet.

Ok, I haven't read that far in the series yet.

> We can rename it to struct ioas_endpoint if it makes you feel
> better.

Meh.  The concept is much more important than the name.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--r8hKFivqxBOeSqL3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFVKwAACgkQbDjKyiDZ
s5IyZBAApEbrAkg3NeEqYJu3KTfMnPffqvQpnQ5gbCPc4rEn+DpHudPJpwNt9uu9
/du7hPrwQqWDI+XCk4f3EWNUCbDZ6pOCT6f5OSCrqOl43qGLyxsSTZWzUh4eBf5I
BJ/YVp1mPfjrzSd0P1znf+/pjTgUIHBrBLbBTqkzrYrrFYTtvU8sV1gokdARiPnr
vnMp96v76nOhNZgVUwL5k+XWUHuSzNTTMttrg964N5IpNkwIOGvT+XO0rioshBjk
JWQMl9vxDKH0+6FGY1Vbc9MdGcO0IbeT+xT7ZTeD/YV3VeML+FL8Z8gaygnD/3J2
pSfDyc2Tm2jK0d96O5OpOchZDhL5A3+khZNMC14fGRUPIpx/itTIeU3vcuutGFCO
jbWItM8fARo2HvFFSXsa6Ir7GY+Ri8M+l02XT8MrWzGVCygmYUQjNisNLj4dxptV
DfxFFsQIN+V8U2rHpKJ3tBOXK4kwSQdDzfnvoHzs+iXgTL4ze/rcE6jVVLFpaDs+
1HmugwuFvDl93FyRfDVaKkj1ckA2Ddpbqyxqut7YHP6QnzH30le/OM0GTIaCGO9E
arJjVmp6cYqlkWc/a6Ues4xstYoW90oxq+XVwO8vzlZHbCTQg6fIkUiBdS29PsPj
3C9MCj4m8zKKjeucsGVvHBigj0CE9UD8dBr0KanSSrz9SIckKC8=
=SsHa
-----END PGP SIGNATURE-----

--r8hKFivqxBOeSqL3--
