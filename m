Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B667741D1B0
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 05:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347953AbhI3DEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 23:04:30 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:40727 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347930AbhI3DE3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 23:04:29 -0400
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HKdMn5D01z4xVP; Thu, 30 Sep 2021 13:02:45 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1632970965;
        bh=bVSYF7uJlZF85jEcbVvfB45l/qUznn+q8FvDHqhizO0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cnh0oOWxARQj4pXBGaJspCnYZDi/18iEwECYzATMMFrV0rie8dj0kAKHE/rojFdlt
         W6n99DYr6n44OH89RrDLmVenjwb8Lc2SIRK+Y/XtQRVahr5LhQpGQvWgvHA7c3eojn
         o5dCH4z4NayPEdPTkPZ3TFrt6RGrjXspxXuJFtFw=
Date:   Thu, 30 Sep 2021 12:48:16 +1000
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
Message-ID: <YVUlcJJBcgQrDTY4@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-4-yi.l.liu@intel.com>
 <20210921160108.GO327412@nvidia.com>
 <BN9PR11MB54330421CA825F5CAA44BAC98CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922010014.GE327412@nvidia.com>
 <YVPTdqWw6or3mK/h@yekko>
 <20210929122230.GO964074@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="h1nhRvd2ptQmOAKV"
Content-Disposition: inline
In-Reply-To: <20210929122230.GO964074@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--h1nhRvd2ptQmOAKV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 29, 2021 at 09:22:30AM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 29, 2021 at 12:46:14PM +1000, david@gibson.dropbear.id.au wro=
te:
> > On Tue, Sep 21, 2021 at 10:00:14PM -0300, Jason Gunthorpe wrote:
> > > On Wed, Sep 22, 2021 at 12:54:02AM +0000, Tian, Kevin wrote:
> > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > Sent: Wednesday, September 22, 2021 12:01 AM
> > > > >=20
> > > > > >  One open about how to organize the device nodes under
> > > > > /dev/vfio/devices/.
> > > > > > This RFC adopts a simple policy by keeping a flat layout with m=
ixed
> > > > > devname
> > > > > > from all kinds of devices. The prerequisite of this model is th=
at devnames
> > > > > > from different bus types are unique formats:
> > > > >=20
> > > > > This isn't reliable, the devname should just be vfio0, vfio1, etc
> > > > >=20
> > > > > The userspace can learn the correct major/minor by inspecting the
> > > > > sysfs.
> > > > >=20
> > > > > This whole concept should disappear into the prior patch that add=
s the
> > > > > struct device in the first place, and I think most of the code he=
re
> > > > > can be deleted once the struct device is used properly.
> > > > >=20
> > > >=20
> > > > Can you help elaborate above flow? This is one area where we need
> > > > more guidance.
> > > >=20
> > > > When Qemu accepts an option "-device vfio-pci,host=3DDDDD:BB:DD.F",
> > > > how does Qemu identify which vifo0/1/... is associated with the spe=
cified=20
> > > > DDDD:BB:DD.F?=20
> > >=20
> > > When done properly in the kernel the file:
> > >=20
> > > /sys/bus/pci/devices/DDDD:BB:DD.F/vfio/vfioX/dev
> > >=20
> > > Will contain the major:minor of the VFIO device.
> > >=20
> > > Userspace then opens the /dev/vfio/devices/vfioX and checks with fstat
> > > that the major:minor matches.
> > >=20
> > > in the above pattern "pci" and "DDDD:BB:DD.FF" are the arguments pass=
ed
> > > to qemu.
> >=20
> > I thought part of the appeal of the device centric model was less
> > grovelling around in sysfs for information.  Using type/address
> > directly in /dev seems simpler than having to dig around matching
> > things here.
>=20
> I would say more regular grovelling. Starting from a sysfs device
> directory and querying the VFIO cdev associated with it is much more
> normal than what happens today, which also includes passing sysfs
> information into an ioctl :\

Hm.. ok.  Clearly I'm unfamiliar with the things that do that.  Other
than current VFIO, the only model I've really seen is where you just
point your program at a device node.

> > Note that this doesn't have to be done in kernel: you could have the
> > kernel just call them /dev/vfio/devices/vfio0, ... but add udev rules
> > that create symlinks from say /dev/vfio/pci/DDDD:BB:SS.F - >
> > ../devices/vfioXX based on the sysfs information.
>=20
> This is the right approach if people want to do this, but I'm not sure
> it is worth it given backwards compat requires the sysfs path as
> input.

You mean for userspace that needs to be able to go back to the old
VFIO interface as well?  It seems silly to force this sysfs mucking
about on new programs that depend on the new interface.

> We may as well stick with sysfs as the command line interface
> for userspace tools.

> And I certainly don't want to see userspace tools trying to reverse a
> sysfs path into a /dev/ symlink name when they can directly and
> reliably learn the correct cdev from the sysfspath.

Um.. sure.. but they can get the correct cdev from the sysfspath no
matter how we name the cdevs.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--h1nhRvd2ptQmOAKV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFVJXAACgkQbDjKyiDZ
s5IQsQ//a9V6hdhkrwfjVg6eLiQNWabABagPIW1pwpFfrQKDiYkmXjBOg5EV0sXq
nld3ED5fjbeTz1XIGFLihE2soGMjfi1+h9bIWl+Yq1idN6Gxkd1Gq3JDqbfg6C4R
SnR1SmqsRvan+Br2Et/2jrdx3qEKEsdvCod33q443cKjNkmDtzrUHJiVE25SRyO/
Z2N2E4N8l+c1nbABzadlLJtKRmO84ptwgnCCnaeg0dg9EBatl00CxNVhM9HuHkOG
q277x6vv5rEBhrW+MbjQNVt0wcKG1lCtWfdOrFl0QkBeI0fjSFCSQcxwnE7r8ehN
/oyBmSaHuuAj5EVUPmJKh7PBf2zlpmhJUe9jOrrsUC7GXW3ykTvCG477Vpr7Pq21
zPcLDzrfrs1J1SW8o8Yc01lW3lsECwqzUW0dO83pblaz0AQimYFmbm+X7FXiHPOu
/cXcoCBpTvBAyXt2I1eThH8HZY4gQoxmL0FWF87ifCKyFWvsZkmSaafEBE2nzkah
c1wutGjFbhxdFZlZbu/R702kC/S4QYoPXgXno9bJkmnZE1xhesbiVBEeeMDu9xak
eCiYkC4yZ3tR/qxsoHpzaa5SS95jbmU9kjNL3QAnasRdMCbRjWXmOApy7h4Avb67
idR+fs+Yk2p9P4kmQUVPeQwF2JW2hvDzh22naJeS9RtLxhlTwtc=
=rIzq
-----END PGP SIGNATURE-----

--h1nhRvd2ptQmOAKV--
