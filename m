Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4CD41D233
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 06:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347998AbhI3EVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 00:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347935AbhI3EVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 00:21:16 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D76C06161C;
        Wed, 29 Sep 2021 21:19:30 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HKg4C5Xqmz4xbR; Thu, 30 Sep 2021 14:19:23 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1632975563;
        bh=7ImM9SI/BFgJ8f/PNNDd6cX2ps2N2DdxQ/FJAtnm3AI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Idy4tPCU0C9XZJC3sZS5E6TqgpCHbbHc++kXGeyUhEGAyEgf7RwUsLnhGvbN+7ICG
         9bhnpFyxwNzypjVu0iWHpWX4St/ADt1yvzX7A7Nd6oKyzFz2nCI8tGdE7osg+O2wcT
         F5ZAMC/Sw/Q7NWWAbjpOcwy9Tv0EBuxv3fPkWtYE=
Date:   Thu, 30 Sep 2021 13:10:29 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        hch@lst.de, jasowang@redhat.com, joro@8bytes.org,
        jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@linux.intel.com, jun.j.tian@intel.com, hao.wu@intel.com,
        dave.jiang@intel.com, jacob.jun.pan@linux.intel.com,
        kwankhede@nvidia.com, robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        nicolinc@nvidia.com
Subject: Re: [RFC 07/20] iommu/iommufd: Add iommufd_[un]bind_device()
Message-ID: <YVUqpff7DUtTLYKx@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-8-yi.l.liu@intel.com>
 <YVP44v4FVYJBSEEF@yekko>
 <20210929122457.GP964074@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Cu/fr+k+GRSm6ylg"
Content-Disposition: inline
In-Reply-To: <20210929122457.GP964074@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Cu/fr+k+GRSm6ylg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 29, 2021 at 09:24:57AM -0300, Jason Gunthorpe wrote:
65;6402;1c> On Wed, Sep 29, 2021 at 03:25:54PM +1000, David Gibson wrote:
>=20
> > > +struct iommufd_device {
> > > +	unsigned int id;
> > > +	struct iommufd_ctx *ictx;
> > > +	struct device *dev; /* always be the physical device */
> > > +	u64 dev_cookie;
> >=20
> > Why do you need both an 'id' and a 'dev_cookie'?  Since they're both
> > unique, couldn't you just use the cookie directly as the index into
> > the xarray?
>=20
> ID is the kernel value in the xarray - xarray is much more efficient &
> safe with small kernel controlled values.
>=20
> dev_cookie is a user assigned value that may not be unique. It's
> purpose is to allow userspace to receive and event and go back to its
> structure. Most likely userspace will store a pointer here, but it is
> also possible userspace could not use it.
>=20
> It is a pretty normal pattern

Hm, ok.  Could you point me at an example?

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--Cu/fr+k+GRSm6ylg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFVKqUACgkQbDjKyiDZ
s5IgWQ//cY+/CZBapInqTS3ld5AVvlLP+hYabxO9YGZASIa/ybrzzLE08lmPx5Wy
0ZaXJF0ZAfE0+QEKy6tjsn27oAn7tndELqyh1VnxEjP/aY4U+CAkhzFeJhKwik3y
1INg32pctc1RlMP46DVWhowOl3IRA2mJSchngrYMhEjDUCbkZVpSaf5LgGeh97Yd
mFc5s0+pKiDRgDrKRJP/7A/qg70L5CgpcEKdxhlJKeuYKI0ZkY3anLUzf6WCZw6o
uLRa/mkkdxxrM+obmXkFQjmPn3uTSWYx6uwZn4lOlpPL4JtP6C+raR48kvJZRGfP
ggkJopqLgoSyuPWI/NojfmkjY95yiw6kv/Et7T/ReUzRAuQ7svHEiBnx7i01S/0B
uZrk/8CKzaA+rGXzLv6kHwynFYAXP81e2cN2OXnb7SWtbt9RHOWwBO/waLRKWqvu
HXsrSqVOUsiN8d2NEQihgfkKSqvhWhBEiM7LmBizFriQVnBiH77SoxaerwFarhcJ
8fjQRLnkN4HX/muq9BxQs66FT7NAKu1DmvoX6FWGC710OFLJ+q6jDsCHiXWIsh3X
0cX60iREJUlVwRWdp1bRu7jX4qnnPPOdvLhHPU7VdpDfnhp5834pno/jceOnbZ6O
xkzEtS6ihpTitwvMkyi3fG2uTU9sRdZNGEoXUPJ8D8nTFP+GIJA=
=KaeT
-----END PGP SIGNATURE-----

--Cu/fr+k+GRSm6ylg--
