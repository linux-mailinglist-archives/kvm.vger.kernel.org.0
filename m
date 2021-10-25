Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A685443A82C
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 01:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234747AbhJYXc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 19:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233418AbhJYXcs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 19:32:48 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E5EC061745;
        Mon, 25 Oct 2021 16:30:25 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HdWQl4cYRz4xbP; Tue, 26 Oct 2021 10:30:23 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1635204623;
        bh=D9s8UCsN8uxpZTpLGN0k3xtAwElruVlh1u99paNigtw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dfwE8Xoh5HvMa28V7E3VIIFgW6XK3TRLC4Ppwq51Hj6iQ9qTqJLjRIY5A5rM9Oqfc
         LHgzhmUCt3Q51SUj9eAGPqg36rPwXwefsXL8PyWgfkn4/uaUlseXVg7t3xEtqYO++1
         x/gOAbBdf7mZOlxMlHPGs8ZkAPbaRmWQeMLFaJxY=
Date:   Tue, 26 Oct 2021 00:16:43 +1100
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
Subject: Re: [RFC 13/20] iommu: Extend iommu_at[de]tach_device() for multiple
 devices group
Message-ID: <YXauO+YSR7ivz1QW@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-14-yi.l.liu@intel.com>
 <YWe+88sfCbxgMYPN@yekko>
 <BN9PR11MB54337A8E65C789D038D875C68CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YWzwmAQDB9Qwu2uQ@yekko>
 <20211018163238.GO2744544@nvidia.com>
 <YXY9UIKDlQpNDGax@yekko>
 <20211025121410.GQ2744544@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="O2NMk5xF7UYH/YH7"
Content-Disposition: inline
In-Reply-To: <20211025121410.GQ2744544@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--O2NMk5xF7UYH/YH7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 25, 2021 at 09:14:10AM -0300, Jason Gunthorpe wrote:
> On Mon, Oct 25, 2021 at 04:14:56PM +1100, David Gibson wrote:
> > On Mon, Oct 18, 2021 at 01:32:38PM -0300, Jason Gunthorpe wrote:
> > > On Mon, Oct 18, 2021 at 02:57:12PM +1100, David Gibson wrote:
> > >=20
> > > > The first user might read this.  Subsequent users are likely to just
> > > > copy paste examples from earlier things without fully understanding
> > > > them.  In general documenting restrictions somewhere is never as
> > > > effective as making those restrictions part of the interface signat=
ure
> > > > itself.
> > >=20
> > > I'd think this argument would hold more water if you could point to
> > > someplace in existing userspace that cares about the VFIO grouping.
> >=20
> > My whole point here is that the proposed semantics mean that we have
> > weird side effects even if the app doesn't think it cares about
> > groups.
> >=20
> > e.g. App's input is a bunch of PCI addresses for NICs.  It attaches
> > each one to a separate IOAS and bridges packets between them all.  As
> > far as the app is concerned, it doesn't care about groups, as you say.
> >=20
> > Except that it breaks if any two of the devices are in the same group.
> > Worse, it has a completely horrible failure mode: no syscall returns
>=20
> Huh? If an app requests an IOAS attach that is not possible then the
> attachment IOCTL will fail.
>=20
> The kernel must track groups and know that group A is on IOAS A and
> any further attach of a group A device must specify IOAS A or receive
> a failure.

Ok, I misunderstood the semantics that were suggested.

So, IIUC what you're suggested is that if group X is attached to IOAS
1, then attaching the group to IOAS 1 again should succeed (as a
no-op), but attaching to any other IOAS should fail?

That's certainly an improvement, but there's still some questions.

If you attach devices A and B (both in group X) to IOAS 1, then detach
device A, what happens?  Do you detach both devices?  Or do you have a
counter so you have to detach as many time as you attached?

> The kernel should never blindly acknowledge a failed attachment.
>=20
> Jason
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--O2NMk5xF7UYH/YH7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmF2rjkACgkQbDjKyiDZ
s5JwahAA391JynQuavWmhBOhDzb14OvOhpDcitGZ2dFWubVWtz4qL5lRWS/02Q0N
9dpFnqINn3fxXAVKM//9YP5KRFeAS5v5C7ScUL0GDjKLMvQ5cl/YR/t8J2i+q1q5
osWlUmUofwjTKMzxrV+fRaY8W8Ro2vdp9NV3xJsE4ipZVIxU4X2XgIJ8Zp37ED+R
WPftlJukAKQIJmdiqaEyNah+eG0Jl4MmqOsGLRXrD4KFiblKwXX2AlQgxb0hzo6P
eScpIA26XA/v3ch/Llh7mo4obgb0PAsqeGhKUQpfFb7p+APamwdtjGqe8vE1UW+E
jVkaZwKTJ6Y6Dc88FBseS0sFvJDCqzGri023feLbP16V8pwhyweegqx75b0rcL1/
piUbQnSt8ZRidBRKq87NusMkBpV221+uqLvranfuoeqgbt9U0vYIB8J5jW+fyrCp
qu5Ch+wAmJZHr1/WmCAPmHV8pmGKoGUVYwc5vStAKkBTru0qAh5ImN7kTlpd8OpS
ktThhH1jVYpejts5quqAtDi/swpjCIBb209clpsidn8nVPBvI0I3diVWnN7qsXI4
vnmi3K+Y8bjANYPaLBtUVX4motWGBXLbOfbPkAua5bmHIYjZMSSm9E81R+SHzsPY
FOecGoVdowCrUloQPRA0YHxXocyX3ZSYvBWX0a8pZMpfMOuec30=
=dI80
-----END PGP SIGNATURE-----

--O2NMk5xF7UYH/YH7--
