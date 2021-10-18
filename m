Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A42430E90
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 06:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhJREQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 00:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhJREQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 00:16:14 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F375C06161C;
        Sun, 17 Oct 2021 21:14:03 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HXk5j6GV3z4xdB; Mon, 18 Oct 2021 15:14:01 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1634530441;
        bh=C/rLmv8fhNr22IXWeZPftueLB57/QIRQ43bJ5wkgLAw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mng9BRO/IxdK3OG5njDh91QRQn7MkjHq4BZrTWPSMQrtRFOkvJmQmbGKpEnryOwL/
         lGGN0xQWdjBc/HC3Idsey/azk6QafUz9OYCU6gQKsJJbV0YWHemh9GMWhCSZz9ks+k
         qzkpofM/UvJMYhZnWWNu1mCR1YkTMZGjVg7/emAA=
Date:   Mon, 18 Oct 2021 14:57:12 +1100
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
Subject: Re: [RFC 13/20] iommu: Extend iommu_at[de]tach_device() for multiple
 devices group
Message-ID: <YWzwmAQDB9Qwu2uQ@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-14-yi.l.liu@intel.com>
 <YWe+88sfCbxgMYPN@yekko>
 <BN9PR11MB54337A8E65C789D038D875C68CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="t5WOCwIxqG/YwyD+"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB54337A8E65C789D038D875C68CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--t5WOCwIxqG/YwyD+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 14, 2021 at 07:06:07AM +0000, Tian, Kevin wrote:
> > From: David Gibson <david@gibson.dropbear.id.au>
> > Sent: Thursday, October 14, 2021 1:24 PM
> >=20
> > On Sun, Sep 19, 2021 at 02:38:41PM +0800, Liu Yi L wrote:
> > > From: Lu Baolu <baolu.lu@linux.intel.com>
> > >
> > > These two helpers could be used when 1) the iommu group is singleton,
> > > or 2) the upper layer has put the iommu group into the secure state by
> > > calling iommu_device_init_user_dma().
> > >
> > > As we want the iommufd design to be a device-centric model, we want to
> > > remove any group knowledge in iommufd. Given that we already have
> > > iommu_at[de]tach_device() interface, we could extend it for iommufd
> > > simply by doing below:
> > >
> > >  - first device in a group does group attach;
> > >  - last device in a group does group detach.
> > >
> > > as long as the group has been put into the secure context.
> > >
> > > The commit <426a273834eae> ("iommu: Limit
> > iommu_attach/detach_device to
> > > device with their own group") deliberately restricts the two interfac=
es
> > > to single-device group. To avoid the conflict with existing usages, we
> > > keep this policy and put the new extension only when the group has be=
en
> > > marked for user_dma.
> >=20
> > I still kind of hate this interface because it means an operation that
> > appears to be explicitly on a single device has an implicit effect on
> > other devices.
> >=20
>=20
> I still didn't get your concern why it's such a big deal. With this propo=
sal
> the group restriction will be 'explicitly' documented in the attach uAPI
> comment and sample flow in iommufd.rst. A sane user should read all
> those information to understand how this new sub-system works and
> follow whatever constraints claimed there. In the end the user should
> maintain the same group knowledge regardless of whether to use an
> explicit group uAPI or a device uAPI which has group constraint...

The first user might read this.  Subsequent users are likely to just
copy paste examples from earlier things without fully understanding
them.  In general documenting restrictions somewhere is never as
effective as making those restrictions part of the interface signature
itself.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--t5WOCwIxqG/YwyD+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFs8JgACgkQbDjKyiDZ
s5KDHQ/7BdJd+sDvBLbOWNk5B46iA+DQ9DKSjis43JQRJWMFpVLPnaYstyJwnfIa
kHMmoTbiHlpQDKh4hgnGKtZvZmd+KWzVmyLH7ny7uBIdrGSN/gyMTqEmpo5K1j1e
lpn9GWi+K/OJOtQqNhsn6E9MSm2PKDN89UIECYn98T7AFe/Rbf+97Lm+wN3csGYp
wLM+QN9yHcA777vkv0ugPRxM47kCfIzaa3eMazjhS3mCopwIuGetxgb04EWXCNyx
mNbOFjX1TWD2RZBmMhQhsYVpaRtTFQJOvwM/8Sh5CDPpmG49zhCNjzc/rXkE8d1Q
P6mc3HGY+oy3RzVfCG26IlnSO96C91g768GD978Rh2y4RD3BqvN5gM91pjJztD1c
fLLxLu4fxfD+3bnjCYh9OT0AdPdWnGJ1rD3YQiSjCR6uW14XO6Msr0oVJVM88/wO
gNkYogm2kz4+CWz93Gqpv6LJpZL0899g0xOEk46JKi4Gc/OU1/KJwLR3tdJ35vIN
bf5OKR8fo7rc+5WO+8hTxmW1NEbL7w+Fyl7c4z1ntfBt6RiXrU88WA5OF+ciZ86w
0Y3LS9Lue21X7jKtQ0QXYB1ucgEDtsIYpd63uVCsG0CnpwOyHyuqbgTONiNaL31a
GmAVdvF9bbldOoxB9Gkw5N6Rgmui7umAMB2r2OA+jUWayx5xu2g=
=hliG
-----END PGP SIGNATURE-----

--t5WOCwIxqG/YwyD+--
