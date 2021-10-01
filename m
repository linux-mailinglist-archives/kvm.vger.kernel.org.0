Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2354341E683
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 06:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237357AbhJAEPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 00:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235689AbhJAEPq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 00:15:46 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BAEC06176A;
        Thu, 30 Sep 2021 21:14:02 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HLGvX3VR8z4xbT; Fri,  1 Oct 2021 14:14:00 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1633061640;
        bh=ErzESc+3j15+IBkmNZmWRkNDim6Klxc8DaJ69XgNhq4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ARxZnU3s5FNr8NvyJlmKRTVFYh6OTyT7VDurD/TxE3AgXrUf0o3e0BEn5otjeg9Gh
         V+tlfc9uRhb4TapUkstbqYbj/OvuZqK2eF2/sIuv2u9+EwpTjqnBnL390uNsxu9sCr
         thN9IcRSVl7shSeObTIvRdq5bYQJZwz6iOXfstXI=
Date:   Fri, 1 Oct 2021 13:54:52 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
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
Subject: Re: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Message-ID: <YVaGjKggJ9guJ4gE@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
 <YVPxzad5TYHAc1H/@yekko>
 <BN9PR11MB5433E1BF538C7D3632F4C6188CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YVQJJ/ZlRoJbAt0+@yekko>
 <20210929125716.GT964074@nvidia.com>
 <YVUqYsJTMkt1nnXL@yekko>
 <20210930222818.GI964074@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yg8w2iyVSrHxaZnC"
Content-Disposition: inline
In-Reply-To: <20210930222818.GI964074@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--yg8w2iyVSrHxaZnC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 30, 2021 at 07:28:18PM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 30, 2021 at 01:09:22PM +1000, David Gibson wrote:
>=20
> > > The *admin* the one responsible to understand the groups, not the
> > > applications. The admin has no idea what a group FD is - they should
> > > be looking at the sysfs and seeing the iommu_group directories.
> >=20
> > Not just the admin.  If an app is given two devices in the same group
> > to use *both* it must understand that and act accordingly.
>=20
> Yes, but this is true regardless of what the uAPI is,

Yes, but formerly it was explicit and now it is implicit.  Before we
said "attach this group to this container", which can reasonably be
expected to affect the whole group.  Now we say "attach this device to
this IOAS" and it silently also affects other devices.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--yg8w2iyVSrHxaZnC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFWhooACgkQbDjKyiDZ
s5KWOxAAjyayEpk3/2UCunzQoONH2hekaB3mFVJmCIhc7mJCra4nKi0QetNRNSJR
Mu4bgd8Espq9vrCUL2gHPfaXOfJqi34ln+aElFfmOiKSiBz0tXQJ3e/L/KWpDAAL
L5KsZxLwWJ4nOCpk9skfKxzECUasDHOgeUHvLhJiLEoHP3dYwO+gijf96rOcTwmj
PHBPL960LXUGBIbFAocGquSuvMOUpbtIRUlCmdVgkPZeWqm2WCUs5/jesBnxAKtj
qJU5aEytGm6bAhFfhvtLasQUVC42xVJmE0A9fXGvhvKtigEcWHWd4c16E7tGYYB3
z7IliPfnD8cuhMN7MzlImEM3zBQWxrgdQn8zKXvCvcIVBGAvlfcj53KYHuPyLGZE
8SzuCMbiqGQjLNZ/d7fxrTalaOvn8r3/njB/YpLUzaRXeUIM5K8MK1pmxLtbOF2q
jYt8WGVQhDFU+BE/YdPDme4E8kgrskk9d3QDeb00pzHayBuq2RZtA1WqnjXDGvfr
uJPnyOiH2WigaRlsyKO6l0a9WmnbWZE5f75rW476Lw9qGFpU8d3vfNXhQHM6payb
4LwEHjDGgdlQncfujTBXHpBt6kH9r0Zg+lmA8mmHTpfRVfNoJtB2HuvFQgUMYVNa
Fa0jPYeQTMyjlp7DpxGosCLB9OQJ3E5S64ppTdpPIQULRQKFx4w=
=37P5
-----END PGP SIGNATURE-----

--yg8w2iyVSrHxaZnC--
